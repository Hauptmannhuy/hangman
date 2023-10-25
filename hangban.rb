class Game
  attr_reader :word

def self.start
  puts 'Welcome to Hangman game!'
  puts 'Would you like to start new game? (Press 1)'
  puts 'Would you like to load save game? (Press 2)'
  new_game = Game.new
  input = gets.chomp
  while input != '1' && input != '2' do
    puts "Invalid input!"
    input = gets.chomp
  end
  if input == '1'
    new_game.initialize_word
  end
end

def get_input
  puts 'Type your guess!'
  input = gets.chomp
  while !input.each_char.all?{|char| ('a'..'z').include?(char)} || input.length != 1
   if input.length != 1
   puts 'Input should be only one character!'
   else 
    puts 'Input should be only alphabetical!'
  end
  input = gets.chomp
end
input
end


def randomizer
  words = File.open('vocabulary.txt')
  lines = words.readlines
  word = ''
  
  if lines.length > 0
    random_index = rand(lines.length)
    word = lines[random_index].chomp
  end
  while word.length != 5 do
    random_index = rand(lines.length)
    word = lines[random_index].chomp
  end
  word
end

def initialize_word
 @word = randomizer
 play
end

def play
  input = get_input
  guess_demonstrate = '_____'
  p "input is #{input}"
  
end

end

Game.start

