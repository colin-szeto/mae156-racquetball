#define ENCODER_PIN_A A0  // Encoder Channel A (Analog Pin)
#define ENCODER_PIN_B A1  // Encoder Channel B (Analog Pin)
#define PPR 7            // Pulses Per Revolution
#define MAX_RPM 5700     // Motor free speed in RPM

volatile int pulseCount = 0;
volatile int lastStateA = 0;
volatile int lastStateB = 0;
volatile int direction = 0; // 1 = CW, -1 = CCW

unsigned long printStartTime = 0;
bool printEnabled = false;

void checkEncoder() {
  int stateA = analogRead(ENCODER_PIN_A) > 512 ? 1 : 0; // Convert analog signal to digital
  int stateB = analogRead(ENCODER_PIN_B) > 512 ? 1 : 0; // Convert analog signal to digital

  if (stateA != lastStateA) { // Change detected
    if (stateA == stateB) {
      direction = 1; // Clockwise
    } else {
      direction = -1; // Counterclockwise
    }
    pulseCount++;
  }

  lastStateA = stateA;
  lastStateB = stateB;
}

void setup() {
  Serial.begin(9600);
  Serial.println("Press 'a' to start printing encoder readings for 5 seconds.");

  lastStateA = analogRead(ENCODER_PIN_A) > 512 ? 1 : 0;
  lastStateB = analogRead(ENCODER_PIN_B) > 512 ? 1 : 0;
}

void loop() {
  if (Serial.available()) {
    char input = Serial.read();
    if (input == 'a') {
      printEnabled = true;
      printStartTime = millis();
      pulseCount = 0;
    }
  }

  checkEncoder(); // Manually poll the encoder since no interrupts are available on analog pins

  if (printEnabled) {
    unsigned long elapsedTime = millis() - printStartTime;

    if (elapsedTime < 10000) { // Print for 10 seconds
      Serial.print("Pulses: ");
      Serial.print(pulseCount);
      Serial.print(" | Direction: ");

      if (direction == 1) {
        Serial.println("Clockwise");
      } else if (direction == -1) {
        Serial.println("Counterclockwise");
      } else {
        Serial.println("Stopped");
      }

      delay(5);
    } else {
      printEnabled = false;
      Serial.println("Stopped printing encoder readings.");
    }
  }
}
