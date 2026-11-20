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

        promptButtons.element(boundBy: 0).tap()

        XCTAssertTrue(startButton.waitForExistence(timeout: 2))
        startButton.tap()

        let recordingStatus = app.staticTexts["recording-status"]
        let stopButton = app.buttons["recording-stop"]
        XCTAssertTrue(recordingStatus.waitForExistence(timeout: 5))
        XCTAssertEqual(recordingStatus.label, "Recording")
        XCTAssertTrue(stopButton.exists)
        XCTAssertFalse(app.staticTexts["recording-elapsed-time"].exists)
        XCTAssertFalse(app.staticTexts["daily-prompt-heading"].exists)

        stopButton.tap()

        let capturedHeading = app.staticTexts["recording-captured-heading"]
        XCTAssertTrue(capturedHeading.waitForExistence(timeout: 2))
        XCTAssertEqual(capturedHeading.label, "Daily rep captured")

        app.buttons["recording-done"].tap()

        XCTAssertTrue(app.staticTexts["daily-prompt-heading"].waitForExistence(timeout: 2))
    }
}
