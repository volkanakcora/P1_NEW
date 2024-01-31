from .menu import menu_print
from .helpers import get_user_input

def high_scores():
    while True:
        print("No scores to display.")
        print("[Back]")
        decision = get_user_input()
        if decision == "back":
            menu_print()
            break
        else:
            print("\nInvalid input")
