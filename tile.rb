class Tile
  attr_accessor :flagged, :revealed, :bombed, :board, :state, :neighbor_bomb_count
  
  def initialize (board, position)
    @visited_tiles = []
    @visited_positions = []
    @position, @board, @state = position, board, "*"
    flagged = false
    revealed = false
    bombed = false
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
  
  def reveal!
    queue = [self] unless self.bombed
    until queue.empty?
      current_tile = queue.shift
      current_tile.state = "-" unless current_tile.neighbor_bomb_count > 0
      current_tile.neighboring_tiles.each do |n_tile|
        queue << n_tile unless @visited_positions.include?(n_tile)
        @visited_positions << n_tile 
      end
    end
  end
  
  def neighboring_spots
    neighbors = []
    NEIGHBORS.each do |coord|
      x = @position[0] + coord[0]
      y = @position[1] + coord[1]
      neighbors << [x,y] if x.between?(0,8) && y.between?(0,8)
    end
    neighbors
  end
  
  def neighboring_tiles
    neighbor_tiles = []
    neighboring_spots.each do |spot|
      neighbor_tiles << board.board_state[spot[0]][spot[1]]
    end
    neighbor_tiles
  end
  
  def set_neighbor_bomb_count
    count = 0
    neighboring_spots.each do |spot|
      tile = @board.board_state[spot[0]][spot[1]]
      if tile.bombed
        count += 1
      end
    end
    @neighbor_bomb_count = count
  end
   
end