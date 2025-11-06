import SwiftUI

enum CalculatorButton: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case add = "+"
    case subtract = "−"
    case multiply = "×"
    case divide = "÷"
    case equal = "="
    case clear = "AC"
    case negate = "+/-"
    case percent = "%"
    case decimal = "."
    
    var backgroundColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color(red: 1.0, green: 0.58, blue: 0.0)
        case .clear, .negate, .percent:
            return Color(red: 0.64, green: 0.64, blue: 0.64)
        default:
            return Color(red: 0.20, green: 0.20, blue: 0.20)
        }
    }
    
   
    var foregroundColor: Color {
        switch self {
        case .clear, .negate, .percent:
            return .black
        default:
            return .white
        }
    }
    
    var title: String {
        return self.rawValue
    }
    

    var widthMultiplier: CGFloat {
        switch self {
        case .zero:
            return 2.2
        default:
            return 1
        }
    }
}

