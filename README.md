# TruthTables.jl

TruthTables.jl is a small package to generate truth tables from boolean expressions.


## Installation

This package isn't listed in the Registry. You can add it to your Julia environment
using it's URL:

```julia
using Pkg
Pkg.add(url="https://github.com/savq/TruthTables.jl")
```


## Usage

To create a truth table, call the `@truth_table` macro on a boolean expression:
```julia
using TruthTables

julia> @truth_table p && q || !r
8×6 Named Matrix{Bool}
 ╲  │            p             q             r        p && q            !r  p && q || !r
────┼───────────────────────────────────────────────────────────────────────────────────
1   │         true          true          true          true         false          true
2   │         true          true         false          true          true          true
3   │         true         false          true         false         false         false
4   │         true         false         false         false          true          true
5   │        false          true          true         false         false         false
6   │        false          true         false         false          true          true
7   │        false         false          true         false         false         false
8   │        false         false         false         false          true          true
```

`@truth_table` returns a [NamedArray](https://github.com/davidavdav/NamedArrays.jl),
but you can can cast it to a Matrix for use elsewhere.

Expressions can include any valid identifier as a variable,
and can also include literal values (`true` and `false`).

You can use the logical operators:
- `&&`
- `||`
- `!`
- `∧` (`\wedge`)
- `∨` (`\vee`)
- `¬` (`\neg`)
- `⊻` (`xor`)
- `⟹` (`\implies`)
- `⟺` (`\iff`)

Note that `∧`, `∨` are functions, whereas `&&` and `||` are not;
These have different operator precedence.
When in doubt, you can use the functions `Base.operator_associativity` and `Base.operator_precedence`
to check the associativity of an operator; or just… you know, use parentheses.

