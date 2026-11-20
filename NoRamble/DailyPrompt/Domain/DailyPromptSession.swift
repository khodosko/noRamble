import Foundation

enum DailyPromptSessionError: Error, Equatable {
    case unknownPrompt(promptID: String)
    case selectionLocked(existingPromptID: String)
    case storedPromptUnavailable(promptID: String)
}

struct DailyPromptSession {
    let prompts: [DailyPrompt]
    private let selectionStore: any DailyPromptSelectionStore

    init(
        prompts: [DailyPrompt],
        selectionStore: any DailyPromptSelectionStore
    ) {
        self.prompts = prompts
        self.selectionStore = selectionStore
    }

    func selectedPrompt(on date: Date, calendar: Calendar) throws -> DailyPrompt? {
        guard let selection = try selectionStore.loadSelection() else {
            return nil
        }

        guard selection.day == LocalDay(date: date, calendar: calendar) else {
            return nil
        }

        guard let prompt = prompt(withID: selection.promptID) else {
            throw DailyPromptSessionError.storedPromptUnavailable(
                promptID: selection.promptID
            )
        }

        return prompt
    }

    func select(
        promptID: DailyPrompt.ID,
        on date: Date,
        calendar: Calendar
    ) throws -> DailyPrompt {
        guard let requestedPrompt = prompt(withID: promptID) else {
            throw DailyPromptSessionError.unknownPrompt(promptID: promptID)
        }

        let requestedDay = LocalDay(date: date, calendar: calendar)
        if let existingSelection = try selectionStore.loadSelection(),
           existingSelection.day == requestedDay {
            guard existingSelection.promptID == promptID else {
                throw DailyPromptSessionError.selectionLocked(
                    existingPromptID: existingSelection.promptID
                )
            }

            return requestedPrompt
        }

        try selectionStore.saveSelection(
            DailyPromptSelection(day: requestedDay, promptID: promptID)
        )
        return requestedPrompt
    }

    private func prompt(withID id: DailyPrompt.ID) -> DailyPrompt? {
        prompts.first { $0.id == id }
    }
}
