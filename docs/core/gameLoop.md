# Game loop, steps

* The core of the game loop is single-threaded execution (the game might be accessed from multiple threads, but always exclusively through mutex).
  * Further subsystems can utilize their own threads, but they're always independent and are synchronized in the game step.
    * Subsystems that use separate threads:
      * Multiplayer sending/receiving is on a separate thread
      * Chunk loading/generating/unloading is on a separate thread on the server
* The step is done in precise predetermined intervals – 25 times per second currently.
  * The value can be changed however in `Game::stepsPerSecond`.
  * In the future, it could be possible to increase step time if server is not keeping up. This would have to be broadcasted to the clients so that they would also lower their step time locally.



## Game step

Game step contains following steps:

1. Multiplayer step (synchronize with the multiplayer thread, read and process messages).
2. Worlds step
   1. Client/server component world step
   2. Chunk loader step
3. Client component step (audio update)
4. Tasks execution
   1. End step callbacks (entity step, block step, ... whatever that requested end step callback)
   2. Timers execution
5. Server sends `ACP::StepSync`