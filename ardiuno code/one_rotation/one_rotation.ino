#define RPWM 10  // Motor driver RPWM
#define LPWM 11  // Motor driver LPWM
#define ENC_A 2  // Encoder Channel A (Hall effect sensor)
#define ENC_B 3  // Encoder Channel B (Hall effect sensor)
#define PPR 260 // Pulses Per Revolution (Gearbox adjusted)
#define MAX_RPM 5700/40  // Motor free speed in RPM (gearbox adjusted)

volatile long encoderTicks = 0;  // Encoder tick count
volatile int direction = 0; // 1 = CW, -1 = CCW
volatile int lastStateA = LOW;    // Stores last known state of ENC_A

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(ENC_A, INPUT);
    pinMode(ENC_B, INPUT);

    Serial.begin(9600);  // Initialize Serial Monitor
    Serial.println("Press 'A' to rotate motor one full revolution.");
    
    // Attach interrupt for encoder channel A (rising edge detection to reduce noise)
    attachInterrupt(digitalPinToInterrupt(ENC_B), countEncoderTicks, CHANGE);
}

void loop() {
    if (Serial.available() > 0) {  // Check for user input
        char command = Serial.read();  // Read input
        
        if (command == 'A' || command == 'a') {  // If 'A' key is pressed
            Serial.println("Motor rotating one full revolution...");
            
            encoderTicks = 0;  // Reset encoder count
            
            // Start motor forward
            analogWrite(RPWM, 150);  // Set speed
            analogWrite(LPWM, 0);

            // Wait until one full revolution is reached
            while (encoderTicks <= PPR) {
                delay(10);  // Small delay to allow encoder updates
                //Serial.println(String(encoderTicks));


            }
            
            // Stop the motor
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Rotation complete.");
        }
    }
}

// ISR: Interrupt Service Routine for encoder counting
//void countEncoderTicks() {
//    int stateB = digitalRead(ENC_B);
//    direction = stateB ? -1 : 1;  // Determine direction based on ENC_B state
//    encoderTicks += direction;  // Increment or decrement based on direction
//    Serial.println(String(encoderTicks));
//
//}

void countEncoderTicks() {
    int stateA = digitalRead(ENC_A);
    int stateB = digitalRead(ENC_B);

    if (stateA != lastStateA) { // Only count when state changes
        if (stateB == LOW) {
            direction = 1;  // Clockwise
        } else {
            direction = -1; // Counterclockwise
        }
        encoderTicks++; // Increment pulse count only on state change
    }

    lastStateA = stateA; // Update last state for next comparison
    //Serial.println("encoder ticks: " + String(encoderTicks));

    // if greater than PPR for one revolution cut off
    if (encoderTicks >= PPR){
      analogWrite(RPWM, 0);
      analogWrite(LPWM, 0);
      Serial.println("inside interupt Rotation complete.");
    }

}
