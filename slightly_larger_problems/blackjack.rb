deck =
  ['2S', '2C', '2D', '2H',
   '3S', '3C', '3D', '3H',
   '4S', '4C', '4D', '4H',
   '5S', '5C', '5D', '5H',
   '6S', '6C', '6D', '6H',
   '7S', '7C', '7D', '7H',
   '8S', '8C', '8D', '8H',
   '9S', '9C', '9D', '9H',
   'TS', 'TC', 'TD', 'TH',
   'JS', 'JC', 'JD', 'JH',
   'QS', 'QC', 'QD', 'QH',
   'KS', 'KC', 'KD', 'KH',
   'AS', 'AC', 'AD', 'AH']

VALUES = { '2' => 2,
           '3' => 3,
           '4' => 4,
           '5' => 5,
           '6' => 6,
           '7' => 7,
           '8' => 8,
           '9' => 9,
           'T' => 10,
           'J' => 10,
           'Q' => 10,
           'K' => 10,
           'A' => 11 }

NUMBER_DECKS = 8 # Typically 6 or 8, depending on the casino

def prompt(message)
  puts "=> #{message}"
end

def display(standing, chips, bet, dealer, player, pause, dd, current_hand = nil)
  system 'cls'
  puts
  puts "Standing: #{standing[0]} | Chips: #{chips[0]}"
  bet_line = 'Set bet amount: '
  bet.each_with_index do |num, idx|
    if [0, nil].include?(dd[idx])
      bet_line << "#{num}, "
    else
      bet_line << "#{num} + #{dd[idx]}, "
    end
  end
  bet_line.chop!.chop!
  puts bet_line
  puts
  puts '                DEALER                '
  if dealer.empty?
    puts
  else
    puts "[ #{dealer.join(' | ')} ]".center(40) + value(dealer).to_s
  end
  puts
  puts 'Insurance pays 3 to 2'.center(40)
  puts
  puts 'Dealer hits to 17'.center(40)
  puts
  if dealer.empty?
    puts
  else
    player.each_with_index do |hand, index|
      if current_hand == index && player.size > 1
        puts "--> [ #{hand.join(' | ')} ]".center(40) + value(hand).to_s
      else
        puts "[ #{hand.join(' | ')} ]".center(40) + value(hand).to_s
      end
    end
  end
  puts '                PLAYER                '
  puts
  sleep(pause)
end

def valid_money?(number_string, chips = [number_string.to_i + 1])
  valid = true
  valid = false if number_string.to_i < 0
  valid = false if number_string.to_i.to_s != number_string
  valid = false if number_string.to_i > chips[0]
  valid
end

def get_chips!(standing, chips)
  amount = ''
  loop do
    prompt 'How much money would you like to convert to chips?'
    prompt 'Enter the amount as an integer without a dollar sign. Example: 100'
    amount = gets.chomp
    break if valid_money?(amount)
    prompt "That's not a valid amount."
  end
  standing[0] -= amount.to_i
  chips[0] += amount.to_i
end

def change_bet_amount(chips)
  amount = ''
  loop do
    prompt 'How much would you like to bet?'
    amount = gets.chomp
    break if valid_money?(amount, chips)
    prompt "That's not a valid amount."
    prompt 'You must bet a whole dollar amount, and it must exceed the amount'
    prompt 'of chips you have. Enter the amount as an integer without symbols.'
  end
  amount.to_i
end

def shuffle_deck(deck)
  deck * NUMBER_DECKS
end

def main_menu
  choice = ''
  loop do
    prompt 'What would you like to do? Enter D, G, C, B, or W.'
    prompt '[D]eal, [G]et chips, [C]olor up, Change [B]et, [W]alk away'
    choice = gets.chomp[0].downcase
    break if ['d', 'g', 'c', 'b', 'w'].include?(choice)
    prompt "That's not a valid choice."
  end
  choice
end

def color_up!(standing, chips)
  amount = ''
  loop do
    prompt 'How many chips would you like to exchange for money?'
    prompt 'Enter the amount as an integer without a dollar sign. Example: 100'
    amount = gets.chomp
    break if valid_money?(amount, chips)
    prompt "That's not a valid amount."
  end
  standing[0] += amount.to_i
  chips[0] -= amount.to_i
end

def deal(dealer, player, deck)
  2.times { dealer << deck.delete_at(rand(deck.size)) }
  2.times { player[0] << deck.delete_at(rand(deck.size)) }
end

def took_even_money?
  prompt 'You have Blackjack, but Dealer may also.'
  prompt 'Would you like to take even money?'
  answer = ''
  loop do
    prompt 'Enter y or n.'
    answer = gets.chomp[0].downcase
    break if answer == 'y' || answer == 'n'
    prompt 'Invalid input. Would you like to take even money?'
  end
  if answer == 'y'
    return true
  else
    return false
  end
end

def offer_insurance(chips, bet, standing, dealer_hand, player_hand)
  # Must return amount player bet on insurance
  prompt 'Dealer shows Ace. Would you like to take insurance for half your bet?'
  prompt 'You may also get [c]hips.'
  answer = ''
  loop do
    prompt 'Enter y, n, or c for insurance or chips.'
    answer = gets.chomp[0].downcase
    if answer == 'c'
      get_chips!(standing, chips)
      display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, [])
      next
    end
    break if answer == 'y' || answer == 'n'
    prompt 'Invalid input. Would you like insurance?'
  end
  if answer == 'y'
    return (bet[0] / 2)
  else
    return 0
  end
end

def value(hand)
  sum = 0
  aces_present = 0
  hand.each do |card|
    sum += VALUES[card[0]] if VALUES.key?(card[0])
    aces_present += 1 if card[0] == 'A'
  end
  while sum > 21 && aces_present > 0
    sum -= 10
    aces_present -= 1
  end
  sum
end

def dealer_draws(dealer_hand, current_deck)
  while value(dealer_hand) < 17
    dealer_hand << current_deck.delete_at(rand(current_deck.size))
  end
end

def double_down(hand_index, deck, standing, chips, bet, dealer_hand,
                player_hand)
  amount = 0
  loop do
    prompt 'How much would you like to bet on your double down?'
    prompt 'You may also get [c]hips.'
    amount = gets.chomp
    if amount[0].downcase == 'c'
      get_chips!(standing, chips)
      display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, [])
      next
    end
    break if valid_money?(amount, chips) &&
             amount.to_i <= bet[hand_index]
    prompt 'Invalid input. Enter the amount without symbols.'
    prompt 'Must be no greater than initial bet.'
  end
  local_dd = []
  local_dd[hand_index] = amount.to_i
  player_hand[hand_index] << deck.delete_at(rand(deck.size))
  display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 5,
          local_dd)
  amount.to_i
end

def player_chooses(array_of_choices)
  choice_to_word = { 'h' => '[h]it', 's' => '[s]tand', 'd' => '[d]ouble down',
                     'p' => 's[p]lit', 'u' => 's[u]rrender' }
  message = []
  choice_to_word.each do |choice, word|
    message << word if array_of_choices.include?(choice)
  end
  decision = ''
  loop do
    prompt 'Choose one: ' + message.join(', ')
    decision = gets.chomp[0].downcase
    break if array_of_choices.include?(decision)
    prompt 'Invalid input'
  end
  decision
end

def hit!(hand_index, deck, standing, chips, bet, dealer_hand, player_hand, dd)
  player_hand[hand_index] << deck.delete_at(rand(deck.size))
  display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, dd)
  choice = ''
  if value(player_hand[hand_index]) < 21
    choice = player_chooses(['h', 's'])
  end
  if choice == 'h'
    hit!(hand_index, deck, standing, chips, bet, dealer_hand, player_hand, dd)
  end
end

def evaluate_hand(hand_index, deck, standing, chips, bet, dealer_hand,
                  player_hand, dd)
  while value(dealer_hand) < 17
    display(standing, chips, bet, dealer_hand, player_hand, 2, dd)
    dealer_hand << deck.delete_at(rand(deck.size))
    sleep(2)
  end
  display(standing, chips, bet, dealer_hand, player_hand, 2, dd, hand_index)
  if value(player_hand[hand_index]) > 21
    prompt 'You bust!'
    sleep(2)
    chips[0] -= (bet[hand_index] + dd[hand_index])
  end
  if value(dealer_hand) > 21 && value(player_hand[hand_index]) <= 21
    prompt 'Dealer bust!'
    sleep(2)
    chips[0] += (bet[hand_index] + dd[hand_index])
  end
  if value(player_hand[hand_index]) <= 21 && value(dealer_hand) <= 21
    if value(player_hand[hand_index]) > value(dealer_hand)
      prompt 'You won!'
      sleep(2)
      chips[0] += (bet[hand_index] + dd[hand_index])
    elsif value(player_hand[hand_index]) < value(dealer_hand)
      prompt 'Dealer won.'
      sleep(2)
      chips[0] -= (bet[hand_index] + dd[hand_index])
    else
      prompt 'Push.'
      sleep(2)
    end
  end
end

def split(hand_index, deck, standing, chips, bet, dealer_hand, player_hand, dd,
          hands_already_done = [])
  amount = ''
  loop do
    prompt 'How much would you like to bet on the new hand?'
    prompt 'You may also get [c]hips.'
    amount = gets.chomp
    if amount[0].downcase == 'c'
      get_chips!(standing, chips)
      display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, dd)
      next
    end
    break if valid_money?(amount, chips) && amount.to_i <= bet[hand_index]
    prompt 'Invalid input. Enter the amount without symbols.'
    prompt 'Must be no greater than initial bet.'
  end
  bet << amount.to_i
  dd << 0
  player_hand[player_hand.size] = [player_hand[hand_index].pop]
  display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, dd)
  player_hand[hand_index] << deck.delete_at(rand(deck.size))
  display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, dd)
  player_hand[player_hand.size - 1] << deck.delete_at(rand(deck.size))
  display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, dd)
  unless player_hand[hand_index][0][0] == 'A' # Cannot hit split aces
    hand_to_split = nil
    player_choice = ''
    player_hand.each_with_index do |hand, index|
      next if hands_already_done[index]
      prompt "For Hand #{index + 1}: "
      if hand[0][0] == hand[1][0] && player_hand.size < 4 # Player can split
        player_choice = player_chooses(['h', 's', 'd', 'p'])
      else
        player_choice = player_chooses(['h', 's', 'd'])
      end
      case player_choice
      when 'h'
        hit!(index, deck, standing, chips, bet, dealer_hand, player_hand, dd)
      when 'd'
        dd[index] = double_down(index, deck, standing, chips, bet, dealer_hand,
                                player_hand)
      when 'p'
        hand_to_split = index
        break
      end
      hands_already_done[index] = true
    end
    if player_choice == 'p'
      split(hand_to_split, deck, standing, chips, bet, dealer_hand, player_hand,
            dd, hands_already_done)
    end
  end
end

def play_a_hand(standing, chips, bet, deck)
  dealer_hand = []
  player_hand = [[]]
  dd = [0]
  deal(dealer_hand, player_hand, deck)
  display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, dd)
  if value(player_hand[0]) == 21 # Player has BJ
    if VALUES[dealer_hand[0][0]] > 9 # Dealer may also have BJ
      if took_even_money?
        chips[0] += bet[0]
        display(standing, chips, bet, dealer_hand, player_hand, 2, dd)
      else
        display(standing, chips, bet, dealer_hand, player_hand, 2, dd)
        if value(dealer_hand) == 21
          prompt 'Push!'
          sleep(2)
        else
          prompt 'Blackjack!'
          sleep(2)
          chips[0] += (bet[0] * 3) / 2
        end
      end
      return (dealer_hand.size + player_hand.flatten.size)
    else
      prompt 'Blackjack!'
      sleep(2)
      chips[0] += (bet[0] * 3) / 2
      display(standing, chips, bet, dealer_hand, player_hand, 2, dd)
      return dealer_hand.size + player_hand.flatten.size
    end
  else # No player BJ
    insurance_bet = 0
    if dealer_hand[0][0] == 'A'
      insurance_bet = offer_insurance(chips, bet, standing, dealer_hand,
                                      player_hand)
      chips[0] -= insurance_bet
      display(standing, chips, bet, [dealer_hand[0], '[]'], player_hand, 2, dd)
    end
    if value(dealer_hand) == 21
      display(standing, chips, bet, dealer_hand, player_hand, 2, dd)
      prompt 'Dealer had Blackjack.'
      sleep(2)
      chips[0] += insurance_bet # Winning insurance results in no gain/loss
      return (dealer_hand.size + player_hand.flatten.size)
    else # No dealer BJ
      if VALUES[dealer_hand[0][0]] > 9
        prompt 'Dealer does not have Blackjack.'
      end
      if player_hand[0][0][0] == player_hand[0][1][0] # Player may split
        player_choice = player_chooses(['h', 's', 'd', 'p', 'u'])
      else
        player_choice = player_chooses(['h', 's', 'd', 'u'])
      end
      case player_choice
      when 'h'
        hit!(0, deck, standing, chips, bet, dealer_hand, player_hand, dd)
        evaluate_hand(0, deck, standing, chips, bet, dealer_hand, player_hand,
                      dd)
        return (dealer_hand.size + player_hand.flatten.size)
      when 's'
        evaluate_hand(0, deck, standing, chips, bet, dealer_hand, player_hand,
                      dd)
        return (dealer_hand.size + player_hand.flatten.size)
      when 'd'
        dd[0] = double_down(0, deck, standing, chips, bet, dealer_hand,
                            player_hand)
        evaluate_hand(0, deck, standing, chips, bet, dealer_hand, player_hand,
                      dd)
        return (dealer_hand.size + player_hand.flatten.size)
      when 'u'
        chips[0] -= (bet[0] / 2)
        display(standing, chips, bet, dealer_hand, player_hand, 2, dd)
        return (dealer_hand.size + player_hand.flatten.size)
      when 'p'
        split(0, deck, standing, chips, bet, dealer_hand, player_hand, dd)
        player_hand.each_index do |index|
          evaluate_hand(index, deck, standing, chips, bet, dealer_hand,
                        player_hand, dd)
        end
        return (dealer_hand.size + player_hand.flatten.size)
      end
    end
  end
end

prompt 'Welcome to Blackjack!'
player_standing = [0]
player_chips = [0]
get_chips!(player_standing, player_chips)
bet_amount = []
bet_amount[0] = change_bet_amount(player_chips)

main_menu_choice = ''
while main_menu_choice != 'w'
  big_deck = shuffle_deck(deck)
  divider_position =
    (((NUMBER_DECKS * 52) / 3)..(((NUMBER_DECKS * 52) * 2) / 3)).to_a.sample
  number_discarded = 0
  loop do
    bet_amount = [[bet_amount[0], player_chips[0]].min]
    display(player_standing, player_chips, bet_amount, [], [[]], 2, [])
    if player_chips[0] == 0
      loop do
        prompt 'You are out of chips.'
        prompt 'Would you like to [g]et chips or [w]alk away?'
        main_menu_choice = gets.chomp[0].downcase
        break if main_menu_choice == 'g' || main_menu_choice == 'w'
        prompt 'Invalid input.'
      end
      case main_menu_choice
      when 'g'
        get_chips!(player_standing, player_chips)
        bet_amount[0] = change_bet_amount(player_chips)
        next
      when 'w'
        break
      end
    end
    main_menu_choice = main_menu
    case main_menu_choice
    when 'g' then get_chips!(player_standing, player_chips)
    when 'c' then color_up!(player_standing, player_chips)
    when 'b' then bet_amount[0] = change_bet_amount(player_chips)
    when 'w' then break
    when 'd' then number_discarded += play_a_hand(player_standing, player_chips,
                                                  bet_amount, big_deck)
    end
    sleep(1)
    if number_discarded >= divider_position
      prompt 'Yellow card up. Shuffling deck...'
      sleep(3)
      break
    end
  end
end

player_standing[0] += player_chips[0]
if player_standing[0] > 0
  puts "Congratulations! You won #{player_standing[0]} dollars!"
elsif player_standing[0] < 0
  puts "Bad luck! You lost #{-player_standing[0]} dollars."
else
  puts "You're walking out with the same amount of money you walked in with."
end
puts 'See you next time! Goodbye!'
