# Def for Define
You can create your own function using the keyword def (right, derived from define). Let's have a look at the syntax:

def function_name(parameter1, parameter2, ...):
    # function's body
    ...
    return "return value"

# After def, we write the name of our function (so as to invoke it later) and the names of parameters, which our function can accept, enclosed in parentheses. Do not miss the colon at the end of the line. 
# The names of a function and its parameters follow the same convention as variable names, that is, they should be written in lowercase with underscores between words.



## Parameters vs arguments

'Its not quite clear right now, what the parameters are, is it? In fact, parameters are just aliases for values, which can be passed to a function. Consider the following example:'

def send_postcard(address, message):
    print("Sending a postcard to", address)
    print("With the message:", message)


send_postcard("Hilton, 97", "Hello, bro!")
# Sending a postcard to Hilton, 97
# With the message: Hello, bro!

send_postcard("Piccadilly, London", "Hi, London!")
# Sending a postcard to Piccadilly, London
# With the message: Hi, London!



#  Execution and return
#  Our previous function only performed some actions, but it didn't have any return value. However, you might want to calculate something in a function and return the result at some point. Check the following example:

def celsius_to_fahrenheit(temps_c):
    temps_f = temps_c * 9 / 5 + 32
    return round(temps_f, 2)


# Convert the boiling point of water
water_bp = celsius_to_fahrenheit(100)
print(water_bp)  # 212.0

