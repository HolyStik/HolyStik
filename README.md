# HolyStik

HolyStik is a simple and beginner-friendly programming language inspired by Swift and HTML, with a subtle biblical Christian theme. It is designed to be easy to learn and supports both interpretation and compilation. The language incorporates the word **"stik"** into its syntax, making it unique while maintaining clarity.

## Features
- **Simple Syntax**: HolyStik is designed to be easy for new developers to understand.
- **Mathematical Operations**: Supports addition, subtraction, multiplication, and division.
- **Variables**: Assign and use variables with ease.
- **Ternary Operator**: Allows conditional expressions.
- **Loops (`stik`)**: Repeats expressions a specified number of times.
- **Interpretation & Compilation**: Can be run as an interpreted script.

## Installation
Clone the HolyStik repository and compile the interpreter:

```sh
git clone https://github.com/your-repo/HolyStik.git
cd HolyStik
swiftc HolyStikInterpreter.swift -o HolyStikInterpreter
```

## Running a HolyStik Script
To execute a HolyStik script, provide a `.hstik` file as input:

```sh
./HolyStikInterpreter test.hstik
```

## HolyStik Syntax
Here is an example HolyStik script:

```hstik
x = 10
y = 5
z = (x + y) * 2
result = z > 20 ? "High value" : "Low value"

stik 3 "HolyStik rocks!"

age = 25
status = age >= 18 ? "Adult" : "Minor"
```

### Expected Output:
```
HolyStik rocks!
HolyStik rocks!
HolyStik rocks!
```

## Language Elements

### 1. **Variables**
Variables are assigned using `=`:

```hstik
name = "John"
age = 30
```

### 2. **Mathematical Expressions**
Supports `+`, `-`, `*`, `/`, and parentheses:

```hstik
x = 5
y = x * 3 + 2
```

### 3. **Ternary Operator**
Use `?` and `:` for quick conditional logic:

```hstik
result = x > 10 ? "Big number" : "Small number"
```

### 4. **Loops (`stik`)**
The `stik` keyword repeats an expression:

```hstik
stik 5 "Praise the Lord!"
```

### 5. **Comparisons**
Supports `==`, `!=`, `<`, `>`, `<=`, `>=`:

```hstik
isAdult = age >= 18 ? "Yes" : "No"
```

## License
HolyStik is licensed under **AGPL-3.0**.

## Contributing
Contributions are welcome! Submit an issue or pull request to help improve HolyStik.

---

🔥 **HolyStik – Simple, Swift, and Divine!** 🔥

