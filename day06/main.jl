using Printf
using Statistics
using Test

MAX_FISH_COUNT_DOWN = 6
NEWLY_BORN_COUNT_DOWN = 8
PART1_SIMULATION_ROUND = 80
PART2_SIMULATION_ROUND = 256

function main()
    original_fishes::Array{UInt} = []
    while !eof(stdin)
        line::String = readline(stdin)

        parts = split(line, ",")

        for part in parts
            push!(original_fishes, tryparse(UInt, part))
        end
    end

    # Create frequency table
    simulated_fishes::Dict{UInt, UInt} = Dict()

    # Init - please don't kill me, I don't how how to do this beautifully in Julia
    for i = 0:NEWLY_BORN_COUNT_DOWN
        simulated_fishes[i] = 0
    end

    # Parse the initial fish
    for fish in original_fishes
        simulated_fishes[fish] += 1
    end

    for i = 1:PART2_SIMULATION_ROUND
        # Simulate a round
        zero_countdown::UInt = simulated_fishes[0]

        # Decrease the pending for all fishes
        for i = 0:NEWLY_BORN_COUNT_DOWN - 1
            simulated_fishes[i] = simulated_fishes[i + 1]
        end

        # Increase the number of fishes at MAX_FISH_COUNT_DOWN
        # Fishes that reached 0 will return to 6
        simulated_fishes[MAX_FISH_COUNT_DOWN] += zero_countdown

        # Spawn new fish at countdown 8 - NEWLY_BORN_COUNT_DOWN
        simulated_fishes[NEWLY_BORN_COUNT_DOWN] = zero_countdown

        if i == PART1_SIMULATION_ROUND
            # We reached part 1
            println("Part 1: ", sum(values(simulated_fishes)))
        end
    end

    println("Part 2: ", sum(values(simulated_fishes)))
end

main()
