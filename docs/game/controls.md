# Controls

The game engine has a custom controls system implemented. The controls are fully customizable in the game settings and are stored within the hive.

The most important class of the system is `ControlsEndpoint` – it represents one thingy/action that can be triggered/controlled. An endpoint can have multiple `ControlsBinding`s – those are actual inputs that the endpoint can accept. For example, the endpoint `moveForward` can have bindings "keyboard button W" and "gamepad left joystick Y+".

* A `ControlsEndpoint` has `float value`. For binary inputs, the value would be either 0 or 1, for analog inputs, the value would usually be between 0 and 1.
* The controls enpoint also has `bool isOn`. For binary inputs, the value is the same, for analog inputs, there's debouncing applied - `isOn` goes to `true` when the analog value raises over 0.6 and goes to `false` when the value lowers below 0.4.
* For endpoints with multiple bindings, the last input change message is always considered. So say if you're using two joysticks at the same time for the same endpoint, things will get a bit messy.