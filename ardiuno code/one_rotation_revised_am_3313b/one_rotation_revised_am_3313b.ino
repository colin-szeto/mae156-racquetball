#define RPWM 5  // Motor driver RPWM
#define LPWM 4  // Motor driver LPWM
#define ENC_A 2  // Encoder Channel A (Hall effect sensor)
#define ENC_B 3  // Encoder Channel B (Hall effect sensor)
#define hall_pin 6  // Motor driver RPWM
#define servo_pin 7  // Motor driver LPWM
#define PPR 1300 // Pulses Per Revolution (Gearbox adjusted)
//#define PPR 200 
#define MAX_RPM 5700/40  // Motor free speed in RPM (gearbox adjusted)
#include <Servo.h>

Servo myServo; // Create a Servo object

volatile long encoderTicks = 0;  // Encoder tick count
//volatile long encoderTicks_after = 0;  // Encoder tick count
volatile bool stopMotor = false; // Flag to signal stopping the motor
volatile int lastStateA = LOW;    // Stores last known state of ENC_A
const int extraTicks = 100; // Extra encoder ticks after stopping condition

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(ENC_A, INPUT);
    pinMode(ENC_B, INPUT);

    pinMode(hall_pin, INPUT);
    pinMode(servo_pin, OUTPUT);

    myServo.attach(servo_pin); // Attach the servo to pin 5
    myServo.write(95);   // Move to 0 degrees

    Serial.begin(9600);  // Initialize Serial Monitor
    Serial.println("Press 'A' to rotate motor one full revolution. G to fire (actuate the servo)");
    
    // Attach interrupt for encoder channel A
    attachInterrupt(digitalPinToInterrupt(ENC_A), countEncoderTicks, CHANGE);
}

void loop() {
    if (Serial.available() > 0) {  // Check for user input
        char command = Serial.read();  // Read input
        
        if (command == 'A' || command == 'a') {  // If 'A' key is pressed
            Serial.println("servo run");
            myServo.write(95);   // Move to 0 degrees
            delay(1000);        // Wait 1 second
            myServo.write(65);  // Move to 90 degrees
            delay(1000);        // Wait 1 second
            myServo.write(95); // Move to 180 degrees
            delay(1000);        // Wait 1 second

            
            myServo.write(95);   // Move to 0 degrees
            delay(1000);        // Wait 1 second
            myServo.write(65);  // Move to 90 degrees
            delay(1000);        // Wait 1 second
            myServo.write(95); // Move to 180 degrees
            delay(1000);        // Wait 1 second
            Serial.println("Motor rotating one full revolution...");
            
            encoderTicks = 0;  // Reset encoder count
            //encoderTicks_after = 0;  // Reset encoder count

            stopMotor = false; // Reset stop flag
            
            // Start motor forward
            analogWrite(RPWM, 0);  // Set speed
            analogWrite(LPWM, 255);

            // Wait until ISR signals to stop
            while (!stopMotor) {
                delay(10);  // Small delay to allow encoder updates
              Serial.println(String(encoderTicks));
              Serial.println("n:   " + String(digitalRead(hall_pin)));

          
            }

            //delay(100);
            // Continue running for extra encoder ticks
            long targetTicks = encoderTicks + extraTicks;
            while (encoderTicks < targetTicks) {
                delay(10);
                Serial.println("Encoder Ticks (Extra Phase): " + String(encoderTicks));
            }
            
            // Stop the motor safely
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Outside ISR: Rotation complete.");
            Serial.println("Press 'A' to rotate motor one full revolution. G to fire (actuate the servo)");
        }
        
    if (command == 'g' || command == 'G') {  // If 
            Serial.println("servo run");
                        

            myServo.write(95);   // Move to 0 degrees
            delay(1000);        // Wait 1 second
            myServo.write(65);  // Move to 90 degrees
            delay(1000);        // Wait 1 second
            myServo.write(95); // Move to 180 degrees
            delay(1000);        // Wait 1 second

            myServo.write(95);   // Move to 0 degrees
            delay(1000);        // Wait 1 second
            myServo.write(65);  // Move to 90 degrees
            delay(1000);        // Wait 1 second
            myServo.write(95); // Move to 180 degrees
            delay(1000);        // Wait 1 second
            Serial.println("servo complete.");

        }
        
    }
    
}

// ISR: Interrupt Service Routine for encoder counting
void countEncoderTicks() {
    int stateA = digitalRead(ENC_A);
    int stateB = digitalRead(ENC_B);

    int stateN = digitalRead(hall_pin);

    if (stateN == 0) {
      if (encoderTicks > 200) {
            //encoderTicks_after = encoderTicks + 100;
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
