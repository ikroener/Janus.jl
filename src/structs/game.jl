mutable struct Game{T <: Vector{<:AbstractPlayer}} <: AbstractGame
  # no parent
  #scope::Scope
  #in_focus::Bool
  players::T
  board::Board
  scoreboard::ScoreBoard
  status::Bool
  winner::Int
  ui::Bool
end

Game() = Game(AbstractPlayer[],Board(),ScoreBoard(),false,0,true)
