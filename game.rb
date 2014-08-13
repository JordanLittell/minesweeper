require_relative 'board.rb'
require 'digest/sha1'
require 'yaml'
require 'debugger'



class Game 
  attr_accessor :board
  
  def initialize
    @board = Board.new
  end
  
  def save_game
    puts "Save game as..?"
    saved_game = gets.chomp.to_s.downcase
    p Time.now
    Dir.mkdir 'games' unless File.exists?('games')
    name = Digest::SHA1.hexdigest(Time.now.to_s)
    file = File.open("games/#{name}-#{saved_game}","w")
    
    game_save = self.to_yaml
    p game_save
    file.write(game_save)
  end

  def self.load_game
    game_names = Dir.open 'games'
    game_names.each {|i| puts i}
    puts "Enter name of your saved game"
    name = gets.chomp.to_s.downcase
    last_save = game_names.select { |g_name|  g_name.scan(name)[0] == name }
    last_save = last_save.first 
    
    load_game = File.read("games/#{last_save}")
    game = YAML::load(load_game)
    game.run
  end

  def run
    game_over = false
    until game_over
      puts "Enter tile coordinates(e.g. x,y)  (enter s to save)"
      response = gets.chomp
      save_game if response[0] == "s"
      load_game if response[0] == "l"
      position = response.split(' ').map!(&:to_i)
      # game_over = true if board.position.bombed?
      #update the board
      board.render
      puts "Flag or Reveal? F/R"
      choice = gets.chomp.upcase
      
      if losing_move?(position, choice)
        print "YOU LOSE!"
        return game_over = true
      end
      
      board.update_board_state(position, choice)
      board.render
    end
  end
  
  def losing_move?(position, choice)
    if choice == "R"
      if board.board_state[position[0]][position[1]].bombed
        return true
      end
    end
  end

end