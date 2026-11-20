import Foundation

enum AudioRecordingPermission: Equatable, Sendable {
    case undetermined
    case denied
    case granted
}

struct AudioRecordingArtifact: Equatable, Sendable {
    let url: URL
}

@MainActor
protocol AudioRecordingService: AnyObject {
    var permission: AudioRecordingPermission { get }

    func requestPermission() async -> AudioRecordingPermission
    func start() throws
    func stop() throws -> AudioRecordingArtifact
    func cancel()
    func discard(_ artifact: AudioRecordingArtifact)
}
