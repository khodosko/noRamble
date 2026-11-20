import XCTest
@testable import NoRamble

final class DailyPromptRotationTests: XCTestCase {
    private let calendar = makeVancouverCalendar()
    private let rotation = DailyPromptRotation(prompts: DailyPromptCatalog.curated)

    func testOptions_forDay_containsExactlyThreeDistinctLibraryPrompts() {
        let options = rotation.options(
            on: date("2026-11-20T18:00:00Z"),
            calendar: calendar
        )
        let libraryIDs = Set(DailyPromptCatalog.curated.map(\.id))

        XCTAssertEqual(options.count, 3)
        XCTAssertEqual(Set(options.map(\.id)).count, 3)
        XCTAssertTrue(options.allSatisfy { libraryIDs.contains($0.id) })
    }

    func testOptions_sameLocalDay_isStableAcrossTimesAndInstances() {
        let morning = date("2026-11-20T16:00:00Z")
        let evening = date("2026-11-21T06:00:00Z")
        let separateInstance = DailyPromptRotation(prompts: DailyPromptCatalog.curated)

        let first = rotation.options(on: morning, calendar: calendar)
        let second = separateInstance.options(on: evening, calendar: calendar)

        XCTAssertEqual(first, second)
    }

    func testOptions_consecutiveLocalDays_changeSet() {
        let first = rotation.options(
            on: date("2026-11-20T18:00:00Z"),
            calendar: calendar
        )
        let second = rotation.options(
            on: date("2026-11-21T18:00:00Z"),
            calendar: calendar
        )

        XCTAssertNotEqual(Set(first.map(\.id)), Set(second.map(\.id)))
    }

    func testOptions_overCompleteCycle_surfaceEntireLibrary() {
        let cycleLength = Int(ceil(Double(DailyPromptCatalog.curated.count) / 3.0))
        let start = date("2026-11-20T18:00:00Z")
        let surfacedIDs = (0..<cycleLength).reduce(into: Set<String>()) { result, offset in
            let day = calendar.date(byAdding: .day, value: offset, to: start)!
            result.formUnion(rotation.options(on: day, calendar: calendar).map(\.id))
        }

        XCTAssertEqual(surfacedIDs, Set(DailyPromptCatalog.curated.map(\.id)))
    }

    func testOptions_beforeReferenceEpoch_stillReturnsThreePrompts() {
        let options = rotation.options(
            on: date("1999-12-31T18:00:00Z"),
            calendar: calendar
        )

        XCTAssertEqual(options.count, 3)
    }

    private func date(_ value: String) -> Date {
        ISO8601DateFormatter().date(from: value)!
    }
}

private func makeVancouverCalendar() -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "America/Vancouver")!
    return calendar
}
