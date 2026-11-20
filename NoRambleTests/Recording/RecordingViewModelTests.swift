import Foundation
import XCTest
@testable import NoRamble

@MainActor
final class RecordingViewModelTests: XCTestCase {
    func testBegin_grantedPermission_startsRecording() async {
        let service = RecordingServiceSpy(permission: .granted)
        let startedAt = Date(timeIntervalSince1970: 1_795_219_200)
        let model = RecordingViewModel(service: service, now: { startedAt })

        await model.begin()

        XCTAssertEqual(service.requestPermissionCallCount, 0)
        XCTAssertEqual(service.startCallCount, 1)
        XCTAssertEqual(model.state, .recording)
        XCTAssertEqual(model.recordingStartedAt, startedAt)
    }

    func testBegin_undeterminedThenGranted_requestsAndStarts() async {
        let service = RecordingServiceSpy(
            permission: .undetermined,
            requestedPermission: .granted
        )
        let model = RecordingViewModel(service: service)

        await model.begin()

        XCTAssertEqual(service.requestPermissionCallCount, 1)
        XCTAssertEqual(service.startCallCount, 1)
        XCTAssertEqual(model.state, .recording)
    }

    func testBegin_undeterminedThenDenied_doesNotStart() async {
        let service = RecordingServiceSpy(
            permission: .undetermined,
            requestedPermission: .denied
        )
        let model = RecordingViewModel(service: service)

        await model.begin()

        XCTAssertEqual(service.requestPermissionCallCount, 1)
        XCTAssertEqual(service.startCallCount, 0)
        XCTAssertEqual(model.state, .permissionDenied)
    }

    func testBegin_deniedPermission_doesNotRequestOrStart() async {
        let service = RecordingServiceSpy(permission: .denied)
        let model = RecordingViewModel(service: service)

        await model.begin()

        XCTAssertEqual(service.requestPermissionCallCount, 0)
        XCTAssertEqual(service.startCallCount, 0)
        XCTAssertEqual(model.state, .permissionDenied)
    }

    func testBegin_startFailure_exposesFailureState() async {
        let service = RecordingServiceSpy(
            permission: .granted,
            startError: RecordingServiceTestError.failed
        )
        let model = RecordingViewModel(service: service)

        await model.begin()

        XCTAssertEqual(model.state, .failed(.couldNotStart))
        XCTAssertNil(model.recordingStartedAt)
    }

    func testStop_activeRecording_returnsCapturedArtifact() async {
        let artifact = AudioRecordingArtifact(
            url: URL(fileURLWithPath: "/tmp/no-ramble-test.m4a")
        )
        let service = RecordingServiceSpy(
            permission: .granted,
            stopArtifact: artifact
        )
        let model = RecordingViewModel(service: service)
        await model.begin()

        model.stop()

        XCTAssertEqual(service.stopCallCount, 1)
        XCTAssertEqual(model.state, .captured(artifact))
    }

    func testStop_failure_exposesFailureState() async {
        let service = RecordingServiceSpy(
            permission: .granted,
            stopError: RecordingServiceTestError.failed
        )
        let model = RecordingViewModel(service: service)
        await model.begin()

        model.stop()

        XCTAssertEqual(model.state, .failed(.couldNotStop))
    }

    func testCancel_activeRecording_cancelsAndRequestsDismissal() async {
        let service = RecordingServiceSpy(permission: .granted)
        let model = RecordingViewModel(service: service)
        await model.begin()

        model.close()

        XCTAssertEqual(service.cancelCallCount, 1)
        XCTAssertTrue(model.shouldDismiss)
    }

    func testClose_capturedRecording_discardsAndRequestsDismissal() async {
        let artifact = AudioRecordingArtifact(
            url: URL(fileURLWithPath: "/tmp/no-ramble-test.m4a")
        )
        let service = RecordingServiceSpy(
            permission: .granted,
            stopArtifact: artifact
        )
        let model = RecordingViewModel(service: service)
        await model.begin()
        model.stop()

        model.close()

        XCTAssertEqual(service.discardedArtifacts, [artifact])
        XCTAssertTrue(model.shouldDismiss)
    }

    func testRepeatedBeginAndStop_doNotDuplicateServiceCalls() async {
        let service = RecordingServiceSpy(permission: .granted)
        let model = RecordingViewModel(service: service)

        await model.begin()
        await model.begin()
        model.stop()
        model.stop()

        XCTAssertEqual(service.startCallCount, 1)
        XCTAssertEqual(service.stopCallCount, 1)
    }
}

@MainActor
private final class RecordingServiceSpy: AudioRecordingService {
    var permission: AudioRecordingPermission
    let requestedPermission: AudioRecordingPermission
    let startError: Error?
    let stopArtifact: AudioRecordingArtifact
    let stopError: Error?

    private(set) var requestPermissionCallCount = 0
    private(set) var startCallCount = 0
    private(set) var stopCallCount = 0
    private(set) var cancelCallCount = 0
    private(set) var discardedArtifacts: [AudioRecordingArtifact] = []

    init(
        permission: AudioRecordingPermission,
        requestedPermission: AudioRecordingPermission = .granted,
        startError: Error? = nil,
        stopArtifact: AudioRecordingArtifact = AudioRecordingArtifact(
            url: URL(fileURLWithPath: "/tmp/no-ramble-default.m4a")
        ),
        stopError: Error? = nil
    ) {
        self.permission = permission
        self.requestedPermission = requestedPermission
        self.startError = startError
        self.stopArtifact = stopArtifact
        self.stopError = stopError
    }

    func requestPermission() async -> AudioRecordingPermission {
        requestPermissionCallCount += 1
        permission = requestedPermission
        return requestedPermission
    }

    func start() throws {
        startCallCount += 1
        if let startError {
            throw startError
        }
    }

    func stop() throws -> AudioRecordingArtifact {
        stopCallCount += 1
        if let stopError {
            throw stopError
        }
        return stopArtifact
    }

    func cancel() {
        cancelCallCount += 1
    }

    func discard(_ artifact: AudioRecordingArtifact) {
        discardedArtifacts.append(artifact)
    }
}

private enum RecordingServiceTestError: Error {
    case failed
}
