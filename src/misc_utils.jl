
# Convenience functions to work with strings and substrings

"""
    $SIGNATURES

Returns the string corresponding to `s`: `s` itself if it is a string, or the parent string if `s`
is a substring.
"""
str(s::String)::String    = s
str(s::SubString)::String = s.string


"""
    subs(s, from, to)
    subs(s, from)
    subs(s, range)

Convenience functions to take a substring of a string.

# Example
```julia-repl
julia> JuDoc.subs("hello", 2:4)
"ell"
```
"""
subs(s::AbstractString, from::Int, to::Int)::SubString    = SubString(s, from, to)
subs(s::AbstractString, from::Int)::SubString             = subs(s, from, from)
subs(s::AbstractString, range::UnitRange{Int})::SubString = SubString(s, range)


"""
    from(ss)

Given a substring `ss`, returns the position in the parent string where the substring starts.

# Example
```julia-repl
julia> ss = SubString("hello", 2:4); JuDoc.from(ss)
2
```
"""
from(ss::SubString)::Int = nextind(str(ss), ss.offset)


"""
    to(ss)

Given a substring `ss`, returns the position in the parent string where the substring ends.

# Example
```julia-repl
julia> ss = SubString("hello", 2:4); JuDoc.to(ss)
4
```
"""
to(ss::SubString)::Int = ss.offset + ss.ncodeunits


"""
    matchrange(m::RegexMatch)

Returns the string span of a regex match. Assumes there is no unicode in the match.

# Example
```julia-repl
julia> JuDoc.matchrange(match(r"ell", "hello"))
2:4
```
"""
matchrange(m::RegexMatch)::UnitRange{Int} = m.offset .+ (0:(length(m.match)-1))

# Other convenience functions

"""
    $SIGNATURES

Convenience function to display a time since `start`.
"""
function time_it_took(start::Float64)::Nothing
    comp_time = time() - start
    mess = comp_time > 60 ? "$(round(comp_time/60;   digits=1))m" :
           comp_time >  1 ? "$(round(comp_time;      digits=1))s" :
                            "$(round(comp_time*1000; digits=1))ms"
    println("[done $(lpad(mess, 6))]")
    return nothing
end


"""
    $SIGNATURES

Convenience function to check if a variable is `nothing`. It is defined here to guarantee
compatibility with Julia 1.0 (the function exists for Julia ≥ 1.1).
"""
isnothing(x)::Bool = (x === nothing)


"""
    $SIGNATURES

Convenience function to denote a string as being in a math context in a recursive parsing
situation. These blocks will be processed as math blocks but without adding KaTeX elements to it
given that they are part of a larger context that already has KaTeX elements.
NOTE: this happens when resolving latex commands in a math environment. So for instance if you have
`\$\$ x \\in \\R \$\$` and `\\R` is defined as a command that does `\\mathbb{R}` well that would be
an embedded math environment. These environments are marked as such so that we don't add additional
KaTeX markers around them.
"""
mathenv(s::AbstractString)::String = "_\$>_$(s)_\$<_"


"""
    $SIGNATURES

Creates a random string pegged to `s` that we can use for hyper-references. We could just use the
hash but it's quite long, here the length of the output is controlled  by `JD_LEN_RANDSTRING` which
is set to 4 by default.
"""
refstring(s::AbstractString)::String = randstring(MersenneTwister(hash(s)), JD_LEN_RANDSTRING)
