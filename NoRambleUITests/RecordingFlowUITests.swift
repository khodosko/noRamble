import XCTest

@MainActor
final class RecordingFlowUITests: XCTestCase {
    func testSelectedPrompt_canStartStopAndFinishDailyRep() {
        let app = XCUIApplication()
        app.launchArguments += [
            "--reset-daily-prompt-selection",
            "--use-simulated-audio-recorder",
        ]
        app.launch()

        let promptButtons = app.buttons.matching(
            NSPredicate(format: "identifier BEGINSWITH %@", "daily-prompt-option-")
        )
        let startButton = app.buttons["start-daily-rep"]

        XCTAssertTrue(app.staticTexts["daily-prompt-heading"].waitForExistence(timeout: 5))
        XCTAssertFalse(startButton.exists)

        let selectedPromptButton = promptButtons.element(boundBy: 0)
        let selectedPromptLabel = selectedPromptButton.label
        selectedPromptButton.tap()

        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        XCTAssertGreaterThanOrEqual(startButton.frame.height, 60)
        startButton.tap()

        let recordingStatus = app.staticTexts["recording-status"]
        let recordingPrompt = app.staticTexts["recording-prompt-title"]
        let elapsedTime = app.staticTexts["recording-elapsed-time"]
        let stopButton = app.buttons["recording-stop"]
        XCTAssertTrue(recordingStatus.waitForExistence(timeout: 5))
        XCTAssertEqual(recordingStatus.label, "Recording")
        XCTAssertTrue(recordingPrompt.exists)
        XCTAssertTrue(selectedPromptLabel.contains(recordingPrompt.label))
        XCTAssertTrue(elapsedTime.exists)
        XCTAssertNotNil(
            elapsedTime.label.range(
                of: #"^[0-9]+:[0-5][0-9]$"#,
                options: .regularExpression
            )
        )
        XCTAssertLessThan(elapsedTime.frame.height, 30)
        XCTAssertTrue(stopButton.exists)
        XCTAssertFalse(app.staticTexts["daily-prompt-heading"].exists)

        stopButton.tap()

        let capturedHeading = app.staticTexts["recording-captured-heading"]
        XCTAssertTrue(capturedHeading.waitForExistence(timeout: 2))
        XCTAssertEqual(capturedHeading.label, "Daily rep captured")

        app.buttons["recording-done"].tap()

        XCTAssertTrue(app.staticTexts["daily-prompt-heading"].waitForExistence(timeout: 2))
    }
}
