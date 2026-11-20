import Foundation

struct DailyPromptRotation: Sendable {
    private let prompts: [DailyPrompt]

    init(prompts: [DailyPrompt]) {
        precondition(prompts.count >= 3, "Daily prompt rotation requires at least three prompts.")
        self.prompts = prompts.sorted { first, second in
            let firstHash = Self.stableHash(first.id)
            let secondHash = Self.stableHash(second.id)
            return firstHash == secondHash ? first.id < second.id : firstHash < secondHash
        }
    }

    func options(on date: Date, calendar: Calendar) -> [DailyPrompt] {
        let localDay = calendar.startOfDay(for: date)
        let referenceDay = calendar.date(
            from: DateComponents(year: 2001, month: 1, day: 1)
        ) ?? localDay
        let dayOffset = calendar.dateComponents(
            [.day],
            from: referenceDay,
            to: localDay
        ).day ?? 0
        let startIndex = positiveModulo(dayOffset * 3, prompts.count)

        return (0..<3).map { offset in
            prompts[(startIndex + offset) % prompts.count]
        }
    }

    private func positiveModulo(_ value: Int, _ divisor: Int) -> Int {
        let remainder = value % divisor
        return remainder >= 0 ? remainder : remainder + divisor
    }

    private static func stableHash(_ value: String) -> UInt64 {
        var hash: UInt64 = 14_695_981_039_346_656_037
        for byte in value.utf8 {
            hash ^= UInt64(byte)
            hash &*= 1_099_511_628_211
        }
        return hash
    }
}
