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

    # Generate nested for loops where each variable is given a truth value
    vals = []
    ex = :(push!($vals, [$(vars...), $(subexprs...)]))    # FIXME: Preallocate vals

    for i in reverse(vars)
        ex = quote
            for $i in [true, false]
                $ex
            end
        end
    end

    # Create and return truth table
    eval(ex)
    NamedArray(
        Matrix(hcat(vals...)'),
        (1:(2^length(vars)), [string.(vars)..., string.(subexprs)...]),
        ("", "")
    )
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
    return sub_exprs, vars
end

end #module

