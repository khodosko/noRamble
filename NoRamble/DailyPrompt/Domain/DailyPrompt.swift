import Foundation

struct DailyPrompt: Identifiable, Equatable, Sendable {
    let id: String
    let category: String
    let title: String
    let guidance: String
}

enum DailyPromptCatalog {
    static let curated: [DailyPrompt] = [
        DailyPrompt(
            id: "work-update",
            category: "Work & Projects",
            title: "What are you working on?",
            guidance: "Lead with the outcome, not the backstory."
        ),
        DailyPrompt(
            id: "priority-case",
            category: "Decision & Impact",
            title: "Why should we prioritize this now?",
            guidance: "State the urgency in your opening line."
        ),
        DailyPrompt(
            id: "team-value",
            category: "Pitch & Intro",
            title: "What does your team actually do?",
            guidance: "Skip the org chart—name the core value."
        ),
    ]
}
