#include <Wire.h>
#include <Firmata.h>
#include "digitalWriteFast.h"

//This sketch has the only things that are necessary
//to run the MIDI player, so probably is faster.

//--------------------------------------------------
//Pin for sending data through analogWrite:
#define BUZZER_LOGIC_PORT 3

//Pin for the buzzer that uses tone() (for higher pitch):
#define BUZZER_TONE_PORT 3

#define PIN_FROM 3 //start of the buzzers array
#define PIN_TO 7 //end of the buzzers array

typedef struct {
  //Activated or not:
  boolean activated;

  //If it's HIGH or LOW:
  boolean on;

  //Time that it will be in HIGH (microseconds):
  unsigned int highTime;

  //Last time the *on* value has changed:
  unsigned long lastTime;
} buzzer;

//Array of buzzers:
buzzer buzzers[TOTAL_PINS];

//The next message will belong to this buzzer:
byte next_buzzer = BUZZER_TONE_PORT;
//--------------------------------------------------

byte reportPINs[TOTAL_PORTS];
byte previousPINs[TOTAL_PORTS];

byte pinConfig[TOTAL_PINS];
byte portConfigInputs[TOTAL_PORTS];
int pinState[TOTAL_PINS];

void outputPort(byte portNumber, byte portValue, byte forceSend) {
  portValue = portValue & portConfigInputs[portNumber];

  if (forceSend || previousPINs[portNumber] != portValue) {
    Firmata.sendDigitalPort(portNumber, portValue);
    previousPINs[portNumber] = portValue;
  }
}

void setPinModeCallback(byte pin, int mode) {
  if (pin < TOTAL_PINS) {
    pinState[pin] = 0;
    digitalWriteFast(PIN_TO_DIGITAL(pin), LOW);
    pinModeFast(PIN_TO_DIGITAL(pin), OUTPUT);
    pinConfig[pin] = OUTPUT;
  }
}

void analogWriteCallback(byte pin, int value) {
  //--------------------------------------------------
  if (pin != BUZZER_LOGIC_PORT) return;

  if (value >= PIN_FROM && value <= PIN_TO) {
    //Set the buzzer for the next message:
    next_buzzer = value;
  } else {
    if (next_buzzer == BUZZER_TONE_PORT) {
      //(De)activate the tone buzzer:
      if (value > 0)
        tone(BUZZER_TONE_PORT, 1000000 / (value * 2));
      else
        noTone(BUZZER_TONE_PORT);
    } else {
      //(De)activate the normal buzzer:
      buzzers[next_buzzer].activated = value != 0;
      buzzers[next_buzzer].on = false;
      buzzers[next_buzzer].highTime = value;
      buzzers[next_buzzer].lastTime = micros();

      if (value == 0) {
        digitalWriteFast(next_buzzer, LOW);
      }
    }
  }
  //--------------------------------------------------
}

void digitalWriteCallback(byte port, int value) {
  byte pin, lastPin, mask=1, pinWriteMask=0;

  if (port < TOTAL_PORTS) {
    lastPin = port*8+8;
    if (lastPin > TOTAL_PINS) lastPin = TOTAL_PINS;
    for (pin=port*8; pin < lastPin; pin++) {
      if (IS_PIN_DIGITAL(pin)) {
        if (pinConfig[pin] == OUTPUT || pinConfig[pin] == INPUT) {
          pinWriteMask |= mask;
          pinState[pin] = ((byte)value & mask) ? 1 : 0;
        }
      }
      mask = mask << 1;
    }
    writePort(port, (byte)value, pinWriteMask);
  }
}

void reportDigitalCallback(byte port, int value) {
  if (port < TOTAL_PORTS) {
    reportPINs[port] = (byte)value;
  }
}

void sysexCallback(byte command, byte argc, byte *argv) {
  switch(command) {
  case EXTENDED_ANALOG:
    if (argc > 1) {
      int val = argv[1];
      if (argc > 2) val |= (argv[2] << 7);
      if (argc > 3) val |= (argv[3] << 14);
      analogWriteCallback(argv[0], val);
    }
    break;
  case CAPABILITY_QUERY:
    Serial.write(START_SYSEX);
    Serial.write(CAPABILITY_RESPONSE);
    for (byte pin=0; pin < TOTAL_PINS; pin++) {
      Serial.write((byte)INPUT);
      Serial.write(1);
      Serial.write((byte)OUTPUT);
      Serial.write(1);
      Serial.write(127);
    }
    Serial.write(END_SYSEX);
    break;
  case PIN_STATE_QUERY:
    if (argc > 0) {
      byte pin=argv[0];
      Serial.write(START_SYSEX);
      Serial.write(PIN_STATE_RESPONSE);
      Serial.write(pin);
      if (pin < TOTAL_PINS) {
        Serial.write((byte)pinConfig[pin]);
        Serial.write((byte)pinState[pin] & 0x7F);
        if (pinState[pin] & 0xFF80) Serial.write((byte)(pinState[pin] >> 7) & 0x7F);
        if (pinState[pin] & 0xC000) Serial.write((byte)(pinState[pin] >> 14) & 0x7F);
      }
      Serial.write(END_SYSEX);
    }
    break;
  case ANALOG_MAPPING_QUERY:
    Serial.write(START_SYSEX);
    Serial.write(ANALOG_MAPPING_RESPONSE);
    for (byte pin=0; pin < TOTAL_PINS; pin++) {
      Serial.write(IS_PIN_ANALOG(pin) ? PIN_TO_ANALOG(pin) : 127);
    }
    Serial.write(END_SYSEX);
    break;
  }
}

void systemResetCallback()
{
  for (byte i=0; i < TOTAL_PORTS; i++) {
    reportPINs[i] = false;
    portConfigInputs[i] = 0;
    previousPINs[i] = 0;
  }

  for (byte i=0; i < TOTAL_PINS; i++)
      setPinModeCallback(i, OUTPUT);
}

void setup()
{
  Firmata.setFirmwareVersion(FIRMATA_MAJOR_VERSION, FIRMATA_MINOR_VERSION);

  Firmata.attach(ANALOG_MESSAGE, analogWriteCallback);
  Firmata.attach(DIGITAL_MESSAGE, digitalWriteCallback);
  Firmata.attach(REPORT_DIGITAL, reportDigitalCallback);
  Firmata.attach(SET_PIN_MODE, setPinModeCallback);
  Firmata.attach(START_SYSEX, sysexCallback);
  Firmata.attach(SYSTEM_RESET, systemResetCallback);

  Firmata.begin(57600);
  systemResetCallback();
}

void loop()
{
  while (Firmata.available())
    Firmata.processInput();

  //--------------------------------------------------
  //Toggle activated pins (if it's time to do it):
  for (int i = PIN_FROM; i <= PIN_TO; i++) {
    if (buzzers[i].activated) {
      unsigned long newTime = micros();
      if (newTime - buzzers[i].lastTime >= buzzers[i].highTime) {
        buzzers[i].on = !buzzers[i].on;
        digitalWriteFast(i, buzzers[i].on ? HIGH : LOW);
        buzzers[i].lastTime = newTime;
      }
    }
  }
  //--------------------------------------------------
}
