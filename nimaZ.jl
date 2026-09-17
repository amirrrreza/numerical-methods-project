using BenchmarkTools
function main()
    stars = [3, 3, 2, 2, 2]   
    n_s = 2                   
    n_q = length(stars)       

    if n_q < n_s
        println("Error: tedad soal be st ha nemikhorad.")
        println("Questions: $n_q, Students: $n_s")
        return
    end

    questions = collect(zip(1:n_q, stars))                 
    sorted_questions = sort(questions, by = x -> -x[2])    

    totalStars = fill(0, n_s)
    studentQuestions = [Int[] for _ in 1:n_s]

    for i in 1:n_q
        k = argmin(totalStars)           
        qid, sval = sorted_questions[i]
        push!(studentQuestions[k], qid)
        totalStars[k] += sval
    end

    println("\n===== GREEDY RESULT =====")
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