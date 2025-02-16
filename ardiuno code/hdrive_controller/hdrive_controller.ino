#define RPWM 10  // Motor driver RPWM
#define LPWM 11  // Motor driver LPWM
#define ENC_A 9  // Encoder Channel A (Hall effect sensor)
#define ENC_B 8  // Encoder Channel B (Hall effect sensor)
#define PPR 7    // Pulses Per Revolution (Update according to your encoder)
#define MAX_RPM 5700  // Motor free speed in RPM

volatile long encoderTicks = 0;  // Encoder tick count
volatile int direction = 0; // 1 = CW, -1 = CCW
unsigned long lastTime = 0; 
volatile int lastStateA = LOW;    // Stores last known state of ENC_A

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(ENC_A, INPUT);
    pinMode(ENC_B, INPUT);

    Serial.begin(9600);  // Initialize Serial Monitor
    Serial.println("Press 'A' to start motor and print encoder readings.");
    
    // Debugging: Check if encoder is working
    Serial.println("Checking Encoder Raw Values...");
    
    // Attach interrupt for encoder channel A (rising and falling edge detection)
    attachInterrupt(digitalPinToInterrupt(ENC_A), countEncoderTicks, CHANGE);
}

void loop() {
    // Debugging Mode: Check if encoder is changing
    Serial.print("Raw ENC_A: ");
    Serial.print(digitalRead(ENC_A));
    Serial.print(" | Raw ENC_B: ");
    Serial.println(digitalRead(ENC_B));
    countEncoderTicks();
    Serial.println(String(encoderTicks));

    //printEncoderData();
    
    if (Serial.available() > 0) {  // Check for user input
        char command = Serial.read();  // Read input
        
        if (command == 'A' || command == 'a') {  // If 'A' key is pressed
            Serial.println("Motor Activated...");
            
            encoderTicks = 0;  // Reset encoder count
            lastTime = millis();

            // Ramp up speed in forward direction
            for (int speed = 0; speed <= 255; speed += 5) {
                analogWrite(RPWM, speed);
                analogWrite(LPWM, 0);
                //printEncoderData();
                countEncoderTicks();
                Serial.println(String(encoderTicks));
                delay(50);
            }

            delay(1000); // Hold at max speed

            // Ramp down speed
            for (int speed = 255; speed >= 0; speed -= 5) {
                analogWrite(RPWM, speed);
                analogWrite(LPWM, 0);
                //printEncoderData();
                countEncoderTicks();
                Serial.println(String(encoderTicks));
                delay(50);
            }

            // Stop the motor
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Motor Stopped.");
        }
    }
}

// ISR: Interrupt Service Routine for encoder counting
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
}
// Function to print encoder readings and RPM
void printEncoderData() {
    float timeElapsed = (millis() - lastTime) / 1000.0;  // Convert to seconds
    lastTime = millis();

    float rpm = (encoderTicks / (float)PPR) * (60.0 / timeElapsed);  // Calculate RPM

    Serial.print("Encoder Ticks: ");
    Serial.print(encoderTicks);
    Serial.print(" | Direction: ");
    Serial.print((direction == 1) ? "Clockwise" : "Counterclockwise");
    Serial.print(" | RPM: ");
    Serial.println(rpm);
}
