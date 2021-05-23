module TruthTables

using NamedArrays: NamedArray, setnames!

export @truth_table

const operators = [:&&, :||, :!]

macro truth_table(expr)
    # Walk the expression and push the variables found to a vector `vars`:
    vars = Vector{Symbol}([])
    find_vars!(var::Symbol) = !(var in operators) && !(var in vars) && push!(vars, var)
    find_vars!(expr::Expr) = find_vars!.(expr.args)
    find_vars!(::Bool) = nothing

    find_vars!(expr)


    # Generate nested for loops where each variable is given a truth value:
    vals = []
    ex = quote
        push!($vals, [$(vars...), $expr]) # there's probably a better way to do this
    end

    for i in reverse(vars)
        ex = quote
            for $i in [true, false]
                $ex
            end
        end
    end

    # Crate the truth table
    eval(ex)
    table = NamedArray(Matrix{Bool}(hcat(vals...)'))
    setnames!(table, [string.(vars)..., string(expr)], 2)
    return table
end

test_tt() = @truth_table (a && b && (!c)) || ((!a) && c && (b || d))

end #mod
