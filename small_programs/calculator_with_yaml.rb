require 'yaml'
MESSAGES = YAML.load_file('calculator_messages.yml')

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

prompt(MESSAGES['welcome'])

name = ''
loop do
  name = gets.chomp

  if name.empty?
    prompt(MESSAGES['valid_name'])
  else
    break
  end
end

prompt(MESSAGES['greeting'] + "#{name}!")

loop do # main loop
  number1 = ''
  loop do
    prompt(MESSAGES['first_number'])
    number1 = gets.chomp

    if number?(number1)
      break
    else
      prompt(MESSAGES['bad_number'])
    end
  end

  number2 = ''
  loop do
    prompt(MESSAGES['second_number'])
    number2 = gets.chomp

    if number?(number2)
      break
    else
      prompt(MESSAGES['bad_number'])
    end
  end

  prompt(MESSAGES['operator_prompt'])

  operator = ''
  loop do
    operator = gets.chomp

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(MESSAGES['bad_operator'])
    end
  end

  prompt("#{operation_to_message(operator)}" + MESSAGES['calculating'])

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

  prompt(MESSAGES['result'] + "#{result}.")

  prompt(MESSAGES['again'])
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
