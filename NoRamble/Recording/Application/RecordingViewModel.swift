import Foundation
import Observation

enum RecordingFailure: Equatable, Sendable {
    case couldNotStart
    case couldNotStop
}

enum RecordingViewState: Equatable, Sendable {
    case preparing
    case recording
    case permissionDenied
    case captured(AudioRecordingArtifact)
    case failed(RecordingFailure)
}

@MainActor
@Observable
final class RecordingViewModel: Identifiable {
    let id = UUID()
    private(set) var state: RecordingViewState = .preparing
    private(set) var shouldDismiss = false

    private let service: any AudioRecordingService

    init(service: any AudioRecordingService) {
        self.service = service
    }

    func begin() async {
        guard state == .preparing, !shouldDismiss else {
            return
        }

        var resolvedPermission = service.permission
        if resolvedPermission == .undetermined {
            resolvedPermission = await service.requestPermission()
        }

        guard !shouldDismiss else {
            return
        }

        guard resolvedPermission == .granted else {
            state = .permissionDenied
            return
        }

        do {
            try service.start()
            state = .recording
        } catch {
            state = .failed(.couldNotStart)
        }
    }

    func stop() {
        guard state == .recording else {
            return
        }

        do {
            state = .captured(try service.stop())
        } catch {
            state = .failed(.couldNotStop)
        }
    }

    func retry() async {
        guard case .failed = state else {
            return
        }

        service.cancel()
        state = .preparing
        await begin()
    }

    func close() {
        if case let .captured(artifact) = state {
            service.discard(artifact)
        } else {
            service.cancel()
        }
        shouldDismiss = true
    }
}
