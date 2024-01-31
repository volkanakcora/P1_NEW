from .menu import print_title, menu_print
from .subgame import play_subgame
from .highscores import high_scores
from .helpers import get_user_input

class Game:
    def __init__(self):
        self.exit_flag = False

    def main_menu(self):
        return get_user_input()

    def main(self):
        menu_print()

        while True:
            result = self.main_menu()

            if result == 'play':
                play_subgame(self)
            elif result == 'high':
                high_scores()
            elif result == 'help':
                self.help_info()
                break
            elif result == 'exit':
                self.exit_game()
            else:
                print("\nInvalid input")

    def help_info(self):
        print("Coming SOON! Thanks for playing!")

    def exit_game(self):
        print("Thanks for playing, bye!")
        exit()

if __name__ == "__main__":
    game = Game()
    game.main()
