class Game
  attr_reader :word

  def self.start
    puts 'Welcome to Hangman game!'
    puts 'Would you like to start new game? (Press 1)'
    puts 'Would you like to load save game? (Press 2)'
    new_game = Game.new
    input = gets.chomp
    while input != '1' && input != '2'
      puts 'Invalid input!'
      input = gets.chomp
    end
    return unless input == '1'

    new_game.initialize_word
  end

  def get_input
    puts 'Type your guess!'
    input = gets.chomp
    while !input.each_char.all? { |char| ('a'..'z').include?(char) } || input.length != 1
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
    while word.length < 5 && word.length > 12
      random_index = rand(lines.length)
      word = lines[random_index].chomp
    end
    word
  end

  def initialize_word
    @word = randomizer
    puts @word
    play
  end

  def play
    attempts = 10
    guess_demonstrate = String.new('_')*word.length
    incorrect_guesses = ''
    word = @word
    while attempts != 0 do
      input = get_input
      puts "input is #{input}"
      word.split('').each_with_index do |char,index|
        if input == char
          word[index] = '+'
          guess_demonstrate[index] = input
          break
        elsif input != char && char != word[-1]
          next
        elsif word[index] == word[-1] && !word.include?(input) 
          !incorrect_guesses.include?(input) ? incorrect_guesses << input : nil
          attempts-=1
          break
      end
    end
    puts "Inccorect attempts remaining #{attempts}"
    puts "Incorrect guesses: #{incorrect_guesses}"
    puts "#{word}"
    puts "#{guess_demonstrate}"
  end
end


end

Game.start
