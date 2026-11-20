import SwiftUI

struct AppShellView: View {
    private let content: AppShellContent

    init(content: AppShellContent = .foundation) {
        self.content = content
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "waveform.circle.fill")
                .font(.system(size: 64, weight: .bold))
                .foregroundStyle(Color(red: 0.35, green: 0.80, blue: 0.01))
                .accessibilityHidden(true)

            Text(content.title)
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityIdentifier("app-shell-title")

            Text(content.status)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("app-shell-status")
        }
        .padding(24)
    }
}

#Preview {
    AppShellView()
}
