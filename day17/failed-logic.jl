struct CandidateY
    y::Int
    min_step::Int
    max_step::Int
end

struct CandidateX
    x::Int
    min_step::Int
    max_step::Int
end

# The logic below, while fancy, are also very hard to work out
# I wasted my damn time, urg


# Find valid x and y
# Find candidate for x
candidates_for_x::Array{CandidateX} = []
max_possible_steps::Int = typemin(Int)
min_possible_steps::Int = typemax(Int)
for possible_x = 1:target.max_x
    max_reach::Int = possible_x * (possible_x + 1) ÷ 2
    if max_reach < target.min_x
        # This can't even reach the min x
        continue
    end
    # We know that this will reach
    valid_candidate::Bool = false
    step_range_min = 0
    step_range_max = 0
    reach = 0
    step_count = 0
    for k = possible_x:-1:1
        step_count += 1
        reach += k
        if reach >= target.min_x && reach <= target.max_x
            if ! valid_candidate
                # First time discovering that this is a valid one
                step_range_min = step_count
                step_range_max = step_count
                # Mark for later
                valid_candidate = true
            else
                # We already know that this is valid, just keep increasing the step_range_max value
                step_range_max = step_count
            end
        elseif reach > target.max_x
            # Passed the zone already, no need to continue
            break
        end
    end

    if valid_candidate
        push!(candidates_for_x, CandidateX(
            possible_x,
            step_range_min,
            step_range_max,
        ))

        max_possible_steps = max(max_possible_steps, step_range_max)
        min_possible_steps = min(min_possible_steps, step_range_min)
    end
end
println(candidates_for_x)
println(min_possible_steps, "-", max_possible_steps)

# Find possible values for y, along with the number of step suitables
part1_answer::Int = typemin(Int)
for candidate_y = -1000:1000
    # Going pass max_possible_steps, we will just waste all our time going up and there's now down anymore
    if candidate_y > 0
        highest_y = candidate_y * (1 + candidate_y) ÷ 2
        step_count = candidate_y
    else
        highest_y = 0
        step_count = 0
    end
    # Work out after how many step we will be within the range of min_y and max_y
    reach = highest_y
    valid_candidate::Bool = false
    step_range_min = 0
    step_range_max = 0
    for k = 1:abs(target.min_y)
        reach -= k
        step_count += 1
        if reach >= target.min_y && reach <= target.max_y
            if ! valid_candidate
                # First time discovering that this is a valid one
                step_range_min = step_count
                step_range_max = step_count
                # Mark for later
                valid_candidate = true
            else
                # We already know that this is valid, just keep increasing the step_range_max value
                step_range_max = step_count
            end
        elseif reach > target.max_x
            # Passed the zone already, no need to continue
            break
        end
    end
    if valid_candidate
        #  This is a valid Y value, with given step_range_min and step_range_max
        #  Now find a combination
        for px in candidates_for_x
            golden::Bool = false
            x = px.x
            min_step = px.min_step
            max_step = px.max_step
            if max_step <= x
                # This is a special case, essentially, there will be event in which the probe doesn't move laterally anymore
                # For this, we only need step_range_min (for y) to be >= min_step
                if step_range_min >= min_step
                    golden = true
                end
            else
                if min_step <= step_range_min && step_range_min <= max_step
            end
        end
    end
end