using Printf
using Statistics
using DataStructures
using Test

directions = [(0, -1), (1, 0), (0, 1), (-1, 0)]

function main()
    cave::Array{Array{Int}} = []
    line_index::Int = 0
    while !eof(stdin)
        line::String = readline(stdin)
        push!(cave, [])
        parts = split(line, "")
        line_index += 1
        for part in parts
            push!(cave[line_index], tryparse(Int, part))
        end
    end

    # display(cave)
    row_count = length(cave)
    col_count = length(cave[1])

    # Actual size
    a_row_count = 5 * row_count
    a_col_count = 5 * col_count

    path_risk::Array{Int, 2} = Array{Int, 2}(undef, a_row_count, a_col_count)

    for row = 1:a_row_count, col = 1:a_col_count
        path_risk[row, col] = typemax(Int)
    end

    # Begin point
    path_risk[1, 1] = 0

    points_to_consider::Queue{Tuple{Int, Int}} = Queue{Tuple{Int, Int}}()
    enqueue!(points_to_consider, (1, 1))

    # Path finding
    while length(points_to_consider) > 0
        (row, col) = dequeue!(points_to_consider)
        for (drow, dcol) in directions
            new_row = row + drow
            new_col = col + dcol

            if new_row < 1 || new_row > a_row_count || new_col < 1 || new_col > a_col_count
                # Invalid point
                continue
            end

            # All of this is because of index start at 1, damn it
            data_row = new_row % row_count
            data_col = new_col % col_count
            row_increment = new_row ÷ row_count
            col_increment = new_col ÷ col_count

            if (new_row % row_count == 0)
                data_row = row_count
                row_increment -= 1
            end
            if (new_col % col_count == 0)
                data_col = col_count
                col_increment -= 1
            end

            actual_data::Int = (cave[data_row][data_col] + row_increment + col_increment) % 9
            if actual_data == 0
                actual_data = 9
            end

            # Compare the 2 options
            via_point::Int = path_risk[row, col] + actual_data

            if via_point < path_risk[new_row, new_col]
                # Find a better way
                path_risk[new_row, new_col] = via_point
                enqueue!(points_to_consider, (new_row, new_col))
            end
        end
    end

    println("Part 1: ", path_risk[row_count, col_count])
    println("Part 2: ", path_risk[a_row_count, a_col_count])
end

main()