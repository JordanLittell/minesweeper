require_relative 'tile.rb'

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
    board.each_index do |i|
      9.times do |j|
        board[i][j] = Tile.new(self, [i,j])
      end
    end
  end
  
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
    system 'clear'
    picture = Array.new(9){ Array.new }  
    @board_state.each_with_index do |array, index|
      picture[index] << array.map { |tile| tile.state }
    end
    picture.each do |array|
      print array.join(" ")
      puts
    end
  end
  
  def update_board_state(position, choice)
    x, y = position[0], position[1]
    if choice == "F"
      p 'you picked flag'
      @board_state[x][y].state = "F"
    end
    if choice == "R"
      tile = @board_state[x][y]
      tile.reveal! 
    end
   end
   
   def set_bomb_count
    @board_state.flatten.each do |tile|
      tile.set_neighbor_bomb_count
    end
   end
end