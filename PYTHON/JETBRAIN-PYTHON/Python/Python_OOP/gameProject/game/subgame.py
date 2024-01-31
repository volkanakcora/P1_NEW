from .menu import print_game_title, print_second_menu, menu_print
from .helpers import get_user_input

def play_subgame(game):
    while not game.exit_flag:
        print_game_title()
        game_response = get_user_input()
        while not game.exit_flag:
            if game_response == "m":
                print_second_menu()
                second_menu_response = get_user_input()
                if second_menu_response == 'back':
                    print_game_title()
                    break
                elif second_menu_response == 'main':
                    menu_print()
                    break
                elif second_menu_response in ["save", "exit"]:
                    print("Coming SOON!")
                    game.exit_flag = True
                    break
            elif game_response in ["ex", "up", "save"]:
                print("Coming SOON!")
                game.exit_flag = True
                break
