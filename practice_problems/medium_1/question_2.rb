#This produces an error because the + method is not defined for a string and an
#integer.

puts "the value of 40 + 2 is " + (40 + 2).to_s

puts "the value of 40 + 2 is #{(40 + 2)}"
