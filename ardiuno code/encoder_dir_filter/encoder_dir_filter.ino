#define ENCODER_PIN_A A0  // Encoder Channel A (Analog Pin)
#define ENCODER_PIN_B A1  // Encoder Channel B (Analog Pin)
#define PPR 7             // Pulses Per Revolution
#define MAX_RPM 5700      // Motor free speed in RPM
#define FILTER_SIZE 5     // Number of samples for smoothing

volatile int pulseCount = 0;
volatile int direction = 0; // 1 = CW, -1 = CCW

unsigned long printStartTime = 0;
bool printEnabled = false;

int bufferA[FILTER_SIZE] = {0}; // Moving average buffer for A
int bufferB[FILTER_SIZE] = {0}; // Moving average buffer for B
int bufferIndex = 0;

int getFilteredValue(int pin, int buffer[]) {
  int sum = 0;
  for (int i = 0; i < FILTER_SIZE; i++) {
    sum += buffer[i];
  }
  return sum / FILTER_SIZE; // Return averaged value
}

void checkEncoder() {
  // Read analog values and store them in the buffer
  bufferA[bufferIndex] = analogRead(ENCODER_PIN_A);
  bufferB[bufferIndex] = analogRead(ENCODER_PIN_B);
  bufferIndex = (bufferIndex + 1) % FILTER_SIZE; // Circular buffer

  // Get smoothed values
  int stateA = getFilteredValue(ENCODER_PIN_A, bufferA) > 512 ? 1 : 0;
  int stateB = getFilteredValue(ENCODER_PIN_B, bufferB) > 512 ? 1 : 0;

  static int lastStateA = stateA;
  static int lastStateB = stateB;

  if (stateA != lastStateA) { // A changed, check direction
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

  // Initialize filter buffers
  for (int i = 0; i < FILTER_SIZE; i++) {
    bufferA[i] = analogRead(ENCODER_PIN_A);
    bufferB[i] = analogRead(ENCODER_PIN_B);
  }
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

  checkEncoder(); // Poll encoder with filtering

  if (printEnabled) {
    unsigned long elapsedTime = millis() - printStartTime;

    if (elapsedTime < 5000) { // Print for 5 seconds
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
