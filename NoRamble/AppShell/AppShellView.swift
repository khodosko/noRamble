import SwiftUI

private struct RecordingRoute: Identifiable {
    let id = UUID()
    let prompt: DailyPrompt
    let model: RecordingViewModel
}

struct AppShellView: View {
    private let content: AppShellContent
    private let dailyPromptModel: DailyPromptViewModel
    private let makeRecordingModel: @MainActor () -> RecordingViewModel
    @State private var recordingRoute: RecordingRoute?

    init(
        content: AppShellContent = .foundation,
        dailyPromptModel: DailyPromptViewModel,
        makeRecordingModel: @escaping @MainActor () -> RecordingViewModel
    ) {
        self.content = content
        self.dailyPromptModel = dailyPromptModel
        self.makeRecordingModel = makeRecordingModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 54, weight: .bold))
                    .foregroundStyle(Color(red: 0.35, green: 0.80, blue: 0.01))
                    .accessibilityHidden(true)

                Text(content.title)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier("app-shell-title")

                Text(content.status)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier("app-shell-status")

                DailyPromptPickerView(
                    model: dailyPromptModel,
                    onStartDailyRep: { prompt in
                        recordingRoute = RecordingRoute(
                            prompt: prompt,
                            model: makeRecordingModel()
                        )
                    }
                )
                    .padding(.top, 8)
            }
            .padding(24)
        }
        .accessibilityHidden(recordingRoute != nil)
        .fullScreenCover(item: $recordingRoute) { route in
            RecordingView(prompt: route.prompt, model: route.model)
        }
    }
}
