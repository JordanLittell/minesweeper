require_relative 'game.rb'
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

