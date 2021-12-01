using Printf
using Statistics
using Test

# Some constants
const LINE_REGEX = r"^([a-z ]+) bags contain (.*)\.$"
const CONTENT_EMPTY = "no other bags" # What we will see in the right side if the container doesn't contain anything
const CONTENT_PART_REGEX = r"^([0-9]+) (.*) bags?$" # Regex of the part of content for a container

const PART1_TARGET = "shiny gold"

struct ContentRule
    container::String
    content::Set
    details::Dict{String, UInt16}
end
#
# Parse a line of input into parts
function line_parser(line::String)::ContentRule
    match_line = match(LINE_REGEX, line)

    if match_line === nothing
        throw(DomainError(line, "Invalid line"))
    end

    # Parse parts of the line
    container::String = match_line.captures[1]
    content::String = match_line.captures[2]

    if content == CONTENT_EMPTY
        # This type of bag doesn't contain anything
        return ContentRule(
                    container,
                    Set(),
                    Dict(),
                   )
    else
        # This type of bag has some content in it
        parts = split(content, ", ", keepempty=false)

        details = Dict()
        content_broken = Set()
        for part in parts
            part_match = match(CONTENT_PART_REGEX, part)

            count::UInt16 = parse(UInt16, part_match.captures[1])
            bag_type::String = part_match.captures[2]

            push!(content_broken, bag_type)
            details[bag_type] = count
        end

        return ContentRule(
                    container,
                    content_broken,
                    details,
                   )
    end
end


# Mapping from the bag type to the rule
rules = Dict()

# Mapping from the bag type to the weight
content_weight = Dict()

# Dynamic programming for part 2
function calculate_content_weight(container::String)::UInt16
    if container in keys(content_weight)
        # Something we already calculated earlier
        return content_weight[container]
    end

    this_container_rule::ContentRule = rules[container]

    result::UInt16 = 0
    # To though the content for calculation
    # No need to check for empty, right?
    for (child_bag_type::String, child_bag_count::UInt16) in this_container_rule.details
        result += child_bag_count * (1 + calculate_content_weight(child_bag_type))
    end

    content_weight[container] = result
end

#
# Main function
function main()
    # Set of all possible container type
    containers::Set{String} = Set()

    while !eof(stdin)
        line::String = readline(stdin)

        new_rule::ContentRule = line_parser(line)

        # Parse and store the rule
        rules[new_rule.container] = new_rule

        # Store the bag type
        push!(containers, new_rule.container)
    end
    # println(containers)

    # Solve part 1
    part1_bag_types::Set{String} = Set([PART1_TARGET])

    while true
        part1_changed = false

        for rule in values(rules)
            container = rule.container
            if container in part1_bag_types
                # This container is already counted for part 1
                continue
            end

            if length(intersect(rule.content, part1_bag_types)) > 0
                # This rule's content include a bag that will eventually contain
                # thar PART1_TARGET
                part1_changed = true # Make sure that we do not break out

                push!(part1_bag_types, container)
            end
        end

        if ! part1_changed
            # Nothing changed after looking at all the rules -> we've reached our
            # limit
            break
        end
    end

    println("Part 1: ", length(part1_bag_types) - 1) # Minus 1 because we don't count the target bag itself
    println("Part 2: ", calculate_content_weight(PART1_TARGET))
end

main()
