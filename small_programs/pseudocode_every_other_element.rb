#a method that takes an array of integers, and returns a new array with every other element

#informal:
#define a method that takes one argument, an array of integers - call it "original"
#create an empty array to store the result - call it "result"
#start an iterating counter at 0, ending at the length of original minus 1
#if counter is even, push the "original" element at counter's index to "result"
#once iteration is complete, return "result"

#formal:

START

given an array of integers called "original"

SET counter = 0
SET result = []

WHILE counter < (length of original - 1)
  IF counter is even
    push original[counter] to "result"

PRINT result

END
