INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diags
WHO_GOES_FIRST = 'choose'

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr_of_ints, separator = ', ', last_separator = 'or ')
  case arr_of_ints.size
  when 0 then ''
  when 1 then arr_of_ints[0].to_s
  when 2 then arr_of_ints.join(' ' + last_separator)
  else
    arr_of_ints[0..arr_of_ints.size - 2].join(separator) + separator +
      last_separator + arr_of_ints.last.to_s
  end
end

def display_board(brd, p_score, c_score)
  system 'cls'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts "Score is: Player #{p_score}, Computer #{c_score}"
  puts "First to 5 wins."
  puts
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd), ', ')}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def identify_offense(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      square_as_arr = line.select { |num| brd[num] == INITIAL_MARKER }
      return square_as_arr.last
    end
  end
  nil
end

def identify_defense(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      square_as_arr = line.select { |num| brd[num] == INITIAL_MARKER }
      return square_as_arr.last
    end
  end
  nil
end

def computer_places_piece!(brd)
  square = identify_offense(brd) # Prefer to win
  square = identify_defense(brd) unless square # Otherwise, prefer defense
  unless square
    square = 5 if empty_squares(brd).include?(5)
  end
  square = empty_squares(brd).sample unless square # Default to random
  brd[square] = COMPUTER_MARKER
end

def place_piece!(brd, current_player)
  if current_player == 'p'
    player_places_piece!(brd)
  else
    computer_places_piece!(brd)
  end
end

def switch_player(current_player)
  if current_player == 'p'
    'c'
  else
    'p'
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      'Computer'
    end
  end
  nil
end

player_score = 0
computer_score = 0
player_up = nil
if WHO_GOES_FIRST == 'choose'
  loop do
    prompt 'Choose who goes first: P for player, or C for computer: '
    response = gets.chomp
    if response.downcase == 'p' || response.downcase == 'c'
      player_up = response.downcase
      break
    end
    prompt 'Invalid input. Please select "P" or "C".'
  end
elsif WHO_GOES_FIRST == 'player'
  player_up = 'p'
else
  player_up = 'c'
end

loop do
  board = initialize_board

  loop do
    display_board(board, player_score, computer_score)

    place_piece!(board, player_up)
    player_up = switch_player(player_up)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board, player_score, computer_score)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won! Updating score..."
    if detect_winner(board) == 'Player'
      player_score += 1
      player_up = 'c' # The one who lost last goes first
    elsif detect_winner(board) == 'Computer'
      computer_score += 1
      player_up = 'p' # The one who lost last goes first
    end
  else
    prompt "It's a tie!"
  end

  sleep(3)
  display_board(board, player_score, computer_score)

  if player_score == 5
    prompt "You're the Grand Winner!"
    break
  elsif computer_score == 5
    prompt "Better luck next time!"
    break
  end
end

prompt "Thanks for playing Tic Tac Toe! Goodbye!"
