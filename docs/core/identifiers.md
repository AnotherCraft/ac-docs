# Identifier

`Identifier` is a type that is supposed to be used instead of strings where the value of the string is not dynamic. It replaces a dynamically allocated string with a single 32-bit number, where each number represents a different string (there's a hash table used for mapping the internal number to actual string). Each number represents a different string, the mappings are never removed during the application run time – thus it is important to only use Identifiers for strings that are not too dynamic. New identifiers (number-string) mappings can be created during the application run however.

Because strings are represented as a single number, they can be compared and copied with a single instruction, so working with Identifiers is very fast.

Typical situations where you want to use Identifier instead of a string:

* Various UIDs
* Hash table/property keys
* Translation keys

Situations where you don't want to be using Identifiers:

* Anything related to user input (chat, user nicknames, ...)
* String accumulators, builders, ...
* If you need to know the string length/content, you usually don't want to use `Identifier`

## Serialization and multiplayer

Identifiers are also used in serialization (multiplayer/gamesave). However:

* Identifier string-number mappings are always local and only kept for a single application run.
* Number mappings are not persistent between application runs.
* Each client/server has different number-string mappings.

Because of the before mentioned rules, there always needs to be a mapping performed when serializing/deserializing data.

* Server has Identifier-IdentifierHandle mapping that is persistent between application runs for a single game (stored within the game save file). This mapping is used for saving/loading data from the save file and for sending data to clients.
* Each client then has its own Identifier-IdentifierHandle mapping for sending data to the server. This mapping does not need to be persistent.
* Server then keeps mappings of client IdentifierHandle->server Identifier for correctly deserializing client messages. And vice versa, client keeps track of server Identifier mappings.
* Clients (and the server, respectively) need to be somehow notified about the mappings. That is what the `ProtocolStateUpdate` message is for - it notifies the clients (or server) about new Identifier-IdentifierHandle mappings. 
* It has to be ensured that `ProtocolStateUpdate` message is sent before new Identifiers are used.