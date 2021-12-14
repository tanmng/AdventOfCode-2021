using Printf
using Statistics
using DataStructures
using Test

function main()
    input_polymer::String = ""
    rules::Dict{String, String} = Dict()
    all_chars::Set{String} = Set()
    in_polymer::Bool = true
    while !eof(stdin)
        line::String = readline(stdin)

        if line == ""
            # Change part
            in_polymer = false
            all_chars = Set(split(input_polymer, ""))
            continue
        end

        if in_polymer
            input_polymer = line
        else
            parts = split(line, " -> ")
            push!(all_chars, parts[2])
            rules[parts[1]] = parts[2]
        end
    end

    # Frequency from input
    frequency::Dict{String, Int} = Dict()
    for char in all_chars
        frequency[char] = 0
    end
    for char in split(input_polymer, "")
        frequency[char] += 1
    end

    # Mapping from the pair to frequency in the current polymer
    cur_polymer_pair::Dict{String, Int} = Dict()
    next_polymer_pair::Dict{String, Int} = Dict()

    for i = 1:length(input_polymer) - 1
        candidate::String = input_polymer[i:i + 1]
        if ! (candidate in keys(cur_polymer_pair))
            cur_polymer_pair[candidate] = 0
        end
        cur_polymer_pair[candidate] += 1
    end

    for step =  1:40
        next_polymer_pair = copy(cur_polymer_pair)
        for (pair, value) in cur_polymer_pair
            if pair in keys(rules)
                # The 2 pairs that will soon appear
                pair1::String = pair[1] * rules[pair]
                pair2::String = rules[pair] * pair[2]

                if ! (pair1 in keys(next_polymer_pair))
                    next_polymer_pair[pair1] = 0
                end
                next_polymer_pair[pair1] += value

                if ! (pair2 in keys(next_polymer_pair))
                    next_polymer_pair[pair2] = 0
                end
                next_polymer_pair[pair2] += value

                # Decrease the current pair since it's now split
                next_polymer_pair[pair] -= value

                # Update frequency on the flight
                frequency[rules[pair]] += value
            end
        end
        cur_polymer_pair = next_polymer_pair

        if step == 10
            println("Part 1: ", maximum(values(frequency)) - minimum(values(frequency)))
        end
    end

    println("Part 2: ", maximum(values(frequency)) - minimum(values(frequency)))

end

main()