def factors(number)
  dividend = number
  divisors = []
  while dividend > 0
    divisors << number / dividend if number % dividend == 0
    dividend -= 1
  end
  divisors
end

p factors(15)
p factors(60)
p factors(19)

#Bonus 1: Line 5 will only append the result of (number / dividend) into
#the divisors array if it has no remainder, i.e., dividend is actually a whole
#divisor of number.

#Bonis 2: Line 8 denotes what the method returns, since it is the last line
#called by the method. This will return the array containing all the whole
#divisors, which is the purpose of the method.
