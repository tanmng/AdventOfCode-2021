using Printf
using Statistics
using DataStructures
using Test

START_POINT = "start"
END_POINT = "end"

struct PossiblePathPart1
    cave::String
    sofar::Array{String} # list of caves we traveled to reach here from start
end

struct PossiblePathPart2
    cave::String
    sofar::Array{String}
    already_twice::Bool # Mark that we have visited a small cave twice in this path already
end


function isBigCave(cave::String)::Bool
    return cave == uppercase(cave)
end
    
function main()
    paths::Dict{String, Array{String}} = Dict{String, Array{String}}()
    part1_answer::Int = 0
    while !eof(stdin)
        line::String = readline(stdin)
        parts = split(line, "-")
        
        node1 = parts[1]
        node2 = parts[2]
        
        if ! (node1 in keys(paths))
            paths[node1] = []
        end
        
        push!(paths[node1], node2)
        
        if node2 != END_POINT
            if ! (node2 in keys(paths))
                paths[node2] = []
            end

            push!(paths[node2], node1)
        end
    end
    # display(paths)
    
    # First, generate the tree root
    to_check_part1::Queue{PossiblePathPart1} = Queue{PossiblePathPart1}()
    enqueue!(to_check_part1, PossiblePathPart1(
        START_POINT,
        [START_POINT],
    ))
    
    # We do BFS here right?
    while length(to_check_part1) > 0
        # While we still have something to check
        cur_node = dequeue!(to_check_part1)
        
        for upcoming_cave in paths[cur_node.cave]
            if (upcoming_cave == END_POINT)
                # println(cur_node.sofar, " to ", END_POINT)
                part1_answer += 1
                continue
            end
            if upcoming_cave in cur_node.sofar && !(isBigCave(upcoming_cave))
                # We already went through this cave and it's not a big one
                continue
            end
            
            # A valid next cave
            next_node_so_far::Array{String} = copy(cur_node.sofar)
            push!(next_node_so_far, upcoming_cave)
            enqueue!(to_check_part1, PossiblePathPart1(
                upcoming_cave,
                next_node_so_far
            ))
        end
    end
    
    println("Part 1: ", part1_answer)
    
    # Part 2
    to_check_part2::Queue{PossiblePathPart2} = Queue{PossiblePathPart2}()
    enqueue!(to_check_part2, PossiblePathPart2(
    START_POINT,
    [START_POINT],
    false,
    ))

    # We do BFS here right?
    part2_answer::Int = 0
    while length(to_check_part2) > 0
        # While we still have something to check
        cur_node::PossiblePathPart2 = dequeue!(to_check_part2)
        
        for upcoming_cave in paths[cur_node.cave]
            if (upcoming_cave == END_POINT)
                part2_answer += 1
                continue
            end
            
            if (upcoming_cave == START_POINT)
                # Not revisiting the start point
                continue
            end

            next_twice::Bool = cur_node.already_twice
            if upcoming_cave in cur_node.sofar && !(isBigCave(upcoming_cave))
                # We already went through this cave and it's not a big one
                if cur_node.already_twice
                    # and we already visit a small cave twice
                    continue
                else
                    # We can visit this cave again, just note that because of that already_twice is now set to true
                    next_twice = true
                end
            end
            
            # A valid next cave (either by visiting twice or by simply being a valid one)
            next_node_so_far::Array{String} = copy(cur_node.sofar)
            push!(next_node_so_far, upcoming_cave)
            enqueue!(to_check_part2, PossiblePathPart2(
                upcoming_cave,
                next_node_so_far,
                next_twice,
            ))
        end
    end
    
    println("Part 2: ", part2_answer)
end

main()