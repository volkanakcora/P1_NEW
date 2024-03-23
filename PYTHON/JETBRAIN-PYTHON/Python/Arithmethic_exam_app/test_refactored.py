import random


def welcome_game():
    print("""
        1 - Simple operations with numbers 2-9
        2 - Integral squares 11-29""")


def get_random_number(start, end):
    return random.randint(start, end)


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
    print("The results are saved in results.txt")


def generate_question(level):
    if level == 1:
        first_number = get_random_number(2, 9)
        second_number = get_random_number(2, 9)
        symbol_dict = ['+', '-', '*']
        operation = random.choice(symbol_dict)
        print(first_number, operation, second_number)
        return calculate_result(first_number, operation, second_number)
    elif level == 2:
        number_for_second_question = get_random_number(11, 30)
        print(number_for_second_question)
        return number_for_second_question * number_for_second_question


def main():
    welcome_game()
    count_game = 0
    count_true = 0
    while True:
        question = ask_question()
        calculation = generate_question(question)
        answer = ask_question()
        if answer == calculation:
            count_true += 1
            print("Right!")
        else:
            print("Wrong!")
        count_game += 1
        if count_game == 5:
            print(f"Your mark is {count_true}/5.")
            save_or_not = input("Would you like to save your result to the file? Enter yes or no.")
            if save_or_not.lower() in ['yes', 'y']:
                name = input("What is your name?")
                save_to_file(name, f'{count_true}/5', '1 (simple operations with numbers 2-9).' if question == 1 else
                             '2 (integral squares of 11-29)')
            else:
                print("Exiting the program.")
                break


if __name__ == "__main__":
    main()
