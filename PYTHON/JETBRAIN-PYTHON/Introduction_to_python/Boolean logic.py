#Boolean type
#The Boolean type, or simply bool, is a special data type that has only two possible values: True and False. In Python, the names of boolean values start with a capital letter.

#If you are writing an application that keeps track of door openings, you'll find it natural to use bool to store the current door state.

is_open = True
is_closed = False

print(is_open)    # True
print(is_closed)  # False


#Boolean operations

a = True and True    # True
b = True and False   # False
c = False and False  # False
d = False and True   # False
or is a binary operator, it returns True if at least one argument is true, otherwise, it returns False.

a = True or True    # True
b = True or False   # True
c = False or False  # False
d = False or True   # True
not is a unary operator, it reverses the boolean value of its argument.

to_be = True           # to_be is True
not_to_be = not to_be  # not_to_be is False

#Logical operators have a different priority and it affects the order of evaluation. Here are the operators in order of their priorities:

1. not

2. and

3. or

So, not is considered first, then and, finally or. Having this in mind, consider the following expression:

print(False or not False)  # True


#Truthy and falsy values
#Though Python has the boolean data type, we often want to use non-boolean values in a logical context. And Python lets you test almost any object for truthfulness. When used with logical operators, values of non-boolean types, such as integers or strings, are called truthy or falsy. It depends on whether they are interpreted as True or False.

#The following values are evaluated to False in Python:

c#onstants defined to be false: None and False,

#zero of any numeric type: 0, 0.0,

#empty sequences and containers: "", [], {}.

#Anything else generally evaluates to True. Here is a couple of examples:

print(0.0 or False)  # False
print("True" and True)  # True
print("" or False)  # False




#Generally speaking, and and or could take any arguments that can be tested for a boolean value.

#Now we can demonstrate more clearly the difference in operator precedence:

# `and` has a higher priority than `or`
truthy_integer = False or 5 and 100  # 100

