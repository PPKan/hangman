# frozen_string_literal: true

# Main game logic here
class Game
  attr_reader :answer, :win, :lose

  def initialize
    @answer = get_word(load_dict)
    @gamepad = Array.new(@answer.length) { ' ' }
    @missed_letter = []
    @win = false
    @lose = false
    @life = 6
  end

  def play
    input_char = input
    this_round_pass = false

    @answer.each_char.with_index do |answer_char, index|
      if answer_char == input_char
        @gamepad[index] = input_char
        this_round_pass = true
      end
    end

    if this_round_pass == false
      @life -= 1
      @missed_letter << input_char
    end

    @win = true if @gamepad.include?(' ') == false
    @lose = true if @life.zero?
  end

  def display
    # puts "The answer: #{@answer}."
    puts "Your current input: #{@gamepad}"
    puts "Misses: #{@missed_letter.sort}"
    puts "Your remain life #{@life}"
    puts '##############################'
  end

  private

#   def save_file
#     File.open('save.dump', 'w') { |f| f.write(YAML.dump(m)) }
#   end

  def input
    input_char = ''
    loop do
      puts 'Guess a single character.'
      input_char = gets.chomp.downcase

    #   if input_char == 'save'
    #     save_file
    #   end

      if (input_char.length == 1) &&
         !@missed_letter.include?(input_char)
        break
      end
    end
    input_char
  end

  def load_dict
    text_array = []
    dict = File.open('../5desk.txt')
    dict.each do |line|
      text_array << line.chomp.downcase if line.chomp.length.between?(5, 12)
    end
    text_array
  end

  def get_word(dict)
    dict.sample
  end
end

game = Game.new

loop do
  game.play
  game.display

  if game.win
    puts 'Yon won the game!'
    break
  end

  next unless game.lose

  puts 'You lose the game!'
  puts "The answer is #{game.answer}."
  break
end
