## arduino-nodejs-coffee
Template for controlling an *Arduino* from *nodejs* with the *Firmata* protocol. It uses *grunt* for compiling the *coffee-script* sources and watching changes for redeploy.

### setup
```bash
npm install -g grunt-cli
npm install #install dependencies
grunt #run the app, and reload on source changes
```

### hardware
- Led on PIN 12 with 220ohm resistor
