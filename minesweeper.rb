

class Board
  attr_reader :board
  def initialize
    @board = generate_board
    @bomb_locations = generate_bomb
    render_board
  end
  
  def generate_board
    board = Array.new(9) { Array.new(9) }
    board.each do |array|
      array.map! { |square| square = Tile.new}
    end
  end
  
  
  def generate_bomb
    bomb_locations = []
    10.times do 
      bomb_locations << [(0...10).to_a.sample,(0...10).to_a.sample]
    end
    
    bomb_locations
  end
  
  def render_board
    @board.each do |array|
      array.map!{ |tile| tile.reveal }
    end
    @board
  end
end

class Tile
  
  def reveal
    p self.inspect
  end
  
  def neighbors
  end
  
  def neighbor_bomb_count
  end
  
  def bombed?
  end
  
  def flagged?
  end
  
  def revealed?
  end
  
  def inspect
    return "F" if flagged?
    return "_" if revealed?
    return "*"
  end
  
end

b = Board.new()
print b.board
