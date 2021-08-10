"TruthTables exports the macro @truth_table"
module TruthTables

## For pretty printing
using NamedArrays: NamedArray

export @truth_table

¬(p::Bool) = !p
∧(p::Bool, q::Bool) = p && q
∨(p::Bool, q::Bool) = p || q
⟹(p::Bool, q::Bool) = if p; q else true end
⟺(p::Bool, q::Bool) = p === q

"""
    @truth_table predicate

Return the truth table of `predicate`.

The `predicate` can contain built-in boolean operators, as well as user-defined boolean-valued functions.
The truth table is a NamedArray whose columns are variables and sub-expressions of the input predicate.
"""
macro truth_table(expr)
    sub_exprs, vars = get_sub_exprs(expr)
    col_names = string.([vars..., sub_exprs...])
    c = gensym(:c)
    vals = gensym(:vals)

    ## escape user-defined functions
    sub_exprs = escape_calls.(sub_exprs)

    ## Form expression
    ex = :($vals[$c+=1, :] = [$(vars...), $(sub_exprs...)])
    for i in reverse(vars)
        ex = :(for $i in [true, false]; $ex end)
    end

    quote
        $c = 0
        $vals = Matrix{Bool}(undef, 2^length($vars), length($vars) + length($sub_exprs))
        $ex
        NamedArray($vals, (1:2^length($vars), $col_names), ("", ""))
    end
end

function get_sub_exprs(expr)
    sub_exprs = Expr[]
    vars = Symbol[]

    ## Traverse expression using multiple dispatch
    function walk!(ex::Expr)
        n = ex.head == :call ? 2 : 1    # Ignore function names
        walk!.(ex.args[n:end])          # Mind the dot
        ex ∉ sub_exprs && push!(sub_exprs, ex)
    end
    walk!(var::Symbol) = var ∉ vars && push!(vars, var)
    walk!(::Bool) = nothing

    walk!(expr)
    return sub_exprs, vars
end

escape_calls(s) = s
function escape_calls(expr::Expr)
    ex = expr
    if ex.head == :call && ex.args[1] isa Symbol && !isdefined(@__MODULE__, ex.args[1])
        ex.args[1] = esc(ex.args[1])
    end
    ex.args[2:end] = escape_calls.(ex.args[2:end])
    ex
end

end #module

