# How tree growing works

AnotherCraft contains a simple yet hopefully powerful enough system for generating trees. This system is not part of the worldgen, but is implemented through the following block type components:
* `TreeLeaves`
  * Composite component
  * Provides leaves shape rendering
  * Applies Difficult terrain status effect
  * Gets destroyed when neighbouring tree trunk is destroyed
* `TreeTrunk`
  * Provides trunk shape (with varying thickness and connecting branches)
  * Larger branches collide with player
* `GrowingTreeTrunk`
  * Derived from `TreeTrunk`, adds growing & generating functionality
* `TreeSapling`
  * Sapling, transforms into `TreeTrunk` eventually

## Basic concept

Growing is based on distributing growth points from the base through the trunk.

Growth point routing is based on binomic distribution, so it's possible to process any amoung of growth points at the same time. This allows to grow the trees at any rate (single growth point at a time up to growing the entire tree instantly, useful for worldgen generated trees) with trees looking still the same.

* Every growth point starts in the tree base.
  * Any amount of growth points can be processed at the same time.
  * A tree has a predetermined total growth point count that will be invested to it (= tree size).
* Each block can decide if the growth point will be invested to the block or if it will be routed to an available direction (either child trunk block, empty space or where leaves are - leaves will be despawned and a trunk block will be spawned).
  * Investing a growth point either spawns a new trunk block (if there was no trunk block before) with the smallest thickness or increasing the thickness of the block.
  * When a trunk block is spawned, leaves are also spawned according to the leaves spawning rules. Leaves are only spawned when a new trunk block is created.
* There is the concept of main and side branches.
  * Each trunk block has 0 or 1 main branch directions. This represents the continuing direction of the current branch.
  * Trunk can also have any amount of side branches.

### Tree trunk properties
* Each trunk has a thickness value (`minThickness`-`maxThickness`, stored in 5 bits in small data -> growth point increases the thickness in 1/32 increments).
  * It is generally assumed that due to investment rules, thickness decreases with the distance from the tree base.
  * Trunks with thickness under `thicknessCollisionThreshold` do not collide and can be walked through.
* When a trunk is mined, all child trunks get destroyed as well (`minedCascade` reason).
  * When a trunk block is destroyed, all neighbouring tree blocks get destroyed too.

## The algorithm
Tree growing is determined based on `TreeGrowthParams` parameters (modapi `actrees`). These parameters are calculated by the mod api and can differ for each trunk block in the tree. They are obtained by calling the function defined in the `params` property with prototype `(a: ac.TreeGrowthParamsArgs) : ac.TreeGrowthParams`. The function should be pure, the results shoudl be based solely on the data provided in  `ac.TreeGrowthParamsArgs` (otherwise the algorithm is not guaranteed to work properly).

See `actrees.ts` for documentation of the specific parameters and params.

The following algorithm is effectively performed for each growth point (thanks to the binomic distributions multiple growth points can be processed at the same time).

1. Start at base tree trunk
1. Until the growth point is invested:
   1. Determine if the point should be invested into the current trunk block.
      * If the current block is at maximum thickness, skip this step.
      * If there is no trunk block on the current position, the points is always invested into spawning the trunk.
         * In this case, leaves are also spawned on available positions around the block with `leavesXXProbability` probability (for each direction, the largest matching probability is considered).
      * Otherwise the point is invested with `selfInvestment` probability.
   1. Determine main branch (= continuing direction of the current branch).
      * `growXXProbability` probabilities are **sequentially** (directions lower in the list are tested only after the previous tests fail) tested, the first successfull roll determines the direction.
   1. Determine directions of the side branches.
      * For each avaialble direction, the largest `branchXXProbability` matching the direction is selected and tested. If the roll succeeds, a side branch is determined to be in that direction.
        * For example for testing the up direction, the larger of `branchProbability` and `branchUpwardsProbability` is selected and rolled for.
   1. Determine if the growth point should be invested into one of the side branches.
      * Chance of the growth point being invested in one of the side branches is `sideBranchInvestment * (number of side branch)`. If the roll is successfull, an available side branch is selected at random for the point to be invested into.
      * If the chance of the point being invested to the main branch would be lower than the chance of it being invested into one of the side branches (`1 - sideBranchInvestment * (number of side branch) <= sideBranchInvestment`), the concept of main branch is forfeited and the main branch is considered as one of the side branches.
   1. If the point was not invested in the current trunk or one of the side branches, invest it into the main branch.