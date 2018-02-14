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

def value(hand)
  sum = 0
  aces_present = 0
  hand.each do |card|
    sum += VALUES[card[0]] if VALUES.has_key?(card[0])
    puts "sum: #{sum}"
    aces_present += 1 if card[0] == 'A'
  end
  while sum > 21 && aces_present > 0
    sum -= 10
    puts "sum: #{sum}"
    aces_present -= 1
  end
  return sum
end

puts
puts "#{value(['2H', '3H', 'AH', '7H', 'TH'])}" #23
puts
puts
puts "#{value(['2H', '3H', 'AH', '7H'])}" #13
puts
puts
puts "#{value(['9H', 'AH', 'AH', 'AH'])}" #12
