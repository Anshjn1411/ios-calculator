import Foundation

enum CalculatorOperation {
    case add, subtract, multiply, divide, none
}


import Foundation
import Combine

class CalculatorViewModel: ObservableObject {

    @Published var displayValue: String = "0"
    
    private var currentValue: Double = 0
    private var storedValue: Double = 0
    private var currentOperation: CalculatorOperation = .none
    private var isTyping: Bool = false
    private var shouldResetDisplay: Bool = false

    
    func didTapButton(_ button: CalculatorButton) {
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            handleNumberInput(button.title)
        case .add, .subtract, .multiply, .divide:
            handleOperationInput(button)
        case .equal:
            performCalculation()
        case .clear:
            clearCalculator()
        case .decimal:
            handleDecimalInput()
        case .negate:
            toggleSign()
        case .percent:
            convertToPercent()
        }
    }
    

    
    private func handleNumberInput(_ number: String) {
        if shouldResetDisplay {
            displayValue = number
            shouldResetDisplay = false
            isTyping = true
        } else if isTyping {
            if displayValue == "0" {
                displayValue = number
            } else if displayValue.count < 9 {
                displayValue += number
            }
        } else {
            displayValue = number
            isTyping = true
        }
    }
    
   
    private func handleDecimalInput() {
        if shouldResetDisplay {
            displayValue = "0."
            shouldResetDisplay = false
            isTyping = true
            return
        }
        
        if !isTyping {
            displayValue = "0."
            isTyping = true
        } else if !displayValue.contains(".") {
            displayValue += "."
        }
    }
    

    private func handleOperationInput(_ button: CalculatorButton) {
        if isTyping {
            currentValue = Double(displayValue) ?? 0
            isTyping = false
        }
        
        if currentOperation != .none && !shouldResetDisplay {
            performCalculation()
        } else {
            storedValue = currentValue
        }
        
    
        switch button {
        case .add:
            currentOperation = .add
        case .subtract:
            currentOperation = .subtract
        case .multiply:
            currentOperation = .multiply
        case .divide:
            currentOperation = .divide
        default:
            break
        }
        
        shouldResetDisplay = true
    }
    
    private func performCalculation() {
        guard currentOperation != .none else { return }
        
        if isTyping {
            currentValue = Double(displayValue) ?? 0
        }
        
        var result: Double = 0
        
        switch currentOperation {
        case .add:
            result = storedValue + currentValue
        case .subtract:
            result = storedValue - currentValue
        case .multiply:
            result = storedValue * currentValue
        case .divide:
            if currentValue != 0 {
                result = storedValue / currentValue
            } else {
                displayValue = "Error"
                clearCalculator()
                return
            }
        case .none:
            return
        }
        
        currentValue = result
        storedValue = result
        displayValue = formatNumber(result)
        currentOperation = .none
        isTyping = false
        shouldResetDisplay = true
    }
    

    private func clearCalculator() {
        displayValue = "0"
        currentValue = 0
        storedValue = 0
        currentOperation = .none
        isTyping = false
        shouldResetDisplay = false
    }
    

    private func toggleSign() {
        if let value = Double(displayValue) {
            let negated = value * -1
            displayValue = formatNumber(negated)
            currentValue = negated
        }
    }
    
    private func convertToPercent() {
        if let value = Double(displayValue) {
            let percent = value / 100
            displayValue = formatNumber(percent)
            currentValue = percent
        }
    }
    
    private func formatNumber(_ number: Double) -> String {

        if abs(number) >= 1_000_000_000 || (abs(number) < 0.0000001 && number != 0) {
            return String(format: "%.2e", number)
        }
        
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", number)
        } else {
            let formatted = String(format: "%.8f", number)
            let trimmed = formatted.replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
            return trimmed.hasSuffix(".") ? String(trimmed.dropLast()) : trimmed
        }
    }
}
