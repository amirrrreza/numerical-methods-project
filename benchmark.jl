using BenchmarkTools

function lpt_upper_bound(w::Vector{Int}, m::Int)
    idx = sortperm(w; rev=true)
    loads = zeros(Int, m)
    bins = [Int[] for _ in 1:m]
    for i in idx
        j = argmin(loads)
        push!(bins[j], i)
        loads[j] += w[i]
    end
    return bins, loads, maximum(loads)
end


function feasible_assignment(w::Vector{Int}, m::Int, T::Int)
    n = length(w)
    idx = sortperm(w; rev=true)         
    loads = zeros(Int, m)
    bins  = [Int[] for _ in 1:m]
    counts = zeros(Int, m)               

    function dfs(k::Int)
        if k > n
            return all(>(0), counts)     
        end

        
        remaining = n - k + 1
        empty_students = count(==(0), counts)
        if remaining < empty_students
            return false
        end

        q = idx[k]
        wi = w[q]

        seen_loads = Set{Int}()
        for m in 1:m
            
            if loads[m] + wi > T
                continue
            end
            
            if loads[m] in seen_loads
                continue
            end
            push!(seen_loads, loads[m])

          
            loads[m] += wi
            push!(bins[m], q)
            counts[m] += 1

            if dfs(k + 1)
                return true
            end

            
            counts[m] -= 1
            pop!(bins[m])
            loads[m] -= wi

            
            if loads[m] == 0
                break
            end
        end

        return false
    end

    ok = dfs(1)
    return ok ? (bins, loads) : nothing
end

function solve_optimal(w::Vector{Int}, m::Int)
    n = length(w)
    if n < m
        error("Not enough questions: n=$n, students=$m (each student must get ≥1 question).")
    end

    _, _, ub = lpt_upper_bound(w, m)
    lb = max(maximum(w), cld(sum(w), m))   

    best_bins = nothing
    best_loads = nothing

    while lb < ub
        mid = (lb + ub) ÷ 2
        res = feasible_assignment(w, m, mid)
        if res === nothing
            lb = mid + 1
        else
            ub = mid
            best_bins, best_loads = res
        end
    end

    if best_bins === nothing
        res = feasible_assignment(w, m, lb)
        best_bins, best_loads = res
    end

    return best_bins, best_loads, lb
end


function main()
    
    stars = [3,3,2,2,2]
    students = 2

    bins, loads, T = solve_optimal(stars, students)

    println("\n===== OPTIMAL RESULT =====")
    println("Optimal maximum load T = ", T)

    for m in 1:students
        qs = sort(bins[m])
        println("Student $m: Questions = $(join(qs, ", ")) | Total Stars = $(loads[m])")
    end
end

function bench_one()
    w = [3,3,2,2,2]
    m = 2
    @btime solve_optimal($w, $m)
end
main()
bench_one()
