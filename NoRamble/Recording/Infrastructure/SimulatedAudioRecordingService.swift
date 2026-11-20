#if DEBUG
import Foundation

@MainActor
final class SimulatedAudioRecordingService: AudioRecordingService {
    var permission: AudioRecordingPermission { .granted }

    func requestPermission() async -> AudioRecordingPermission {
        .granted
    }

    func start() throws {}

    func stop() throws -> AudioRecordingArtifact {
        AudioRecordingArtifact(
            url: URL(fileURLWithPath: "/tmp/no-ramble-simulated.m4a")
        )
    }

    func cancel() {}

    func discard(_ artifact: AudioRecordingArtifact) {}
}
#endif
