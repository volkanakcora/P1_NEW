#Simple if statement

biscuits = 17
if biscuits >= 5:
    print("It's time for tea!")


#Nested if statement
#Sometimes a condition happens to be too complicated for a simple if statement. In this case, you can use so-called nested if statements. 
# The more if statements are nested, the more complex your code gets, which is usually not a good thing. However, this doesn't mean that 
# you need to avoid nested if statements at all costs. Let's take a look at the code below:

rainbow = "red, orange, yellow, green, blue, indigo, violet"
warm_colors = "red, yellow, orange"
my_color = "orange"

if my_color in rainbow:
    print("Wow, your color is in the rainbow!")
    if my_color in warm_colors:
        print("Oh, by the way, it's a warm color.")



#Simple if-else

if today == "holiday":
    print("Lucky you!")
else:
    print("Keep your chin up, then.")


if x < 100:
    print('x < 100')
else:
    if x == 100:
        print('x = 100')
    else:
        print('x > 100')
    print('This will be printed only because x >= 100')

#For loop

oceans = ['Atlantic', 'Pacific', 'Indian', 'Southern', 'Arctic']
for ocean in oceans:
    print(ocean)

#During each iteration, the program will take one item from the list and execute the statements on it, so the final output will be:

Atlantic
Pacific
Indian
Southern
Arctic




#Range function
#The range() function can be used to specify the number of iterations. It returns a sequence of numbers from 0 (by default) and ends at a specified number. Be careful: the last number won't be in the output since we started from 0.

#Let's look at the example below:

for i in range(5):
    print(i)
What we'll get is this:

0
1
2
3
4


#Input data processing

#You can also use the input() function that helps the user to pass a value to some variable and work with it. Thus, you can get the same output as with the previous piece of code:

word = input()
for char in word:
    print(char)
Oh, look, you can write a piece of code with a practical purpose:

times = int(input('How many times should I say "Hello"?'))
for i in range(times):
    print('Hello!')