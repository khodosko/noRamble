import SwiftUI

struct DailyPromptPickerView: View {
    @Bindable var model: DailyPromptViewModel
    let onStartDailyRep: () -> Void

    init(
        model: DailyPromptViewModel,
        onStartDailyRep: @escaping () -> Void = {}
    ) {
        self.model = model
        self.onStartDailyRep = onStartDailyRep
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily rep")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            Text("Pick 1 of 3 prompts")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
                .accessibilityIdentifier("daily-prompt-heading")

            Text("Choose once for today. Your retries will use the same prompt.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ForEach(model.prompts) { prompt in
                promptButton(prompt)
            }

            if let errorMessage = model.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .accessibilityIdentifier("daily-prompt-error")
            }

            if model.selectedPromptID != nil {
                Button("Start Daily Rep", action: onStartDailyRep)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.35, green: 0.80, blue: 0.01))
                    .accessibilityHint("Opens the microphone recording screen.")
                    .accessibilityIdentifier("start-daily-rep")
                    .padding(.top, 8)
            }
        }
        .onAppear {
            model.loadSelection()
        }
    }

    private func promptButton(_ prompt: DailyPrompt) -> some View {
        let isSelected = model.selectedPromptID == prompt.id

        return Button {
            model.select(promptID: prompt.id)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(prompt.category)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(isSelected ? Color.green : Color.blue)

                    Text(prompt.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(prompt.guidance)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isSelected ? Color.green : Color.secondary)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                isSelected
                    ? Color.green.opacity(0.12)
                    : Color(uiColor: .secondarySystemBackground)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color.green : Color.secondary.opacity(0.25),
                        lineWidth: 2
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .disabled(!model.isPromptEnabled(prompt.id))
        .accessibilityLabel("\(prompt.category). \(prompt.title). \(prompt.guidance)")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint(
            isSelected
                ? "This prompt is locked for today’s retries."
                : "Selects and locks this prompt for today."
        )
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("daily-prompt-option-\(prompt.id)")
    }
}
