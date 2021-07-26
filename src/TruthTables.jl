# This module serves as a simple example of what macros can do.
"TruthTables exports the macro @truth_table"
module TruthTables

# Used for pretty printing.
using NamedArrays: NamedArray

export @truth_table

# TODO: Support user defined functions
¬(p::Bool) = !p
∧(p::Bool, q::Bool) = p && q
∨(p::Bool, q::Bool) = p || q
⟹(p::Bool, q::Bool) = if p; q else true end
⟺(p::Bool, q::Bool) = p === q


"""
Take a boolean expression and return a truth table

The truth table is a NamedArray whose columns are variables and sub-expressions
of the input expression.
"""
macro truth_table(expr)
    subexprs, vars = get_sub_exprs(expr)
    c = gensym(:c)
    vals = gensym(:vals)
    ex = :($vals[$c+=1, :] = [$(vars...), $(subexprs...)])

    for i in vars
        ex = :(for $i in [true, false]; $ex end)
    end

    quote
        $c = 0
        $vals = Matrix{Bool}(undef, 2^length($vars), length($vars) + length($subexprs))
        $ex
        NamedArray($vals, (1:2^length($vars), string.([$vars..., $subexprs...])), ("Val.", "Pred."))
   end
end


"Returns two vectors: a vector of sub-expressions and a vector of variables."
function get_sub_exprs(expr::Expr)
    sub_exprs = Expr[]
    vars = Symbol[]

    # Traverse the expression using multiple dispatch
    function walk!(expr::Expr)
        n = (expr.head == :call) ? 2 : 1    # Ignore function names
        walk!.(expr.args[n:end])            # Mind the dot
        expr ∉ sub_exprs && push!(sub_exprs, expr)
    end
    walk!(var::Symbol) = var ∉ vars && push!(vars, var)
    walk!(::Bool) = nothing

    walk!(expr)
    return sub_exprs, reverse(vars)
end

end #module

