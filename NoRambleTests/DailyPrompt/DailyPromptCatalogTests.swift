import XCTest
@testable import NoRamble

final class DailyPromptCatalogTests: XCTestCase {
    func testCuratedLibrary_containsAtLeastThirtyDistinctOriginalPromptsAcrossCategories() {
        let prompts = DailyPromptCatalog.curated

        XCTAssertGreaterThanOrEqual(prompts.count, 30)
        XCTAssertEqual(Set(prompts.map(\.id)).count, prompts.count)
        XCTAssertEqual(
            Set(prompts.map { $0.title.lowercased() }).count,
            prompts.count
        )
        XCTAssertGreaterThanOrEqual(Set(prompts.map(\.category)).count, 5)
        XCTAssertTrue(prompts.allSatisfy { !$0.category.isEmpty })
        XCTAssertTrue(prompts.allSatisfy { !$0.title.isEmpty })
        XCTAssertTrue(prompts.allSatisfy { !$0.guidance.isEmpty })
    }

    func testLegacyPrompts_areExcludedFromCuratedRotationLibrary() {
        let currentIDs = Set(DailyPromptCatalog.curated.map(\.id))
        let legacyIDs = Set(DailyPromptCatalog.legacy.map(\.id))

        XCTAssertTrue(currentIDs.isDisjoint(with: legacyIDs))
        XCTAssertEqual(DailyPromptCatalog.all.count, currentIDs.count + legacyIDs.count)
    }
}
