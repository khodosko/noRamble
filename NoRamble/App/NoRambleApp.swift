import SwiftUI

@main
@MainActor
struct NoRambleApp: App {
    @State private var dailyPromptModel: DailyPromptViewModel

    init() {
        let store = UserDefaultsDailyPromptSelectionStore()
        if ProcessInfo.processInfo.arguments.contains("--reset-daily-prompt-selection") {
            try? store.clearSelection()
        }

        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.all,
            selectionStore: store
        )
        let calendar = Calendar.autoupdatingCurrent
        _dailyPromptModel = State(
            initialValue: DailyPromptViewModel(
                session: session,
                rotation: DailyPromptRotation(prompts: DailyPromptCatalog.curated),
                calendar: calendar,
                now: Date.init
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            AppShellView(
                dailyPromptModel: dailyPromptModel,
                makeRecordingModel: makeRecordingModel
            )
        }
    }

    private func makeRecordingModel() -> RecordingViewModel {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--use-simulated-audio-recorder") {
            return RecordingViewModel(service: SimulatedAudioRecordingService())
        }
        #endif
        return RecordingViewModel(service: SystemAudioRecordingService())
    }
}
