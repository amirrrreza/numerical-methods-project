using JuMP, HiGHS
using BenchmarkTools

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
    n_s = 2
    stars = [2,2,2,3,3]

    n_q = length(stars)
    if n_q < n_s
        println("Error: Not enough questions for all students.")
        println("Questions: $n_q, Students: $n_s")
        return
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
function bench_one()
    w = [3,3,2,2,2]
    m = 2
    @btime solve_optimal($w, $m)
end


main()
bench_one()