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
            id: "harmless-opinion",
            category: "Opinion",
            title: "What harmless opinion will you defend forever?",
            guidance: "Make your case with one vivid example."
        ),
        DailyPrompt(
            id: "tiny-decision",
            category: "Story",
            title: "Tell a story about a tiny decision that changed your day.",
            guidance: "Start at the moment you made the choice."
        ),
        DailyPrompt(
            id: "everyday-redesign",
            category: "Imagination",
            title: "What everyday object deserves a complete redesign?",
            guidance: "Name the problem before pitching your fix."
        ),
        DailyPrompt(
            id: "adult-skill",
            category: "Opinion",
            title: "Which skill should every adult learn?",
            guidance: "Explain the real-life moment when it matters."
        ),
        DailyPrompt(
            id: "changed-mind",
            category: "Reflection",
            title: "When did you change your mind about something important?",
            guidance: "Contrast what you believed before and after."
        ),
        DailyPrompt(
            id: "remove-rule",
            category: "Imagination",
            title: "What rule would you remove for one week?",
            guidance: "Predict one benefit and one surprise."
        ),
        DailyPrompt(
            id: "ordinary-day",
            category: "Reflection",
            title: "If you could relive one ordinary day, which would you choose?",
            guidance: "Use details that explain why it mattered."
        ),
        DailyPrompt(
            id: "wildly-overrated",
            category: "Opinion",
            title: "What is wildly overrated?",
            guidance: "Take a clear position without hedging."
        ),
        DailyPrompt(
            id: "worthwhile-risk",
            category: "Story",
            title: "Describe a risk that was worth taking.",
            guidance: "Show what was at stake and what happened."
        ),
        DailyPrompt(
            id: "remembered-kindness",
            category: "Connection",
            title: "What small kindness do you still remember?",
            guidance: "Tell us what the person did, then why it stayed with you."
        ),
        DailyPrompt(
            id: "trade-places",
            category: "Imagination",
            title: "Whose job would you try for one day?",
            guidance: "Describe what you would want to understand."
        ),
        DailyPrompt(
            id: "bad-advice",
            category: "Story",
            title: "What bad advice taught you something useful?",
            guidance: "Set up the advice, the result, and the lesson."
        ),
        DailyPrompt(
            id: "perfect-morning",
            category: "Reflection",
            title: "What makes a morning feel genuinely good?",
            guidance: "Choose two details instead of listing everything."
        ),
        DailyPrompt(
            id: "unpopular-convenience",
            category: "Opinion",
            title: "Which modern convenience could you happily lose?",
            guidance: "Explain what you would gain by giving it up."
        ),
        DailyPrompt(
            id: "unexpected-teacher",
            category: "Connection",
            title: "Who taught you something without realizing it?",
            guidance: "Share the moment their lesson clicked."
        ),
        DailyPrompt(
            id: "small-bravery",
            category: "Story",
            title: "Tell us about a small moment when you were brave.",
            guidance: "Focus on the hesitation just before you acted."
        ),
        DailyPrompt(
            id: "city-improvement",
            category: "Decision",
            title: "What one change would improve your city?",
            guidance: "Name who benefits and why it should happen first."
        ),
        DailyPrompt(
            id: "keep-or-quit",
            category: "Decision",
            title: "How do you decide whether to keep going or quit?",
            guidance: "Give one principle and one real example."
        ),
        DailyPrompt(
            id: "future-tradition",
            category: "Imagination",
            title: "What new tradition should people celebrate in the future?",
            guidance: "Paint the scene as if it already exists."
        ),
        DailyPrompt(
            id: "useful-failure",
            category: "Reflection",
            title: "Which failure became useful later?",
            guidance: "Connect the setback directly to what it changed."
        ),
        DailyPrompt(
            id: "conversation-starter",
            category: "Connection",
            title: "What question reliably starts a great conversation?",
            guidance: "Answer the question yourself to prove it works."
        ),
        DailyPrompt(
            id: "buying-time",
            category: "Decision",
            title: "What is worth paying more for?",
            guidance: "Explain the tradeoff in practical terms."
        ),
        DailyPrompt(
            id: "misunderstood-hobby",
            category: "Connection",
            title: "What hobby do people misunderstand?",
            guidance: "Show what an outsider usually misses."
        ),
        DailyPrompt(
            id: "surprising-compliment",
            category: "Story",
            title: "What compliment surprised you the most?",
            guidance: "Explain why you did not expect it."
        ),
        DailyPrompt(
            id: "pause-button",
            category: "Imagination",
            title: "When would you use a pause button on everyday life?",
            guidance: "Describe one specific scene, not a general wish."
        ),
        DailyPrompt(
            id: "protect-hour",
            category: "Decision",
            title: "If you protected one hour every day, how would you use it?",
            guidance: "Say what you would stop doing to make room."
        ),
        DailyPrompt(
            id: "earned-confidence",
            category: "Reflection",
            title: "What made you more confident than you used to be?",
            guidance: "Describe the evidence that changed your self-view."
        ),
        DailyPrompt(
            id: "borrowed-talent",
            category: "Imagination",
            title: "Which talent would you borrow for a weekend?",
            guidance: "Tell us exactly what you would do with it."
        ),
        DailyPrompt(
            id: "worth-disagreeing",
            category: "Opinion",
            title: "What is worth disagreeing about?",
            guidance: "Draw the line between principle and preference."
        ),
        DailyPrompt(
            id: "better-question",
            category: "Connection",
            title: "What question do you wish people asked you more often?",
            guidance: "Answer it with the story you want people to hear."
        ),
    ]

    static let legacy: [DailyPrompt] = [
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

    static let all = curated + legacy
}
