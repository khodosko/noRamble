import SwiftUI

struct AppShellView: View {
    private let content: AppShellContent
    private let dailyPromptModel: DailyPromptViewModel
    private let makeRecordingModel: @MainActor () -> RecordingViewModel
    @State private var recordingModel: RecordingViewModel?

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
                    onStartDailyRep: {
                        recordingModel = makeRecordingModel()
                    }
                )
                    .padding(.top, 8)
            }
            .padding(24)
        }
        .accessibilityHidden(recordingModel != nil)
        .fullScreenCover(item: $recordingModel) { model in
            RecordingView(model: model)
        }
    }
}
