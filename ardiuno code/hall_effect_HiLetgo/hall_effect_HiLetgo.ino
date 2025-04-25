// Define the pin for the Hall sensor
//https://www.amazon.com/dp/B01NBE2XIR?ref=ppx_yo2ov_dt_b_fed_asin_title
#include <Servo.h>

const int hallSensorPin = 8;   // Hall sensor input
const int pwmOutputPin = 3;    // Custom PWM output pin
Servo myServo;  // Create servo object

void setup() {
  pinMode(hallSensorPin, INPUT);
  pinMode(pwmOutputPin, OUTPUT);
  Serial.begin(9600);
  myServo.attach(4);  // Connect servo signal to pin 9

}

void loop() {
  int sensorState = digitalRead(hallSensorPin);

  if (sensorState == LOW) {  // Magnet detected
    Serial.println("Magnet detected! singal high");

    // Send custom PWM: 50 Hz -> 20ms period, with 1.5ms pulse width
    digitalWrite(pwmOutputPin, HIGH);
    delayMicroseconds(1800);           // 1.5 ms pulse width
    digitalWrite(pwmOutputPin, LOW);
    delay(18);                          // Rest of the 20 ms period
    delayMicroseconds(500);            // Fine-tune to hit ~20 ms total
  } else {
    Serial.println("No magnet. singal low");

    // Optional: Keep pin LOW or turn off signal
    digitalWrite(pwmOutputPin, LOW);
    myServo.writeMicroseconds(1500);  // Connect servo signal to pin 9

    delay(20); // Match the cycle time
  }
}
