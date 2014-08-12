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
      position = response.split(',').map!(&:to_i)
      game_over = true if board.is_bombed?
      #update the board
      board.render
      puts "Flag or Reveal? F/R"
      choice = gets.chomp.upcase
      
      if losing_move?(position, choice)
        print "YOU LOSE!"
        return game_over = true
      end
      
      board.update_board_state(position, choice)
      #update the board
      board.render
    end
  end
  
  def losing_move?(position, choice)
    if choice == "R"
      if board.board_state[position[0]][position[1]].bombed?
        return true
      end
    end
  end
end



class Board
  attr_reader :board_state, :bomb_locations
  def initialize
    @board_state = generate_board
    @bomb_locations = generate_bombs
    set_bomb_count
  end
  
  def generate_board
    board = Array.new(9) { Array.new(9) }
    
    # give tile its pos, and pass board in
    board.each do |array|
      array.map! { |square| square = Tile.new }
    end
  end
  
  # def set_bomb_count
  #   9.times do |i|
  #     9.times do |j|
  #       bomb_count = 0
  #       current_tile = @board_state[i][j]
  #       neighbors = current_tile.neighbors([i,j])
  #       neighbors.each do |neighbor|
  #         neighbor_tile = @board_state[neighbor[0]][neighbor[1]]
  #         bomb_count += 1 if neighbor_tile.bombed?
  #       end
  #       unless current_tile.bombed? || bomb_count == 0
  #         current_tile.neighbor_bomb_count = bomb_count
  #       end
  #     end
  #   end
  # end
  
  def generate_bombs
    bomb_locations = []
    10.times do 
      bomb = [(0..8).to_a.sample,(0..8).to_a.sample]
      bomb_locations << bomb unless bomb_locations.include?(bomb)
    end
    
    bomb_locations.each do |coord|
      # @board_state[coord[0]][coord[1]]
      @board_state[coord[0]][coord[1]].bombed = true
    end
    
    bomb_locations
  end
  
  def render
    # system 'clear'
    picture = Array.new(9){Array.new}  
    @board_state.each_with_index do |array,index|
      picture[index] << array.map { |tile| tile.reveal }
    end
    picture.each do |array|
      print array.join(" ")
      puts
    end
  end
  
  
  # def process_reveal(position)
#     root = @board_state[position[0]][position[1]]
#     @visited_tiles = [root]
#     queue = [root]
#     until queue.empty?
#       current_tile = queue.shift
#       neighbors = current_tile.neighbors(position)
#       neighbors.each do |neighbor|
#         neighbor_tile = @board_state[neighbor[0]][neighbor[1]]
#         neighbor_tile.revealed = true unless neighbor_tile.bombed?
#         queue << neighbor_tile unless @visited_tiles.include?(neighbor_tile)
#         @visited_tiles << neighbor_tile
#       end
#     end
#   end

  def process_flagged(position)
    @board_state[position[0]][position[1]].flagged = true
  end

  def update_board_state(position, choice)
    x, y = position[0], position[1]
    p @board_state[x][y]
    if choice == "F"
      @board_state[x][y].flagged = true
      process_flagged(position)
    end
    if choice == "R"
      @board_state[x][y].revealed = true 
      process_reveal(position)
    end
   end
end

class Tile
  attr_accessor :flagged, :revealed, :bombed
  
  def initialize(position, board)
    @position, @board = position, board
    flagged = false
    revealed = false
    bombed = false
  end
  
  def reveal
    self.inspect
  end
  
  NEIGHBORS = [ 
    [1, -1],
    [1,  0],
    [1,  1],
    [0, -1],
    [0,  1],
    [-1, 1],
    [-1, 0],
    [-1, -1],
  ]
  
  def neighboring_spots
    neighbors = []
    NEIGHBORS.each do |coord|
      x = @position[0] + coord[0]
      y = @position[1] + coord[1]
      neighbors << [x,y] if x.between?(0,8) && y.between?(0,8)
    end
    neighbors
  end
  
  def neighbors 
    # get tiles (from board) at neighboring_spots
  end
  
  def neighbor_bomb_count
    # get number of neighbors that are bombs
  end
  
  def bombed?
    bombed
  end
  
  def flagged?
    flagged
  end
  
  def revealed?
    revealed
  end
  
  def inspect
    return 'F' if flagged?
    return "#{neighbor_bomb_count}" if neighbor_bomb_count && self.revealed?
    return '_' if revealed?
    return '*' 
  end
end



if __FILE__ == $PROGRAM_NAME
  p "Would you like to start a new game or load?  ( enter n or l)"
  input = gets.chomp
  if input == "n"
    g= Game.new()
    g.run
  else
    Game.load_game
  end
end

