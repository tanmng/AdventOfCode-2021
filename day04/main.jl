using Printf
using Statistics
using Test

#  The board is 5 by 5
const BOARD_DIMENSION = 5

#
# Update the board (given as array) with the value (given as int). We also need
# a status board to mark whether the value is called from this board
# This is annoying, originally I wanted to use negative number in the board to
# mark that a value is called, but since they allow 0 that won't work - urggg
# Return whether the board meet the requirement of a bingo (all values in
# a row/column was called
function update_board(board::Array{Int}, status_board::BitArray, value::Int)::Bool
    # Find the indices which contain the value (note that theoretically there
    # should only be one)
    # Here we simply check and confirm that, if there are more than 1 then the
    # program will be more complicated
    locations = findall(x->x==value, board)

    if length(locations) == 0
        # This is not a value for this board
        return false
    elseif length(locations) > 1
        # Error, we have more than 1 occurence of the value in this board
        throw(DomainError(value, board, "Value appeared in the board for more than once"))
    else
        # Only 1 occurrence - as all thing should be
        value_index = locations[1]

        # Update the board
        # Marking by specifying the board to be negative does not work since the
        # board can contain 0 (urggg, more memory needed)
        status_board[value_index] = true

        # Check the column and row (file and rank)
        file_bingo::Bool = true
        rank_bingo::Bool = true

        for i = 1:length(board)
            if i == value_index
                # Same position, no need to check this
                continue
            end

            if i % BOARD_DIMENSION == value_index % BOARD_DIMENSION
                # Same file
                file_bingo &= status_board[i]
            end

            if (i - 1) ÷ BOARD_DIMENSION  == (value_index - 1) ÷ BOARD_DIMENSION
                # Same rank
                rank_bingo &= status_board[i]
            end
        end

        return file_bingo | rank_bingo
    end
    # Safety, should not have reached here
    throw(DomainError("We reached somewhere we should not have"))
end

# Our tests
function test()
    # Test the update_board function
    test_board::Array{Int} = [22, 13, 17, 11, 0, 8, 2, 23, 4, 24, 21, 9, 14, 16, 7, 6, 10, 3, 18, 5, 1, 12, 20, 15, 19]
    test_status_board::BitArray = falses(BOARD_DIMENSION * BOARD_DIMENSION)
    status::Bool = false
    println(test_board)
    println(test_status_board)
    status = update_board(test_board, test_status_board, 22)
    println(test_status_board)
    status = update_board(test_board, test_status_board, 7)
    println(test_status_board)
    status = update_board(test_board, test_status_board, 13)
    println(status)
    status = update_board(test_board, test_status_board, 17)
    println(status)
    status = update_board(test_board, test_status_board, 11)
    println(status)
    status = update_board(test_board, test_status_board, 0)
    println(status)
end

function main()
    line_index::UInt = 0
    number_input::Array{Int} = []

    # Storing our boards and status board
    boards::Array{Array{Int}} = []
    status_boards::Array{BitArray} = []

    while !eof(stdin)
        line::String = readline(stdin)

        line_index += 1

        if line_index == 1
            # First line
            parts::Array{String} = split(line, ",")
            for part in parts
                push!(number_input, tryparse(Int, part))
            end
            continue
        end

        if line == ""
            # Empty line - we will need to store new board (and generate new
            # status board which is full of false)
            push!(status_boards, falses(BOARD_DIMENSION * BOARD_DIMENSION))

            # New board
            push!(boards, [])
            continue
        end

        # If we reach here, we have a line filled with numbers
        parts = split(line, " ", keepempty=false)
        for part in parts
            # Store thie value into the last board
            push!(boards[length(boards)], tryparse(Int, part))
        end
    end

    # Record all the boards that have bingo
    boards_with_bingo::Set{Int} = Set{Int}()

    # Answers for the 2 parts
    part1_answer::Int = 0
    part2_answer::Int = 0

    # part 1 - play bingo
    for number in number_input, i = 1:length(boards)
        # Go throubh each number
        # println("After input ", number)
        if i in boards_with_bingo
            # Skip boards that already have bingo - so that we don't repeatedly
            # call out bingo - that's just annoying
            continue
        end

        # Go through each board
        if update_board(boards[i], status_boards[i], number)
            # BINGO
            println("Bingo in board ", i, " after adding number ", number)
            # Record this
            push!(boards_with_bingo, i)

            if length(boards_with_bingo) == 1
                # First board with a bingo
                # This is clanky, but it works, negating the array would be better
                # but Julia doesn't have such easy thing
                part1_answer = number * (sum(boards[i]) - sum(boards[i] .* status_boards[i]))
            end

            if length(boards_with_bingo) == length(boards)
                # Last board to have a bingo
                # Same mechanism as answer for part 1
                part2_answer = number * (sum(boards[i]) - sum(boards[i] .* status_boards[i]))
            end
        end

        # println(status_boards[i])
    end
    println("Part 1: ", part1_answer)
    println("Part 2: ", part2_answer)
end

main()
