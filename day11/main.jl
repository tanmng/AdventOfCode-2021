using Printf
using Statistics
using DataStructures
using Test

CAVE_ROW = 10
CAVE_COL = 10
PART1_ITERATION_COUNT = 100
FLASH_THRESHOLD = 9

function main()
    cave::Array{Int, 2} = Array{Int, 2}(undef, CAVE_ROW, CAVE_COL)
    line_index::Int = 0

    while !eof(stdin)
        line::String = readline(stdin)

        line_index += 1

        parts = split(line, "")
        for i = 1:CAVE_COL
            cave[line_index, i] = tryparse(Int, parts[i])
        end
    end

    # Simulate
    part1_answer::Int = 0
    iteration_count = 0

    while true
        # At the beginning of each iteration, we have a queue of octopuses to
        # flash
        to_flash::Queue{Tuple{Int, Int}} = Queue{Tuple{Int, Int}}()
        already_flashed::Set{Tuple{Int, Int}} = Set{Tuple{Int, Int}}()

        for row = 1:CAVE_ROW, col = 1:CAVE_COL
            cave[row, col] += 1
            if cave[row, col] > FLASH_THRESHOLD
                # This has to flash now
                enqueue!(to_flash, (row, col))
            end
        end

        # Continue flashing
        while length(to_flash) > 0
            flash_location = dequeue!(to_flash)

            if flash_location in already_flashed
                # Skip this one - this test is actually not needed (see line 74)
                # but still kept to be safe
                continue
            end
            row = flash_location[1]
            col = flash_location[2]
            push!(already_flashed, flash_location)

            # Mark the answer
            # println("Round ", i, ": (", row, ", ", col, ") just flashed")
            part1_answer += 1

            # Perform the flash
            for drow = -1:1:1, dcol = -1:1:1
                if drow == 0 && dcol == 0
                    # Skip the very same cell
                    continue
                end
                new_row = row + drow
                new_col = col + dcol
                if new_row < 1 || new_row > CAVE_ROW || new_col < 1 || new_col > CAVE_COL
                    # Not a valid location
                    continue
                end

                if ! ((new_row, new_col) in already_flashed)
                    # The one that already flashed are impervious to effect of
                    # flashes
                    cave[new_row, new_col] += 1
                    if cave[new_row, new_col] > FLASH_THRESHOLD
                        # Mark this for flashing again
                        enqueue!(to_flash, (new_row, new_col))
                    end
                end
            end

            # Reset the octopus that just flashed
            cave[row, col] = 0
        end

        iteration_count += 1
        if iteration_count == PART1_ITERATION_COUNT
            println("Part 1: ", part1_answer)
        end

        # 100 by 100 right?
        if length(already_flashed) == 100
            println("Part 2: ", iteration_count)
            break
        end
        # display(cave)
    end

end

main()
