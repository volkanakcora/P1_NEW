def print_title(title):
    print(title)

def print_game_title():
    title = """+==============================================================================+
$   $$$$$$$   $  |  $   $$$$$$$   $  |  $   $$$$$$$   $
$$$$$     $$$$$  |  $$$$$     $$$$$  |  $$$$$     $$$$$
    $$$$$$$      |      $$$$$$$      |      $$$$$$$
    $$$   $$$    |     $$$   $$$     |     $$$   $$$
    $       $    |     $       $     |     $       $
+==============================================================================+"""
    print_title(title)

def print_second_menu():
    menu = """|==========================|
    |            MENU          |
    |                          |
    | [Back] to game           |
    | Return to [Main] Menu    |
    | [Save] and exit          |
    | [Exit] game              |
    |==========================|"""
    print_title(menu)

def menu_print():
    print_title(
        """+=======================================================================+
  ######*   ##*   ##*  #######*  ##*  ##*  #######*  ######*   #######*
  ##*  ##*  ##*   ##*  ##*       ##* ##*   ##*       ##*  ##*  ##*
  ##*  ##*  ##*   ##*  #######*  #####*    #####*    ######*   #######*
  ##*  ##*  ##*   ##*       ##*  ##* ##*   ##*       ##*  ##*       ##*
  ######*    ######*   #######*  ##*  ##*  #######*  ##*  ##*  #######*
                      (Survival ASCII Strategy Game)
+=======================================================================+"""
    )
    print("[Play]")
    print("[High] Scores")
    print("[Help]")
    print("[Exit]")

