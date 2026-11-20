import SwiftUI

struct RecordingView: View {
    @Bindable var model: RecordingViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private let recordingRed = Color(red: 1.0, green: 0.29, blue: 0.29)
    private let successGreen = Color(red: 0.35, green: 0.80, blue: 0.01)

    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                closeBar

                Spacer()

                stateContent

                Spacer()

                Color.clear
                    .frame(height: 44)
                    .accessibilityHidden(true)
            }
            .padding(20)
        }
        .interactiveDismissDisabled()
        .task {
            await model.begin()
        }
        .onChange(of: model.shouldDismiss) { _, shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        }
    }

    private var closeBar: some View {
        HStack {
            Spacer()
            Button {
                model.close()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .frame(width: 44, height: 44)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 2)
                    }
            }
            .foregroundStyle(.primary)
            .accessibilityLabel("Close recording")
            .accessibilityHint("Cancels and deletes this recording.")
            .accessibilityIdentifier("recording-close")
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch model.state {
        case .preparing:
            ProgressView()
                .controlSize(.large)
                .accessibilityLabel("Getting microphone ready")
        case .recording:
            activeRecording
        case .permissionDenied:
            permissionDenied
        case .captured:
            captured
        case let .failed(failure):
            failed(failure)
        }
    }

    private var activeRecording: some View {
        VStack(spacing: 48) {
            HStack(spacing: 8) {
                Circle()
                    .fill(recordingRed)
                    .frame(width: 10, height: 10)
                    .accessibilityHidden(true)
                Text("Recording")
                    .font(.headline)
                    .accessibilityIdentifier("recording-status")
            }
            .foregroundStyle(Color(red: 0.78, green: 0.12, blue: 0.12))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(recordingRed.opacity(0.4), lineWidth: 2)
            }

            Button {
                model.stop()
            } label: {
                Image(systemName: "mic.fill")
                    .font(.system(size: 58, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 164, height: 164)
                    .background(recordingRed)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(recordingRed.opacity(0.2), lineWidth: 16)
                            .padding(-8)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Stop recording")
            .accessibilityHint("Stops and saves this daily rep.")
            .accessibilityIdentifier("recording-stop")
        }
    }

    private var permissionDenied: some View {
        VStack(spacing: 20) {
            Image(systemName: "mic.slash.fill")
                .font(.system(size: 58, weight: .bold))
                .foregroundStyle(recordingRed)
                .accessibilityHidden(true)

            Text("Microphone access needed")
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text("Allow microphone access in Settings to record your daily rep.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Open Settings") {
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                openURL(url)
            }
            .buttonStyle(.borderedProminent)
            .tint(successGreen)
            .accessibilityIdentifier("recording-open-settings")
        }
        .frame(maxWidth: 320)
    }

    private var captured: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(successGreen)
                .accessibilityHidden(true)

            Text("Daily rep captured")
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
                .accessibilityIdentifier("recording-captured-heading")

            Text("Your recording is ready.")
                .foregroundStyle(.secondary)

            Button("Done") {
                model.close()
            }
            .buttonStyle(.borderedProminent)
            .tint(successGreen)
            .controlSize(.large)
            .accessibilityIdentifier("recording-done")
        }
    }

    private func failed(_ failure: RecordingFailure) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 58, weight: .bold))
                .foregroundStyle(.orange)
                .accessibilityHidden(true)

            Text(failure == .couldNotStart ? "Recording didn’t start" : "Recording couldn’t finish")
                .font(.title.bold())
                .multilineTextAlignment(.center)

            Text("Check your audio connection and try again.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task {
                    await model.retry()
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(successGreen)
            .accessibilityIdentifier("recording-retry")
        }
        .frame(maxWidth: 320)
    }
}
