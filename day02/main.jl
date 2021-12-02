using Printf
using Statistics
using Test

mutable struct Position
    x::UInt
    y::UInt
    aim::UInt
end

function main()
    # Answers for both part of the question
    answer_1 = Position(0, 0, 0)
    answer_2 = Position(0, 0, 0)

    while !eof(stdin)
        line::String = readline(stdin)

        matches = match(r"^(forward|down|up) ([0-9]+)$", line)

        if isnothing(matches)
            throw(DomainError(line, "Invalid line"))
        end

        command = matches.captures[1]
        value::UInt = tryparse(UInt, matches.captures[2])

        if command == "forward"
            # Move forward
            # Part 1
            answer_1.x += value

            # Part 2
            answer_2.x += value
            answer_2.y += value * answer_2.aim
        elseif command == "down"
            # Part 1
            # Dive
            answer_1.y += value

            # Part 2
            # Aim down
            answer_2.aim += value
        elseif command == "up"
            # Part 1
            # Surface
            answer_1.y -= value

            # Part 2
            # Aim up
            answer_2.aim -= value
        else
            throw(DomainError(command, "Unrecognized command"))
        end
    end

    println("Part 1: ", answer_1.x * answer_1.y)
    println("Part 2: ", answer_2.x * answer_2.y)
end

main()
