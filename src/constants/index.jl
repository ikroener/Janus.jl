const COLORS=[
    :red,
    :green,
    :blue,
    :yellow,
    :grey
]

const MOVES=[
    1,
    2,
    3,
    4,
    5
]

const DIRECTIONS=[
 [true true true; true false true; true true true],   ## STAR
 [true false true; false false false; true false true], ## DIAGONALS
 [false true false; true false true; false true false], ## CROSS
 [false false false; true false true; false false false], ## 1-Line
]
const ROTATION= [
    0,
    1,
    2,
    3
]


idx=[CartesianIndex(-1, -1)  CartesianIndex(-1, 0)  CartesianIndex(-1, 1);
 CartesianIndex(0, -1)  CartesianIndex(0, 0)  CartesianIndex(0, 1);
 CartesianIndex(1, -1)  CartesianIndex(1, 0)  CartesianIndex(1, 1)]
