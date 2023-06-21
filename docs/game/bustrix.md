# Bustrix subsystem

Bustrix is AnotherCraft’s solution for all things regarding logic operations, resources transport, automation and such. The core concept is quite simple, but it can be used for a lot of things.

The core concept of the Bustrix system are endpoints and buses (bustrix ~ bus tricks):

- **Endpoints** are blocks that use the bustrix subsystem (specifically, BTC_BustrixEndpoint is a block type component).
    - For example machines that require electricity input, doors that require logical open/close signal, logical gates, levers, …
- Endpoints have **ports.**
    - One endpoint can have any number of ports.
    - Each port has a name assigned and a **bus type** that it can be connected to.
        - For example logical value bus type, power transfer bus type, item transfer bus type, …
- Players can place wires in the world to connect ports between various endpoints.
    - The wires are placed in a separate voxel grid only loosely constrained by the actual world block voxel grid. This means that **wires can be placed inside blocks.** 
    - Multiple wire types can be placed inside one block (limitations can apply).
        - You can for example put energy and logical wire in the same block.
- There’s a **bustrix vision** status effect/stat that makes you see nearby bustrix wires inside blocks. Without the vision, the wires are hidden.
    - The vision is applied when you’re holding a bustrix wire or a tool (also there will be “bustrix goggles” you can equip etc).
- Buses then simply connect ports of endpoints and provide an API to define behavior for the bus. There can be various **bus types** with various functionality/use cases.
    - You can have value-based bus types (value from an output port is distributed to all input ports on the bus) - logical, numerical, …
    - You can have packet-based bus types (basically a mesh network)
    - You can have resource transfer bus types (that can distribute items, liquids, … over the bus)
    - You can have power distribution type bus.
    - The system is very performant because it’s abstracted from the world structure.

![image-20230608112907037](assets/image-20230608112907037.png)

![image-20230608113231627](assets/image-20230608113231627.png)

## Implementation

Bustrix is implemented as a standalone subsystem, injecting its behavior via world/game callbacks like `GA_WorldLoaded`, `GA_ClientConnected`, `WA_DynamicRender` and so on. These callbacks have been added specifically for Bustrix, so they might need some ironing out if they are to be used for something else as well.

Bustrix also has its own separate voxel grid for wire data. The voxel grid is sparse, meaning it's implemented as a hash table `ChunkBlockIndex -> BustrixBlockData` for each chunk.

## Buses construction, value invalidation and such

Endpoint ports connected through wires form buses. Buses are represented by the `BustrixBus` class. The buses are initialized lazily (meaning to `BustrixBus` instance is created until someone requests it) and are destroyed whenever any of the blocks it goes through changes (`World_BustrixComponent_Server::invalidateBuses`) – it has to be created again then.

In an attempt to make this more optimized (reducing array pushes and pops when creating/destroying buses), the buses are stored within a Bloom Filter Tree where the tree key is a bitwise or of hashes (special hash with reduced number of set bits) of all blocks a bus is related with. For retrieving the list of buses that are related to a given block, a hash is computed of the block position and the tree is searched for all record where `lookupKey & recKey == lookupKey`.

## Content

- Bus types
    - `bus.booleanValue`
        - Logical value bus, similar to Minecraft. Endpoint ports can be output (provide value to the bus) or input (read value from the bus). If there are multiple output ports on the bus, the value is ORed.
    - `bus.power`
        - Bus emulating electricity.
        - Each port has a defined capacity and charge level. When connecting ports through a bus, the bus attempts to equalize charge levels of all connected ports, taking charge and discharge limits and capacities into consideration.
- Wire types (also double as items, with the `item.` prefix added)
    - `wire.logical.red`
    - `wire.logical.blue`
    - `wire.logical.lime`
    - `wire.logical.yellow`
    - `wire.electric`
    - `wire.eletric.red`
- Utility things
    - `item.core.bustrixDebugger` - debugging tool for bustrix system
    - `item.core.bustrixWireStripper` - tool you can use for removing wires
    - `item.core.bustrixpiping` - pipe block that can be used to run wires through. The wires inside are visible even without bustrix vision
- Logical endpoints
    - `item.core.lever` - logical output, press to toggle
    - `item.core.ironDoor` - door that can be opened/closed only by logical input
    - `item.core.bustrixAndGate` - simple logical AND gate, two inputs, one output
    - `item.core.bustrixLamp.red` - light that can be turned on/off using logic
- Power endpoints
    - `item.core.solarPanel` - power generator
    - `item.core.battery` - large capacity power port
    - `item.core.oneWayRelay` - transfers all power from input port to output port, can be disabled using the logical `isOn` port
    - `item.core.bustrixlamp.blue` - lamp that requires power to run