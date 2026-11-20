import Foundation

struct LocalDay: Codable, Equatable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }

    init(date: Date, calendar: Calendar) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard
            let year = components.year,
            let month = components.month,
            let day = components.day
        else {
            preconditionFailure("Calendar did not produce a local day")
        }

        self.init(year: year, month: month, day: day)
    }
}

struct DailyPromptSelection: Codable, Equatable, Sendable {
    let day: LocalDay
    let promptID: String
}

protocol DailyPromptSelectionStore: AnyObject {
    func loadSelection() throws -> DailyPromptSelection?
    func saveSelection(_ selection: DailyPromptSelection) throws
    func clearSelection() throws
}
