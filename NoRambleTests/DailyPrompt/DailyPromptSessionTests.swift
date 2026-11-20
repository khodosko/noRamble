import XCTest
@testable import NoRamble

final class DailyPromptSessionTests: XCTestCase {
    private let calendar = TestDates.vancouverCalendar
    private let today = TestDates.date("2026-11-19T18:00:00Z")

    func testSelect_knownPrompt_persistsAndRestoresForSameDayRetry() throws {
        let store = InMemoryDailyPromptSelectionStore()
        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.curated,
            selectionStore: store
        )
        let chosen = try XCTUnwrap(DailyPromptCatalog.curated.first)

        let selected = try session.select(
            promptID: chosen.id,
            on: today,
            calendar: calendar
        )
        let restored = try session.selectedPrompt(on: today, calendar: calendar)

        XCTAssertEqual(selected, chosen)
        XCTAssertEqual(restored, chosen)
        XCTAssertEqual(
            store.selection,
            DailyPromptSelection(
                day: LocalDay(date: today, calendar: calendar),
                promptID: chosen.id
            )
        )
    }

    func testSelect_samePromptAgain_isIdempotent() throws {
        let store = InMemoryDailyPromptSelectionStore()
        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.curated,
            selectionStore: store
        )
        let chosen = try XCTUnwrap(DailyPromptCatalog.curated.first)

        _ = try session.select(promptID: chosen.id, on: today, calendar: calendar)
        let selectedAgain = try session.select(
            promptID: chosen.id,
            on: today,
            calendar: calendar
        )

        XCTAssertEqual(selectedAgain, chosen)
        XCTAssertEqual(store.saveCount, 1)
    }

    func testSelect_differentPromptOnSameDay_keepsOriginalAndThrowsLocked() throws {
        let store = InMemoryDailyPromptSelectionStore()
        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.curated,
            selectionStore: store
        )
        let original = try XCTUnwrap(DailyPromptCatalog.curated.first)
        let replacement = try XCTUnwrap(DailyPromptCatalog.curated.dropFirst().first)
        _ = try session.select(promptID: original.id, on: today, calendar: calendar)

        XCTAssertThrowsError(
            try session.select(
                promptID: replacement.id,
                on: today,
                calendar: calendar
            )
        ) { error in
            XCTAssertEqual(
                error as? DailyPromptSessionError,
                .selectionLocked(existingPromptID: original.id)
            )
        }
        XCTAssertEqual(store.selection?.promptID, original.id)
        XCTAssertEqual(store.saveCount, 1)
    }

    func testSelect_unknownPrompt_doesNotPersistAndThrowsUnknownPrompt() {
        let store = InMemoryDailyPromptSelectionStore()
        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.curated,
            selectionStore: store
        )

        XCTAssertThrowsError(
            try session.select(
                promptID: "missing-prompt",
                on: today,
                calendar: calendar
            )
        ) { error in
            XCTAssertEqual(
                error as? DailyPromptSessionError,
                .unknownPrompt(promptID: "missing-prompt")
            )
        }
        XCTAssertNil(store.selection)
        XCTAssertEqual(store.saveCount, 0)
    }

    func testSelection_onNextLocalDay_startsEmptyAndAllowsNewChoice() throws {
        let store = InMemoryDailyPromptSelectionStore()
        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.curated,
            selectionStore: store
        )
        let original = try XCTUnwrap(DailyPromptCatalog.curated.first)
        let nextChoice = try XCTUnwrap(DailyPromptCatalog.curated.dropFirst().first)
        let tomorrow = TestDates.date("2026-11-20T18:00:00Z")
        _ = try session.select(promptID: original.id, on: today, calendar: calendar)

        XCTAssertNil(try session.selectedPrompt(on: tomorrow, calendar: calendar))
        let selectedTomorrow = try session.select(
            promptID: nextChoice.id,
            on: tomorrow,
            calendar: calendar
        )

        XCTAssertEqual(selectedTomorrow, nextChoice)
        XCTAssertEqual(store.selection?.promptID, nextChoice.id)
        XCTAssertEqual(store.saveCount, 2)
    }

    func testSelectedPrompt_savedIdentifierMissingFromCatalog_throwsUnavailable() {
        let missingID = "retired-prompt"
        let store = InMemoryDailyPromptSelectionStore(
            selection: DailyPromptSelection(
                day: LocalDay(date: today, calendar: calendar),
                promptID: missingID
            )
        )
        let session = DailyPromptSession(
            prompts: DailyPromptCatalog.curated,
            selectionStore: store
        )

        XCTAssertThrowsError(
            try session.selectedPrompt(on: today, calendar: calendar)
        ) { error in
            XCTAssertEqual(
                error as? DailyPromptSessionError,
                .storedPromptUnavailable(promptID: missingID)
            )
        }
    }

    func testLocalDay_usesInjectedCalendarTimeZone() {
        let instant = TestDates.date("2026-11-20T07:30:00Z")
        var utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let vancouverDay = LocalDay(date: instant, calendar: calendar)
        let utcDay = LocalDay(date: instant, calendar: utcCalendar)

        XCTAssertEqual(vancouverDay, LocalDay(year: 2026, month: 11, day: 19))
        XCTAssertEqual(utcDay, LocalDay(year: 2026, month: 11, day: 20))
    }
}

private final class InMemoryDailyPromptSelectionStore: DailyPromptSelectionStore {
    var selection: DailyPromptSelection?
    private(set) var saveCount = 0

    init(selection: DailyPromptSelection? = nil) {
        self.selection = selection
    }

    func loadSelection() throws -> DailyPromptSelection? {
        selection
    }

    func saveSelection(_ selection: DailyPromptSelection) throws {
        self.selection = selection
        saveCount += 1
    }

    func clearSelection() throws {
        selection = nil
    }
}

private enum TestDates {
    static var vancouverCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/Vancouver")!
        return calendar
    }

    static func date(_ value: String) -> Date {
        ISO8601DateFormatter().date(from: value)!
    }
}
