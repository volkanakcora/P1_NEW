import argparse
import random
import time

class Game:
    def __init__(self, seed, min_duration, max_duration, possible_locations):
        random.seed(seed)
        self.min_duration = min_duration
        self.max_duration = max_duration
        self.possible_locations = possible_locations.split(',')

        self.total_titanium = 0

    def explore(self):
        print("Searching...")
        num_locations = random.randint(1, 9)
        locations_to_explore = random.sample(self.possible_locations, num_locations)

        for idx, location in enumerate(locations_to_explore, start=1):
            print(f"[{idx}] {location.replace('_', ' ')}")

            input("[S] to continue searching")

        print("Nothing more in sight.")

        while True:
            choice = input("Enter the number of the location you want to explore or [Back]: ")

            if choice.lower() == 'back':
                return

            try:
                choice = int(choice)
                if 1 <= choice <= len(locations_to_explore):
                    self.explore_location(locations_to_explore[choice - 1])
                    break
                else:
                    print("Invalid location number")
            except ValueError:
                print("Invalid input")

    def explore_location(self, location):
        print("Deploying robots...")
        titanium_yield = random.randint(10, 100)
        self.total_titanium += titanium_yield
        print(f"{location.replace('_', ' ')} explored successfully, with no damage taken.")
        print(f"Acquired {titanium_yield} lumps of titanium")
        print(f"Total titanium: {self.total_titanium}")

    def print_second_menu(self):
        menu = """|==========================|
    |            MENU          |
    |                          |
    | [Back] to game           |
    | Return to [Main] Menu    |
    | [Save] and exit          |
    | [Exit] game              |
    |==========================|"""
        self.print_title(menu)

    def main_menu(self):
        while True:
            print("+=============================================================================+")
            print("     ######*   ##*   ##*  #######*  ##*  ##*  #######*  ######*   #######*")
            print("     ##*  ##*  ##*   ##*  ##*       ##* ##*   ##*       ##*  ##*  ##*      ")
            print("     ##*  ##*  ##*   ##*  #######*  #####*    #####*    ######*   #######*")
            print("     ##*  ##*  ##*   ##*       ##*  ##* ##*   ##*       ##*  ##*       ##*")
            print("     ######*    ######*   #######*  ##*  ##*  #######*  ##*  ##*  #######*")
            print("                         (Survival ASCII Strategy Game)")
            print("+=============================================================================+")
            print("\n[Play]\n[High] Scores\n[Help]\n[Exit]")

            command = input("\nYour command: ").strip().lower()

            if command == 'play':
                self.play_game()
            elif command == 'high':
                if self.total_titanium == 0:
                    print("No scores")
                else:
                    print(f"Total titanium: {self.total_titanium}")
                while True:
                    back_command = input("\n[Back] to game: ").strip().lower()
                    if back_command == 'back':
                        break
                    else:
                        print("Invalid input")
            elif command == 'help':
                print("Coming SOON! Thanks for playing!")
            elif command == 'exit':
                print("Thanks for playing, bye!")
                break
            elif command == 'm':
                self.print_second_menu()
            else:
                print("Invalid input")


    def play_game(self):
        name = input("\nEnter your name: ")
        print(f"\nGreetings, commander {name}!")
        start = input("Are you ready to begin?\n[Yes] [No] Return to Main[Menu]\n\nYour command: ").strip().lower()

        if start == 'yes':
            self.show_hub()

    def show_hub(self):
        print("+==============================================================================+")
        print("  $   $$$$$$$   $  |  $   $$$$$$$   $  |  $   $$$$$$$   $")
        print("  $$$$$     $$$$$  |  $$$$$     $$$$$  |  $$$$$     $$$$$")
        print("      $$$$$$$      |      $$$$$$$      |      $$$$$$$")
        print("     $$$   $$$     |     $$$   $$$     |     $$$   $$$")
        print("     $       $     |     $       $     |     $       $")
        print("+==============================================================================+")
        print("| Titanium:", self.total_titanium, " " * (76 - len(str(self.total_titanium))), "|")
        print("+==============================================================================+")
        print("|                  [Ex]plore                          [Up]grade                |")
        print("|                  [Save]                             [M]enu                   |")
        print("+==============================================================================+")

        while True:
            command = input("\nYour command: ").strip().lower()

            if command == 'ex':
                self.explore()
            elif command == 'exit':
                print("Thanks for playing, bye!")
                break
            else:
                print("Invalid command")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Survival ASCII Strategy Game")
    parser.add_argument("Seed", help="Seed for pseudo-random number generation")
    parser.add_argument("MinimumDuration", type=int, default=0, nargs='?', help="Minimum duration of animations")
    parser.add_argument("MaximumDuration", type=int, default=0, nargs='?', help="Maximum duration of animations")
    parser.add_argument("PossibleLocations", nargs='?', default="High_street,Green_park,Destroyed_Arch",
                        help="Names of possible locations separated by comma")

    args = parser.parse_args()

    game = Game(args.Seed, args.MinimumDuration, args.MaximumDuration, args.PossibleLocations)
    game.main_menu()
