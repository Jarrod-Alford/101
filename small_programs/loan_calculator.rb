def invalid_number?(input)
  digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
  all_digits = true
  input.each_char { |char| all_digits = false unless digits.include?(char) }
  if all_digits && input.to_i > 0
    return false
  else
    return true
  end
end

def invalid_apr?(input)
  digits_plus = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '.']
  all_digits_plus = true
  input.each_char { |char| all_digits_plus = false unless digits_plus.include?(char) }
  if all_digits_plus && input.to_f > 0.0
    return false
  else
    return true
  end
end

# Prompt method
def prompt(message)
  puts '=> ' + message
end

# Introduction
prompt 'Welcome to Loan Calculator.'
loop do
  prompt 'To begin, we will need three inputs:'

  # Get loan amount and check for proper input
  prompt '1. The loan amount (how much money are you borrowing), '
  prompt '   rounded to the nearest dollar, without a dollar sign.'
  loan_amount = gets.chomp
  while invalid_number?(loan_amount)
    prompt 'That input is invalid. Please express the loan amount as a '
    prompt '   whole number, without any special characters.'
    loan_amount = gets.chomp
  end

  # Get APR and check for proper input
  prompt '2. The Annual Percentage Rate (APR) of the loan, '
  prompt '   expressed as a decimal (2.5 for 2.5%).'
  apr = gets.chomp
  while invalid_apr?(apr)
    prompt 'That input is invalid. Please express the APR as a decimal number.'
    apr = gets.chomp
  end

  # Get duration and check for proper input
  prompt '3. The duration of the loan, in years '
  prompt '   (how long you expect it to take to pay off the loan).'
  duration = gets.chomp
  while invalid_number?(duration)
    prompt 'That input is invalid. Please express the loan duration in years '
    prompt '   as a whole number, without any special characters.'
    duration = gets.chomp
  end

  # Calculations
  n = duration.to_i * 12
  j = (apr.to_f / 100) / 12
  p = loan_amount.to_i
  m = p * (j / (1 - (1 + j)**(-n)))

  prompt 'Based on your inputs, your monthly loan payment will be: '
  prompt "$#{m.round(2)}."
  prompt 'Would you like to calculate for another loan? y/n'
  again = gets.chomp
  break unless again.downcase.start_with?('y')
end
prompt 'Thank you for using the Loan Calculator. Goodbye!'
