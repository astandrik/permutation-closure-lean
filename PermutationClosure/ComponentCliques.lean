module

public import Mathlib.Combinatorics.SimpleGraph.Connectivity.Connected

/-!
# Complete graphs on the connected components of a simple graph
-/

public section

namespace SimpleGraph

/-- Joining every pair of distinct reachable vertices gives the union of the
complete graphs on the connected components of `G`. Each clique is included
in the original vertex set by `spanningCoe`. -/
theorem fromRel_reachable_eq_iSup_completeGraph {V : Type*} (G : SimpleGraph V) :
    fromRel G.Reachable =
      ⨆ C : G.ConnectedComponent, (completeGraph C.supp).spanningCoe := by
  ext x y
  simp [iSup_adj, spanningCoe, map_adj', Subtype.exists, ← ConnectedComponent.eq, eq_comm]

end SimpleGraph
