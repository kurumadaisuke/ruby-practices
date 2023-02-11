def fizzbuzz(number)
  if number % 15 == 0 
    puts "FizzBuzz"
  elsif number % 5 == 0
    puts "Fizz"
  elsif number % 3 == 0
    puts "Buzz"
  else
    puts number
  end
end

numbers = (1..20)
numbers.each do |x|
  fizzbuzz(x)
end
