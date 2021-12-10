using Printf
using Statistics
using DataStructures
using Test

function main()
    corrupted_scores_map::Dict{String, Int} = Dict([(")", 3), ("]", 57), ("}", 1197), (">", 25137)])
    incomplete_scores_map::Dict{String, Int} = Dict([(")", 1), ("]", 2), ("}", 3), (">", 4)])
    matcher::Dict{String, String} = Dict([("(", ")"), ("[", "]"), ("{", "}"), ("<", ">"), (")", "("), ("]", "["), ("}", "{"), (">", "<")])
    begin_char::Set{String} = Set{String}(["(", "[", "{", "<"])

    part1_answer::Int = 0
    part2_scores::Array{Int} = []

    while !eof(stdin)
        line::String = readline(stdin)

        # Just parentheses matching right
        main_stack::Stack{String} = Stack{String}()

        parts = split(line, "")
        for part in parts
            if part in begin_char
                # This is a beginning character
                push!(main_stack, part)
            else
                # This i an ending character
                if length(main_stack) == 0
                    # Stack is currently empty
                    part1_answer += corrupted_scores_map[part]

                    # Done with this line
                    @goto line_done
                end

                # Check if the top of the stack is a matching character
                matching::String = matcher[part]
                stack_top::String = pop!(main_stack)

                if matching != stack_top
                    # An issue - mismatch
                    part1_answer += corrupted_scores_map[part]

                    # Done with this line
                    @goto line_done
                end
            end
        end

        # If we reach this point then the line is simply incomplete, check the
        # stack to find the missing pieces
        part2_score::Int = 0

        while length(main_stack) > 0
            # Get the top of the stack
            stack_top::String = pop!(main_stack)
            # Find the char missing for it
            matching::String = matcher[stack_top]
            # Get the point for the missing char
            point::Int = incomplete_scores_map[matching]

            # Increase the score accordingly
            part2_score = part2_score * 5 + point
        end

        if part2_score > 0
            println("Incomplete with a score of ", part2_score)
            push!(part2_scores, part2_score)
        end

        # Here simply the line is done for
        @label line_done
    end

    println("Part 1: ", part1_answer)

    # Get the answer of part 2
    # println(part2_scores)
    sort!(part2_scores)
    println("Part 2: ", part2_scores[(length(part2_scores) ÷ 2) + 1])
end

main()
