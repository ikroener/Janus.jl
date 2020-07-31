mutable struct Player <: AbstractPlayer
  #name::String
  id::Int
  color::Symbol
  position::CartesianIndex
  janus::Array{Symbol,1}
  score::Int
  coins::Int
  action::AbstractString
end
