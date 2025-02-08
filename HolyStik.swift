import Foundation

// MARK: - Custom Point and Size Types
struct Point {
    let x: Double
    let y: Double
}

struct Size {
    let width: Double
    let height: Double
}

// MARK: - Token Types
enum TokenType: Equatable {
    case circle
    case rectangle
    case line
    case color
    case clear
    case number
    case string
    case identifier
    case letKeyword
    case equals
    case plus
    case minus
    case multiply
    case divide
    case leftParen
    case rightParen
    case comma
}

// MARK: - Token
struct Token: CustomStringConvertible {
    let type: TokenType
    let value: String

    var description: String {
        return "Token(type: \(type), value: \(value))"
    }
}

// MARK: - Shape Definitions
struct Line {
    let start: Point
    let end: Point
}

struct Circle {
    let center: Point
    let radius: Double
}

struct Rectangle {
    let origin: Point
    let size: Size
}

// MARK: - Graphics State
class GraphicsState {
    var shapes: [AnyShape] = []
    var currentColor: String = "black"
    var variables: [String: Double] = [:]

    func addShape(_ shape: AnyShape) {
        shapes.append(shape)
    }

    func clear() {
        shapes.removeAll()
    }

    func setVariable(_ name: String, value: Double) {
        variables[name] = value
    }

    func getVariable(_ name: String) -> Double? {
        return variables[name]
    }
}

struct AnyShape {
    let shape: Any
    let color: String
}

// MARK: - Math Evaluator
class MathEvaluator {
    private let graphicsState: GraphicsState

    init(graphicsState: GraphicsState) {
        self.graphicsState = graphicsState
    }

    func evaluate(_ expression: String) throws -> Double {
        let tokens = try tokenize(expression)
        let rpn = try shuntingYard(tokens)
        return try evaluateRPN(rpn)
    }

    private func tokenize(_ expression: String) throws -> [Token] {
        var tokens: [Token] = []
        var remaining = expression

        while !remaining.isEmpty {
            if let match = remaining.range(of: "^\\s+", options: .regularExpression) {
                remaining.removeSubrange(match)
                continue
            }

            if let match = remaining.range(of: "^\\d+(\\.\\d+)?", options: .regularExpression) {
                let value = String(remaining[match])
                tokens.append(Token(type: .number, value: value))
                remaining.removeSubrange(match)
                continue
            }

            if let match = remaining.range(of: "^[a-zA-Z_][a-zA-Z0-9_]*", options: .regularExpression) {
                let value = String(remaining[match])
                tokens.append(Token(type: .identifier, value: value))
                remaining.removeSubrange(match)
                continue
            }

            for op in ["+", "-", "*", "/", "(", ")", ","] {
                if remaining.hasPrefix(op) {
                    let type: TokenType
                    switch op {
                    case "+": type = .plus
                    case "-": type = .minus
                    case "*": type = .multiply
                    case "/": type = .divide
                    case "(": type = .leftParen
                    case ")": type = .rightParen
                    case ",": type = .comma
                    default: fatalError("Unknown operator")
                    }
                    tokens.append(Token(type: type, value: op))
                    remaining.removeFirst()
                    break
                }
            }
        }

        return tokens
    }

    private func shuntingYard(_ tokens: [Token]) throws -> [Token] {
        var output: [Token] = []
        var operators: [Token] = []

        for token in tokens {
            switch token.type {
            case .number, .identifier:
                output.append(token)
            case .plus, .minus, .multiply, .divide:
                while let lastOp = operators.last, precedence(lastOp) >= precedence(token) {
                    output.append(operators.removeLast())
                }
                operators.append(token)
            case .leftParen:
                operators.append(token)
            case .rightParen:
                while let lastOp = operators.last, lastOp.type != .leftParen {
                    output.append(operators.removeLast())
                }
                if operators.last?.type == .leftParen {
                    operators.removeLast()
                } else {
                    throw NSError(domain: "Mismatched parentheses", code: 1, userInfo: nil)
                }
            default:
                break
            }
        }

        while let lastOp = operators.popLast() {
            if lastOp.type == .leftParen || lastOp.type == .rightParen {
                throw NSError(domain: "Mismatched parentheses", code: 1, userInfo: nil)
            }
            output.append(lastOp)
        }

        return output
    }

    private func evaluateRPN(_ tokens: [Token]) throws -> Double {
        var stack: [Double] = []

        for token in tokens {
            switch token.type {
            case .number:
                if let value = Double(token.value) {
                    stack.append(value)
                } else {
                    throw NSError(domain: "Invalid number", code: 1, userInfo: nil)
                }
            case .identifier:
                if let value = graphicsState.getVariable(token.value) {
                    stack.append(value)
                } else {
                    throw NSError(domain: "Unknown variable: \(token.value)", code: 1, userInfo: nil)
                }
            case .plus, .minus, .multiply, .divide:
                guard stack.count >= 2 else {
                    throw NSError(domain: "Invalid expression", code: 1, userInfo: nil)
                }
                let b = stack.removeLast()
                let a = stack.removeLast()
                switch token.type {
                case .plus: stack.append(a + b)
                case .minus: stack.append(a - b)
                case .multiply: stack.append(a * b)
                case .divide: stack.append(a / b)
                default: break
                }
            default:
                throw NSError(domain: "Invalid token in RPN", code: 1, userInfo: nil)
            }
        }

        guard stack.count == 1 else {
            throw NSError(domain: "Invalid expression", code: 1, userInfo: nil)
        }

        return stack[0]
    }

    private func precedence(_ token: Token) -> Int {
        switch token.type {
        case .plus, .minus: return 1
        case .multiply, .divide: return 2
        default: return 0
        }
    }
}

// MARK: - HolyStik Interpreter
class HolyStikInterpreter {
    var graphicsState: GraphicsState // Changed from 'private' to 'internal'
    private var mathEvaluator: MathEvaluator

    init() {
        self.graphicsState = GraphicsState()
        self.mathEvaluator = MathEvaluator(graphicsState: graphicsState)
    }

    // Token patterns
    private let tokenPatterns: [(TokenType, String)] = [
        (.circle, "circle"),
        (.rectangle, "rectangle"),
        (.line, "line"),
        (.color, "color"),
        (.clear, "clear"),
        (.letKeyword, "let"),
        (.number, "-?\\d+(\\.\\d+)?"),
        (.string, #""[^"]*""#),
        (.identifier, "[a-zA-Z_][a-zA-Z0-9_]*"),
        (.equals, "="),
        (.plus, "\\+"),
        (.minus, "-"),
        (.multiply, "\\*"),
        (.divide, "/"),
        (.leftParen, "\\("),
        (.rightParen, "\\)"),
        (.comma, ",")
    ]

    func tokenize(_ code: String) throws -> [Token] {
        var tokens: [Token] = []
        var remainingCode = code

        while !remainingCode.isEmpty {
            // Skip any leading whitespace.
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
                throw NSError(domain: "Invalid token", code: 1, userInfo: nil)
            }
        }

        return tokens
    }

    func evaluate(_ tokens: [Token]) throws -> [String] {
        var output: [String] = []
        var index = 0

        while index < tokens.count {
            let token = tokens[index]

            switch token.type {
            case .circle:
                let (x, y, radius) = try parseCoordinates(tokens[index + 1 ..< tokens.count])
                let circle = Circle(center: Point(x: x, y: y), radius: radius)
                graphicsState.addShape(AnyShape(shape: circle, color: graphicsState.currentColor))
                index += 3
                output.append("Stik: Circle drawn at (\(x), \(y)) with radius \(radius).")
            case .rectangle:
                let (x, y, width, height) = try parseRectangleCoordinates(tokens[index + 1 ..< tokens.count])
                let rectangle = Rectangle(origin: Point(x: x, y: y), size: Size(width: width, height: height))
                graphicsState.addShape(AnyShape(shape: rectangle, color: graphicsState.currentColor))
                index += 4
                output.append("Stik: Rectangle drawn at (\(x), \(y)) with size \(width)x\(height).")
            case .line:
                let (x1, y1, x2, y2) = try parseLineCoordinates(tokens[index + 1 ..< tokens.count])
                let line = Line(start: Point(x: x1, y: y1), end: Point(x: x2, y: y2))
                graphicsState.addShape(AnyShape(shape: line, color: graphicsState.currentColor))
                index += 4
                output.append("Stik: Line drawn from (\(x1), \(y1)) to (\(x2), \(y2)).")
            case .color:
                let colorToken = tokens[index + 1]
                if colorToken.type == .string {
                    let colorName = colorToken.value.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                    graphicsState.currentColor = colorName
                    index += 1
                    output.append("Stik: Drawing color set to \(colorName).")
                } else {
                    throw NSError(domain: "Syntax error", code: 1, userInfo: nil)
                }
            case .clear:
                graphicsState.clear()
                output.append("Stik: Canvas cleared.")
            case .letKeyword:
                let nameToken = tokens[index + 1]
                guard nameToken.type == .identifier else {
                    throw NSError(domain: "Invalid variable name", code: 1, userInfo: nil)
                }
                guard tokens[index + 2].type == .equals else {
                    throw NSError(domain: "Expected '=' after variable name", code: 1, userInfo: nil)
                }
                let expressionTokens = Array(tokens[index + 3 ..< tokens.count])
                let value = try mathEvaluator.evaluate(expressionTokens.map { $0.value }.joined(separator: " "))
                graphicsState.setVariable(nameToken.value, value: value)
                index += 3 + expressionTokens.count
                output.append("Stik: Variable \(nameToken.value) set to \(value).")
            default:
                index += 1
            }
        }

        return output
    }

    // Helpers for parsing coordinates
    private func parseCoordinates(_ tokens: ArraySlice<Token>) throws -> (Double, Double, Double) {
        guard tokens.count >= 3 else {
            throw NSError(domain: "Invalid coordinates for circle", code: 1, userInfo: nil)
        }
        let x = try mathEvaluator.evaluate(tokens[tokens.startIndex].value)
        let y = try mathEvaluator.evaluate(tokens[tokens.startIndex + 1].value)
        let radius = try mathEvaluator.evaluate(tokens[tokens.startIndex + 2].value)
        return (x, y, radius)
    }

    private func parseRectangleCoordinates(_ tokens: ArraySlice<Token>) throws -> (Double, Double, Double, Double) {
        guard tokens.count >= 4 else {
            throw NSError(domain: "Invalid coordinates for rectangle", code: 1, userInfo: nil)
        }
        let x = try mathEvaluator.evaluate(tokens[tokens.startIndex].value)
        let y = try mathEvaluator.evaluate(tokens[tokens.startIndex + 1].value)
        let width = try mathEvaluator.evaluate(tokens[tokens.startIndex + 2].value)
        let height = try mathEvaluator.evaluate(tokens[tokens.startIndex + 3].value)
        return (x, y, width, height)
    }

    private func parseLineCoordinates(_ tokens: ArraySlice<Token>) throws -> (Double, Double, Double, Double) {
        guard tokens.count >= 4 else {
            throw NSError(domain: "Invalid coordinates for line", code: 1, userInfo: nil)
        }
        let x1 = try mathEvaluator.evaluate(tokens[tokens.startIndex].value)
        let y1 = try mathEvaluator.evaluate(tokens[tokens.startIndex + 1].value)
        let x2 = try mathEvaluator.evaluate(tokens[tokens.startIndex + 2].value)
        let y2 = try mathEvaluator.evaluate(tokens[tokens.startIndex + 3].value)
        return (x1, y1, x2, y2)
    }

    func run(_ code: String) -> [String] {
        do {
            let tokens = try tokenize(code)
            return try evaluate(tokens)
        } catch {
            return ["Stik Error: \(error)"]
        }
    }

    func getShapes() -> [AnyShape] {
        return graphicsState.shapes
    }
}

// MARK: - Terminal Renderer
func renderTerminal(shapes: [AnyShape], width: Int = 80, height: Int = 24) -> String {
    var grid: [[Character]] = Array(
        repeating: Array(repeating: " ", count: width),
        count: height
    )

    for anyShape in shapes {
        if let circle = anyShape.shape as? Circle {
            drawCircle(circle, on: &grid)
        } else if let rectangle = anyShape.shape as? Rectangle {
            drawRectangle(rectangle, on: &grid)
        } else if let line = anyShape.shape as? Line {
            drawLine(line, on: &grid)
        }
    }

    let result = grid.map { String($0) }.joined(separator: "\n")
    return result
}

func drawCircle(_ circle: Circle, on grid: inout [[Character]]) {
    let r = circle.radius

    for y in 0..<grid.count {
        for x in 0..<grid[0].count {
            let dx = Double(x) - circle.center.x
            let dy = Double(y) - circle.center.y
            let distance = sqrt(dx * dx + dy * dy)
            if abs(distance - r) < 1 {
                grid[y][x] = "o"
            }
        }
    }
}

func drawRectangle(_ rectangle: Rectangle, on grid: inout [[Character]]) {
    let x = Int(rectangle.origin.x)
    let y = Int(rectangle.origin.y)
    let w = Int(rectangle.size.width)
    let h = Int(rectangle.size.height)

    for i in x..<x + w {
        if y >= 0 && y < grid.count && i >= 0 && i < grid[0].count {
            grid[y][i] = "#"
        }
        if y + h - 1 >= 0 && y + h - 1 < grid.count && i >= 0 && i < grid[0].count {
            grid[y + h - 1][i] = "#"
        }
    }
    for j in y..<y + h {
        if x >= 0 && x < grid[0].count && j >= 0 && j < grid.count {
            grid[j][x] = "#"
        }
        if x + w - 1 >= 0 && x + w - 1 < grid[0].count && j >= 0 && j < grid.count {
            grid[j][x + w - 1] = "#"
        }
    }
}

func drawLine(_ line: Line, on grid: inout [[Character]]) {
    let x0 = Int(line.start.x)
    let y0 = Int(line.start.y)
    let x1 = Int(line.end.x)
    let y1 = Int(line.end.y)

    let dx = abs(x1 - x0)
    let dy = abs(y1 - y0)
    let sx = x0 < x1 ? 1 : -1
    let sy = y0 < y1 ? 1 : -1
    var err = dx - dy
    var x = x0
    var y = y0

    while true {
        if x >= 0 && x < grid[0].count && y >= 0 && y < grid.count {
            grid[y][x] = "*"
        }
        if x == x1 && y == y1 { break }
        let e2 = 2 * err
        if e2 > -dy {
            err -= dy
            x += sx
        }
        if e2 < dx {
            err += dx
            y += sy
        }
    }
}

// MARK: - Main Function
func main() {
    let arguments = CommandLine.arguments

    guard arguments.count > 1 else {
        print("Stik Usage: \(arguments[0]) <file.hstik> or \(arguments[0]) --calc <expression>")
        return
    }

    if arguments[1] == "--calc" {
        // Calculator mode
        guard arguments.count > 2 else {
            print("Stik Calculator Usage: \(arguments[0]) --calc <expression>")
            return
        }

        let expression = arguments[2...].joined(separator: " ")
        let interpreter = HolyStikInterpreter()
        let mathEvaluator = MathEvaluator(graphicsState: interpreter.graphicsState)

        do {
            let result = try mathEvaluator.evaluate(expression)
            print("Stik Calculator Result: \(result)")
        } catch {
            print("Stik Calculator Error: \(error)")
        }
    } else {
        // Graphics mode
        let filePath = arguments[1]

        do {
            let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
            print("Stik File contents:\n\(fileContents)\n")

            let interpreter = HolyStikInterpreter()
            let output = interpreter.run(fileContents)
            
            output.forEach { print($0) }
            
            let shapes = interpreter.getShapes()
            if !shapes.isEmpty {
                let rendered = renderTerminal(shapes: shapes, width: 80, height: 24)
                print("\n--- Stik Terminal Graphics ---\n")
                print(rendered)
            } else {
                print("Stik: No shapes were drawn.")
            }
        } catch {
            print("Stik Error: Failed to read file at path: \(filePath)")
            print("Stik Error: \(error)")
        }
    }
}

// Run the main function.
main()