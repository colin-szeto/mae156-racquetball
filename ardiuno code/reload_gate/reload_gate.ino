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
    Serial.println("Press 'A' to servo move. 'G' for fire");
    myServo.attach(5); // Attach the servo to pin 5
    myServo.write(95);   // Move to 0 degrees

}

void loop() {
    if (Serial.available() > 0) {  // Check for user input
        char command = Serial.read();  // Read input
        
         if (command == 'A' || command == 'a') {  // If 'A' key is pressed
            Serial.println("servo run");
                        

            //digitalWrite(servo_p,1800);
            myServo.write(95);   // Move to 0 degrees
            delay(1000);        // Wait 1 second

            myServo.write(65);  // Move to 90 degrees
            delay(1000);        // Wait 1 second
            myServo.write(95); // Move to 180 degrees
            delay(1000);        // Wait 1 second

            Serial.println("servo complete.");

        }

        if (command == 'g' || command == 'G') {  // If 'A' key is pressed
            Serial.println("fire");
                            // Fire
            analogWrite(RPWM, 200);  // Set speed
            analogWrite(LPWM, 0);

            delay(1100);        // Wait 1 second

            
            // Stop the motor
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Rotation complete.");

        }
    }
}
