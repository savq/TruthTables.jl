# TruthTables.jl

TruthTables.jl is a small package to generate truth tables.


## Installation

This package isn't listed in the Registry, you can add it to your Julia environment
using it's URL:

```julia
using Pkg
Pkg.add(url="https://github.com/savq/TruthTables.jl")
```


## Usage

To create a truth table, call the `@truth_table` macro on an a predicate:
```julia
using TruthTables

julia> ↑(p, q) = !(p && q) # you can define your own operators
↑ (generic function with 1 method)

julia> @truth_table !(p && q) ⟺ p ↑ q
4×6 Named Matrix{Bool}
 ╲  │                 p                  q             p && q          !(p && q)              p ↑ q  !(p && q) ⟺ p ↑ q
────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────────────
1   │              true               true               true              false              false               true
2   │              true              false              false               true               true               true
3   │             false               true              false               true               true               true
4   │             false              false              false               true               true               true
```

`@truth_table` returns a [NamedArray](https://github.com/davidavdav/NamedArrays.jl),
but you can can cast it to a Matrix for use elsewhere.
If you prefer `1` and `0` instead `true` and `false`, you can just broadcast
a call to `Int` over the truth table.

Expressions can include any valid identifier as a variable,
and can also include literal values (`true` and `false`).

You can use the boolean operators defined in base (`&&`, `||`, etc.)
as well as any other boolean-valued function.
TruthTables defines (but doesn't export) the operators:
- `∧` (`\wedge`)
- `∨` (`\vee`)
- `¬` (`\neg`)
- `⟹` (`\implies`)
- `⟺` (`\iff`)

TruthTables follows the usual precedence rules. When in doubt, use parentheses.

