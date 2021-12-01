using Printf
using Statistics

# Some constants
const REQUIRED_FIELDS = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
const VALID_EYE_COLORS = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
const PASSPORT_ID_REGEX = r"^[0-9]{9}$"
const HEIGHT_REGEX = r"^([0-9]+)(cm|in)$"
const HAIR_COLOR_REGEX = r"^#[0-9a-f]{6}$"

function check_part2(field_name::String, field_value::String)::Bool
    year::UInt16 = 0


    if field_name == "byr"
        # Birth year
        year = tryparse(UInt16, field_value)
        if year === nothing
            # Not an int
            return false
        end

        return year >= 1920 && year <= 2002
    elseif field_name == "iyr"
        # Issued year
        year = tryparse(UInt16, field_value)
        if year === nothing
            # Not an int
            return false
        end

        return year >= 2010 && year <= 2020
    elseif field_name == "eyr"
        # Expiration year
        year = tryparse(UInt16, field_value)
        if year === nothing
            # Not an int
            return false
        end

        return year >= 2020 && year <= 2030
    elseif field_name == "hgt"
        # Height
        height_parts = match(HEIGHT_REGEX, field_value)

        if height_parts === nothing
            # Invalid height
            return false
        end

        value::UInt8 = tryparse(UInt8, height_parts.captures[1])
        unit::String = height_parts.captures[2]

        if unit == "cm"
            return value >= 150 && value <= 193
        elseif unit == "in"
            return value >= 59 && value <= 76
        end

    elseif field_name == "hcl"
        # Hair color
        return match(HAIR_COLOR_REGEX, field_value) !== nothing
    elseif field_name == "ecl"
        # Eye Color
        return field_value in VALID_EYE_COLORS
    elseif field_name == "pid"
        # Passport ID
        return match(PASSPORT_ID_REGEX, field_value) !== nothing
    end
    # Not a field we recognize (most likely CID)
    return true
end

function main()
    input_passports::Array{String} = [""]
    part1_answer::Int32 = 0
    part2_answer::Int32 = 0

    while !eof(stdin)
        line::String = readline(stdin)

        if line == ""
            # We just ended a passport, add a new one
            push!(input_passports, "")
        else
            # Add this line into the current input_passports
            input_passports[end] *= line * " "
        end
    end

    # Process the passports
    for passport::String in input_passports
        # Some debug first
        # println(strip(passport))

        # Split this passport into parts
        parts::Array{String} = split(passport, keepempty=false)

        # Part 1 - parse the fields we have from this passport and compare it to
        # the list of required fields
        current_fields::Set{String} = Set()

        valid_for_part2::Bool = true

        for part::String in parts
            field_parts::Array{String} = split(part, ":", limit=2)
            field_name = field_parts[1]
            field_value = field_parts[2]

            push!(current_fields, field_name)

            # Process for part 2
            valid_for_part2 = valid_for_part2 && check_part2(field_name, field_value)
            # if ! valid_for_part2
            #     println(field_name, ": ", field_value, " INVALID now")
            # end
        end

        valid_for_part1::Bool = isempty(setdiff(REQUIRED_FIELDS, current_fields))
        # Check if this is a valid one for part 1
        # All the fields we have are inside the required fields
        part1_answer += valid_for_part1 ? 1 : 0

        # Increase part 2 answer when this passport is valid for part 2
        part2_answer += valid_for_part1 && valid_for_part2 ? 1 : 0
    end

    println("Part 1: ", part1_answer)
    println("Part 2: ", part2_answer)
end

main()
