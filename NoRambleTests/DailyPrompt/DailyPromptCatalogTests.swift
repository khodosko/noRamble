import XCTest
@testable import NoRamble

final class DailyPromptCatalogTests: XCTestCase {
    func testCurated_containsExactlyThreeDistinctPrompts() {
        let prompts = DailyPromptCatalog.curated

        XCTAssertEqual(prompts.count, 3)
        XCTAssertEqual(Set(prompts.map(\.id)).count, 3)
        XCTAssertTrue(prompts.allSatisfy { !$0.category.isEmpty })
        XCTAssertTrue(prompts.allSatisfy { !$0.title.isEmpty })
        XCTAssertTrue(prompts.allSatisfy { !$0.guidance.isEmpty })
    }
}
