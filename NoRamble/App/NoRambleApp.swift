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
            prompts: DailyPromptCatalog.curated,
            selectionStore: store
        )
        _dailyPromptModel = State(
            initialValue: DailyPromptViewModel(
                session: session,
                calendar: .autoupdatingCurrent,
                now: Date.init
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            AppShellView(dailyPromptModel: dailyPromptModel)
        }
    }
}
