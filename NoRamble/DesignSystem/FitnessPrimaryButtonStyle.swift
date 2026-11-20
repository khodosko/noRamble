import SwiftUI

struct FitnessPrimaryButtonStyle: ButtonStyle {
    private let primaryGreen = Color(
        red: 88.0 / 255.0,
        green: 204.0 / 255.0,
        blue: 2.0 / 255.0
    )
    private let depthGreen = Color(
        red: 70.0 / 255.0,
        green: 163.0 / 255.0,
        blue: 2.0 / 255.0
    )

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(depthGreen)
                .offset(y: 4)

            configuration.label
                .font(.system(.title3, design: .rounded, weight: .heavy))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 60)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(primaryGreen)
                }
                .offset(y: configuration.isPressed ? 4 : 0)
        }
        .padding(.bottom, 4)
        .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
