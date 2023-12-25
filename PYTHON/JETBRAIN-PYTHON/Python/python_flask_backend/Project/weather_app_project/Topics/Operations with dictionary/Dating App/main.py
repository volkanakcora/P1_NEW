def select_dates(potential_dates):
   selected_dates = [person['name'] for person in potential_dates if person['age'] > 30
                     and "art" in person["hobbies"] and person ["city"] == "Berlin"]
   return ", ".join(selected_dates)
