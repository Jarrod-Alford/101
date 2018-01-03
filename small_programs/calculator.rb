def prompt(message)
  puts "=> #{message}"
end

def number?(num)
  # A valid number contains only digits and, at most, one period. Supports only decimal number entries.
  return false if num == '.' # Deals with the edge case of the operator entering only a period
  digits_plus = ['0','1','2','3','4','5','6','7','8','9','.'] # List out all valid characters
  all_digits = true
  number_of_periods = 0
  num.each_char do |char|
    all_digits = false unless digits_plus.include?(char) # Flags if any character is not valid
    number_of_periods += 1 if char == '.' # Ensure no more than one period is included
  end
  return true if all_digits && number_of_periods <= 1
  return false # This line only runs if the previous line's conditional was not true
end

def operation_to_message(op)
  message = case op
              when '1'
                'Adding'
              when '2'
                'Subtracting'
              when '3'
                'Multiplying'
              when '4'
                'Dividing'
              end
  message
end

prompt("Welcome to Calculator! Enter your name:")

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt("Make sure to use a valid name.")
  else
    break
  end
end

prompt("Hi #{name}!")

loop do # main loop
  number1 = ''
  loop do
    prompt("What's the first number?")
    number1 = gets.chomp

    if number?(number1)
      break
    else
      prompt("Hmm... that doesn't look like a valid number")
    end
  end

  number2 = ''
  loop do
    prompt("What's the second number?")
    number2 = gets.chomp

    if number?(number2)
      break
    else
      prompt("Hmm... that doesn't look like a valid number")
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG

  prompt(operator_prompt)

  operator = ''
  loop do
    operator = gets.chomp

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt("Must choose 1, 2, 3, or 4")
    end
  end

  prompt("#{operation_to_message(operator)} the two numbers...")

  result = case operator
           when '1'
             number1.to_f + number2.to_f
           when '2'
             number1.to_f - number2.to_f
           when '3'
             number1.to_f * number2.to_f
           when '4'
             number1.to_f / number2.to_f
           end

  prompt("The result is #{result}")

  prompt("Do you want to perform another calculation? (Y to calculate again)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
