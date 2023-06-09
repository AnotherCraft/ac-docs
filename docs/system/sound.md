# Sound effects

- AnotherCraft has the Soloud (https://solhsa.com/soloud/) audio engine implemented. There are a few basic lame sounds added in the game.
- **Audio effects change based on the environment.** When you’re inside caves, you hear reverb. When you go into a wool-surrounded room, everything’s muffled.
  - This is implemented by continuously probing the environment about player using random ray casts and adjusting soloud reverb effect parameters based on that (depending on what block the ray hits and in what distance - blocks can report their audio properties)