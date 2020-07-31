## board

mutable struct Tile
    color::Symbol
    moves::Int64
    directions::Array{Bool,2}
    janus::Bool
    active::Bool
end

function make_tile()
    col=rand(1:4)
    mov=rand(1:5)
    dir=rand(1:4)
    rot=rand(1:4)
    ## include tiles rotation
    out=Tile(COLORS[col],MOVES[mov],DIRECTIONS[dir],false,true)
    out
end

mutable struct chip
    color::Symbol
end

mutable struct ScoreBoard
    active::Array{Bool,2}
    id::Array{Any,2}
    points::Array{Any,2}
    player::Array{Any,2}
end

ScoreBoard() = init_scoreboard()

function init_scoreboard()
    id = Array{Int,2}(undef,10,10)
    points = Array{Int,2}(undef,10,10)
    player = zeros(10,10)
    active = falses(10,10)

    for ((i,j),k) in zip(Base.Iterators.product([1,3,5,7,9],[1,3,5,7,9]),1:25)
        seli=i:(i+1)
        selj=j:(j+1)
        id[seli,selj] .= k
        points[seli,selj] .= rand(1:5)
    end
    ScoreBoard(active,id,points,player)
end


mutable struct Board
    tiles::Array{Any,2}
end

Board() = make_board()

function make_board()

   #### MAKE ALL TILES
   tmptiles=[]
    while length(tmptiles) < 100
        push!(tmptiles,make_tile())
    end
    tiles=copy(tmptiles)
    posits = collect(1:100)

    tmpboard=Board(reshape(tiles,10,10))

    # make 2 x Janus per color
    cols = map(x -> x.color,tmpboard.tiles)
    for i in COLORS[1:4]
        tmp = findall(cols .== i)
        for j in rand(tmp,2)
            tmpboard.tiles[j] = make_janus(i)
        end
    end
    return tmpboard
end
