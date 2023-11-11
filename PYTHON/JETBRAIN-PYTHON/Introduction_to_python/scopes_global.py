#Local variables are created when you define them in the body of a function. So its name can only be resolved inside the current function's scope. It lets you avoid issues with side-effects that may happen when using global variables.

#Consider the example to see the difference between global and local variables:

phrase = "Let it be"

def global_printer():
    print(phrase)  # we can use phrase because it's a global variable

global_printer()  # Let it be is printed
print(phrase)  # we can also print it directly

phrase = "Hey Jude"

global_printer()  # Hey Jude is now printed because we changed the value of phrase

def printer():
    local_phrase = "Yesterday"
    print(local_phrase)  # local_phrase is a local variable

printer()  # Yesterday is printed as expected

print(local_phrase)  # NameError is raised

#Thus, a global variable can be accessed both from the top-level of the module and the function's body. On the other hand, a local variable is only visible inside the nearest scope and cannot be accessed from the outside.




#LEGB Rule

# LEGB rule
# A variable resolution in Python follows the LEGB rule. That means that the interpreter looks for a name in the following order:

# Locals. Variables defined within the function body and not declared global.
# Enclosing. Names of the local scope in all enclosing functions from inner to outer.
# Globals. Names defined at the top-level of a module or declared global with a global keyword.
# Built-in. Any built-in name in Python.
Let's consider an example to illustrate the LEGB rule:

x = "global"
def outer():
    x = "outer local"
    def inner():
        x = "inner local"
        def func():
            x = "func local"
            print(x)
        func()
    inner()

outer()  # "func local"
# When the print() function inside the func() is called the interpreter needs to resolve the name x. 
# It'll first look at the innermost variables and will search for the local definition of x in func() function. In the case of the code above, 
# the interpreter will find the local x in func() successfully and print its value, 'func local'. Here is the visualization of the code. Check it out to see how it works almost in real-time!



!!!## Keywords "nonlocal" and "global"


x = 1
def print_global():
    print(x)

print_global()  # 1

def modify_global():
    print(x)
    x = x + 1

modify_global()  # UnboundLocalError: local variable 'x' referenced before assignment, line 8



#To fix this error, we need to declare x global:

x = 1
def global_func():
    global x
    print(x)
    x = x + 1

global_func()  # 1
global_func()  # 2
global_func()  # 3
When x is global you can increment its value inside the function.




#nonlocal keyword lets us assign to variables in the outer (but not global) scope:

def func():
    x = 1
    def inner():
        x = 2
        print("inner:", x)
    inner()
    print("outer:", x)

def nonlocal_func():
    x = 1
    def inner():
        nonlocal x
        x = 2
        print("inner:", x)
    inner()
    print("outer:", x)

func()  # inner: 2
        # outer: 1

nonlocal_func()  # inner: 2
                 # outer: 2