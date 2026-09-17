using JuMP, HiGHS
function read_int(prompt)
    while true
        print(prompt, " ")
       flush(stdout)
        s = strip(readline(stdin))

       if isempty(s)
            println("Input cannot be empty. Try again.")
            continue
        end

        x = tryparse(Int, s)
       if x === nothing
            println("Invalid integer. Try again.")
            continue
        end

        return x
    end
end

function assign_questions_optimal(stars::Vector{Int}, n_s::Int)
    n_q = length(stars)

    model = Model(HiGHS.Optimizer) 
    set_silent(model)

    @variable(model, x[1:n_q, 1:n_s], Bin)
    @variable(model, M >= 0, Int)

    @constraint(model, [i=1:n_q], sum(x[i,s] for s in 1:n_s) == 1)
    @constraint(model, [s=1:n_s], sum(stars[i] * x[i,s] for i in 1:n_q) <= M)
    @constraint(model, [s=1:n_s], sum(x[i,s] for i in 1:n_q) >= 1)
    
    @objective(model, Min, M)

    optimize!(model)

    studentQuestions = [Int[] for _ in 1:n_s]
    totalStars = zeros(Int, n_s)

    for i in 1:n_q
        for s in 1:n_s
            if value(x[i,s]) > 0.5
                push!(studentQuestions[s], i)
                totalStars[s] += stars[i]
                break
            end
        end
    end

    return studentQuestions, totalStars, Int(round(value(M)))
end

function main()
    n_q = read_int("Enter number of questions:")
    n_s = read_int("Enter number of students:")

    if n_q <= 0 || n_s <= 0
        println("Error: number of questions and students must be positive.")
        return
    end

    if n_q < n_s
        println("Error: There are not enough questions for all students.")
        println("Questions: $n_q, Students: $n_s")
        return
    end

    stars = Int[]
    for i in 1:n_q
        sval = read_int("Enter star value for question $i (1–4):")
        while sval < 1 || sval > 4
            println("Star value must be between 1 and 4. Try again.")
            sval = read_int("Enter star value for question $i (1–4):")
        end
        push!(stars, sval)
    end

    studentQuestions, totalStars, maxLoad = assign_questions_optimal(stars, n_s)

    println("\n===== RESULT =====")
    println("Maximum stars assigned to any student: ", maxLoad)

    for s in 1:n_s
        println("Student $s:")
        println("  Questions: ", join(sort(studentQuestions[s]), ", "))
        println("  Total Stars: ", totalStars[s])
        println()
    end
end

main()


