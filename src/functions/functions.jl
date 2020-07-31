## functions....
function make_janus(col)
    mov=rand([1,5])
    rot=rand(1:4)
    Tile(col,mov,DIRECTIONS[4],true,true)
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

### Playing Engine and Rules.....

function find_moves(P::Player,board=cur_game.board)
    tmppos =  P.position
    tmptile = board.tiles[tmppos]
    directions =  tmptile.directions .* idx * tmptile.moves
    sel = findall(tmptile.directions)
    directions =  idx[sel] * tmptile.moves
    directions = map(x -> tmppos + x,directions)

    function in_grid(X::CartesianIndex)
        all([(X.I[1] > 0 && X.I[2] > 0) , (X.I[1] < 11 && X.I[2] < 11)])
    end

    function occupied!(possiblemove,cur_game)
        ## remove all spots where a player is already on...
        occupied_spots=map(x->x.position,cur_game.players)
        sel=in(possiblemove).(occupied_spots)
        if any(sel)
            delsel = findall(possiblemove .==  occupied_spots[sel])
            deleteat!(possiblemove,delsel)
        end
    end

    possiblemove=directions[map(in_grid,directions)]
    occupied!(possiblemove,cur_game)
    return possiblemove
end


function make_move!(P::Player,mov::CartesianIndex,board=cur_game.board)
    pos = P.position

    ## Check if there is a janus at current tile and push it to the players profile
    if board.tiles[pos].janus
        push!(P.janus,board.tiles[pos].color)
        board.tiles[pos].janus = false
    end

    ## Overwrite old tile
    update_board!(board.tiles,pos)
    update_scoreboard!(cur_game.scoreboard,pos)
    update_score!(P,pos)

    # check if game is finished....
    if cur_game.status
         return false
     else
         nothing
     end
    ## check if Player is allowed another turn...
    turn = board.tiles[mov].color in P.janus

    # Change position of the Player
    P.position = mov

    return turn
end

function update_board!(board,tmppos)
    board[tmppos] = Tile(:grey,1,DIRECTIONS[1],false,false)
end
function update_scoreboard!(scoreboard,tmppos)
    scoreboard.active[tmppos] = true
end

function make_turn!(P::Player)
    turn = true

    while turn
        posmoves=find_moves(P)
        ## select move
        #@info posmoves
        #sel = parse(Int,readline())
        sel = rand(1:length(posmoves))
        if length(sel) == 1
            mov = posmoves[sel]
        ## update scores
        # +++
            turn = make_move!(P,mov)
        end
        cur_game.ui ? p = draw_board(cur_game) : nothing
    end
end


### Scoreing engine....

## Deal scoring ...
## zero:: retrieve scoring information
### on which filed id is player
function return_id(mov)
    cur_game.scoreboard.id[mov]
end
function return_field(id)
    findall(cur_game.scoreboard.id .== id)
end
## first:: is the field already active?
function check_active(id)
    all(cur_game.scoreboard.active[id])
end
### if not your own....
function check_lord(P::Player,ids)
    cur_game.scoreboard.player[ids[1]]
end
### -> pay rent!
function pay_rent!(Pturn::Player,Plord::Player)
    Pturn.coins -= 1
    Plord.score += 1
end
### --> remove one coin in players bank
### --> add one point to the owner of the field....
## second:: is the field now to be set active?
function occupy_field!(P::Player,ids)
    cur_game.scoreboard.player[ids] .= P.id
    P.score += cur_game.scoreboard.points[ids[1]]
    cur_game.scoreboard.points[ids] .= 0
end
### -> occupy it
### -> add scores
## third:: check if game is finished now
### -> has player no more coins?
function check_coins(P)
    P.coins == 0
end
### -> are all fields activated?
function check_board()
    all(cur_game.scoreboard.active)
end

function update_score!(P::Player,mov::CartesianIndex)
    id = return_id(mov)
    ids = return_field(id)
    lord = check_lord(P,ids)
    if check_active(ids)
        if lord == 0
            occupy_field!(P,ids)
            @show "Player scored"
        elseif lord != P.id
            pay_rent!(P,cur_game.players[lord])
            @show "Player paid rent"
        end
    end

    cur_game.status = any([check_coins(P),check_board()])
end

#### Graphical Interface...

x = Array{Float64}(undef,10,10)
for i in 1:10
  x[:,i] .= 1:10
end

y = Array{Float64}(undef,10,10)
for i in 1:10
  y[:,i] .= i
end


function draw_board(cur_game)

  p=scatter(x,y,color=map(x -> x.color,cur_game.board.tiles),leg=false,
    ylims=(-3,11),xlims=(0,11),markershape=:rect,markersize=12,ratio=1,
    xticks=[],yticks=[])

  m = map(x -> x.janus,cur_game.board.tiles)
  p=scatter!(x[m],y[m],color=map(x -> x.color,cur_game.board.tiles)[m],leg=false,
    fillalpha=0.1,markershape=:rect,markersize=10,lc=:black,lw=10)

  for i in 0.5:2:10.5
      plot!([0.5,10.5],[i,i],color=:black,lw=2)
      plot!([i,i],[0.5,10.5],color=:black,lw=2)
  end

  for (i,player) in enumerate(cur_game.players)
      p=scatter!((player.position[1],player.position[2]),
        markershape=:star5,markercolor=player.color,markersize=6)
      p=annotate!(1,(0-i),"Player$i")
      N=length(player.janus)
      if N > 0
          p=scatter!(repeat([4],N).+collect(1:N),repeat([0-i],N),color=player.janus)
      end
  end
  return p
end
