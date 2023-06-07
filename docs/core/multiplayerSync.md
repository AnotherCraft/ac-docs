# Multiplayer synchronization

* Server is fully authoritative for everything.

* All physics, collisions and such are fully deterministic and the physics is executed both on client and server

  * Server occasionally sends physics updates to the clients to make sure that they're kept in sync. In the meantime the client predicts the physics locally.

* Stuff like block breaking/building, actor stats updates, and so on is always initiated from the server and is not predicted on the client.

* At the end of each step, `ACP::StepSync` message is broadcasted from the server to the clients.

  * Clients keep buffer of incoming messages and always process one step worth of messages on the beginning of their game step. This is to combat network jitter.
    * In the future, a strategy that gradually reduces the buffer size when it gets larger than one could be implemented.

  ##  Player movement

  * Server is fully authoritative in player movement.
  * Server receives controls data each game step and moves the player accordingly.
  * Client however also processes the movement inputs right away, not waiting for the server response/update.
  * When the client receives update of the player position/speed/movement data from the server, it replays  some of the inputs because of client-server delay (https://www.gabrielgambetta.com/client-side-prediction-server-reconciliation.html).
  * Server keeps buffer of received controls snapshots from the client and always processes a single message each step (to combat network jitter).
    * In the future, a strategy that gradually reduces the buffer size when it gets larger than one could be implemented.