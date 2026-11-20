import Foundation
import Observation

@MainActor
@Observable
final class DailyPromptViewModel {
    private(set) var prompts: [DailyPrompt]
    private(set) var selectedPromptID: DailyPrompt.ID?
    private(set) var errorMessage: String?

    private let session: DailyPromptSession
    private let rotation: DailyPromptRotation?
    private let calendar: Calendar
    private let now: () -> Date

    init(
        session: DailyPromptSession,
        calendar: Calendar,
        now: @escaping () -> Date
    ) {
        self.session = session
        self.prompts = session.prompts
        self.rotation = nil
        self.calendar = calendar
        self.now = now
    }

    init(
        session: DailyPromptSession,
        rotation: DailyPromptRotation,
        calendar: Calendar,
        now: @escaping () -> Date
    ) {
        self.session = session
        self.rotation = rotation
        self.calendar = calendar
        self.now = now
        self.prompts = rotation.options(on: now(), calendar: calendar)
    }

    func loadSelection() {
        do {
            let date = now()
            let currentOptions = rotation?.options(on: date, calendar: calendar)
                ?? session.prompts
            let selectedPrompt = try session.selectedPrompt(
                on: date,
                calendar: calendar
            )
            prompts = visiblePrompts(
                currentOptions: currentOptions,
                selectedPrompt: selectedPrompt
            )
            selectedPromptID = selectedPrompt?.id
            errorMessage = nil
        } catch {
            selectedPromptID = nil
            errorMessage = "We couldn’t load today’s prompt. Try reopening the app."
        }
    }

    private func visiblePrompts(
        currentOptions: [DailyPrompt],
        selectedPrompt: DailyPrompt?
    ) -> [DailyPrompt] {
        guard let selectedPrompt,
              !currentOptions.contains(where: { $0.id == selectedPrompt.id }) else {
            return currentOptions
        }

        return [selectedPrompt] + currentOptions
            .filter { $0.id != selectedPrompt.id }
            .prefix(2)
    }

    func select(promptID: DailyPrompt.ID) {
        guard isPromptEnabled(promptID) else {
            return
        }

        do {
            selectedPromptID = try session.select(
                promptID: promptID,
                on: now(),
                calendar: calendar
            ).id
            errorMessage = nil
        } catch let error as DailyPromptSessionError {
            handleSessionError(error)
        } catch {
            errorMessage = "We couldn’t save your prompt. Please try again."
        }
    }

    func isPromptEnabled(_ promptID: DailyPrompt.ID) -> Bool {
        selectedPromptID == nil || selectedPromptID == promptID
    }

    private func handleSessionError(_ error: DailyPromptSessionError) {
        switch error {
        case let .selectionLocked(existingPromptID):
            selectedPromptID = existingPromptID
            errorMessage = "Today’s prompt is already locked for your retries."
        case .unknownPrompt, .storedPromptUnavailable:
            errorMessage = "That prompt is unavailable. Reopen the app to refresh."
        }
    }
}
