import json
import operator
# The following line creates a dictionary from the input. Do not modify it, please
test_dict = json.loads(input())

# Work with the 'test_dict'
# Find the key for the minimum value
min_key = min(test_dict, key=test_dict.get)

# Find the key for the maximum value
max_key = max(test_dict, key=test_dict.get)

print(f"min: {min_key}")
print(f"max: {max_key}")


