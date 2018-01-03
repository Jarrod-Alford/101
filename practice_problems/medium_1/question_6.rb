#Using << in both instances will work more consistently since << modifies the
#caller, while += does not, for both strings and arrays.
#Since methods should only perform one task (modifying a variable or returning
#a variable), changing the += to << will keep us from having to change the
#method to do two things.

def tricky_method(a_string_param, an_array_param)
  a_string_param << " rutabaga"
  an_array_param << "rutabaga"
end

my_string = "pumpkins"
my_array = ["pumpkins"]
tricky_method(my_string, my_array)

puts "My string looks like this now: #{my_string}"
puts "My array looks like this now: #{my_array}"
