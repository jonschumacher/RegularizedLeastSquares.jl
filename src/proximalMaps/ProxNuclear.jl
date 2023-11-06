export NuclearRegularization


"""
    NuclearRegularization

Regularization term implementing the proximal map for singular value soft-thresholding.

# Arguments:
* `λ`           - regularization paramter
* `svtShape::NTuple`  - size of the underlying matrix
"""
struct NuclearRegularization{T} <: AbstractParameterizedRegularization{T}
  λ::T
  svtShape::NTuple
end
NuclearRegularization(λ; svtShape::NTuple=[], kargs...) = NuclearRegularization(λ, svtShape)

"""
    prox!(reg::NuclearRegularization, x, λ)

performs singular value soft-thresholding - i.e. the proximal map for the nuclear norm regularization.
"""
function prox!(reg::NuclearRegularization, x::Vector{Tc}, λ::T) where {T, Tc <: Union{T, Complex{T}}}
  U,S,V = svd(reshape(x, reg.svtShape))
  prox!(L1Regularization, S, λ)
  x[:] = vec(U*Matrix(Diagonal(S))*V')
end

"""
    norm(reg::NuclearRegularization, x, λ)

returns the value of the nuclear norm regularization term.
"""
function norm(reg::NuclearRegularization, x::Vector{Tc}, λ::T) where {T, Tc <: Union{T, Complex{T}}}
  U,S,V = svd( reshape(x, reg.svtShape) )
  return λ*norm(S,1)
end
