# HolyStik

HolyStik is a beginner-friendly programming language inspired by Swift and HTML. It is designed for simplicity, making it easy for new developers to learn.

## Features
- **Simple and Readable Syntax**: Inspired by Swift with an emphasis on clarity.
- **Mathematical Operations**: Supports basic arithmetic.
- **Variables**: Assign and manipulate values easily.
- **Ternary Operator**: Supports concise conditional expressions.
- **Repetitive Execution (`stik`)**: A unique keyword for repeating actions.
- **Interpretation & Compilation**: Execute scripts directly or compile them.

## Installation
Clone the repository and compile the HolyStik interpreter:

```sh
git clone https://github.com/your-repo/HolyStik.git
cd HolyStik
swiftc HolyStikInterpreter.swift -o HolyStikInterpreter
```

## Running a HolyStik Script
To run a `.hstik` script using the interpreter:

```sh
./HolyStikInterpreter test.hstik
```

## HolyStik Syntax
### Example Script (`test.hstik`)
```hstik
x = 10
y = 5
z = (x + y) * 2
result = z > 20 ? "High value" : "Low value"

stik 3 "HolyStik rocks!"

age = 70
status = age <= 65 ? "Adult" : "Senior"
```

### Expected Output:
```
x = 10
y = 5
z = 15.0
result = false
Low value
HolyStik rocks!
HolyStik rocks!
HolyStik rocks!
age = 25
status = true
Senior
```

## Language Elements

### 1. **Variables**
Declare variables with `=`:

```hstik
name = "John"
age = 30
```

### 2. **Mathematical Operations**
Perform arithmetic using `+`, `-`, `*`, `/`:

```hstik
x = 5
y = (x * 3) + 2
```

### 3. **Ternary Operator**
Use `?` and `:` for conditional evaluation:

```hstik
result = x > 10 ? "Big" : "Small"
```

### 4. **Loops (`stik`)**
Repeat an expression using the `stik` keyword:

```hstik
stik 5 "Praise the Lord!"
```

### 5. **Comparison Operators**
Supports `==`, `!=`, `<`, `>`, `<=`, `>=`:

```hstik
isAdult = age >= 18 ? "Yes" : "No"
```

## License
HolyStik is licensed under **AGPL-3.0**.

## Contributing
Contributions are welcome! Submit an issue or pull request to help improve HolyStik.
