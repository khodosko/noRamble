import Foundation
import Observation

@MainActor
@Observable
final class DailyPromptViewModel {
    let prompts: [DailyPrompt]
    private(set) var selectedPromptID: DailyPrompt.ID?
    private(set) var errorMessage: String?

    private let session: DailyPromptSession
    private let calendar: Calendar
    private let now: () -> Date

    init(
        session: DailyPromptSession,
        calendar: Calendar,
        now: @escaping () -> Date
    ) {
        self.session = session
        self.prompts = session.prompts
        self.calendar = calendar
        self.now = now
    }

    func loadSelection() {
        do {
            selectedPromptID = try session.selectedPrompt(
                on: now(),
                calendar: calendar
            )?.id
            errorMessage = nil
        } catch {
            selectedPromptID = nil
            errorMessage = "We couldn’t load today’s prompt. Try reopening the app."
        }
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
