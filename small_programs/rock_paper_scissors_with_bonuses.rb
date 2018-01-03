VALID_CHOICES = %w(rock paper scissors lizard Spock)

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  what_beats_what = { 'rock' => %w(scissors lizard),
                      'paper' => %w(rock Spock),
                      'scissors' => %w(paper lizard),
                      'lizard' => %w(paper Spock),
                      'Spock' => %w(rock scissors) }
  what_beats_what[first].include?(second)
end

def display_result(player, computer)
  if win?(player, computer)
    prompt('You won!')
  elsif win?(computer, player)
    prompt('Computer won!')
  else
    prompt("It's a tie!")
  end
end

def update_score(player, computer, old_score)
  if win?(player, computer)
    old_score[0] += 1
  elsif win?(computer, player)
    old_score[1] += 1
  end
end

def display_score(new_score)
  prompt("The score is: Player #{new_score[0]}, Computer #{new_score[1]}")
end

prompt('Welcome to rock, paper, scissors, lizard, Spock!')
prompt('First to 5 wins!')

valid_choices_abbreviated = %w(r p s l S)

score = [0, 0]

loop do
  choice = ''
  choice_abbreviated = ''
  loop do
    prompt("Choose one: #{valid_choices_abbreviated.join(', ')}")
    choice_abbreviated = gets.chomp
    VALID_CHOICES.each do |full_word|
      choice = full_word if full_word.start_with?(choice_abbreviated)
    end

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not a valid choice.")
    end
  end

  computer_choice = VALID_CHOICES.sample

  prompt("You chose: #{choice}; Computer chose: #{computer_choice}")

  display_result(choice, computer_choice)
  update_score(choice, computer_choice, score)
  display_score(score)

  if score[0] == 5
    prompt("You're the champion!")
    break
  elsif score[1] == 5
    prompt("Better luck next time!")
    break
  end
end

prompt('Thank you for playing! Goodbye!')
