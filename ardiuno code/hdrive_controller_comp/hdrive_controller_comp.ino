#define LPWM 7  // Motor driver LPWM
#define RPWM 6  // Motor driver RPWM
#define servo_p 5  // Motor driver LPWM

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(servo_p, OUTPUT);

    Serial.begin(9600);  // Initialize Serial Monitor
    Serial.println("Press 'A' to rotate motor one full revolution.");
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

            // Stop the motor
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Rotation complete.");
        }
    }
}

}
