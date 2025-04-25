#define RPWM 5
#define LPWM 4
#define ENC_A 2
#define ENC_B 3
#define hall_pin 6
#define servo_pin 7
#define PPR 1300
#define MAX_RPM 5700 / 40

#include <Servo.h>

Servo myServo;

volatile long encoderTicks = 0;
volatile bool stopMotor = false;
volatile int lastStateA = LOW;

bool userStop = false;
const int extraTicks = 0;

void setup() {
    pinMode(RPWM, OUTPUT);
    pinMode(LPWM, OUTPUT);
    pinMode(ENC_A, INPUT);
    pinMode(ENC_B, INPUT);
    pinMode(hall_pin, INPUT);
    pinMode(servo_pin, OUTPUT);

    myServo.attach(servo_pin);
    myServo.write(95);

    Serial.begin(9600);
    Serial.println("Commands: A = rotate, G = servo fire, STOP = halt");

    attachInterrupt(digitalPinToInterrupt(ENC_A), countEncoderTicks, CHANGE);
}

void loop() {
    if (Serial.available() > 0) {
        String command = Serial.readStringUntil('\n');
        command.trim();

        if (command.equalsIgnoreCase("STOP")) {
            userStop = true;
            stopMotor = true; // ensure ISR loop is broken
            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("STOPPED.");
            return;
        }

        if (command.equalsIgnoreCase("A") && !userStop) {
            Serial.println("Motor rotating one full revolution...");

            encoderTicks = 0;
            stopMotor = false;

            analogWrite(RPWM, 0);
            analogWrite(LPWM, 255);

            // Main loop — immediately stop motor if condition is met
            while (!stopMotor && !userStop) {
                delay(10);
                Serial.println("Encoder: " + String(encoderTicks));
                Serial.println("n: " + String(digitalRead(hall_pin)));

                if (stopMotor || userStop) {
                    analogWrite(RPWM, 0);
                    analogWrite(LPWM, 0);
                    Serial.println("Motor stopped during active loop.");
                    break;
                }
            }

            // Extra ticks phase (optional)
            long targetTicks = encoderTicks + extraTicks;
            while (encoderTicks < targetTicks && !stopMotor && !userStop) {
                delay(10);
                Serial.println("Encoder Ticks (Extra Phase): " + String(encoderTicks));

                if (stopMotor || userStop) {
                    analogWrite(RPWM, 0);
                    analogWrite(LPWM, 0);
                    Serial.println("Motor stopped during extra phase.");
                    break;
                }
            }

            analogWrite(RPWM, 0);
            analogWrite(LPWM, 0);
            Serial.println("Outside ISR: Rotation complete.");
        }

        if (command.equalsIgnoreCase("G") && !userStop) {
            Serial.println("Servo running...");
            myServo.write(95);
            delay(1000);
            myServo.write(65);
            delay(1000);
            myServo.write(95);
            delay(1000);
            Serial.println("Servo complete.");
        }
    }
}

void countEncoderTicks() {
    int stateA = digitalRead(ENC_A);
    int stateB = digitalRead(ENC_B);
    int stateN = digitalRead(hall_pin);

    if (stateN == 0 && encoderTicks > 200) {
        stopMotor = true;
    }

    if (encoderTicks > 600) {
        stopMotor = true;
    }

    if (stateA != lastStateA) {
        encoderTicks++;
        if (encoderTicks >= PPR) {
            stopMotor = true;
        }
    }

    lastStateA = stateA;
}
