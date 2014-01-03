# TO DO
# adjust number of turns given to user
# make the enemy boards the same, but only display empty spots for user

$debug = true

class NewBoard
  attr_accessor :board, :perceived_board, :ships_location, :remaining_ships, :shots_taken, :next_shots, :ship_hits
  attr_reader :empty

  def initialize
    @empty = "."
    @board =  [[''] + (1..10).to_a] + 
              [['A'] + Array.new(10,@empty)] + 
              [['B'] + Array.new(10,@empty)] + 
              [['C'] + Array.new(10,@empty)] + 
              [['D'] + Array.new(10,@empty)] + 
              [['E'] + Array.new(10,@empty)] + 
              [['F'] + Array.new(10,@empty)] +  
              [['G'] + Array.new(10,@empty)] + 
              [['H'] + Array.new(10,@empty)] + 
              [['I'] + Array.new(10,@empty)] + 
              [['J'] + Array.new(10,@empty)]
    @perceived_board = [[''] + (1..10).to_a] + # @board.dub didn't work...
              [['A'] + Array.new(10,@empty)] + 
              [['B'] + Array.new(10,@empty)] + 
              [['C'] + Array.new(10,@empty)] + 
              [['D'] + Array.new(10,@empty)] + 
              [['E'] + Array.new(10,@empty)] + 
              [['F'] + Array.new(10,@empty)] + 
              [['G'] + Array.new(10,@empty)] + 
              [['H'] + Array.new(10,@empty)] + 
              [['I'] + Array.new(10,@empty)] + 
              [['J'] + Array.new(10,@empty)]
    @ships_location = { }
    @shots_taken = []
    @next_shots = []
    @ship_hits = []
  end

  def display(board)
    puts $board_color
    board.each{|x| print "#{x.join("\t")} \n" }
    puts $text_color
    puts @ships_location if $debug == true
  end

  def get_random_location
    [(1..10).to_a.sample,(1..10).to_a.sample]
  end

  def get_random_dirction
    [:vertical, :horizontal].sample
  end

  def empty_location?(row,column,direction,size,board=@board)
    if direction == :horizontal && column < (11-size)
      size.times.all? {board[row][column+=1] == @empty}
    elsif direction == :vertical && row < (11-size)
      size.times.all? {board[row+=1][column] == @empty}
    end
  end

  def place_and_map(ship,board=@board)
    @ships_location[ship] = []
    symbol = $ship_color + ship[0] + $board_color
    case ship 
    when "Aircraft Carrier"
      size = 5
    when "Battleship"
      size = 4
    when "Cruiser"
      size = 3
    when "Destroyer" || "Destroyer 2"
      size = 2
    when "Submarine" || "Submarine 2"
      size = 1    
    end
    placement = get_random_location
    row = placement[0]
    column = placement[1]
    direction = get_random_dirction
    if direction == :vertical && empty_location?(row,column,direction,size)
      size.times do 
        board[row+=1][column]=symbol
        @ships_location[ship] << [row,column]
      end
    elsif direction == :horizontal && empty_location?(row,column,direction,size)
      size.times do 
        board[row][column+=1]=symbol
        @ships_location[ship] << [row,column]
      end
    else
      place_and_map(ship)
    end
  end

  def populate
    place_and_map("Aircraft Carrier")
    place_and_map("Battleship")
    place_and_map("Cruiser")
    place_and_map("Destroyer")
    place_and_map("Submarine")
    # If this changes, make sure to change the $full_ship_names
  end

end

class EnemyBoard < NewBoard
  def initialize
    super
    #@perceived_board = @board.dup #I don't understand why this doesn't work??!!
  end

  def display_secret_board
    puts "Secret Enemy Board------------------------"
    display(@board)
    puts ''
  end

  def display_perceived_board
    puts ''
    puts $alert_color + "Enemy Board----------------------------------------------" + $text_color
    display(@perceived_board)
    puts $hit_token + " = Hit  " + $missed_token +" = Miss"
    puts ''
  end

end

class HomeBoard < NewBoard
  def initialize
    super
  end

  def display_my_board
    puts ''
    puts $success_color + "My Board-------------------------------------------------" + $text_color
    display(@board)
    puts "A = Aircraft Carrier  B = Battleship   C = Cruiser  D = Destroyer  S = Submarine"
    puts ''
  end

end


# Set up the variables
$letters_as_numbers = [""] + ("A".."J").to_a
$board_color = "\e[37m"
$text_color = "\e[37m"
$background_color = "\e[40m"
$alert_color = "\e[31m"
$success_color = "\e[32m"
$logo_color = "\e[36m"
$ship_color = "\e[33m"
$hit_token = $alert_color + "X" + $text_color
$missed_token = $success_color + "/" + $text_color
$letters_and_ships = {($ship_color+"A"+$board_color)=>"Aircraft Carrier",($ship_color+"B"+$board_color)=>"Battleship",($ship_color+"C"+$board_color)=>"Cruiser",($ship_color+"D"+$board_color)=>"Destroyer",($ship_color+"S"+$board_color)=>"Submarine"}
$full_ship_names = ["Aircraft Carrier","Battleship","Cruiser","Destroyer","Submarine"]


# Initialize GamePlay

def intro_pictures
  $ready = false # a local variable raises an error??!!
  intro_welcome = $logo_color + "
      '|| '||'  '|' '||''''|  '||'        ..|'''.|  ..|''||   '||    ||' '||''''|  
       '|. '|.  .'   ||  .     ||       .|'     '  .|'    ||   |||  |||   ||  .    
        ||  ||  |    ||''|     ||       ||         ||      ||  |'|..'||   ||''|    
         ||| |||     ||        ||       '|.      . '|.     ||  | '|' ||   ||       
          |   |     .||.....| .||.....|  ''|....'   ''|...|'  .|. | .||. .||.....|\n\n\n\n\n\n\n\n\n\n" + $text_color

  intro_to = $logo_color + "
                                |''||''|  .||''||   
                                   ||    ||'    ||  
                                   ||    ||      || 
                                   ||    '|.     || 
                                  .||.    ''|...|'  \n\n\n\n\n\n\n\n\n\n" + $text_color  

  intro_battleship = $logo_color + "
'||''|.       |     |''||''| |''||''| '||'      '||''''|   .|'''.|  '||'  '||' '||' '||''|.  
 ||   ||     |||       ||       ||     ||        ||  .     ||..  '   ||    ||   ||   ||   || 
 ||'''|.    |  ||      ||       ||     ||        ||''|      ''|||.   ||''''||   ||   ||...|' 
 ||    ||  .''''|.     ||       ||     ||        ||       .     '||  ||    ||   ||   ||      
.||...|'  .|.  .||.   .||.     .||.   .||.....| .||.....| |'....|'  .||.  .||. .||. .||.   " + $text_color

  $logo = $logo_color + " 

                                            I
                                         _.$I
                                      _.$#$$I
                         I            $._   I
                         I            _.$   I
                         I     ...:::\"\"\"    I
                         I                  IU
                         I                  ==
                         IU                 IU
                         ==           =======U=======
                         IU           |      U      |
                     =====U=====      |      U      |
                     |    U    |     |       U       |
                     |    U    |     |       U       |
                    |     U     |   |        U        |
                    |     U     |   |        U        |
                   |      U      |  |        U        |         I
                   |      U      | |         U         |    ---~I        //
                  |       U       ||         U         | -=~ qp I       //|
                  |       U       |         _U____      | }  >< I      // |
                 |       _U___    |___----~~\\WWWW/~---__|/  ---~I     //  |
                 |__---~~YYYYY---__|         U||         ~~~    I    //   |
                          U||    =============||============    I|| //    `.
                 ==========||====|            ||           |    ===//      |
                 |         ||    |            ||           |    I||/       |
                 |         ||    |            ZZ           |    /||        `.
                 |         ZZ    |            ZZ           |   //||         |
                 |         ZZ    |            ||           |  // ||         |
          I      |         ||    |            ||           | //  ||         `.
       ===I===   |         ||    |            ||           |//   ||          |
       |  I  |   |         ||    |            ||           //    ||          |
       |  I  |   |         ||    |            ZZ          //_____||_-----~~~~~\\
       |__I__|   |_________||____|            ZZ          /|     ||     !!!!!! \\
         .I                ||    |            ZZ           |     ||     ;  A I==+==
         `bo.              ||    |____________||___________|   !!!!!!!!!    /
         ===`bo.===        ||                 ||               ;   888    ,/
         |     `boo.   TTTTTTTTT              ||   !!!!!!!!!!!!   A   A A I
         |     &--`boo/        |______________LL   ;                 iiiiiii
         |     (___        8888 !!!!!!!!!!!!!!!!---'8888888            /
         |________\\                                                   /
                   \\            []   []   []   []   []   []   []     /
                    \\                                               =|\\
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" + $text_color
  clear_screen
  puts intro_welcome
  sleep (1.0)
  clear_screen
  puts intro_to
  sleep (1.0)
  clear_screen
  puts intro_battleship
  puts $logo
  prompt_return
  clear_screen
end

def initialize_game_play
  random_number = get_random_number
  random_number.times do
    $home = HomeBoard.new
    $home.populate
    $enemy = EnemyBoard.new
    $enemy.populate
  end
end


# Logistics

def get_random_number
  Random.new.rand(1..10)
end

def prompt_return(special="")
  if special == :start_new_round
    puts ""
    puts "Hit enter to start the next round..."
  else
    puts "Hit enter to continue..."
  end
  gets
end

def clear_screen
  puts "\e[H\e[2J"
end

def change_color_scheme
  puts $background_color + $text_color
end

# Start Game Play

def play_game
  change_color_scheme
  intro_pictures if $debug == false
  initialize_game_play
  intro_to_home_board
  intro_to_enemy_board
  game_loop
end

def intro_to_home_board
  puts "Here is your fleet:"
  $home.display_my_board
  puts "You can change your board by typing 'new'."
  puts ""
  puts "Or, hit Enter if you're ready..."
  initial_response = gets
  if initial_response == "\n"
    return
  elsif initial_response.downcase == "new\n"
    initialize_game_play
    intro_to_home_board
  else
    puts "Either type 'new' to get a new board, or hit enter to begin."
  end
end

def intro_to_enemy_board
  $ready = true
  clear_screen
  puts "Let's begin!"
  puts "Here's what you can see of your enemy's board:"
  $enemy.display_perceived_board
  prompt_return
end

# Game Loop

def game_loop
  fire_at_enemy
  has_more_turns(:enemy)
  puts "\nNow it's the Computer's turn\n"
  prompt_return
  clear_screen
  $home.display_my_board
  enemy_fires_back
  has_more_turns(:home)
  prompt_return(:start_new_round)
  game_loop #exit game loop through game_over at sink_ship or at remove_from_ships_location_array
end

def fire_at_enemy
  clear_screen
  $enemy.display_perceived_board
  display_turns_left_and_ships_hit(:home)
  puts ''
  puts ''
  puts "IT'S YOUR TURN!"
  puts 'Where do you want to fire? (e.g. F4)'
  puts ''
  $shot = gets.chomp
  puts ''
  if $shot == ""
    fire_at_enemy
  elsif ($shot[0].match(/[A-J]/) || $shot[0].match(/[a-j]/)) && ($shot[1..-1].match(/\b\d\b/) || $shot[1..-1].to_i == 10) # Check if input was valid
    $shot = $shot[0].upcase + $shot[1..-1] # change lower-case letters to upper-case ($shot.upcase! doesn't work???..worked on that for like 20 minutes...)
    take_shot(:home,$shot)
  else
    puts "#{$shot} is not a valid input!"
    sleep(1.0) if $debug == false
    fire_at_enemy
  end
end

def has_more_turns(board)
  puts ''
  number_of_turns = nil # is there a more effecient way to write this (Declare variable as nil first)
  if board == :home
    number_of_turns = $enemy.ships_location.size - 1 # -1 to account for the turn already taken
    number_of_turns.times {fire_at_enemy}
  elsif board == :enemy
    number_of_turns = $home.ships_location.size - 1 # -1 to account for the turn already taken
    number_of_turns.times {enemy_fires_back}
  end
end

def display_turns_left_and_ships_hit(shooter)
  ships_still_alive = nil
  if shooter == :home
    ships_still_alive = $enemy.ships_location.keys
  elsif shooter == :enemy
    ships_still_alive = $home.ships_location.keys
  end
  ships_sunk = determine_ships_sunk(ships_still_alive)
  puts "ships sunk: " if $debug == true
  puts ships_sunk if $debug == true
  if ships_sunk.size > 0 && shooter == :home
    print $success_color + "Ships Sunk: " + ships_sunk.join(", ") + $text_color + "\n"
  elsif ships_sunk.size > 0 && shooter == :enemy
    print $alert_color + "Ships Sumk: " + ships_sunk.join(", ") + $text_color + "\n"
  end
  puts "ships still alive: #{ships_still_alive}" if $debug == true
  # puts "Number of turns remaining for this round: #{ships_still_alive.size - $turns_taken - 1}"
end

def determine_ships_sunk(ships_still_alive)
  $full_ship_names - ships_still_alive
end

def enemy_fires_back
  display_turns_left_and_ships_hit(:enemy)
  take_shot(:enemy, smart_shot)
end

def smart_shot 
  coordinates = nil
  if $enemy.next_shots.size == 0
    random_letter = ("A".."J").to_a.sample
    random_number = ("1".."10").to_a.sample
    coordinates = random_letter + random_number
  else #there are some shots cued up
    if $enemy.ship_hits.size == 2 #two hits for a single ship
      puts "$enemy.ship_hits: " if $debug == true
      puts $enemy.ship_hits if $debug == true
      #find commonality between two shots
      if $enemy.ship_hits[0][0] == $enemy.ship_hits[1][0]
        #delete all coordinates from next_shot that don't match that letter
        $enemy.next_shots.each do |shot|
          if shot[0] != $enemy.ship_hits[0][0]
            $enemy.next_shots.delete(shot)
          end
        end
      else #delet all coordinates from next_shot that don't match that number
        $enemy.next_shots.each do |shot|
          if shot[1..-1] != $enemy.ship_hits[0][1..-1]
            $enemy.next_shots.delete(shot)
          end
        end
      end
      puts "$enemy.next_shots: " if $debug == true     
      puts $enemy.next_shots if $debug == true     
      sleep(2.0) if $debug == true      
      $enemy.ship_hits.delete_at(0) #delete first ship_hits, so there are only a maximum of 2 at any time
    end
    coordinates = $enemy.next_shots.sample
    $enemy.next_shots.delete(coordinates)
  end
  if $enemy.shots_taken.include?(coordinates)
    smart_shot
  else
    $enemy.shots_taken << coordinates
    return coordinates
  end
end

def add_smart_shots_to_next_shots_array(row, column)
  surrounding_coordinates = []
  surrounding_coordinates << coordinate_numbers_to_coordinate_string((row+1),column) if row != 10
  surrounding_coordinates << coordinate_numbers_to_coordinate_string((row-1),column) if row != 1
  surrounding_coordinates << coordinate_numbers_to_coordinate_string(row,(column+1)) if column != 10
  surrounding_coordinates << coordinate_numbers_to_coordinate_string(row,(column-1)) if column != 1
  surrounding_coordinates.shuffle!
  surrounding_coordinates.each {|coordinate| $enemy.next_shots << coordinate} #$enemy.next_shots += surrounding_coordinates didn't work for some reason...
  puts "surrounding coordinates: " if $debug == true
  puts surrounding_coordinates if $debug == true
  puts "enemy next shots: " if $debug == true
  puts $enemy.next_shots if $debug == true
  sleep (2.0) if $debug == true
end

def coordinate_numbers_to_coordinate_string(row,column)
  letters = [""] + ("A".."J").to_a
  letter = letters[row]
  number = column.to_s
  return letter + number
end

def take_shot(shooter,shot)
  if shooter == :enemy
    sleep (1.0) if $debug == false
  else
    puts "Firing at #{$shot}"
  end
  puts ''
  puts ''
  if shooter == :enemy
    puts "Firing at #{shot}"
  else
    puts '...'
  end
  puts ''
  puts ''
  sleep(1.0) if $debug == false
  analyze_and_print_results(shooter,shot)
end

def analyze_and_print_results(shooter,shot)
  row = $letters_as_numbers.index(shot[0])
  column = shot[1..-1].to_i
  if shooter == :home
    secret_board = $enemy.board
    perceived_board = $enemy.perceived_board
    if secret_board[row][column].include?("X") || secret_board[row][column].include?("/")
      display_results(shooter, :repeat)
    elsif secret_board[row][column] == $enemy.empty
      perceived_board[row][column] = $success_color + "/" + $board_color #Blue /
      display_results(shooter, :missed)
    else #HIT 
      remove_from_ships_location_array($enemy, secret_board[row][column], row, column, :home)
      perceived_board[row][column] = $alert_color + "X" + $board_color # RED X
      ship_letter = secret_board[row][column]
      display_results(shooter, :hit, ship_letter)
    end
  elsif shooter == :enemy
    if $home.board[row][column].include?("X") || $home.board[row][column].include?("/")
      enemy_fires_back
    elsif $home.board[row][column] == $home.empty
      clear_screen
      $home.board[row][column] = $success_color + "/" + $board_color #Blue /
      display_results(shooter, :miss)
    else # Computer gets a hit
      clear_screen
      $enemy.ship_hits << coordinate_numbers_to_coordinate_string(row,column)
      remove_from_ships_location_array($home, $home.board[row][column], row, column, :enemy)
      ship_letter = $home.board[row][column]
      $home.board[row][column] = $alert_color + "X" + $board_color #RED X
      display_results(shooter, :hit, ship_letter)
    end
  end
end

def display_results(shooter, hit_or_miss, ship_letter=nil)
  if shooter == :home
    clear_screen
    $enemy.display_perceived_board
    if hit_or_miss == :repeat
      puts "YOU ALREADY SHOT THERE! BETTER LUCK NEXT TIME!"
    elsif hit_or_miss == :missed
      puts "You missed..."
    elsif hit_or_miss == :hit
      puts $success_color + "GOOD HIT!!!" + $text_color #In the Color Green
    end
    sleep(1.0) if $debug == false
  elsif shooter == :enemy
    $home.display_my_board
    if hit_or_miss == :miss
      puts $success_color + "Computer missed..." + $text_color
    else
      puts $alert_color + "COMPUTER HIT YOUR #{letter_to_ship_conversion(ship_letter)}!" + $text_color #In the Color Red
    end
  end
end

def remove_from_ships_location_array(board, letter, row, column, shooter)
  ship_name = letter_to_ship_conversion(letter)
  ships_array = board.ships_location[ship_name]
  ships = remaining_ships(shooter)
  if ships_array.size == 1
    sink_ship(board.ships_location, ship_name, shooter)
    $enemy.next_shots = []
    $enemy.ship_hits = []
  else
    add_smart_shots_to_next_shots_array(row, column) if shooter == :enemy
    ships_array.delete([row,column])
  end
end

def sink_ship(ships_location, ship_name, shooter)
  if ship_name == "Battleship"
    clear_screen
    if shooter == :home
      puts $logo_color + "YOU JUST SUNK THE ENEMY'S BATTLESHIP!!!" + $text_color
    elsif shooter == :enemy
      puts $alert_color + "THE COMPUTER JUST SANK YOUR BATTLESHIP!!!" + $text_color
    end
    puts $logo
    game_over(shooter)
  else
    print_sunk_ship_results(ship_name, shooter)
    ships_location.delete(ship_name)
  end
end

def print_sunk_ship_results(ship_name, shooter)
  clear_screen
  if shooter == :home
    puts $success_color #initiate the color Green
    puts "YOU JUST SUNK THE ENEMY'S #{ship_name.upcase}!!!\n\n\n\n"
  else #computer sinks ship
    puts $alert_color #initiate the color Red
    puts "THE COMPUTER JUST SUNK YOUR #{ship_name.upcase}!!!\n\n\n\n"
  end
  case ship_name
  when "Aircraft Carrier"
    puts "
                               |\\
                               ||.
                               ||;`
                             ,'|;  :
                           ,': |;  `
                         ,'  | ;  `-`
                       ,'    | ;     :
                     ,'    `-|;      `
                    ;        ;        `
                  ,'      `--\\`-.   `--:
            ,-._,'`.         |\\||`-.   `
            `;-.`-._`.       | |\\ \\ `-. `
             :`--`-.`-\\  `--.| /`\\;\\   `-:
             ;      ``-`.    |/  ;  \\    `.
             ;           `.`-/   ;   \\    `
             ;      :      `/    ;    \\    `
     ,-._    |             /     ;   -`\\    :
     `;-.`-._| :          /      |      \\   `
      ;   `-.|     :     /       |       \\   `
      ;      | :    :   /        |        \\   :
      ;      | :       /   ;     |         \\  `
      ;      |        /   ;      |       --`\\  `
      |      |  :    /    ;      |           \\  :
      | :    |  :   /            ;            \\ `
      |      :     ;            ;:'-.._      -`\\ `
      |  :   ;___  ;'---....___;__:__| `-._     \\ :
      |      :   `;``-------'';||  :  \\    `-._  \\`
     -=======:===;===========;=||   :  \\       `-.\\:
         ___ ; _;_||        ;  ||___,:-.\\___,....__\\_
        |`--:.|;_o||-______;,..-----\"\"\"\"\" __|__...-''
----....|___     \"\"\"\"                     __||-------........________
            \"\"\"\"----....____      __..--''  || ~~~~~
     ~~~ ~~~                \"\"\"\"----....____|\/    ~~~~~~~     ~~~~~~~
~~~                ~~~~   ~~~~~~  ~  ~~~       ~~~~
  ~~~~~      ~~~      ~     ~~~~~~~~~ ~~~                ~~~~~~~~~~"
  when "Cruiser"
    puts "
                                       ..
                                     .(  )`-._
                                   .'  ||     `._
                                 .'    ||        `.
                              .'       ||          `._
                            .'        _||_            `-.
                         .'          |====|              `..
                       .'             \\__/               (  )
                     ( )               ||          _      ||
                     /|\\               ||       .-` \\     ||
                   .' | '              ||   _.-'    |     ||
                  /   |\\ \\             || .'   `.__.'     ||   _.-..
                .'   /| `.            _.-'   _.-'       _.-.`-'`._`.`
                \\  .' |  |        .-.`    `./      _.-`.    `._.-'
                 |.   |  `.   _.-'   `.   .'     .'  `._.`---`
                .'    |   |  :   `._..-'.'        `._..'  ||
               /      |   \\  `-._.'    ||                 ||
              |     .'|`.  |           ||_.--.-._         ||
              '    /  |  \\ \\       __.--'\\    `. :        ||
               \\  .'  |   \\|   ..-'   \\   `._-._.'        ||
`.._            |/    |    `.  \\  \\    `._.-              ||
    `-.._       /     |      \\  `-.'_.--'                 ||
         `-.._.'      |      |        | |         _ _ _  _'_ _ _ _ _
              `-.._   |      \\        | |        |_|_|_'|_|_|_|_|_|_|
                  [`--^-..._.'        | |       /....../|  __   __  |
                   \\`---.._|`--.._    | |      /....../ | |__| |__| |
                    \\__  _ `-.._| `-._|_|_ _ _/_ _ _ /  | |__| |__| |
                     \\   _o_   _`-._|_|_|_|_|_|_|_|_/   '-----------/
                      \\_`.|.'  _  - .--.--.--.--.--.`--------------'
      .```-._ ``-.._   \\__   _    _ '--'--'--'--'--'  - _ - _  __/
 .`-.```-._ ``-..__``.- `.      _     -  _  _  _ -    _-   _  __/(.``-._
 _.-` ``--..  ..    _.-` ``--..  .. .._ _. __ __ _ __ ..--.._ / .( _..``
`.-._  `._  `- `-._  .`-.```-._ ``-..__``.-  -._--.__---._--..-._`...```
   _.-` ``--..  ..  `.-._  `._  `- `-._ .-_. ._.- -._ --.._`` _.-`-._`-.
"
  when "Destroyer"
    puts "
     *                            *                    ((   *  
        *                 *                *            ~      
                ___.                          *          *     
       *    ___.\\__|.__.           *                           
            \\__|. .| \\_|.                                      
            . X|___|___| .                         *           
          .__/_||____ ||__.            *                /\\     
  *     .  |/|____ |_\\|_ |/ _                          /  \\    
        \\ _/ |_X__\\|_  |\\||~,~{                       /    \\   
         \\/\\ |/|    |_ |/:|`X'{                   _ _/      \\__
          \\ \\/ |___ |_\\|_.|~~~                   /    . .. . ..
         _|X/\\ |___\\|_ :| |_.                  - .......... . .
         | __\\_:____ |  ||o-|            ___/........ . . .. ..
         |/_-|-_|__ \\|_ |/--|       ____/  . . .. . . .. ... . 
 ........:| -|- o-o\\_:_\\|o-/:....../...........................
 ._._._._._\\=\\====o==o==o=/:.._._._._._._._._._._._._._._._._._
 _._._._._._\\_\\ ._._._._.:._._._._._._._._._._._._._.P_._._._._
 ._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._._
---------------------------------------------------------------"
  when "Submarine"
    puts "
                           |`-:_
  ,----....____            |    `+.
 (             ````----....|___   |
  \\     _                      ````----....____
   \\    _)                                     ```---.._
    \\                                                   \\ 
  )`.\\  )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )`.   )
-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   `-'   "
  end
  puts $text_color # Change back to White text
  sleep(2.0)
end

def letter_to_ship_conversion(letter)
  $letters_and_ships[letter]
end

def remaining_ships(shooter)
  if shooter == :enemy
    $home.ships_location.keys
  elsif shooter == :home
    $enemy.ships_location.keys
  end
end

# Game Over

def game_over(shooter)
  sleep(2.0)
  if shooter == :home
    puts $success_color
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "               YOU WON!!!!!               "
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts ''
    puts ''
    puts ''
  elsif shooter == :enemy
    puts $alert_color
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "                YOU LOST!                 "
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts "******************************************"
    puts ''
    puts ''
    puts ''
  end
  puts $text_color
  sleep(3.0)
  prompt_return
  play_game
end

# Method to Start the Application

play_game
