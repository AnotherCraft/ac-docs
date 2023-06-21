# `WorldEvent`
WorldEvent is an identifier for various world event types. There are currently only statically defined world event types (by enum), in the future, there will be a possibility to dynamically define world event types.

The idea of world events is that certain blocks/entities/whatever might require for example to do some code each world step, receive notification when block around them changes etc. When such situation happens, blocks/entities that are interesting in receiving such event are looked up and appropriate functions are called for them.

Because only a very small portion of blocks/events require such information, it would be very inefficient if the event handlers would be called for each block in the world. For that, event subscription system is in place. Blocks/entities/... have to first subscribe to a given event to receive the notifications (and unsubscribe after they no longer need receiving it).

Event subscription is transitive, meaning if a block is subscribed to an event, the chunk the block is in is subscribed, too.

## Events list
### `ChunkPostWorldEnter`
When blocks subscribe to this event, they receive `b_postWorldEnter` right after the chunk the block is in enters the world (after being loaded from the database/generated). The only time where it is effective to subscribe to this event is in the `b_preWorldEnter` function.

### `ChunkPreWorldExit`
When blocks subscribe to this event, they receive `b_preWorldExit` right before the chunk is unloaded from the world.

### `DynamicRender`
Blocks subscribing to this event receive `b_dynamicRender` perpetually every frame.