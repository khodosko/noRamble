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
    private(set) var recordingStartedAt: Date?

    private let service: any AudioRecordingService
    private let now: () -> Date

    init(
        service: any AudioRecordingService,
        now: @escaping () -> Date = Date.init
    ) {
        self.service = service
        self.now = now
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
            recordingStartedAt = now()
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
