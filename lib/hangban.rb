require 'colorize'
require 'yaml'
class Game
  attr_accessor :word, :guess_demonstrate, :attempts, :guesses

  def initialize
    @word = nil
    @guess_demonstrate = nil
    @attempts = nil
    @guesses = nil
  end

  def start 
    puts 'Welcome to Hangman game!'
    puts 'Would you like to start new game? (Press 1)'
    puts 'Would you like to load save game? (Press 2)'
    input = gets.chomp
    while input != '1' && input != '2'
      puts 'Invalid input!'
      input = gets.chomp
    end
    input == '1' ? self.initialize_word : self.load_game
  end

  def get_guess
    puts 'Type your guess!'
    input = gets.chomp
   input == 'save' ? input : (until input.match?(/[a-z]/) && input.length == 1
     puts 'Input should be one-character and alphabetical!'
      input = gets.chomp
    end)
    
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
    while word.length < 5 && word.length > 12
      random_index = rand(lines.length)
      word = lines[random_index].chomp
    end
    word
  end

  def initialize_word
    @attempts = 10
    @word = randomizer
    @guess_demonstrate = String.new('_')*@word.length
    @guesses = ''
    puts @word
    play
  end

  def play
    puts "Incorrect guess remains: #{@attempts}"
    puts "Your guesses: #{@guesses}"
    puts "Your progress: #{@guess_demonstrate}"
    
    while @attempts != 0 do
      input = get_guess
      if input == 'save'
        self.save_game
        break
      else
        input
      end
      puts "input is #{input}"
      word.split('').each_with_index do |char,index|
      if input == char
          word[index] = '+'
          @guess_demonstrate[index] = input
          !@guesses.include?(input) ? @guesses << input.green : nil
          break
        elsif input != char && char != word[-1]
          next
        elsif word[index] == word[-1] && !word.include?(input) 
          !@guesses.include?(input) ? @guesses << input.red : nil
          @attempts-=1
          break
      end
    end
    puts "Incorrect guess remains: #{@attempts}"
    puts "Your guesses: #{@guesses}"
    puts "Your progress: #{@guess_demonstrate}"
    if check_win(@word)
      puts 'You win!'
      break
    end
  end
  if check_loose(@word)
    puts 'You lost!'
end
  game_restart
end

  def check_win(word)
    word.split('').all?{|el| el == '+'} 
  end

  def check_loose(word)
    !word.split('').all?{|el| el == '+'} && word != 'save'
  end

  def game_restart
    puts 'Would you like to restart the game? Press 1 if or press any other character otherwise'
    input = gets.chomp
    input == '1' ? start : 'Thanks for playing!'
  end

  def save_game
    puts 'Please, enter a name for the save game'
    input = gets.chomp
    serialize = Marshal.dump(self)
    game_file = File.new("../saved_games/#{input}", 'w')
    game_file = File.open("../saved_games/#{input}", 'w')
    game_file.write(serialize)
    puts 'Game saved!'
    game_restart
end

  def load_game
    show_files = Dir.children("../saved_games").each{|file| puts file}
    puts 'Select one of the listed saves'
    input = gets.chomp
    until show_files.include?(input)
      puts "This save game doesn't exist!"
      input = gets.chomp
    end
   game_file = File.open("../saved_games/#{input}")
   deserialized = Marshal.load(game_file)
    @word = deserialized.word
    @guess_demonstrate = deserialized.guess_demonstrate
    @attempts = deserialized.attempts
    @guesses = deserialized.guesses
    play

  end
end

game = Game.new()

game.start


