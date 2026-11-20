import XCTest

@MainActor
final class DailyPromptSelectionUITests: XCTestCase {
    func testSelectingPrompt_marksItSelectedAndLocksOtherChoices() {
        let app = XCUIApplication()
        app.launchArguments.append("--reset-daily-prompt-selection")
        app.launch()

        let heading = app.staticTexts["daily-prompt-heading"]
        let promptButtons = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH %@", "daily-prompt-option-")
        )
        let chosen = promptButtons.element(boundBy: 0)
        let alternative = promptButtons.element(boundBy: 1)

        XCTAssertTrue(heading.waitForExistence(timeout: 5))
        XCTAssertEqual(heading.label, "Pick 1 of 3 prompts")
        XCTAssertEqual(promptButtons.count, 3)
        XCTAssertTrue(chosen.isEnabled)

        chosen.tap()

        XCTAssertEqual(chosen.value as? String, "Selected")
        XCTAssertTrue(chosen.isEnabled)
        XCTAssertFalse(alternative.isEnabled)
    }
}
