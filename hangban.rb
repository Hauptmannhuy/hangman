
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

def initialize_word
 @word = randomizer
 puts @word
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


end

Game.start

