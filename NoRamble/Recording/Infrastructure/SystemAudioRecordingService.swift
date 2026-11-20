import AVFAudio
import Foundation

enum SystemAudioRecordingError: Error {
    case recordingAlreadyActive
    case noActiveRecording
    case couldNotPrepare
    case couldNotStart
}

@MainActor
final class SystemAudioRecordingService: AudioRecordingService {
    private let audioSession: AVAudioSession
    private let fileManager: FileManager
    private let makeIdentifier: () -> UUID

    private var recorder: AVAudioRecorder?
    private var ownedURL: URL?

    init(
        audioSession: AVAudioSession = .sharedInstance(),
        fileManager: FileManager = .default,
        makeIdentifier: @escaping () -> UUID = UUID.init
    ) {
        self.audioSession = audioSession
        self.fileManager = fileManager
        self.makeIdentifier = makeIdentifier
    }

    var permission: AudioRecordingPermission {
        switch AVAudioApplication.shared.recordPermission {
        case .undetermined:
            return .undetermined
        case .denied:
            return .denied
        case .granted:
            return .granted
        @unknown default:
            return .denied
        }
    }

    func requestPermission() async -> AudioRecordingPermission {
        await AVAudioApplication.requestRecordPermission() ? .granted : .denied
    }

    func start() throws {
        guard recorder == nil, ownedURL == nil else {
            throw SystemAudioRecordingError.recordingAlreadyActive
        }

        let url = fileManager.temporaryDirectory
            .appendingPathComponent("no-ramble-\(makeIdentifier().uuidString)")
            .appendingPathExtension("m4a")

        do {
            try audioSession.setCategory(.record, mode: .measurement)
            try audioSession.setActive(true)

            let newRecorder = try AVAudioRecorder(
                url: url,
                settings: [
                    AVFormatIDKey: kAudioFormatMPEG4AAC,
                    AVSampleRateKey: 44_100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
                ]
            )
            guard newRecorder.prepareToRecord() else {
                throw SystemAudioRecordingError.couldNotPrepare
            }
            guard newRecorder.record() else {
                throw SystemAudioRecordingError.couldNotStart
            }

            recorder = newRecorder
            ownedURL = url
        } catch {
            try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            try? fileManager.removeItem(at: url)
            throw error
        }
    }

    func stop() throws -> AudioRecordingArtifact {
        guard let recorder, let ownedURL else {
            throw SystemAudioRecordingError.noActiveRecording
        }

        recorder.stop()
        self.recorder = nil

        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            return AudioRecordingArtifact(url: ownedURL)
        } catch {
            try? fileManager.removeItem(at: ownedURL)
            self.ownedURL = nil
            throw error
        }
    }

    func cancel() {
        recorder?.stop()
        recorder = nil
        removeOwnedRecording()
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
    }

    func discard(_ artifact: AudioRecordingArtifact) {
        guard artifact.url == ownedURL else {
            return
        }
        removeOwnedRecording()
    }

    private func removeOwnedRecording() {
        guard let ownedURL else {
            return
        }
        try? fileManager.removeItem(at: ownedURL)
        self.ownedURL = nil
    }
}
