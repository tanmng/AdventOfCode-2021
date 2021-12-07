using Printf
using Statistics
using Test

function main()
    initial_positions::Array{Int} = []
    while !eof(stdin)
        line::String = readline(stdin)

        parts = split(line, ",")

        for part in parts
            push!(initial_positions, tryparse(Int, part))
        end
    end

    # Try each and every possible positions and find the min
    min_fuel_use_1::Int = 999999999
    min_fuel_use_2::Int = 999999999

    min_pos = minimum(initial_positions)
    max_pos = maximum(initial_positions)

    for i in min_pos:max_pos
        possible_1::Int = 0
        possible_2::Int = 0
        for j in initial_positions
            diff = abs(j - i)
            # Part 1 - constants fuel consumption
            possible_1 += diff

            # Part 2 - increasing fuel consumption
            possible_2 += (diff * (diff + 1)) / 2
        end

        min_fuel_use_1 = min(possible_1, min_fuel_use_1)
        min_fuel_use_2 = min(possible_2, min_fuel_use_2)
    end

    println("Part 1: ", min_fuel_use_1)
    println("Part 2: ", min_fuel_use_2)
end

main()
