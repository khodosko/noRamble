import XCTest
@testable import NoRamble

@MainActor
final class DailyPromptViewModelTests: XCTestCase {
    func testSelection_updatesObservableStateAndLocksAlternatives() throws {
        let store = ViewModelSelectionStore()
        let prompts = DailyPromptCatalog.curated
        let chosen = try XCTUnwrap(prompts.first)
        let alternative = try XCTUnwrap(prompts.dropFirst().first)
        let model = makeModel(store: store)

        model.loadSelection()
        model.select(promptID: chosen.id)

        XCTAssertEqual(model.selectedPromptID, chosen.id)
        XCTAssertTrue(model.isPromptEnabled(chosen.id))
        XCTAssertFalse(model.isPromptEnabled(alternative.id))
        XCTAssertNil(model.errorMessage)
    }

    func testLoadSelection_existingChoice_restoresObservableState() throws {
        let date = ISO8601DateFormatter().date(from: "2026-11-19T18:00:00Z")!
        let calendar = makeCalendar()
        let chosen = try XCTUnwrap(DailyPromptCatalog.curated.last)
        let store = ViewModelSelectionStore(
            selection: DailyPromptSelection(
                day: LocalDay(date: date, calendar: calendar),
                promptID: chosen.id
            )
        )
        let model = makeModel(store: store, date: date, calendar: calendar)

        model.loadSelection()

        XCTAssertEqual(model.selectedPromptID, chosen.id)
        XCTAssertNil(model.errorMessage)
    }

    func testLoadSelection_storeFailure_exposesRecoveryMessage() {
        let model = makeModel(store: ViewModelSelectionStore(loadError: TestStoreError.failed))

        model.loadSelection()

        XCTAssertNil(model.selectedPromptID)
        XCTAssertEqual(
            model.errorMessage,
            "We couldn’t load today’s prompt. Try reopening the app."
        )
    }

    private func makeModel(
        store: ViewModelSelectionStore,
        date: Date = ISO8601DateFormatter().date(from: "2026-11-19T18:00:00Z")!,
        calendar: Calendar = makeCalendar()
    ) -> DailyPromptViewModel {
        DailyPromptViewModel(
            session: DailyPromptSession(
                prompts: DailyPromptCatalog.curated,
                selectionStore: store
            ),
            calendar: calendar,
            now: { date }
        )
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Vancouver")!
        return calendar
    }
}

private final class ViewModelSelectionStore: DailyPromptSelectionStore {
    var selection: DailyPromptSelection?
    let loadError: Error?

    init(
        selection: DailyPromptSelection? = nil,
        loadError: Error? = nil
    ) {
        self.selection = selection
        self.loadError = loadError
    }

    func loadSelection() throws -> DailyPromptSelection? {
        if let loadError {
            throw loadError
        }
        return selection
    }

    func saveSelection(_ selection: DailyPromptSelection) throws {
        self.selection = selection
    }

    func clearSelection() throws {
        selection = nil
    }
}

private enum TestStoreError: Error {
    case failed
}
