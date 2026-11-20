import XCTest
@testable import NoRamble

final class UserDefaultsDailyPromptSelectionStoreTests: XCTestCase {
    private var defaults: UserDefaults!
    private var suiteName: String!

    override func setUp() {
        super.setUp()
        suiteName = "UserDefaultsDailyPromptSelectionStoreTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testSavedSelection_roundTrips() throws {
        let store = UserDefaultsDailyPromptSelectionStore(
            defaults: defaults,
            key: "selection"
        )
        let selection = DailyPromptSelection(
            day: LocalDay(year: 2026, month: 11, day: 19),
            promptID: "work-update"
        )

        try store.saveSelection(selection)

        XCTAssertEqual(try store.loadSelection(), selection)
    }

    func testCorruptSelection_throwsWithoutInventingState() {
        defaults.set(Data([0x00, 0x01, 0x02]), forKey: "selection")
        let store = UserDefaultsDailyPromptSelectionStore(
            defaults: defaults,
            key: "selection"
        )

        XCTAssertThrowsError(try store.loadSelection())
    }

    func testClearSelection_removesSavedValue() throws {
        let store = UserDefaultsDailyPromptSelectionStore(
            defaults: defaults,
            key: "selection"
        )
        try store.saveSelection(
            DailyPromptSelection(
                day: LocalDay(year: 2026, month: 11, day: 19),
                promptID: "work-update"
            )
        )

        try store.clearSelection()

        XCTAssertNil(try store.loadSelection())
    }
}
