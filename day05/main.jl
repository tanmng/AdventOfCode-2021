using Printf
using Statistics
using Test

struct Line
    x1::Int
    y1::Int
    x2::Int
    y2::Int
end

function main()
    part1_lines::Array{Line} = []
    part2_lines::Array{Line} = []
    x_max::Int = 0
    y_max::Int = 0
    while !eof(stdin)
        line::String = readline(stdin)

        matches = match(r"^([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)$", line)

        if matches == nothing
            throw(DomainError(line, "invalid line"))
        end

        x1 = tryparse(Int, matches.captures[1])
        y1 = tryparse(Int, matches.captures[2])
        x2 = tryparse(Int, matches.captures[3])
        y2 = tryparse(Int, matches.captures[4])

        if x1 == x2 || y1 == y2
            # Vertical or horizontal
            push!(part1_lines, Line(x1, y1, x2, y2))
        end

        push!(part2_lines, Line(x1, y1, x2, y2))

        x_max = max(x_max, x1, x2)
        y_max = max(y_max, y1, y2)
    end

    # println(x_max)
    # println(y_max)
    # println(part1_lines)

    # Create the matrix marking how many lines are in each point
    point_matrix::Array{UInt, 2} = Array{UInt, 2}(undef, x_max + 1, y_max + 1)
    # println(point_matrix)
    for line in part1_lines
        if line.x1 == line.x2
            # Horizontal line
            # Julia and its "index start at 1" rule
            actual_x = line.x1 + 1

            min_y = min(line.y1, line.y2)
            max_y = max(line.y1, line.y2)
            for i = min_y:max_y
                # Increase the marking
                point_matrix[actual_x, i + 1] += 1
            end
        end

        if line.y1 == line.y2
            # Vertical line
            # Julia and its "index start at 1" rule
            actual_y = line.y1 + 1

            min_x = min(line.x1, line.x2)
            max_x = max(line.x1, line.x2)
            for i = min_x:max_x
                # Increase the marking
                point_matrix[i + 1, actual_y] += 1
            end
        end
    end
    # display(point_matrix)
    # println(point_matrix)
    part1_answer = 0
    for row = 1:x_max+1, col = 1:y_max+1
        if point_matrix[row, col] >= 2
            part1_answer += 1
        end
    end

    println("Part 1: ", part1_answer)

    # Process part 2 - just skip the vertical / horizontal lines
    for line in part2_lines
        if line.x1 == line.x2 || line.y1 == line.y2
            continue
        else
            # Diagonal lines
            x_dif = line.x2 - line.x1
            x_incre = x_dif > 0 ? 1 : -1
            y_dif = line.y2 - line.y1
            y_incre = y_dif > 0 ? 1 : -1

            for i = 0:x_incre:x_dif
                # Damn the +1 in index
                point_matrix[line.x1 + i + 1, line.y1 + abs(i) * y_incre + 1] += 1
            end
        end

    end

    part2_answer = 0
    for row = 1:x_max+1, col = 1:y_max+1
        if point_matrix[row, col] >= 2
            part2_answer += 1
        end
    end

    println("Part 2: ", part2_answer)
end

main()
