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

        digits::Array{Set{String}} = []

        # The simple ones
        digit_1 = input[2][1]
        digit_4 = input[4][1]
        digit_7 = input[3][1]
        digit_8 = input[7][1]

        digit_2 = nothing
        digit_3 = nothing
        digit_5 = nothing
        digit_6 = nothing
        digit_9 = nothing
        digit_0 = nothing
        # 6 segments - might be 6, 9 and 0
        for candidate in input[6]
            if length(intersect(candidate, digit_1)) == 1
                # This is a 6
                digit_6 = candidate
            else
                if length(intersect(digit_4, setdiff(candidate, digit_7))) == 1
                    # This is a 0
                    digit_0 = candidate
                else
                    # This is a 9
                    digit_9 = candidate
                end
            end
        end

        # 5 segments - might be 2, 5 and 3
        for candidate in input[5]
            if length(intersect(candidate, digit_1)) == 2
                # This is a 3
                digit_3 = candidate
            else
                if length(setdiff(candidate, digit_9)) == 1
                    # This is a 2
                    digit_2 = candidate
                else
                    # This is a 5
                    digit_5 = candidate
                end
            end
        end

        # println(digit_1)
        # println(digit_2)
        # println(digit_3)
        # println(digit_5)
        # Get the number from output
        output_string = ""
        for output_digit in output
            # This is really ugly
            if output_digit == digit_1
                output_string *= "1"
            elseif output_digit == digit_2
                output_string *= "2"
            elseif output_digit == digit_3
                output_string *= "3"
            elseif output_digit == digit_4
                output_string *= "4"
            elseif output_digit == digit_5
                output_string *= "5"
            elseif output_digit == digit_6
                output_string *= "6"
            elseif output_digit == digit_7
                output_string *= "7"
            elseif output_digit == digit_8
                output_string *= "8"
            elseif output_digit == digit_9
                output_string *= "9"
            elseif output_digit == digit_0
                output_string *= "0"
            end
        end

        println(i, ", output = ", output_string)
        part2_answer += tryparse(Int, output_string)

    end

    println("Part 1: ", part1_answer)
    println("Part 2: ", part2_answer)
end

main()
