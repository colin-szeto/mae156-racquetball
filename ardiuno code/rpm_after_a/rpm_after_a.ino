#define ENCODER_PIN_A 2  // Encoder signal pin (must support interrupts)
#define ENCODER_PIN_B 3  // Optional second encoder pin
#define PPR 7            // Pulses Per Revolution
#define MAX_RPM 5700     // Motor free speed in RPM

volatile int pulseCount = 0; // Pulse counter
unsigned long printStartTime = 0;
bool printEnabled = false; 

void countPulses() {  // Interrupt function (no IRAM_ATTR needed for Arduino)
  pulseCount++;   
}

void setup() {
  Serial.begin(9600);
  Serial.println("Press 'a' to start printing encoder readings for 5 seconds.");
  
  pinMode(ENCODER_PIN_A, INPUT_PULLUP);
  pinMode(ENCODER_PIN_B, INPUT_PULLUP);
  
  attachInterrupt(digitalPinToInterrupt(ENCODER_PIN_A), countPulses, RISING);
}

void loop() {
  if (Serial.available()) {
    char input = Serial.read();
    
    if (input == 'a') {
      printEnabled = true;
      printStartTime = millis(); // Start 5-second timer
      pulseCount = 0; // Reset encoder count
    }
  }

  if (printEnabled) {
    unsigned long elapsedTime = millis() - printStartTime;
    
    if (elapsedTime < 5000) { // Print for 5 seconds
      //int currentPulseCount = pulseCount; // Store pulse count
      //float revolutions = (float)currentPulseCount / PPR;
      //float speedRPM = (revolutions / (elapsedTime / 60000.0)); // Convert to RPM
      int valueA0 = analogRead(A0);
      int valueA1 = analogRead(A1);
      
      Serial.print("A0: ");
      Serial.print(valueA0);
      Serial.print(" | A1: ");
      Serial.println(valueA1);
      
      delay(5); // Adjust print rate
    } else {
      printEnabled = false; // Stop printing after 5 seconds
      Serial.println("Stopped printing encoder readings.");
    }
  }
}
