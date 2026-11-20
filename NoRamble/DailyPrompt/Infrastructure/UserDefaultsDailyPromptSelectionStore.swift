import Foundation

final class UserDefaultsDailyPromptSelectionStore: DailyPromptSelectionStore {
    static let defaultKey = "dailyPrompt.selection.v1"

    private let defaults: UserDefaults
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        defaults: UserDefaults = .standard,
        key: String = defaultKey,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.defaults = defaults
        self.key = key
        self.encoder = encoder
        self.decoder = decoder
    }

    func loadSelection() throws -> DailyPromptSelection? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }

        return try decoder.decode(DailyPromptSelection.self, from: data)
    }

    func saveSelection(_ selection: DailyPromptSelection) throws {
        defaults.set(try encoder.encode(selection), forKey: key)
    }

    func clearSelection() throws {
        defaults.removeObject(forKey: key)
    }
}
