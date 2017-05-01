/*
Script to perform automated appliance switching using relay controlled extension cord. 
Author: Manoj Gulati
PhD (IIIT-Delhi)
-- Sequential control: One appliance at a time
-- Total appliances: 8
-- ON Duration: 2min
-- OFF Duration: 2min
*/

int i;
#define guard_interval 5000
#define duration 10000
#define num_appliances 8
void setup()
{
  // initialize digital pin 0-7 as output.
  for (i = 1; i <= 8; i++)
  {
    pinMode(i, OUTPUT);
    digitalWrite(i, HIGH);
  }
}

void Turn_OFF()
{
  for (i = 1; i <= num_appliances; i++) // Loop to turn OFF all relays
  {
    digitalWrite(i, HIGH);
  }
}
void Turn_ON()
{
  for (i = 1; i <= num_appliances; i++) // Loop to turn OFF all relays
  {
    digitalWrite(i, LOW);
  }
}

// the loop function runs over and over again forever
void loop()
{
  //  Execution set of automated switching circuit
  
    Turn_ON();
    delay(guard_interval);              // wait
    Turn_OFF();
    delay(guard_interval);              // wait

    digitalWrite(1, LOW);digitalWrite(2, HIGH);digitalWrite(3, HIGH);digitalWrite(4, HIGH);  // Load-1
    digitalWrite(5, HIGH);digitalWrite(6, HIGH);digitalWrite(7, HIGH);digitalWrite(8, HIGH);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    digitalWrite(1, HIGH);digitalWrite(2, LOW);digitalWrite(3, HIGH);digitalWrite(4, HIGH);  // Load-2
    digitalWrite(5, HIGH);digitalWrite(6, HIGH);digitalWrite(7, HIGH);digitalWrite(8, HIGH);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    digitalWrite(1, HIGH);digitalWrite(2, HIGH);digitalWrite(3, LOW);digitalWrite(4, HIGH);  // Load-3
    digitalWrite(5, HIGH);digitalWrite(6, HIGH);digitalWrite(7, HIGH);digitalWrite(8, HIGH);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    digitalWrite(1, HIGH);digitalWrite(2, HIGH);digitalWrite(3, HIGH);digitalWrite(4, LOW);  // Load-4
    digitalWrite(5, HIGH);digitalWrite(6, HIGH);digitalWrite(7, HIGH);digitalWrite(8, HIGH);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    digitalWrite(1, HIGH);digitalWrite(2, HIGH);digitalWrite(3, HIGH);digitalWrite(4, HIGH);  // Load-5
    digitalWrite(5, LOW);digitalWrite(6, HIGH);digitalWrite(7, HIGH);digitalWrite(8, HIGH);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    digitalWrite(1, HIGH);digitalWrite(2, HIGH);digitalWrite(3, HIGH);digitalWrite(4, HIGH);  // Load-6
    digitalWrite(5, HIGH);digitalWrite(6, LOW);digitalWrite(7, HIGH);digitalWrite(8, HIGH);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    digitalWrite(1, HIGH);digitalWrite(2, HIGH);digitalWrite(3, HIGH);digitalWrite(4, HIGH);  // Load-7
    digitalWrite(5, HIGH);digitalWrite(6, HIGH);digitalWrite(7, LOW);digitalWrite(8, HIGH);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    digitalWrite(1, HIGH);digitalWrite(2, HIGH);digitalWrite(3, HIGH);digitalWrite(4, HIGH);  // Load-8
    digitalWrite(5, HIGH);digitalWrite(6, HIGH);digitalWrite(7, HIGH);digitalWrite(8, LOW);
    delay(duration);              // wait
    Turn_OFF();
    delay(duration);              // wait

    Turn_ON();
    delay(guard_interval);              // wait
    Turn_OFF();
    delay(guard_interval);              // wait
}
