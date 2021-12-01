using Printf
using Statistics
using Test

function main()
    prev_depth = nothing

    all_measurements::Array{UInt} = []

    part1_answer = 0

    while !eof(stdin)
        line::String = readline(stdin)

        # Store the nubmer from this line
        current_depth::UInt = tryparse(UInt, line)

        if !isnothing(prev_depth) && prev_depth < current_depth
            part1_answer += 1
        end

        prev_depth = current_depth

        # Just record the thing
        push!(all_measurements, current_depth)
    end

    # Part 1 - Simple
    println("Part 1: ", part1_answer)

    part2_answer::UInt = 0

    # Part 2 - slidding window
    for i = 1:(length(all_measurements) - 3)
        if all_measurements[i] < all_measurements[i + 3]
            part2_answer += 1
        end
    end

    # Part 1 - Simple
    println("Part 2: ", part2_answer)
end

main()
