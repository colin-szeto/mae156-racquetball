#define LPWM 7  // Motor driver LPWM
#define RPWM 6  // Motor driver RPWM
#define servo_p 5  // Motor driver LPWM
#include <Servo.h>

Servo myServo; // Create a Servo object

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(servo_p, OUTPUT);

    Serial.begin(9600);  // Initialize Serial Monitor
    Serial.println("Press 'A' to rotate motor one full revolution.");
    myServo.attach(5); // Attach the servo to pin 5

}

void loop() {
    if (Serial.available() > 0) {  // Check for user input
        char command = Serial.read();  // Read input
        
        if (command == 'A' || command == 'a') {  // If 'A' key is pressed
            Serial.println("Motor rotating one full revolution...");
                        


            // Fire
            analogWrite(RPWM, 0);  // Set speed
            analogWrite(LPWM, 255);

            delay(2000/2);        // Wait 1 second

            // Reset motor
            analogWrite(RPWM, 100);  // Set speed
            analogWrite(LPWM, 0);

            delay(2000);        // Wait 1 second

            // Stop the motor
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Rotation complete.");


            // servo
/*
            digitalWrite(servo_p,1800);
            myServo.write(0);   // Move to 0 degrees
            delay(1000);        // Wait 1 second

            myServo.write(1800);  // Move to 90 degrees
            delay(1000);        // Wait 1 second
            myServo.write(0); // Move to 180 degrees
            delay(1000);        // Wait 1 second

            Serial.println("servo complete.");
*/
        }
    }
}
