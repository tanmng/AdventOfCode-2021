using Printf
using Statistics
using Test

function main()
    lines::Array{String} = []
    line_index::Int = 1
    while !eof(stdin)
        line::String = readline(stdin)
        push!(lines, line)
    end

    # Dimension
    cave_x::Int = length(lines)
    cave_y::Int = length(lines[1])

    inputs::Array{Int, 2} = Array{Int, 2}(undef, cave_x, cave_y)

    # Parse the input matrix
    for i = 1:length(lines)
        parts = split(lines[i], "")
        for j = 1:length(parts)
            inputs[i, j] = tryparse(Int, parts[j])
        end
    end

    # println(inputs)
    part1_answer::Int = 0
    low_points::Array{Tuple{Int, Int}} = []
    for row = 1:cave_x, col = 1:cave_y
        # Count the around values
        cur_value = inputs[row, col]

        low_point::Bool = true
        for d_x = -1:1:1, d_y = -1:1:1
            if d_x == 0 || d_y == 0
                # This to guarantee we only look at 4 directions
                x = row + d_x
                y = col + d_y

                if d_x == 0 && d_y == 0
                    continue
                end

                if x >= 1 && x <= cave_x && y >= 1 && y <= cave_y
                    # println("Comparing ", row, ", ", col, " with ", x, ", ", y)
                    # In the matrix
                    if cur_value >= inputs[x, y]
                        # This is no longer a low point
                        low_point = false
                    end
                end
            end
        end

        if low_point
            # println("Low", row, col)
            push!(low_points, (row, col))
            # Only take this if it is low point
            part1_answer += cur_value + 1
        end
    end

    println("Part 1: ", part1_answer)

    # Part 2 - explore the basins
    part2_answer::Int = 0
    basin_sizes::Array{Int} = []
    for low_point in low_points
        # Graph graph till we hit a wall of 9 or the boundary
        # Note that because a basin has only 1 low point we don't have to worry
        # about cases such as 584 (this will kill it all)
        basin_points::Set{Tuple{Int, Int}} = Set([low_point])
        new_points::Set{Tuple{Int, Int}} = Set([low_point])

        while true
            found_new = false

            new_points_again::Set{Tuple{Int, Int}} = Set([])

            for new_point in new_points
                # Only take care of new points
                row = new_point[1]
                col = new_point[2]

                for d_x = -1:1:1, d_y = -1:1:1
                    if d_x == 0 || d_y == 0
                        if d_x == 0 && d_y == 0
                            continue
                        end
                        # This to guarantee we only look at 4 directions

                        x = row + d_y
                        y = col + d_x

                        # println("Basin ", low_point, " Checking ", x, ", ", y)

                        if x >= 1 && x <= cave_x && y >= 1 && y <= cave_y && (! ((x, y) in basin_points)) && inputs[x, y] != 9
                            # This is a new point for the basin
                            push!(new_points_again, (x, y))
                            push!(basin_points, (x, y))
                            found_new = true
                        end
                    end
                end
            end

            if ! found_new
                # Exit from the infinite loop
                break
            else
                # We found something new
                new_points = new_points_again
            end
        end

        # println("Basin around ", low_point, " has ", length(basin_points), " points")
        push!(basin_sizes, length(basin_points))
    end

    # Get the 3 largest
    basin_sizes_sorted_decreasing::Array{Int} = sort(basin_sizes, rev=true)

    println("Part 2: ", basin_sizes_sorted_decreasing[1] * basin_sizes_sorted_decreasing[2] * basin_sizes_sorted_decreasing[3])
end

main()
