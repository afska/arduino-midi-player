# arduino-midi-player
---------------------
A MIDI File player for [Arduino](http://arduino.cc/), made in [CoffeeScript](https://github.com/jashkenas/coffeescript) (with [node](https://github.com/joyent/node)).

## introduction

### demo
[![screenshot2](https://cloud.githubusercontent.com/assets/1631752/4229016/bafcd452-3966-11e4-9e99-d57b5b198311.png)](https://www.youtube.com/watch?v=hKU2V201VXA)

### features
A subset of the MIDI File specification is implemented.

It supports:
- various tracks
- simultaneous notes in one track
- bpm changes

### limitations
- It does ignore:
	- effects (bend, vibrato...)
	- track's information (instrument\*, volume...)
	- any other non-note events

	\* *be careful with percussion tracks*

- The higher note that the buzzers can play is a *B4*: the exception is the first buzzer, which takes advantage of the Arduino's internal timer.

## usage
### wiring
![screenshot1](https://cloud.githubusercontent.com/assets/1631752/4197936/1f7d0a3a-37f2-11e4-8488-42d5e666f6a3.png)
- up to 5 buzzers simultaneously, connected to pins [3..7]
- a 220Ω resistor for each connected buzzer

### install
```bash
#node is required
npm install grunt-cli
npm install
```

### usage
```bash
#upload sketch/fast/fast.ino to your Arduino board
grunt --midi=examples/pokemon-battle.mid
grunt --midi=examples/mentirosa.mid --firstIddle
```

## theory
### producing notes
The player is made with buzzers. A buzzer makes a clicking sound each time it is pulsed with current. A clicking sound is not funny, but what if we pulse it *440* times in a second? Bingo, we got an *A* note.

### time of a pulse
To produce a square wave with *440hz* of frequency, the time that the pin has to be *HIGH* is *1136us*. How do we know that?

The period is the amount of time it takes for the wave to repeat itself:

![owbvrjqo3925446228614708412](https://cloud.githubusercontent.com/assets/1631752/4197568/f0fd4676-37eb-11e4-9c61-8c550085414e.jpg)

=> we need the buzzer's pin to be *HIGH* in the first half of the period, and *LOW* in the other half =>
```javascript
timeHigh = period / 2 = (1 / frequency) / 2
```

### frequency of a note
The frequency of a note can be calculated (taking by reference an *A* in the 4th octave: *A4 - 440hz*):
```javascript
440 * c^distance
//c: a constant, the twelth root of 2
//distance: semitones between the note and the A4
```

## details for nerds
### nodejs? how?
Arduino boards can be controlled by any computer using the [Firmata Protocol](http://firmata.org/wiki/V2.3ProtocolDetails), particularly by nodejs thanks to the [johnny-five](https://github.com/rwaldron/johnny-five) programming framework: it sends to the board the instructions by the serial connection.

### performance issues
Node is slow. Not really, but it's slower than native C code running on the board. To reach high notes, pauses of very few microseconds are needed. Because of this, the wave-generating part is implemented in the sketch.

### communication node-sketch
The js scripts tells to the sketch what note it has to play and in which speaker: this is made by a pseudo custom protocol. The serial port is used by Firmata to control the board, so extra info can't be appended.

=> The `analogWrite` message was used on a specific port (*3*) for sending notes.

For example, to make the *buzzer 6* to play an *A4*, the messages are:
```c
analogWrite(3, 6); //selected buzzer
analogWrite(3, 1136); //timeHigh of the A4
```

For making the buzzer to stop:
```c
analogWrite(3, 6);
analogWrite(3, 0);
```

### the internal timer
The sketch code (while is optimized to write ports with [direct-io](https://code.google.com/p/digitalwritefast/)), can't handle high frequencies. That limitation impedes the buzzers [4..7] to play high notes. The only one that can play any notes is the *buzzer 3*: it uses the internal timer and the *tone()* function.

### merging tracks
Many times, some MIDI Tracks can be unified: while one is playing notes, another is playing silences. The player makes a mix only with the notes that will be actually played. This depends on the *play modes*.

#### the playing modes
Because the max-note-limitation, there're two modes of playing files:
- **First Iddle**: *(--firstIddle)* It assigns the first iddle buzzer to all notes. This produces more uniform sound when the user is sure that the notes of the MIDI are lower than the max note.
- **High Channel**: *[default]* The notes higher than the max note are assigned to the first buzzer. If two high notes have to sound together, one will be ignored.
