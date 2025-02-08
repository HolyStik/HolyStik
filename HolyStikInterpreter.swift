import Foundation

enum TokenType: Equatable {
    case string
    case number
    case identifier
    case assign
    case `operator`
    case compare
    case ternary
    case colon
    case loop
    case leftParen
    case rightParen
}

struct Token: CustomStringConvertible {
    let type: TokenType
    let value: String
    
    var description: String {
        return "Token(type: \(type), value: \(value))"
    }
}

enum InterpreterError: Error, CustomStringConvertible {
    case syntaxError(String)
    case runtimeError(String)
    case undefinedVariable(String)
    case divisionByZero
    
    var description: String {
        switch self {
        case .syntaxError(let msg): return "Syntax Error: \(msg)"
        case .runtimeError(let msg): return "Runtime Error: \(msg)"
        case .undefinedVariable(let name): return "Undefined variable: \(name)"
        case .divisionByZero: return "Division by zero"
        }
    }
}

class HolyStikInterpreter {
    private var variables: [String: Any] = [:]
    
    private let tokenPatterns: [(TokenType, String)] = [
        (.string, #""[^"]*""#),
        (.number, "-?\\d+(\\.\\d+)?"),
        (.loop, "stik"),  // Moved before identifier to ensure it's matched first
        (.identifier, "[a-zA-Z_][a-zA-Z0-9_]*"),
        (.assign, "="),
        (.operator, "[+\\-*/]"),
        (.compare, "(==|!=|<=|>=|<|>)"),
        (.ternary, "\\?"),
        (.colon, ":"),
        (.leftParen, "\\("),
        (.rightParen, "\\)")
    ]
    
    func tokenize(_ code: String) throws -> [Token] {
        var tokens: [Token] = []
        var remainingCode = code
        
        while !remainingCode.isEmpty {
            if let range = remainingCode.range(of: "^\\s+", options: .regularExpression) {
                remainingCode.removeSubrange(range)
                continue
            }
            
            var matched = false
            for (type, pattern) in tokenPatterns {
                if let range = remainingCode.range(of: "^\(pattern)", options: .regularExpression) {
                    let value = String(remainingCode[range])
                    tokens.append(Token(type: type, value: value))
                    remainingCode.removeSubrange(range)
                    matched = true
                    break
                }
            }
            
            if !matched {
                throw InterpreterError.syntaxError("Invalid token at: \(remainingCode)")
            }
        }
        
        return tokens
    }
    
    private func evaluateExpression(_ tokens: ArraySlice<Token>) throws -> (Any, Int) {
        guard !tokens.isEmpty else {
            throw InterpreterError.syntaxError("Empty expression")
        }
        
        // Handle loop statement first
        if tokens.first?.type == .loop {
            throw InterpreterError.syntaxError("Unexpected loop statement in expression")
        }
        
        // Single token evaluation
        if tokens.count == 1 {
            return try (evaluateToken(tokens.first!), 1)
        }
        
        // Handle parentheses
        if tokens.first?.type == .leftParen {
            return try evaluateParentheses(tokens)
        }
        
        // Binary operations
        if tokens.count >= 3 {
            let leftToken = tokens[tokens.startIndex]
            let left = try evaluateToken(leftToken)
            
            if tokens.count > tokens.startIndex + 1 {
                let opToken = tokens[tokens.startIndex + 1]
                if opToken.type == .operator || opToken.type == .compare {
                    let remainingTokens = tokens[(tokens.startIndex + 2)...]
                    let (right, length) = try evaluateExpression(remainingTokens)
                    let result = try applyOperator(opToken.value, left: left, right: right)
                    return (result, length + 2)
                }
            }
            
            return (left, 1)
        }
        
        throw InterpreterError.syntaxError("Invalid expression")
    }
    
    private func evaluateToken(_ token: Token) throws -> Any {
        switch token.type {
        case .number:
            if token.value.contains(".") {
                guard let value = Double(token.value) else {
                    throw InterpreterError.syntaxError("Invalid number: \(token.value)")
                }
                return value
            }
            guard let value = Int(token.value) else {
                throw InterpreterError.syntaxError("Invalid number: \(token.value)")
            }
            return value
        case .string:
            return String(token.value.dropFirst().dropLast())
        case .identifier:
            guard let value = variables[token.value] else {
                throw InterpreterError.undefinedVariable(token.value)
            }
            return value
        default:
            throw InterpreterError.syntaxError("Unexpected token type: \(token.type)")
        }
    }
    
    private func evaluateParentheses(_ tokens: ArraySlice<Token>) throws -> (Any, Int) {
        var parenCount = 1
        var index = tokens.startIndex + 1
        
        while index < tokens.endIndex && parenCount > 0 {
            if tokens[index].type == .leftParen {
                parenCount += 1
            } else if tokens[index].type == .rightParen {
                parenCount -= 1
            }
            index += 1
        }
        
        if parenCount > 0 {
            throw InterpreterError.syntaxError("Unmatched parenthesis")
        }
        
        let innerTokens = tokens[(tokens.startIndex + 1)..<(index - 1)]
        let (value, _) = try evaluateExpression(innerTokens)
        return (value, index - tokens.startIndex)
    }
    
    private func applyOperator(_ op: String, left: Any, right: Any) throws -> Any {
        switch (left, right) {
        case let (l as Int, r as Int):
            return try evaluateNumericOperation(op, Double(l), Double(r))
        case let (l as Double, r as Double):
            return try evaluateNumericOperation(op, l, r)
        case let (l as Int, r as Double):
            return try evaluateNumericOperation(op, Double(l), r)
        case let (l as Double, r as Int):
            return try evaluateNumericOperation(op, l, Double(r))
        case let (l as Bool, r as Bool):
            switch op {
            case "==": return l == r
            case "!=": return l != r
            default:
                throw InterpreterError.runtimeError("Invalid operator for boolean values")
            }
        default:
            throw InterpreterError.runtimeError("Invalid operand types")
        }
    }
    
    private func evaluateNumericOperation(_ op: String, _ left: Double, _ right: Double) throws -> Any {
        switch op {
        case "+": return left + right
        case "-": return left - right
        case "*": return left * right
        case "/":
            if right == 0 {
                throw InterpreterError.divisionByZero
            }
            return left / right
        case ">": return left > right
        case "<": return left < right
        case "==": return left == right
        case "!=": return left != right
        case "<=": return left <= right
        case ">=": return left >= right
        default:
            throw InterpreterError.syntaxError("Unknown operator: \(op)")
        }
    }
    
    func evaluate(_ tokens: [Token]) throws -> [String] {
        var output: [String] = []
        var index = 0
        
        while index < tokens.count {
            let token = tokens[index]
            
            switch token.type {
            case .loop:
                guard index + 2 < tokens.count else {
                    throw InterpreterError.syntaxError("Incomplete loop statement")
                }
                
                let countToken = tokens[index + 1]
                let messageToken = tokens[index + 2]
                
                guard countToken.type == .number,
                      let count = Int(countToken.value),
                      count >= 0 else {
                    throw InterpreterError.syntaxError("Loop count must be a non-negative number")
                }
                
                guard messageToken.type == .string else {
                    throw InterpreterError.syntaxError("Loop message must be a string")
                }
                
                let message = String(messageToken.value.dropFirst().dropLast())
                output.append(contentsOf: Array(repeating: message, count: count))
                index += 3
                
            case .identifier:
                if index + 1 < tokens.count && tokens[index + 1].type == .assign {
                    // Handle assignment
                    let varName = token.value
                    index += 2 // Skip past the equals sign
                    
                    let remainingTokens = ArraySlice(tokens[index...])
                    let (value, length) = try evaluateExpression(remainingTokens)
                    variables[varName] = value
                    output.append("\(varName) = \(value)")
                    index += length
                } else {
                    // Handle variable reference
                    let (value, length) = try evaluateExpression(ArraySlice(tokens[index...]))
                    output.append("\(value)")
                    index += length
                }
                
            case .ternary:
                guard index >= 1 else {
                    throw InterpreterError.syntaxError("Invalid ternary expression: missing condition")
                }
                
                let condTokens = ArraySlice(tokens[..<index])
                let (conditionValue, _) = try evaluateExpression(condTokens)
                let condition = conditionValue as? Bool ?? false
                
                guard index + 3 < tokens.count,
                      tokens[index + 2].type == .colon else {
                    throw InterpreterError.syntaxError("Invalid ternary format")
                }
                
                let trueToken = tokens[index + 1]
                let falseToken = tokens[index + 3]
                
                let result: String
                if condition {
                    result = try evaluateToken(trueToken) as? String ?? String(describing: try evaluateToken(trueToken))
                } else {
                    result = try evaluateToken(falseToken) as? String ?? String(describing: try evaluateToken(falseToken))
                }
                
                output.append(result)
                index += 4
                
            default:
                index += 1
            }
        }
        
        return output
    }
    
    func run(_ code: String) -> [String] {
        do {
            let tokens = try tokenize(code)
            return try evaluate(tokens)
        } catch {
            return ["Error: \(error)"]
        }
    }
}

// Function to read the contents of a file
func readFileContents(atPath path: String) -> String? {
    do {
        return try String(contentsOfFile: path, encoding: .utf8)
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

// Main function to handle command-line arguments
func main() {
    let arguments = CommandLine.arguments
    
    guard arguments.count > 1 else {
        print("Usage: \(arguments[0]) <file.hstik>")
        return
    }
    
    let filePath = arguments[1]
    
    guard let fileContents = readFileContents(atPath: filePath) else {
        print("Failed to read file at path: \(filePath)")
        return
    }
    
    let interpreter = HolyStikInterpreter()
    let output = interpreter.run(fileContents)
    output.forEach { print($0) }
}

// Run the main function
main()