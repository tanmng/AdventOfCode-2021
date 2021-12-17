using Printf
using Statistics
using DataStructures
using Test

struct Target
    min_x::Int
    max_x::Int
    min_y::Int
    max_y::Int
end

function main()
    target = nothing
    while !eof(stdin)
        line::String = readline(stdin)

        matcher = match(r"^target area: x=([-0-9]+)\.\.([-0-9]+), y=([-0-9]+)\.\.([-0-9]+)$", line)
        target = Target(
            tryparse(Int, matcher.captures[1]),
            tryparse(Int, matcher.captures[2]),
            tryparse(Int, matcher.captures[3]),
            tryparse(Int, matcher.captures[4]),
        )
    end
    println(target)

    max_height::Int = typemin(Int)
    part2_answer::Int = 0
    for px = 1:target.max_x, py = -3000:3000
        highest = py * (py + 1) ÷ 2
        vel_x = px
        vel_y = py
        cur_x = 0
        cur_y = 0
        suitable = false
        while true
            cur_x += vel_x
            cur_y += vel_y
            vel_x = max(0, vel_x - 1)
            vel_y -= 1

            if cur_x >= target.min_x && cur_x <= target.max_x && cur_y >= target.min_y && cur_y <= target.max_y
                # Suitable one
                suitable = true
                break
            end

            if cur_y < target.min_y || cur_x > target.max_x
                # No way
                break
            end
        end

        if suitable
            # println("Suitable ", px, ", ", py)
            max_height = max(highest, max_height)
            part2_answer += 1
        end
    end

    println("Part 1: ", max_height)
    println("Part 2: ", part2_answer)
end

main()