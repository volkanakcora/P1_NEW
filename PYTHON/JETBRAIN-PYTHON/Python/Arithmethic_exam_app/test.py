# write your code here
import random    
import sys

def welcome_game():
    print("""
        1 - simple operations with numbers 2-9
        2 - integral squares 11-29""")

def get_random_number(start, end):
    return random.randrange(start, end, 1)

def calculate_result(first_number, operation, second_number):
    if operation == '-':
        return first_number - second_number 
    elif operation == '*':
        return first_number * second_number 
    elif operation == '+':
        return first_number + second_number 

def ask_question():
    while True:
        answer = input()
        if not answer or not answer.replace('-', '').replace('+', '').replace('*', '').isdigit():
                print("Incorrect format.")
        else:
            return int(answer)
        
def save_to_file(name, score, operation):
    with open("results.txt", "a") as text_file:
        text_file.write(f'{name}: {score} in level {operation}\n')
    text_file.close()
    print("The results are saved in results.txt")


def main():
    count_game = 0
    count_true = 0
    welcome_game()
    while True:
        question = ask_question()
        if question == 1:
            while True:
                first_number = get_random_number(2,9)
                second_number = get_random_number(2,9)
                symbol_dict = ['+','-','*']
                operation = symbol_dict[get_random_number(0,3)]
                print(first_number, operation, second_number)
                calculation = calculate_result(first_number, operation, second_number)
                if ask_question() == calculation:
                    count_true += 1
                    count_game += 1
                    print("Right!")
                    if count_game == 5:
                        print(f"Your mark is {count_true}/5.")
                        save_or_not = input("Would you like to save your result to the file? Enter yes or no.")
                        if save_or_not in ['yes','y','YES','Yes']:
                            name = input("What is your name?")
                            save_to_file(name, f'{count_true}/5', '1 (simple operations with numbers 2-9).')
                        else:
                            print("exit the program")
                            sys.exit()
                else:
                    print("Wrong!")
                    count_game += 1
                    if count_game == 5:
                        print(f"Your mark is {count_true}/5.")
                        save_or_not = input("Would you like to save your result to the file? Enter yes or no.")
                        if save_or_not in ['yes','y','YES','Yes']:
                            name = input("What is your name?")
                            save_to_file(name, f'{count_true}/5', '1 (simple operations with numbers 2-9).')
                        else:
                            print("exit the program")
                            sys.exit()

        elif question == 2:
             while True:
                number_forsecond_question = get_random_number(11,30)
                print(number_forsecond_question)
                calculation_second_question = number_forsecond_question * number_forsecond_question
                if ask_question() == calculation_second_question:
                    count_true += 1
                    count_game += 1
                    print("Right!")
                    if count_game == 5:
                        print(f"Your mark is {count_true}/5.")
                        save_or_not = input("Would you like to save your result to the file? Enter yes or no.")
                        if save_or_not in ['yes','y','YES','Yes']:
                            name = input("What is your name?")
                            save_to_file(name, f'{count_true}/5', '2 - integral squares of 11-29.')
                        else:
                            print("exit the program")
                            sys.exit()
                else: 
                    print("Wrong!")
                    count_game += 1
                    if count_game == 5:
                        print(f"Your mark is {count_true}/5.")
                        save_or_not = input("Would you like to save your result to the file? Enter yes or no.")
                        if save_or_not in ['yes','y','YES','Yes']:
                            name = input("What is your name?")
                            save_to_file(name, f'{count_true}/5', '2 (integral squares of 11-29.')
                        else:
                            print("exit the program")
                            sys.exit()


if __name__ == "__main__":
    main()
