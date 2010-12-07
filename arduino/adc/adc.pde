// read ADC

int led_pin = 13;
int ad_pin = 0;
boolean led_stat = true;

void setup(){
  pinMode(led_pin, OUTPUT);
  Serial.begin(9600);
  digitalWrite(led_pin, led_stat);
}

void loop(){
  int ad = analogRead(ad_pin);
  Serial.println(ad);
  led_stat = !led_stat;
  digitalWrite(led_pin, led_stat);
  delay(20);
}
