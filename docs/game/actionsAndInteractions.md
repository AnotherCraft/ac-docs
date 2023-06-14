# Actions and interactions

This page describes three different, but somewhat related, mechanics:

* Actor actions represented by the `ActorAction` class
* Actor-item actions, represented by the `IA_Action` callback.
* Actor-block interactions, represented by the `BA_Interact` callback.

## Actor actions

Whenever something results in a action that should take some time, the `ActorAction` is the way to go. The class represents an action an `Actor` is performing.

* The action has a predefined duration (and start and end time once it starts).
  * There are however flags like `canFinishPrematurely` or `runForever`.
* The actions are not typed, each action is set up individually.
* Actions do not have components, however they can have standard c++ callback functions assigned to various events like finished, step and such.
* Checks can be added that are evaluated each step and fail the action if they're not met. For example:
  * Failing the action if the actor moves during casting
  * Failing the action if an item is moved outside of the inventory (for example pickaxe that you're trying to swing)
* Once the action starts, it can either finish/succeed, be cancelled (for example player releases the button) or fail (player moves, is killed, ...). Each result can end up calling a different callback.
* Actions usually have some animation that the actor performs during casting.
* Actions can have an `origin` (left hand, right hand, off hand, ...)
* Actions can enforce item equip records during execution - this is for example to prevent the player from initiating a pickaxe swing and then quickly switching to a different item. Thanks to the equip record override, the pickaxe is still displayed in the players hand. Similarly this mechanic is used to enforce temporarily equipping an item action of which was performed off hand.
* Actor's actions are managed by `ActorActionManager`. Only one action can be performed at a time per actor.

## Actor-item interactions

When an user wants to use the item, he does so through the `IA_Action` callback. The action can be triggered by various means, for example by holding the item in a hand and pressing an action button or off-hand from the item context menu, if the action allows it.

Please note that there's separation between actions and their behaviors – there's a separate API using `IA_ExecActionBehavior`  and `IA_CanExecActionBehavior` for that. While it's possible to implement action behavior right into `IA_Action`, the components using `IA_Action` are supposed to be higher level components that define the character of the action and leave the actual action effects on other components based around `IA_ExecActionBehavior` for better separation and making the system more modular and versatile.

* Action behaviors are linked with the actions using the `action` property (defined in `ITCB_ActionBehavior`). When an action triggers a behavior, it calls `IA_ExecActionBehavior` over all behavior components with the same `action`.

To illustrate the concept, let's list item type components based around `IA_Action`:

* `ITC_InstantAction` does not exist (but it makes sense to add it eventually), but if it did, it would immediately trigger related action behaviors and potentially played some animation on the character.
  * There's the symmetrical `BTC_InstantInteraction` that actually exists and does that.
* `ITC_BasicAction` issues an `ActorAction` to the triggering actor and triggers the action behavior when the action finishes. Meaning that this action takes time. It also checks `IA_CanExecActonBehavior` and does not start at all if it fails at the beginning.
  * This action is used for almost anything - swinging pickaxes, swords, drinking potions, ...
* `ITC_ChargingAction` issues an `ActorAction` witch a given charge time, but does not finish the action immediately when the time elapses, but waits for the input to be released. The default behavior is checked and executed at the start, but additional `successAction` (resp. `failureAction`) behavior is triggered upon the action finish.
  * Use case of this component is for example charging a bow.
  * The charge progress can be accessed as an item property.
  * There's also the `successThreshold` that can shift what charge percentage triggers the success behavior.
  * You can also set up a `chargingStatusEffect`.

And now let's introduce some action behavior components. Please note that one action can have multiple behavior components attached – all `IA_CanExecActionBehavior` must succeed in that case and all `IA_ExecActionBehavior` callbacks are executed.

* `ITC_BlockBuildActionBehavior` builds a block.
* `ITC_ModifyStatsActionBehavior` modifies stats - for example it can permanently increase strength, level, and so on.
* `ITC_SpawnEntityActionBehavior` spawns an entity.
* `ITC_ConsumeItemActionBehavior` consumes the item that triggered the behavior.
* `ITC_ConsumeOtherHandItemActionBehavior` consumes an item in the other hand.
  * This requires for the item to be execued on-hand.
  * There's a filter for what must be in the other hand for the behavior to succeed.
  * Use case of this is bow shooting arrows - you put bow in one hand, arrows in the other hand, using the bow consumes arrows that are in the other hand.
* `ITC_ReduceDurabilityActionBehavior` damages the item when used.
* `ITC_DamageActionBehavior` does damage to whatever you're pointing at (entity/block).
  * Use case: swords, pickaxes, ...

## Actor-block interactions

Blocks provide symmetrical action API to the items, except for blocks, it's called "interaction" (instead of "action").

* Symmetrical callbacks are `BA_Interact`, `BA_ExecInteractionBehavior` and `BA_CanExecInteractionBehavior`.
*  Symmetrical interaction components are `BTC_BasicInteraction`, and `BTC_InstantInteraction`.
* There's one more interesting callback, `BA_IndirectlyInteract`. It's similar to `BA_Interact`, but it's called when the player clicks on a neighbouring block  in the direction of the current block (and the neighbouring block doesn't accept the `BA_Interact` callback). This automatically falls back to `b_interact` inside `BTCB_Interaction`.

Some interesting block interaction behaviors:

