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

    func testLoadSelection_legacySameDayChoice_preservesItWithinThreeVisibleOptions() throws {
        let date = ISO8601DateFormatter().date(from: "2026-11-20T18:00:00Z")!
        let calendar = makeCalendar()
        let legacyPrompt = try XCTUnwrap(DailyPromptCatalog.legacy.first)
        let store = ViewModelSelectionStore(
            selection: DailyPromptSelection(
                day: LocalDay(date: date, calendar: calendar),
                promptID: legacyPrompt.id
            )
        )
        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.all,
            selectionStore: store
        )
        let model = DailyPromptViewModel(
            session: session,
            rotation: DailyPromptRotation(prompts: DailyPromptCatalog.curated),
            calendar: calendar,
            now: { date }
        )

        model.loadSelection()

        XCTAssertEqual(model.selectedPromptID, legacyPrompt.id)
        XCTAssertEqual(model.prompts.count, 3)
        XCTAssertTrue(model.prompts.contains(legacyPrompt))
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

    func testSelect_storeFailure_exposesSaveRecoveryMessage() {
        let model = makeModel(store: ViewModelSelectionStore(saveError: TestStoreError.failed))

        model.select(promptID: "work-update")

        XCTAssertNil(model.selectedPromptID)
        XCTAssertEqual(
            model.errorMessage,
            "We couldn’t save your prompt. Please try again."
        )
    }

    func testSelect_unknownPrompt_exposesUnavailableMessage() {
        let model = makeModel(store: ViewModelSelectionStore())

        model.select(promptID: "missing-prompt")

        XCTAssertNil(model.selectedPromptID)
        XCTAssertEqual(
            model.errorMessage,
            "That prompt is unavailable. Reopen the app to refresh."
        )
    }

    func testSelect_whenStoreAlreadyHasDifferentSameDayChoice_restoresLock() throws {
        let date = ISO8601DateFormatter().date(from: "2026-11-19T18:00:00Z")!
        let calendar = makeCalendar()
        let original = try XCTUnwrap(DailyPromptCatalog.curated.first)
        let replacement = try XCTUnwrap(DailyPromptCatalog.curated.dropFirst().first)
        let model = makeModel(
            store: ViewModelSelectionStore(
                selection: DailyPromptSelection(
                    day: LocalDay(date: date, calendar: calendar),
                    promptID: original.id
                )
            ),
            date: date,
            calendar: calendar
        )

        model.select(promptID: replacement.id)

        XCTAssertEqual(model.selectedPromptID, original.id)
        XCTAssertEqual(
            model.errorMessage,
            "Today’s prompt is already locked for your retries."
        )
    }

    func testSelect_disabledAlternativeAfterChoice_isIgnored() throws {
        let prompts = DailyPromptCatalog.curated
        let original = try XCTUnwrap(prompts.first)
        let alternative = try XCTUnwrap(prompts.dropFirst().first)
        let model = makeModel(store: ViewModelSelectionStore())

        model.select(promptID: original.id)
        model.select(promptID: alternative.id)

        XCTAssertEqual(model.selectedPromptID, original.id)
        XCTAssertNil(model.errorMessage)
    }

    private func makeModel(
        store: ViewModelSelectionStore,
        date: Date = ISO8601DateFormatter().date(from: "2026-11-19T18:00:00Z")!,
        calendar: Calendar? = nil
    ) -> DailyPromptViewModel {
        let calendar = calendar ?? makeCalendar()
        return DailyPromptViewModel(
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
    let saveError: Error?

    init(
        selection: DailyPromptSelection? = nil,
        loadError: Error? = nil,
        saveError: Error? = nil
    ) {
        self.selection = selection
        self.loadError = loadError
        self.saveError = saveError
    }

    func loadSelection() throws -> DailyPromptSelection? {
        if let loadError {
            throw loadError
        }
        return selection
    }

    func saveSelection(_ selection: DailyPromptSelection) throws {
        if let saveError {
            throw saveError
        }
        self.selection = selection
    }

    func clearSelection() throws {
        selection = nil
    }
}

private enum TestStoreError: Error {
    case failed
}
