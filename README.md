# Permutation closure graphs in Lean 4

Let $M$ be a set of permutations of $n$ points. Draw an undirected edge
between distinct points $x$ and $y$ when some permutation in $M$ sends
$x$ to $y$ or $y$ to $x$. Write $\Gamma(M)$ for this graph.

Passing to the subgroup $\langle M\rangle$ fills in every missing edge
inside each original connected component. If the components have vertex
sets $C_1,\ldots,C_k$, the graph equality is

$$
\Gamma(\langle M\rangle) = K_{C_1} \sqcup \cdots \sqcup K_{C_k}.
$$

This is the graph equality in the appendix to the 2016 paper by Vyacheslav
Shvedovsky, Anton Standrik and Yuriy Bilan. Its group-theoretic basis is
the classical fact that the orbits of a generated group are the connected
components of its generator graph. [Original statement, pp. 146–147](https://www.economics-sociology.eu/files/ES_9_2_Shvedovsky_Standrik_Bilan.pdf#page=10) · [DOI](https://doi.org/10.14254/2071-789X.2016/9-2/9) · [Azhar and Reif, Lemma 4.2.2 (1999)](https://users.cs.duke.edu/~reif/paper/azhar/group/group.pub.pdf#page=18)

## Closure with loops

Let $X=\{1,\ldots,n\}$, let $S_n$ be its symmetric group, and let
$M\subseteq S_n$ be any set. Write $[x,y]=[y,x]$ for an unordered pair,
allowing $x=y$. For $A\subseteq S_n$, define the undirected graph
$\Gamma_\ell(A)$ on $X$ by its edge set

$$
E_\ell(A)=\{[x,\sigma(x)]\mid x\in X,\ \sigma\in A\}.
$$

Each edge occurs once. A loop $[x,x]$ is present exactly when some
$\sigma\in A$ fixes $x$. Deleting the loops gives the simple graph
$\Gamma(A)$ above. [Edge definition and loop convention in Lean](PermutationClosure.lean#L155-L176)

**Algorithm.** Let $e$ be the identity permutation. Set

$$
A_0=M\cup\{e\},\qquad
A_{r+1}=A_r\cup\{\sigma\circ\tau\mid \sigma,\tau\in A_r\}.
$$

Stop at the **first** $r$ for which $A_{r+1}=A_r$ and return $H=A_r$.
[First stopping round in Lean](PermutationClosure.lean#L194-L209)

**Theorem.** The algorithm terminates and returns $H=\langle M\rangle$.
For every $x,y\in X$, including $x=y$,

$$
[x,y]\in E_\ell(H)
\quad\Longleftrightarrow\quad
x\text{ and }y\text{ belong to the same connected component of }\Gamma_\ell(M).
$$

Thus each original component contributes a complete graph with one loop
at every vertex, including singleton components. [Theorem in Lean](PermutationClosure.lean#L211-L224) · [Equality of edge sets](PermutationClosure.lean#L187-L192)

**Proof.** Every strict round adds a permutation, and $S_n$ is finite.
At the stopping round $H$ contains $e$ and is closed under composition.
If $g\in H$ has order $d$, then $g^{-1}=g^{d-1}\in H$. Hence $H$ is a
subgroup containing $M$. Every round lies in $\langle M\rangle$, so
$H=\langle M\rangle$. A walk from $x$ to $y$ gives a product of generators
and their inverses that sends $x$ to $y$. Conversely, applying the factors
of such a product in order gives a walk. The empty product fixes every vertex.

**Empty input.** For $M=\varnothing$, the input graph has no edges.
Already $A_0=A_1=\{e\}$, so $r=0$ and the output edges are exactly
$[x,x]$ for $x\in X$. [Empty-input proof](PermutationClosure.lean#L226-L241)

## General graph lemma

For any simple graph `G`, `fromRel G.Reachable` joins distinct vertices
connected by a walk in `G`. On the right, `spanningCoe` includes each
component's complete graph in the original vertex set. [Lemma and proof](PermutationClosure/ComponentCliques.lean#L13-L20)

```lean
import PermutationClosure.ComponentCliques

open SimpleGraph

example {V : Type*} (G : SimpleGraph V) :
    fromRel G.Reachable =
      ⨆ C : G.ConnectedComponent, (completeGraph C.supp).spanningCoe :=
  G.fromRel_reachable_eq_iSup_completeGraph
```

For any set of permutations `M`, including the empty set, the orbit
criterion `reachable_iff` identifies the graph of the generated subgroup
with `fromRel (graph M).Reachable`. The proof of `closure_graph_eq_union`
then applies the general lemma to `graph M`. [Derivation in Lean](PermutationClosure.lean#L57-L71)

## Lean statement

`PermutationClosure.permutation_closure_theorem` gives the simple-graph
version on `Fin n` for nonempty `M`, with multiplication rounds starting at `M`.
[Appendix theorem in Lean](PermutationClosure.lean#L138-L148)

Mathlib also states the orbit characterization for labelled Schreier graphs
in `Quiver.SchreierGraph.reachable_iff`. [Mathlib source](https://github.com/leanprover-community/mathlib4/blob/v4.36.0/Mathlib/Combinatorics/Quiver/Schreier.lean#L283-L291)

## Check the proof

The project pins Lean and mathlib to v4.36.0. From the repository root,
fetch the compiled imports and build the proof.

```sh
lake exe cache get Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected \
  Mathlib.Data.Fintype.Perm Mathlib.GroupTheory.OrderOfElement Mathlib.Order.OrderIsoNat
lake build
```
