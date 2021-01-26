stateDiagram-v2
   [*] --> SDL_slot : (USB Device)
   [*] --> Mouse
   Mouse --> Signal : (mouse states)
   [*] --> Keyboard
   Keyboard --> Signal : (keys)
   [*] --> Gamepad
   Gamepad --> DeviceState
   DeviceState --> Dpad
   DeviceState --> Button
   DeviceState --> Axis
   DeviceState --> Hat
   Axis --> Signal
   SDL_slot
   SDL_slot --> SDL
   SDL_Remapping --> SDL
   SDL --> Device : slot_id
   SDL_Gamecontroller_DB --> SDL_Remapping 
   Player --> Device : index
   Player --> Players
   Device --> Devices
   DeviceState --> Thumbstick
   Thumbstick --> Axis : H
   Thumbstick --> Axis : V
   Dpad --> Signal
   Hat --> Signal
   Signal --> Signals
   Button --> Signal
   Player --> Settings
   Binding --> Bindings
   Signal --> Binding : ic_code
   Bindings --> Settings
   Binding --> Action
   Signals --> Binding 
   Signals --> Action : (default from action)
   Signal --> Action : ic_code
   Action --> Actions
   Action --> Behavior : (in the game)
   Behavior --> [*] : (Gameplay)
