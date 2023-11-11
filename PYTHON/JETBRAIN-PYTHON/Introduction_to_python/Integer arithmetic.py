Basic operations
Python supports basic arithmetic operations:

addition +

subtraction -

multiplication *

division /

integer division //

The examples below show how it works for numbers.

print(10 + 10)   # 20
print(100 - 10)  # 90
print(10 * 10)   # 100
print(77 / 10)   # 7.7
print(77 // 10)  # 7
There is a difference between division / and integer division //. The first produces a floating-point number (like 7.7), while the second one produces an integer value (like 7) ignoring the decimal part.

Python raises an error if you try to divide by zero.

ZeroDivisionError: division by zero
Writing complex expressions
Arithmetic operations can be combined to write more complex expressions:

print(2 + 2 * 2)  # 6
The calculation order coincides with the rules of arithmetic operations. Multiplication has a higher priority level than addition and subtraction, so the operation 2 * 2 is calculated first.

To specify an order of execution, you can use parentheses, as in the following:

print((2 + 2) * 2)  # 8
Like in arithmetic, parentheses can be nested inside each other. You can also use them for clarity.

The minus operator has a unary form that negates the value or expression. A positive number becomes negative, and a negative number becomes positive.

print(-10)  # -10
print(-(100 + 200))  # -300
print(-(-20))  # 20
Other operations
The remainder of a division. Python modulo operator % is used to get the remainder of a division. It may come in handy when you want to check if a number is even. Applied to 2, it returns 1 for odd numbers and 0 for the even ones.

print(7 % 2)  # 1, because 7 is an odd number
print(8 % 2)  # 0, because 8 is an even number
Here are some more examples:

# Divide the number by itself
print(4 % 4)     # 0
# At least one number is a float
print(11 % 6.0)  # 5.0
# The first number is less than the divisor
print(55 % 77)   # 55
# With negative numbers, it preserves the divisor sign
print(-11 % 5)    # 4
print(11 % -5)    # -4
Taking the remainder of the division by 0 also leads to ZeroDivisionError.

The behavior of the mod function when two numbers have different signs might seem unexpected at first glance. Compare 11 % 5 = 1 and -11 % -5 = -1 (both the divider and the division have the same signs) with 11 % -5 = -4 and -11 % 5 = 4 (different signs).

To understand why it works that way we need to look under the "hood". In Python, the remainder always has the same sign as the divisor, and the modulo operator ( %) and integer division (//) are internally connected by the following expression:

x == (x // y) * y + (x % y)
We can rewrite it to get the "formula" for modulo division:

(x % y) == x - (x // y) * y
Now, let's apply it to our examples. We want to calculate 11 % -5. First, we calculate 11 // -5 and the result is -3. Then we apply that to our formula and get 11 % -5 == 11 - (-3) * (-5) == 11 - 15 == -4.

For -11 % 5 that looks like -11 % 5 == -11 - (-3) * 5 which equals 4.

If you want gain deeper understanding of this operation, you can check the topic "Modulo division with negative numbers" from the Math section.

Exponentiation. Here is a way to raise a number to a power:

print(10 ** 2)  # 100
This operation has a higher priority over multiplication.

Operation priority
To sum up, there is a list of priorities for all considered operations:

parentheses

power

unary minus

multiplication, division, and remainder

addition and subtraction

As mentioned above, the unary minus changes the sign of its argument.

Sometimes operations have the same priority:

print(10 / 5 / 2)  # 1.0
print(8 / 2 * 5)   # 20.0

# The expressions above may seem ambiguous to you, since they have alternative solutions depending on the operation order: either 1.0 or 4.0 in the first example, and either 20.0 or 0.8 in the second one. In such cases, Python follows a left-to-right operation convention from mathematics. It's a good thing to know, so try to keep that in mind, too!

# PEP time!

There are a few things to mention about the use of binary operators (that is, the operators that influence both operands). As you know, readability does matter in Python. So first, remember to surround a binary operator with a single space on both sides:

number=30+12      # No!

number = 30 + 12  # It's better this way
Operators are special symbols indicating what operation to perform. Operands are values that the operation is performed on. Let's consider our example: 30 + 12. Here + is an operator and 30 and 12 are operands.

Also, sometimes people use the break after binary operators. But this can hurt readability in two ways:

the operators are not in one column,

each operator has moved away from its operand and onto the previous line:

# No: operators sit far away from their operands
income = (gross_wages +
          taxable_interest +
          (dividends - qualified_dividends) -
          ira_deduction -
          student_loan_interest)
Mathematicians and their publishers follow the opposite convention in order to solve the readability problem. Donald Knuth explains this in his Computers and Typesetting series: "Although formulas within a paragraph always break after binary operations and relations, displayed formulas always break before binary operations". Following this tradition makes the code more readable:

# Yes: easy to match operators with operands
income = (gross_wages
          + taxable_interest
          + (dividends - qualified_dividends)
          - ira_deduction
          - student_loan_interest)
In Python code, it is permissible to break before or after a binary operator, as long as the convention is consistent locally. For new code, Knuth's style is suggested, according to PEP 8.