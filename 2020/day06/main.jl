using Printf
using Statistics
using Test

#
# Main function
function main()

    part1_answer::UInt16 = 0
    part2_answer::UInt16 = 0
    current_part1_group_answer::Set{String} = Set()
    current_part2_group_answer::Set{String} = Set()
    current_part2_just_reset::Bool = true # Tell us if part 2 just reset
    while !eof(stdin)
        line::String = readline(stdin)

        if line == ""
            # We just ended a group
            part1_answer += length(current_part1_group_answer)
            part2_answer += length(current_part2_group_answer)

            # Reset the group
            current_part1_group_answer = Set()

            # Mark this so that we know to calculate part2 correctly
            current_part2_just_reset = true
            current_part2_group_answer = Set() # This is actually not needed, but we still do it to be sure

            # Skip this line from the processing we have later
            continue
        end

        current_answers::Set{String} = Set{String}(split(line, "", keepempty=false))

        # Not end of group, extend current_part1_group_answer
        union!(current_part1_group_answer, current_answers)

        if current_part2_just_reset
            # Fresh for part 2
            current_part2_just_reset = false
            current_part2_group_answer = current_answers
        else
            # A new member for the group in part 2
            intersect!(current_part2_group_answer, current_answers)
        end

    end

    # This is for the last group, which doesn't end with an empty line
    part1_answer += length(current_part1_group_answer)
    part2_answer += length(current_part2_group_answer)

    println("Part 1: ", part1_answer)
    println("Part 2: ", part2_answer)
end

main()
