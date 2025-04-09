#define RPWM 4  // Motor driver RPWM
#define LPWM 5  // Motor driver LPWM
#define ENC_A 2  // Encoder Channel A (Hall effect sensor)
#define ENC_B 3  // Encoder Channel B (Hall effect sensor)
#define PPR 805*1.5 // Pulses Per Revolution (Gearbox adjusted)
#define MAX_RPM 5700/40  // Motor free speed in RPM (gearbox adjusted)

#define Signal1 6
#define Signal2 7
// docs https://docs.revrobotics.com/rev-crossover-products/sensors/magnetic-limit-switch/specs
// 1 high nominal
// 0 low detected magnet

volatile long encoderTicks = 0;  // Encoder tick count
volatile bool stopMotor = false; // Flag to signal stopping the motor
volatile int lastStateA = LOW;    // Stores last known state of ENC_A

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(ENC_A, INPUT);
    pinMode(ENC_B, INPUT);
    
    pinMode(Signal1, INPUT);
    pinMode(Signal2, INPUT);

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
            Serial.println("n:   " + String(digitalRead(Signal1)));
            Serial.println("n+1: " + String(digitalRead(Signal2)));

          
            }
            
            // Stop the motor safely
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Outside ISR: Rotation complete.");
            Serial.println("Press 'A' to rotate motor one full revolution.");
        }
    }
}

// ISR: Interrupt Service Routine for encoder counting
void countEncoderTicks() {
    int stateA = digitalRead(ENC_A);
    int stateB = digitalRead(ENC_B);

    int stateN = digitalRead(Signal1);
    int stateN_1 = digitalRead(Signal2);


    if (stateN == 0) {
      if (encoderTicks > 400) {
            stopMotor = true;  // Signal to stop the motor
      }
    
    }

    if (stateN_1 == 0) {
      if (encoderTicks > 400) {
            stopMotor = true;  // Signal to stop the motor
      }    
    }
    if (stateA != lastStateA) { // Only count when state changes
        encoderTicks++;
        
        if (encoderTicks >= PPR) {  // Stop after one revolution
            stopMotor = true;  // Signal to stop the motor
        }
    }

    lastStateA = stateA; // Update last state
}
