# Game loop, steps

* The core of the game loop is single-threaded execution (the game might be accessed from multiple threads, but always exclusively through mutex – `GameLocker` is responsible for locking the game thread).
  * Further subsystems can utilize their own threads, but they're always independent and are synchronized in the game step.
    * Subsystems that use separate threads:
      * Multiplayer sending/receiving is on a separate thread
      * Chunk loading/generating/unloading is on a separate thread on the server
* The step is done in precise predetermined intervals – 25 times per second currently. This is done on a separate game thread (not the main GUI thread).
  * The value can be changed however in `Game::stepsPerSecond`.
  * In the future, it could be possible to increase step time if server is not keeping up. This would have to be broadcasted to the clients so that they would also lower their step time locally.
* Asynchronously to this, a rendering step is done each frame, during part of which the game is also locked.
  * To prevent the rendering thread from waiting during `gameStep` processing, escape points during the `gameStep` procedure are added that allow temporarily pausing the game step and passing the mutex to the rendering thread - `GameLocker::priorityWindow()`.


## Game step

Game step contains following steps:

1. Multiplayer step (synchronize with the multiplayer thread, read and process messages).
2. Worlds step
   1. Client/server component world step
   2. Chunk loader step
3. Client component step (audio update)
4. In the future, there could be a "parallel step" here, where the game state would be immutable, but actors could read from it in parallel and do some processing.
   * This would be followed by a sequential "post parallel step" that would apply the computations.
   * This could be utilized for example for physics processing (assuming there would be some resolution mechanics if two dynamic objects would be colliding with each other), liquid/energy simulations and so on.
5. Tasks execution
   1. End step callbacks (entity step, block step, ... whatever that requested end step callback)
   2. Timers execution
6. Server sends `ACP::StepSync`