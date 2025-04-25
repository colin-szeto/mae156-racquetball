#include <Servo.h>

Servo myServo;  // Create servo object

void setup() {
  myServo.attach(9);  // Connect servo signal to pin 9
}

void loop() {
  // Sweep from 0 to 180 degrees
  for (int angle = 0; angle <= 180; angle++) {
    myServo.write(angle);
    delay(15);  // Wait for the servo to reach the position
  }

  // Sweep back from 180 to 0 degrees
  for (int angle = 180; angle >= 0; angle--) {
    myServo.write(angle);
    delay(15);
  }
}
