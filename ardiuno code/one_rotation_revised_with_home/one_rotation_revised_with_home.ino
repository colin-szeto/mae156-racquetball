#define RPWM 6  // Motor driver RPWM
#define LPWM 7  // Motor driver LPWM
#define ENC_A 2  // Encoder Channel A (Hall effect sensor)
#define ENC_B 3  // Encoder Channel B (Hall effect sensor)
#define PPR 900 // Pulses Per Revolution (Gearbox adjusted)
#define MAX_RPM 5700/40  // Motor free speed in RPM (gearbox adjusted)

volatile long encoderTicks = 0;  // Encoder tick count
volatile bool stopMotor = false; // Flag to signal stopping the motor
volatile int lastStateA = LOW;    // Stores last known state of ENC_A

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(ENC_A, INPUT);
    pinMode(ENC_B, INPUT);

    Serial.begin(9600);  // Initialize Serial Monitor
    Serial.println("Press 'A' to rotate motor one full revolution.");
    
    // Attach interrupt for encoder channel A
    attachInterrupt(digitalPinToInterrupt(ENC_A), countEncoderTicks, CHANGE);
}

void loop() {
    if (Serial.available() > 0) {  // Check for user input
        char command = Serial.read();  // Read input
        
        if (command == 'A' || command == 'a') {  // If 'A' key is pressed
            Serial.println("Motor rotating one full revolution...");
            
            encoderTicks = 0;  // Reset encoder count
            stopMotor = false; // Reset stop flag
            
            // Start motor forward
            analogWrite(RPWM, 0);  // Set speed
            analogWrite(LPWM, 255);

            // Wait until ISR signals to stop
            while (!stopMotor) {
                delay(10);  // Small delay to allow encoder updates
              Serial.println(String(encoderTicks));

          
            }
            
            // Stop the motor safely
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);

            delay(1000);        // Wait 1 second
            // running in the anti clockwise direciton 

            // Reset motor
            analogWrite(RPWM, 50);  // Set speed
            analogWrite(LPWM, 0);

            delay(2000);        

            // Stop the motor
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Rotation complete.");
            

            Serial.println("Outside ISR: Rotation complete.");
            Serial.println("Press 'A' to rotate motor one full revolution.");
        }
    }
}

// ISR: Interrupt Service Routine for encoder counting
void countEncoderTicks() {
    int stateA = digitalRead(ENC_A);
    int stateB = digitalRead(ENC_B);

    if (stateA != lastStateA) { // Only count when state changes
        encoderTicks++;
        
        if (encoderTicks >= PPR) {  // Stop after one revolution
            stopMotor = true;  // Signal to stop the motor
        }
    }

    lastStateA = stateA; // Update last state
}
