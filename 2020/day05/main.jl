using Printf
using Statistics
using Test

# Some constants
const SEAT_ID_REGEX = r"^[BF]{7}[RL]{3}$"

#
# Convert the seat_id into the numeric representation
function convert_id(seat_id::String)::UInt16
    if match(SEAT_ID_REGEX, seat_id) === nothing
        throw(DomainError(seat_id, "Invalid seat ID representation"))
    end

    # Replace the string
    binary_string::String = seat_id
    binary_string = replace(binary_string, "B" => "1")
    binary_string = replace(binary_string, "F" => "0")
    binary_string = replace(binary_string, "R" => "1")
    binary_string = replace(binary_string, "L" => "0")

    # Form the binary
    return parse(UInt16, binary_string, base=2)
end

#
# Test suite for our functions
function test()
    @test convert_id("FBFBBFFRLR") == 357
    @test convert_id("BFFFBBFRRR") == 567
    @test convert_id("FFFBBBFRRR") == 119
    @test convert_id("BBFFBBFRLL") == 820
end

function main()

    all_seat_ids_from_input::Array{UInt16} = []

    while !eof(stdin)
        line::String = readline(stdin)

        # Store the nubmer from this line
        push!(all_seat_ids_from_input, convert_id(line))
    end

    # Part 1 - the max
    println("Part 1: ", maximum(all_seat_ids_from_input))

    # Part 2 - Find the seat ID that is missing from the list
    for part2_candidate::UInt16 in minimum(all_seat_ids_from_input):maximum(all_seat_ids_from_input)
        if ! (part2_candidate in all_seat_ids_from_input)
            println("Part 2: ", part2_candidate)
            break
        end
    end
end

main()
