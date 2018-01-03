def color_valid(color)
  ["blue", "green"].include?(color)
end

puts color_valid("green")
puts color_valid("blue")
puts color_valid("silver")
