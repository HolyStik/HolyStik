# HolyStik

HolyStik is a versatile tool that combines **graphics rendering** and **mathematical expression evaluation**. It can interpret commands to draw shapes (circles, rectangles, lines) in a terminal-based graphics environment and also function as a calculator to evaluate mathematical expressions.

---

## Features

- **Graphics Mode**:
  - Draw shapes like circles, rectangles, and lines.
  - Set colors for shapes.
  - Clear the canvas.
  - Render shapes in the terminal.

- **Calculator Mode**:
  - Evaluate mathematical expressions (e.g., `3 + 5 * (2 - 8)`).
  - Support for variables using the `let` keyword.

---

## Usage

### Graphics Mode
To use HolyStik in graphics mode, provide a `.hstik` file as input. The file should contain commands to draw shapes.

#### Example `.hstik` File:
```plaintext
circle 10 10 5
rectangle 20 20 10 10
color "red"
line 0 0 30 30
```

#### Command:
```sh
$ ./HolyStik shapes.hstik
```

#### Output:
The program will print the actions performed (e.g., drawing shapes) and render the shapes in the terminal.

### Calculator Mode
To use HolyStik in calculator mode, use the `--calc` flag followed by a mathematical expression.

#### Command:
```sh
$ ./HolyStik --calc "3 + 5 * (2 - 8)"
```

#### Output:
```plaintext
Stik Calculator Result: -27.0
```

---

## Command Syntax

### Graphics Commands
- **Circle:** `circle <x> <y> <radius>`  
  Example: `circle 10 10 5`
- **Rectangle:** `rectangle <x> <y> <width> <height>`  
  Example: `rectangle 20 20 10 10`
- **Line:** `line <x1> <y1> <x2> <y2>`  
  Example: `line 0 0 30 30`
- **Color:** `color "<color_name>"`  
  Example: `color "red"`
- **Clear:** `clear`  
  Clears the canvas.

### Calculator Commands
- **Mathematical Expressions:**
  Example: `3 + 5 * (2 - 8)`
- **Variables:**
  Use the `let` keyword to define variables.
  Example: `let x = 10`

---

## Installation

### Clone the Repository:
```sh
git clone https://github.com/0-Blu/HolyStik.git
cd HolyStik
```

### Build the Project:
Ensure you have Swift installed. Run the following command to build the project:
```sh
swiftc HolyStik.swift -o HolyStik
```

### Run the Program:
For graphics mode:
```sh
./HolyStik shapes.hstik
```
For calculator mode:
```sh
./HolyStik --calc "3 + 5 * (2 - 8)"
```

---

## Examples

### Example 1: Drawing Shapes

#### Input (`shapes.hstik`):
```plaintext
circle 10 10 5
rectangle 20 20 10 10
color "red"
line 0 0 30 30
```

#### Output:
```plaintext
Stik: Circle drawn at (10.0, 10.0) with radius 5.0.
Stik: Rectangle drawn at (20.0, 20.0) with size 10.0x10.0.
Stik: Drawing color set to red.
Stik: Line drawn from (0.0, 0.0) to (30.0, 30.0).

--- Stik Terminal Graphics ---

(Terminal graphics output)
```

### Example 2: Calculator Mode

#### Input:
```sh
$ ./HolyStik --calc "3 + 5 * (2 - 8)"
```

#### Output:
```plaintext
Stik Calculator Result: -27.0
```

---

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:
1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Submit a pull request.

---

## License

This project is licensed under the **AGPL-3.0** License. See the [LICENSE](LICENSE) file for details.

---

## Author
Your Name  
GitHub: [0-Blu](https://github.com/0-Blu)

