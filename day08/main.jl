using Printf
using Statistics
using Test

function main()
    inputs::Array{Dict{Int, Array{Set{String}}}} = []
    outputs::Array{Array{Set{String}}} = []
    part1_answer::Int = 0
    part2_answer::Int = 0
    while !eof(stdin)
        line::String = readline(stdin)

        parts = split(line, " | ")
        input = parts[1]
        output = parts[2]

        input_parts = split(input, " ", keepempty = false)

        cur_input::Dict{Int, Array{Set{String}}} = Dict()
        for e in input_parts
            g = Set(split(e, ""))
            g_len = length(g)

            if ! (g_len in keys(cur_input))
                cur_input[g_len] = []
            end
            # println(g)

            push!(cur_input[g_len], g)
        end
        push!(inputs, cur_input)

        cur_output::Array{Set{String}} = []
        output_parts = split(output, " ")
        for e in output_parts
            output_len = length(e)
            if output_len == 2 || output_len == 4 || output_len == 3 || output_len == 7
                part1_answer += 1
            end

            g = Set(split(e, ""))
            push!(cur_output, g)
        end

        push!(outputs, cur_output)
    end

    # Try to decode for part 2
    for i = 1:length(inputs)
        input = inputs[i]
        output = outputs[i]

        digits::Array{Set{String}} = Array{Set{String}}(undef, 10)

        # The simple ones
        digits[1] = input[2][1]
        digits[4] = input[4][1]
        digits[7] = input[3][1]
        digits[8] = input[7][1]

        # 6 segments - might be 6, 9 and 0
        for candidate in input[6]
            if length(intersect(candidate, digits[1])) == 1
                # This is a 6
                digits[6] = candidate
            else
                if length(intersect(digits[4], setdiff(candidate, digits[7]))) == 1
                    # This is a 0 - but Julia doesn't have index 0, does it
                    digits[10] = candidate
                else
                    # This is a 9
                    digits[9] = candidate
                end
            end
        end

        # 5 segments - might be 2, 5 and 3
        for candidate in input[5]
            if length(intersect(candidate, digits[1])) == 2
                # This is a 3
                digits[3] = candidate
            else
                if length(setdiff(candidate, digits[9])) == 1
                    # This is a 2
                    digits[2] = candidate
                else
                    # This is a 5
                    digits[5] = candidate
                end
            end
        end

        # Get the number from output
        output_value::Int = 0
        for output_digit in output
            for j = 1:10
                if output_digit == digits[j]
                    digit_value::Int = j % 10 # This is for the wrap around of 0
                    output_value = output_value * 10 + digit_value
                    # Break from this loop - continue to the next digit
                    break
                end
            end
        end

        println(i, ", output = ", output_value)
        part2_answer += output_value

    end

    println("Part 1: ", part1_answer)
    println("Part 2: ", part2_answer)
end

main()
