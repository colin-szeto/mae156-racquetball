#define Signal1 8
//#define Signal2 9
// docs https://docs.revrobotics.com/rev-crossover-products/sensors/magnetic-limit-switch/specs
// 1 high nominal
// 0 low detected magnet


void setup() {
  // put your setup code here, to run once:
    pinMode(Signal1, INPUT);
    //pinMode(Signal2, INPUT);

    Serial.begin(9600);  // Initialize Serial Monitor
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.println("n:   " + String(digitalRead(Signal1)));
  //Serial.println("n+1: " + String(digitalRead(Signal2)));
  delay(100);  // Small delay to allow encoder updates

}
