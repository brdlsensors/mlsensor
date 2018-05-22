

// pins
int sig = 1;
int s0 = 2;
int s1 = 3;
int s2 = 4;
int s3 = 5;

// Global counter for cycling through the select lines using interrupts.
int counter = 0;

int val = 0; 
double read1 = 0;
double read2 = 0;
double read3 = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(s0, OUTPUT);
  pinMode(s1, OUTPUT);
  pinMode(s2, OUTPUT);
  pinMode(s3, OUTPUT);
   noInterrupts();           // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1  = 0;

  OCR1A = 625;            // compare match register 16MHz/256/2Hz
  TCCR1B |= (1 << WGM12);   // CTC mode
  TCCR1B |= (1 << CS12);    // 256 prescaler 
  TIMSK1 |= (1 << OCIE1A);  // enable timer compare interrupt
  interrupts();   
}

ISR(TIMER1_COMPA_vect)          // timer compare interrupt service routine
{
//  digitalWrite(ledPin, digitalRead(ledPin) ^ 1);   // toggle LED pin
  if (0 == counter)
  {
    // 0000 - 5V
    digitalWrite(s0, LOW);
    digitalWrite(s1, LOW);
    digitalWrite(s2, LOW);
    digitalWrite(s3, LOW);
    counter = 1;
  }
  else if (1 == counter)
  {
    // 0001 - sensor 1
    digitalWrite(s0, HIGH);
    digitalWrite(s1, LOW);
    digitalWrite(s2, LOW);
    digitalWrite(s3, LOW);
    counter = 2;
  }
  else if (2 == counter)
  {
    // 0010 - 0V
    digitalWrite(s0, LOW);
    digitalWrite(s1, HIGH);
    digitalWrite(s2, LOW);
    digitalWrite(s3, LOW);
    counter = 3;
  }
  else if (3 == counter)
  {
    // 0011 - sensor 2
    digitalWrite(s0, HIGH);
    digitalWrite(s1, HIGH);
    digitalWrite(s2, LOW);
    digitalWrite(s3, LOW);
    counter = 4;
  }
  else if (4 == counter)
  {
    // 0100 - 0V
    digitalWrite(s0, LOW);
    digitalWrite(s1, LOW);
    digitalWrite(s2, HIGH);
    digitalWrite(s3, LOW);
    counter = 5;
  }
  else if (5 == counter)
  {
    // 0101 - sensor 3
    digitalWrite(s0, HIGH);
    digitalWrite(s1, LOW);
    digitalWrite(s2, HIGH);
    digitalWrite(s3, LOW);
    counter = 0;
  }
}


void loop() {
  // put your main code here, to run repeatedly:


//  val = analogRead(sig);
//  read1 = val/1023.0*5.0;
//  delay(100);



//  val = analogRead(sig);
//  read2 = val/1023.0*5.0;
//  delay(100);
  

//  val = analogRead(sig);
//  read3 = val/1023.0*5.0;
//  delay(100);
  
//  Serial.print("C0: ");
//  Serial.print(read1);
//  Serial.print("\tC1: ");
//  Serial.print(read2);
//  Serial.print("\tC2: ");
//  Serial.println(read3);
}
