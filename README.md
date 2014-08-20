## arduino-midi-player
MIDI player with buzzers @ Arduino. The device is controlled from *nodejs* with the *Firmata* protocol. It uses *grunt* for compiling the *coffee-script* sources and watching changes for redeploy.
This is recontra experimental. Sí, recontra. Tengo que editar el readme también :D

### setup
```bash
npm install -g grunt-cli #install the task-runner
npm install #install dependencies
grunt #run the app, and reload on source changes
```

node-inspector
google-chrome

### hardware
- Led on PIN 12 with 220ohm resistor
