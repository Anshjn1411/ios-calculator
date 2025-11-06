import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    let buttonRows: [[CalculatorButton]] = [
        [.clear, .negate, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 12) {
                Spacer()
                
                // Display Area
                DisplayView(value: viewModel.displayValue)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                // Button Grid
                VStack(spacing: 12) {
                    ForEach(buttonRows, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(row, id: \.self) { button in
                                CalculatorButtonView(
                                    button: button,
                                    action: { viewModel.didTapButton(button) }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 40)
            }
        }
    }
}


struct DisplayView: View {
    let value: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(value)
                .font(.system(size: dynamicFontSize, weight: .light, design: .default))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var dynamicFontSize: CGFloat {
        let length = value.count
        if length <= 6 {
            return 80
        } else if length <= 8 {
            return 64
        } else {
            return 48
        }
    }
}

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let action: () -> Void
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            Text(button.title)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(button.foregroundColor)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(
                    ZStack {
                        button.backgroundColor
                        if isPressed {
                            Color.white.opacity(0.3)
                        }
                    }
                )
                .cornerRadius(buttonHeight / 2)
        }
        .buttonStyle(CalculatorButtonStyle(isPressed: $isPressed))
    }
    
    private var buttonWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        let horizontalPadding: CGFloat = 48
        let standardWidth = (screenWidth - horizontalPadding - (spacing * 3)) / 4
        return standardWidth * button.widthMultiplier + (button.widthMultiplier > 1 ? spacing : 0)
    }
    
    private var buttonHeight: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        let horizontalPadding: CGFloat = 48
        return (screenWidth - horizontalPadding - (spacing * 3)) / 4
    }
    
    private var fontSize: CGFloat {
        return buttonHeight * 0.4
    }
}


struct CalculatorButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}


#Preview {
    ContentView()
}


