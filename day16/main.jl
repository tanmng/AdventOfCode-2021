using Printf
using Statistics
using DataStructures
using Test

struct LiteralPacket
    version::Int
    type::Int
    value::Int
    string_length::Int
end

struct OperatorPacket
    version::Int
    type::Int
    length_type::Int
    string_length::Int
    subcommands::Array{Union{LiteralPacket, OperatorPacket}}
end

# Sum of the version number
function version_sum(this_command::Union{LiteralPacket, OperatorPacket})::Int
    value = this_command.version
    if this_command isa OperatorPacket
        for subcommand in this_command.subcommands
            value += version_sum(subcommand)
        end
    end
    return value
end

# Get the value of a command
function command_value(this::Union{LiteralPacket, OperatorPacket})::Int
    if this isa LiteralPacket
        return this.value
    else
        subcommand_values::Array{Int} = []
        for subcommand in this.subcommands
            push!(subcommand_values, command_value(subcommand))
        end
        if this.type == 0
            # Sum
            return sum(subcommand_values)
        elseif this.type == 1
            # Product
            return prod(subcommand_values)
        elseif this.type == 2
            # Minimum
            return minimum(subcommand_values)
        elseif this.type == 3
            # Maximum
            return maximum(subcommand_values)
        elseif this.type == 5
            # Greater than
            return subcommand_values[1] > subcommand_values[2] ? 1 : 0
        elseif this.type == 6
            # Less than
            return subcommand_values[1] < subcommand_values[2] ? 1 : 0
        elseif this.type == 7
            # Equal to
            return subcommand_values[1] == subcommand_values[2] ? 1 : 0
        end
    end
end

function packet_parser(line::String)::Union{LiteralPacket, OperatorPacket}
    # Prase the bit
    version = parse(Int, line[1:3], base=2) # First 3 bits
    type = parse(Int, line[4:6], base=2) # Next 3 bits
    if type == 4
        # Literal one, now try to parse this
        next_start = 7
        value_binary = ""
        while true
            # We can still get one more group
            current_group = line[next_start:next_start + 4]
            value_binary *= current_group[2:5]
            next_start += 5
            if (current_group[1] == '0')
                # This is the last group already
                break
            end
        end
        
        value = parse(Int, value_binary, base=2)
        
        return LiteralPacket(
            version,
            type,
            value,
            next_start - 1,
        )
    else
        length_type = parse(Int, line[7], base=2) # Next 3 bits
        subcommands = []
        start::Int = 19 # Where to begin next
        if length_type == 1
            # The next 11 bits are number of sub-packets in here
            subpackage_count::Int = parse(Int, line[8:18], base=2)
            start = 19 # The beginning point for each subcommand
            for i = 1:subpackage_count
                subcommand = packet_parser(line[start:end])
                push!(subcommands, subcommand)
                start += subcommand.string_length
            end
        elseif length_type == 0
            # The next 15 bits are the length of all subpackets
            all_subpacket_length::Int = parse(Int, line[8:22], base=2)
            start = 23
            subpacket_length_sofar = 0
            while subpacket_length_sofar < all_subpacket_length
                subcommand = packet_parser(line[start:end])
                push!(subcommands, subcommand)
                start += subcommand.string_length
                subpacket_length_sofar += subcommand.string_length
            end
        end
        
        return OperatorPacket(
            version,
            type,
            length_type,
            start - 1,
            subcommands,
        )
    end
end

function main()
    input_line::String = ""
    while !eof(stdin)
        line::String = readline(stdin)
        input_line = line
    end
    
    # Create binary representation
    binary::String = ""
    for char in split(input_line, "")
        binary *= string(tryparse(Int, char, base=16), base=2, pad=4)
    end
    
    # Try parse the thing
    this_command = packet_parser(binary)
    # println(this_command)
    println("Part 1: ", version_sum(this_command))
    println("Part 2: ", command_value(this_command))
end

main()