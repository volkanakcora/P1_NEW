#Let's slice a list of planets picking every second planet. We start from the third (with the index 2) planet and stop at the seventh (with the index 6) one. The eighth planet (with the index 7) is not included in the slice.

planets = ['Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune']
print(planets[2:7:2])  # ['Earth', 'Jupiter', 'Uranus']

#Each part of the slice has a default value, so it can be omitted. If we don't specify the start index, it is considered to be 0; if we don't specify the stop index, it is equal to the length of the sequence. The default step is 1, i.e. every element between the beginning and the end is put in the slice.

#Here's what happens if we slice without specifying some indexes:

sequence[:end]    # elements from start to end-1
sequence[start:]  # elements from start to the last element
sequence[:]       # the full copy of the sequence
sequence[::step]  # every element with a given step

#Let's take a look at some examples to make understanding more practical.

snakes = ['python', 'cobra', 'viper']
print(snakes[:2])     # ['python', 'cobra']
print(snakes[0][:2])  # py

powers_of_two = [1, 2, 4, 8, 16, 32, 64, 128]
print(powers_of_two[4:])  # [16, 32, 64, 128]

colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet']
print(colors[::3])  # ['red', 'green', 'violet']