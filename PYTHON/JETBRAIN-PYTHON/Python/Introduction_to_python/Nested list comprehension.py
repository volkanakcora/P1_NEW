#Nested list comprehension

# original list
school = [["Mary", "Jack", "Tiffany"], 
          ["Brad", "Claire"],
          ["Molly", "Andy", "Carla"]]
If you want to create a list of all students in all classes without the list comprehension it would look like this:

student_list = []
for class_group in school:
    for student in class_group:
        student_list.append(student)