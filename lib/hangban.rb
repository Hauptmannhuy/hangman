require 'colorize'
class Game
  attr_accessor :word, :guess_demonstrate, :attempts, :guesses

  def initialize
    @word = nil
    @guess_demonstrate = nil
    @attempts = nil
    @guesses = nil
    @original_word = nil
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
    input == '1' ? initialize_word : load_game
  end

  def get_guess
    puts 'Type your guess!'
    input = gets.chomp
    if input == 'save'
      input
    else
      (until input.match?(/[a-z]/) && input.length == 1 && !@guesses.include?(input)
         puts 'Input should be one-character and alphabetical neither contain already guessed characters!'
         input = gets.chomp
       end)
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
    while word.length < 5 && word.length > 12
      random_index = rand(lines.length)
      word = lines[random_index].chomp
    end
    word
  end

  def initialize_word
    @attempts = 10
    @word = randomizer
    @guess_demonstrate = String.new('_') * @word.length
    @guesses = ''
    play
  end

  def play
    puts "Incorrect guess remains: #{@attempts}"
    puts "Your guesses: #{@guesses}"
    puts "Your progress: #{@guess_demonstrate}"
    puts @word
    while @attempts != 0
      is_guessed = false
      input = get_guess
      if input == 'save'
        save_game
        break
      else
        input
      end
      puts "input is #{input}"
      word.split('').each_with_index do |char, index|
        if input == char
          is_guessed = true
          @guess_demonstrate[index] = input
          !@guesses.include?(input) ? @guesses << input.green : nil
        elsif input != char && char != word[-1]
          next
        elsif word[index] == word[-1] && !word.include?(input) && is_guessed == false
          !@guesses.include?(input) ? @guesses << input.red : nil
          @attempts -= 1
          break
        end
      end
      puts "Incorrect guess remains: #{@attempts}"
      puts "Your guesses: #{@guesses}"
      puts "Your progress: #{@guess_demonstrate}"
      if check_win(@guess_demonstrate)
        puts 'You win!'
        break
      end
    end
   check_loose(@guess_demonstrate)
    game_restart
  end

  def check_win(word)
    word.split('').all? { |el| el != '_' }
  end

  def check_loose(word)
   if word.split('').any? { |el| el == '_' } && word != 'save'
    puts 'You lost!'
    puts "The word was #{@word}"
   end
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
    game_file.close
    puts 'Game saved!'
    game_restart
  end

  def load_game
    show_files = Dir.children('../saved_games').each { |file| puts file }
    puts 'Select one of the listed saves'
    input = gets.chomp
    until show_files.include?(input)
      puts "This save game doesn't exist!"
      input = gets.chomp
    end
    game_file = File.open("../saved_games/#{input}")
    deserialized = Marshal.load(game_file)
    game_file.close
    @word = deserialized.word
    @guess_demonstrate = deserialized.guess_demonstrate
    @attempts = deserialized.attempts
    @guesses = deserialized.guesses
    play
  end
end

game = Game.new

game.start
