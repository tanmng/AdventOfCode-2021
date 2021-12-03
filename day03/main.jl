using Printf
using Statistics
using Test

function main()
    sums_for_each_column::Array{UInt} = []
    number_of_entries::UInt = 0

    all_readings::Array{UInt} = []

    while !eof(stdin)
        line::String = readline(stdin)

        parts = split(line, "")

        for i = 1:length(parts)
            if number_of_entries == 0
                push!(sums_for_each_column, 0)
            end

            sums_for_each_column[i] += tryparse(UInt, parts[i])
        end

        # Parse the reading as binary and store that into teh all_readings array
        push!(all_readings, tryparse(UInt, line, base=2))
        number_of_entries += 1
    end

    # Part 1 - build the string representation of gamma and then calculate
    # epsilon, then perform the multiplication - it's dumb but it still works
    gamma_characters::String = ""

    # Build the binary string for gamma
    for i = 1:length(sums_for_each_column)
        if sums_for_each_column[i] > (number_of_entries / 2)
            # 1 is more than 0
            gamma_characters *= "1"
        else
            # 0 is more than 1
            gamma_characters *= "0"
        end
    end

    gamma::UInt = tryparse(UInt, gamma_characters, base=2)
    epsilon::UInt = 2 ^ length(sums_for_each_column) - 1 - gamma

    println("Part 1: ", gamma * epsilon)

    # Part 2 - Use a filtering method
    oxygen::Array{UInt} = copy(all_readings)

    # Gamma and epsilon already contain the most common and least common
    # digit, so we can reuse them (somehow)
    # Actually not, we need the most common and least common for each round of
    # consideration
    while true
        for i = 1:length(sums_for_each_column)
            # First, we have to find the most common bit for a position
            examine_bit_sum::UInt = 0
            right_shift_count::UInt = length(sums_for_each_column) - i

            for value in oxygen
                examine_bit_sum += (value >> right_shift_count) % 2
            end

            most_common_bit = examine_bit_sum >= length(oxygen) / 2 ? 1 : 0

            for j = length(oxygen):-1:1
                if (oxygen[j] >> right_shift_count) % 2 != most_common_bit
                    # This number from oxygen is not a suitable one
                    deleteat!(oxygen, j)
                    if length(oxygen) == 1
                        # We are at a pont where there's only 1 value left for oxygen
                        # Please don't kill me, it's hard breaking from 3 layers
                        # at once in Julia
                        @goto oxygen_done
                        break
                    end
                end
            end
        end
    end

    @label oxygen_done
    # println(oxygen)

    # CO2 reading
    co2::Array{UInt} = copy(all_readings)
    while true
        for i = 1:length(sums_for_each_column)
            # First, we have to find the most common bit for a position
            examine_bit_sum::UInt = 0
            right_shift_count::UInt = length(sums_for_each_column) - i

            for value in co2
                examine_bit_sum += (value >> right_shift_count) % 2
            end

            least_common_bit = examine_bit_sum < length(co2) / 2 ? 1 : 0

            for j = length(co2):-1:1
                if (co2[j] >> right_shift_count) % 2 != least_common_bit
                    # This number from co2 is not a suitable one
                    deleteat!(co2, j)
                    if length(co2) == 1
                        # We are at a pont where there's only 1 value left for co2
                        # Please don't kill me, it's hard breaking from 3 layers
                        # at once in Julia
                        @goto co2_done
                        break
                    end
                end
            end
        end
    end

    @label co2_done
    # println(co2)

    println("Part 2: ", oxygen[1] * co2[1])
end

main()
