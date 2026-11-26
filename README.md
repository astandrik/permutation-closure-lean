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

This is the theorem in the appendix to the 2016 paper by Vyacheslav
Shvedovsky, Anton Standrik and Yuriy Bilan. Its group-theoretic basis is
the classical fact that the orbits of a generated group are the connected
components of its generator graph. [Original statement, pp. 146–147](https://www.economics-sociology.eu/files/ES_9_2_Shvedovsky_Standrik_Bilan.pdf#page=10) · [DOI](https://doi.org/10.14254/2071-789X.2016/9-2/9) · [Azhar and Reif, Lemma 4.2.2 (1999)](https://users.cs.duke.edu/~reif/paper/azhar/group/group.pub.pdf#page=18)

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

`PermutationClosure.permutation_closure_theorem` combines this graph
equality with stabilization of the multiplication process on `Fin n`.
[Appendix theorem in Lean](PermutationClosure.lean#L138-L148)

Mathlib also states the orbit characterization for labelled Schreier graphs
in `Quiver.SchreierGraph.reachable_iff`. [Mathlib source](https://github.com/leanprover-community/mathlib4/blob/v4.36.0/Mathlib/Combinatorics/Quiver/Schreier.lean#L283-L291)

For the multiplication process, start with $A_0=M$ and take
$A_{r+1}=A_r\cup A_r A_r$. The stopping condition in the formalization
is $A_{r+1}=A_r$. For nonempty $M$, all sufficiently late rounds equal
$\langle M\rangle$. For $M=\varnothing$, every round started from $M$ is
empty, while the generated subgroup contains the identity.
`productRound_insert_one_stabilizes` covers every input by starting from
$M\cup\{1\}$. [Algorithm and lemma in the paper](https://www.economics-sociology.eu/files/ES_9_2_Shvedovsky_Standrik_Bilan.pdf#page=10)

## Check the proof

The project pins Lean and mathlib to v4.36.0. From the repository root,
fetch the compiled imports and build the proof.

```sh
lake exe cache get Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected \
  Mathlib.Data.Fintype.Perm Mathlib.GroupTheory.OrderOfElement Mathlib.Order.OrderIsoNat
lake build
```
