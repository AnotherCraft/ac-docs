# Currently unsolved problems

- Ray casts reported to server are not checked/validated
- Players can see items in other players inventories (otherwise we’d have problem with handheld items - probably needs solving)
  - Possibly this could be turned into a feature. We could then have private inventories which other players could not see into, but those would not be accessible from hotbars.
- We’ll need some access-token based system for accessing block & entity inventories and such
- `ACP::ChunkRequest` is always granted, even if it's really far from the client