# HolyStik - A Terminal Graphics Interpreter

HolyStik is a simple domain-specific language (DSL) interpreter written in Swift that allows you to draw basic shapes—such as circles, rectangles, and lines—directly in your terminal. It also supports setting colors, clearing the canvas, and evaluating mathematical expressions with variable support.

---

## Features

- **Shape Drawing**: Draw circles, rectangles, and lines using simple commands.
- **Color Management**: Set the current drawing color (for state tracking).
- **Canvas Clearing**: Clear all shapes from the canvas with a single command.
- **Mathematical Expressions**: Evaluate arithmetic expressions supporting addition (`+`), subtraction (`-`), multiplication (`*`), division (`/`), and parentheses.
- **Variables**: Declare and use variables within expressions.
- **Terminal Rendering**: Render drawn shapes as ASCII art on a terminal grid.
- **Simple DSL**: Intuitive command syntax for quick prototyping and drawing.

---

## DSL Syntax

The HolyStik language uses a straightforward syntax. Here are the primary commands:

- **Drawing Commands:**
  - `circle <x> <y> <radius>`  
    Draws a circle with its center at `(x, y)` and the specified `radius`.
  
  - `rectangle <x> <y> <width> <height>`  
    Draws a rectangle with its top-left corner at `(x, y)` and the specified `width` and `height`.
  
  - `line <x1> <y1> <x2> <y2>`  
    Draws a line from point `(x1, y1)` to point `(x2, y2)`.

- **State Management:**
  - `color "colorName"`  
    Sets the current drawing color. The color is stored in the interpreter’s state and is applied to subsequently drawn shapes.
  
  - `clear`  
    Clears all shapes from the canvas.

- **Variables and Expressions:**
  - `let <variable> = <expression>`  
    Declares a variable with a value obtained by evaluating the provided mathematical expression.  
    Expressions can include numbers, identifiers (previously defined variables), and arithmetic operators (`+`, `-`, `*`, `/`).

### Example `.hstik` File

```hstik
color "blue"
circle 40 12 10
rectangle 10 5 20 10
line 0 0 79 23
let a = 5 + 10 * 2
```

This sample file sets the drawing color to blue, draws a circle, a rectangle, a line, and declares a variable `a` with the value calculated from the expression.

---

## Getting Started

### Prerequisites

- **Swift 5.x or later**: Ensure that Swift is installed on your system.
- **Platform**: macOS, Linux, or any platform that supports Swift.

### Building and Running

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/holystik.git
   cd holystik
   ```

2. **Build the Project**

   Using the Swift Package Manager:
   
   ```bash
   swift build
   ```

3. **Run the Interpreter**

   Pass the path to your `.hstik` file as a command-line argument:
   
   ```bash
   swift run holystik path/to/yourfile.hstik
   ```

   Alternatively, you can compile directly with `swiftc`:

   ```bash
   swiftc main.swift -o holystik
   ./holystik path/to/yourfile.hstik
   ```

The interpreter reads the file, processes the commands, and renders the shapes as ASCII art in the terminal.

---

## Code Structure

- **Custom Types & Token Definitions**
  - **Point & Size**: Structures representing coordinates and dimensions.
  - **Token & TokenType**: Definitions used for lexical analysis of the DSL input.

- **Shape Definitions**
  - **Line, Circle, Rectangle**: Data structures representing the different shapes.
  - **AnyShape**: A wrapper that pairs a shape with its color.

- **GraphicsState**
  - Maintains the current drawing state, including shapes, current color, and defined variables.

- **MathEvaluator**
  - Implements tokenization, the shunting yard algorithm for expression parsing, and Reverse Polish Notation (RPN) evaluation to compute arithmetic expressions.

- **HolyStikInterpreter**
  - The main interpreter class that tokenizes the DSL code, processes commands (drawing shapes, setting color, clearing, and variable declaration), and updates the graphics state accordingly.

- **Terminal Renderer**
  - Functions to render the shapes (circle, rectangle, line) onto an ASCII grid that is printed to the terminal.

- **Main Function**
  - Reads a `.hstik` file from the command line, invokes the interpreter, prints feedback messages, and renders the resulting graphics.

---

## Error Handling

- **Syntax & Token Errors**: The interpreter checks for syntax errors and invalid tokens, reporting errors with descriptive messages.
- **Expression Evaluation Errors**: Errors in mathematical expressions or variable lookup are captured and reported.

---

## Contributing

Contributions, bug reports, and feature requests are welcome. Feel free to open an issue or submit a pull request on GitHub.

---

## License

This project is licensed under the MIT License.

---

## Contact

For any questions or suggestions, please contact [your-email@example.com].

---

Enjoy creating terminal graphics with HolyStik!

