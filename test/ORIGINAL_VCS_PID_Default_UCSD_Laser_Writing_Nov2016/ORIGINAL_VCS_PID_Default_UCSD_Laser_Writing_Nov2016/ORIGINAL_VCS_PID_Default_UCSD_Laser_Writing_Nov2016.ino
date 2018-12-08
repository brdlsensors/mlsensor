//Pin intialization
// motor 1
  int  motor1_Enable_Pin = 43;
  int  motor1_Direction_Pin = 44;
  int  motor1_Clock_Pin = 45;
  int  motor1_Back_LS = 51;
  int  motor1_Forward_LS = 52;
  int  pressure_Sensor1_signal = A1;

//motor 2
  int  motor2_Enable_Pin = 46;
  int  motor2_Direction_Pin = 47;
  int  motor2_Clock_Pin = 12;
  int  motor2_Back_LS = 49;
  int  motor2_Forward_LS = 50;
  int  pressure_Sensor2_signal = A2;

//motor 3
  int  motor3_Enable_Pin = 13;
  int  motor3_Direction_Pin = 11;
  int  motor3_Clock_Pin = 10;
  int  motor3_Back_LS = 9;
  int  motor3_Forward_LS = 8;
  int  pressure_Sensor3_signal = A3;
  
void setup() {
  Serial.begin(250000);
  
  //Motor 1
  
  pinMode(motor1_Enable_Pin,OUTPUT);
  pinMode(motor1_Direction_Pin,OUTPUT);
  pinMode(motor1_Clock_Pin,OUTPUT);
  pinMode(motor1_Back_LS,INPUT);
  pinMode(motor1_Forward_LS,INPUT);

  digitalWrite(motor1_Enable_Pin,HIGH);

  //Motor 2
  
  pinMode(motor2_Enable_Pin,OUTPUT);
  pinMode(motor2_Direction_Pin,OUTPUT);
  pinMode(motor2_Clock_Pin,OUTPUT);
  pinMode(motor2_Back_LS,INPUT);
  pinMode(motor2_Forward_LS,INPUT);

  digitalWrite(motor2_Enable_Pin,HIGH);
  
  //Motor 3
  
  pinMode(motor3_Enable_Pin,OUTPUT);
  pinMode(motor3_Direction_Pin,OUTPUT);
  pinMode(motor3_Clock_Pin,OUTPUT);
  pinMode(motor3_Back_LS,INPUT);
  pinMode(motor3_Forward_LS,INPUT);

  digitalWrite(motor3_Enable_Pin,HIGH);

}

//inorout => 49 = pushing forwards
//inorout => 48 = pushing backwards
//inorout => 50 = stop
int inorout1=49;
int inorout2=49;
int inorout3=49;

//preallocation for deley value for varying motor speed with PID
float delay_val1 = 2000;
float delay_val2 = 2000;
float delay_val3 = 2000;

// PID Parameters
int Kp = 10;
int Ki = 0.05;
int Kd = 30;

//PID tolerance 
int integralThresh = 1000;
float pressureThresh = 0.15;

//preallocation for integral values for PID
int integ1 = 0;
int integ2 = 0;
int integ3 = 0;

//set points for path following
const int numPoints = 48; // number of waypoints in the path.
float setpt1[numPoints] = {-1.75,-2,-1,   1,.25,-.25,-.5,-1,-1,-.75,0,.5,.75,1,    1.75,1.75,2,1.25,1,1.25,1.5,1.5,  1.75,1.75,2,2.5,2.5,2.25,2.5,2.75,3.5,2.75,  2.75,2.75,2.75,2.75,2.75,2.75,3.25,3.75,3.25,3.25,  3.25,0,-0.75,-0.75,-1,-2};
float setpt2[numPoints] = {0,0,1.5,      .75,.75,.75,.75,.75,.75,.5,.25,.25,.25,.25,    0.25,0.25,1.5,1.5,1.5,1.75,2,1.25,  1.25,1.5,1.5,1.25,1.25,1.25,1.25,1.25,1.25,1.25,  0.5,1,1.75,2,1.75,1,1,1,1,1,  -2,-2,-2,-0.5,-0.5,-0.5};
float setpt3[numPoints] = {0,-1.75,-1.75,   -2.75,-2.5,-2.25,-2.25,-2,-1.5,-.75,-1,-1,-1,-1,   1.5,1,1,1,1.25,1.75,2.5,2.5,  2.75,3.25,3.25,3.5,2.75,2.25,2,2.25,2.75,3,  2.75,3.25,4,4.5,5,4.5,4.75,4,3.25,2.5,  3.5,3.5,1.5,1,0,-1};

//preallocation for current pressure values
float curr1 = 0;
float curr2 = 0;
float curr3 = 0;

//preallocation for previous pressure values
float prev1 = 0;
float prev2 = 0;
float prev3 = 0;

//preallocation for error value between desired and current position
float err1 = 0;
float err2 = 0;
float err3 = 0;

//sum of all PID terms
float drive1 = 0;
float drive2 = 0;
float drive3 = 0;

//absolute value of drive variable
float drive1abs = 0;
float drive2abs = 0;
float drive3abs = 0;

//time passed since last step to be used for PID speed control
float timer1 = 0;
float timer2 = 0;
float timer3 = 0;

//compare timer with time_passed to evaluate elapsed time
float time_passed1 = 0;
float time_passed2 = 0;
float time_passed3 = 0;

//flag for reseting motor stage
int reset_motors = 0;

//preallocation for input value - when input is 1 from serial after reset motors, program will start
int run_stop = 0;

//pressure sensors parameters
int Vsupply = 5;
int Pmax = 150; //psi
int Pmin = 0;

//preallocation for elapsed time since all 3 units are at desired pressures
float SetPointTimer1 = 0;
float SetPointTimer2 = 0;
float SetPointTimer3 = 0;

//preallocation for is unit at desired pressure +- Threshhold
int SetPointOn1 = 0;
int SetPointOn2 = 0;
int SetPointOn3 = 0;

//count for current set point number
int count1 = 0;
int count2 = 0;
int count3 = 0;

// counter for moving initial starting point to middle of syringe for enabling vacuum use.
int stepCount = 0; 


void loop() {

//Reset motors
//reset motor 1
if (reset_motors == 0){
while (digitalRead(motor1_Back_LS)==LOW || digitalRead(motor2_Back_LS)==LOW || digitalRead(motor3_Back_LS)==LOW){
if (digitalRead(motor1_Back_LS)==LOW){ 
           digitalWrite(motor1_Enable_Pin,LOW);
           digitalWrite(motor1_Direction_Pin,HIGH);

            digitalWrite(motor1_Clock_Pin, HIGH);
            digitalWrite(motor1_Clock_Pin, LOW);
            delayMicroseconds(300);
//            Serial.print(digitalRead(51));
        }

//reset motor 2
if (digitalRead(motor2_Back_LS)==LOW){  
           digitalWrite(motor2_Enable_Pin,LOW);
           digitalWrite(motor2_Direction_Pin,HIGH);

            digitalWrite(motor2_Clock_Pin, HIGH);
            digitalWrite(motor2_Clock_Pin, LOW);
            delayMicroseconds(300);
//            Serial.print(digitalRead(49));
        }

//reset motor 3
if (digitalRead(motor3_Back_LS)==LOW){

           digitalWrite(motor3_Enable_Pin,LOW);
           digitalWrite(motor3_Direction_Pin,HIGH);

            digitalWrite(motor3_Clock_Pin, HIGH);
            digitalWrite(motor3_Clock_Pin, LOW);
            delayMicroseconds(300);
//            Serial.print(digitalRead(9));
        }
}

// Run the motors forward each by 400 microsteps.
    while (stepCount < 6000) {
      Serial.println(stepCount);
      // Move motor 1 forward by 1 microstep.
      digitalWrite(motor1_Enable_Pin, LOW);
      digitalWrite(motor1_Direction_Pin, LOW);

      digitalWrite(motor1_Clock_Pin, HIGH);
      delayMicroseconds(1);
      digitalWrite(motor1_Clock_Pin, LOW);
      delayMicroseconds(300);
      //            Serial.print(digitalRead(51));

      // Move motor 2 forward by 1 microstep.
      digitalWrite(motor2_Enable_Pin, LOW);
      digitalWrite(motor2_Direction_Pin, LOW);

      digitalWrite(motor2_Clock_Pin, HIGH);
      delayMicroseconds(1);
      digitalWrite(motor2_Clock_Pin, LOW);
      delayMicroseconds(300);
      //            Serial.print(digitalRead(49));

      // Move motor 3 forward by 1 microstep.
      digitalWrite(motor3_Enable_Pin, LOW);
      digitalWrite(motor3_Direction_Pin, LOW);

      digitalWrite(motor3_Clock_Pin, HIGH);
      delayMicroseconds(1);
      digitalWrite(motor3_Clock_Pin, LOW);
      delayMicroseconds(300);
      //            Serial.print(digitalRead(9));

      reset_motors = 1;
      stepCount++;
    }


//while (digitalRead(51)==HIGH || digitalRead(49)==HIGH || digitalRead(9)==HIGH){
//if (digitalRead(51)==HIGH){
//           digitalWrite(43,LOW);
//           digitalWrite(44,LOW);
//
//            digitalWrite(45, HIGH);
//            delayMicroseconds(1);
//            digitalWrite(45, LOW);
//            delayMicroseconds(300);
////            Serial.print(digitalRead(51));
//        }
//
//if (digitalRead(49)==HIGH){  
//           digitalWrite(46,LOW);
//           digitalWrite(47,LOW);
//
//            digitalWrite(12, HIGH);
//            delayMicroseconds(1);
//            digitalWrite(12, LOW);
//            delayMicroseconds(300);
////            Serial.print(digitalRead(49));
//        }
//        
//if (digitalRead(9)==HIGH){ 
//           digitalWrite(motor3_Enable_Pin,LOW);
//           digitalWrite(motor3_Direction_Pin,LOW);
//
//            digitalWrite(10, HIGH);
//            delayMicroseconds(1);
//            digitalWrite(10, LOW);
//            delayMicroseconds(300);
////            Serial.print(digitalRead(9));
//        }
//        reset_motors = 1;
//}
}



if (Serial.available() > 0) {  // read the incoming byte:
                run_stop = Serial.read();
}
while (run_stop == 49){
      
 
      float pressure1 = (analogRead(pressure_Sensor1_signal)/1024.0*5.0 - 0.10*Vsupply) * (Pmax - Pmin) / 0.8 / Vsupply + Pmin;
      float pressure2 = (analogRead(pressure_Sensor2_signal)/1024.0*5.0 - 0.10*Vsupply) * (Pmax - Pmin) / 0.8 / Vsupply + Pmin;
      float pressure3 = (analogRead(pressure_Sensor3_signal)/1024.0*5.0 - 0.10*Vsupply) * (Pmax - Pmin) / 0.8 / Vsupply + Pmin;

  // motor 1 PID
        curr1 = pressure1;
        err1 = setpt1[count1] - curr1;

        if (abs(err1) < integralThresh) {// prevent integral 'windup'.
            integ1 = integ1 + err1; // accumulate the error integral.
        }
        else {
            integ1 = 0; // zero if it's out of bounds.
        }
        
    float   P1 = err1 * Kp;
    float   I1 = integ1 * Ki;
    float   D1 = (prev1 - curr1) * Kd;

        drive1 = P1 + I1 + D1;

//        if (drive1 < -200){ 
//            drive1 = -200;
//        }
//        
//        if (drive1 > 200){
//            drive1 = 200;
//        }
        
        if (0 < drive1){
            inorout1 = 49;
        }
        else if(0 > drive1){
            inorout1 = 48;
        }

        drive1abs = abs(drive1);

        prev1 = curr1;



  // motor 2 PID
        curr2 = pressure2;
        err2 = setpt2[count1] - curr2;

        if (abs(err2) < integralThresh) {// prevent integral 'windup'.
            integ2 = integ2 + err2; // accumulate the error integral.
        }
        else {
            integ2 = 0; // zero if it's out of bounds.
        }
        
    float   P2 = err2 * Kp;
    float   I2 = integ2 * Ki;
    float   D2 = (prev2 - curr2) * Kd;

        drive2 = P2 + I2 + D2;

//        if (drive2 < -200){ 
//            drive2 = -200;
//        }
//        
//        if (drive2 > 200){
//            drive2 = 200;
//        }
        
        if (0 < drive2){
            inorout2 = 49;
        }
        else if(0 > drive2){
            inorout2 = 48;
        }

        drive2abs = abs(drive2);

        prev2 = curr2;


  // motor 3 PID
        curr3 = pressure3;
        err3 = setpt3[count1] - curr3;

        if (abs(err3) < integralThresh) {// prevent integral 'windup'.
            integ3 = integ3 + err3; // accumulate the error integral.
        }
        else {
            integ3 = 0; // zero if it's out of bounds.
        }
        
    float   P3 = err3 * Kp;
    float   I3 = integ3 * Ki;
    float   D3 = (prev3 - curr3) * Kd;

        drive3 = P3 + I3 + D3;

//        if (drive3 < -200){ 
//            drive3 = -200;
//        }
//        
//        if (drive3 > 200){
//            drive3 = 200;
//        }
        
        if (0 < drive3){
            inorout3 = 49;
        }
        else if(0 > drive3){
            inorout3 = 48;
        }

        drive3abs = abs(drive3);

        prev3 = curr3;


    //Motor 1
    
    if (inorout1 == 48){
        if (digitalRead(motor1_Back_LS)==HIGH){
          inorout1=50;
            //Serial.print("Y");
        }
        else { 
           digitalWrite(43,LOW);
           digitalWrite(44,HIGH);
        }
    }
    
    if (inorout1 == 49) {
      if (digitalRead(motor1_Forward_LS)==HIGH){
        inorout1=50;
      }
      else {
        digitalWrite(motor1_Enable_Pin,LOW);
        digitalWrite(motor1_Direction_Pin,LOW);
      }
    }

    if (inorout1 == 50){
      digitalWrite(motor1_Enable_Pin,HIGH);
    }


    //Motor 2
    
    if (inorout2 == 48){
        if (digitalRead(motor2_Back_LS)==HIGH){
          inorout2=50;
            //Serial.print("Y");
        }
        else { 
           digitalWrite(motor2_Enable_Pin,LOW);
           digitalWrite(motor2_Direction_Pin,HIGH);
        }
    }
    
    if (inorout2 == 49) {
      if (digitalRead(motor2_Forward_LS)==HIGH){
        inorout2=50;
      }
      else {
        digitalWrite(motor2_Enable_Pin,LOW);
        digitalWrite(motor2_Direction_Pin,LOW);
      }
    }

    if (inorout2 == 50){
      digitalWrite(motor2_Enable_Pin,HIGH);
    }


    //Motor 3
    
    if (inorout3 == 48){
        if (digitalRead(motor3_Back_LS)==HIGH){
          inorout3=50;
            //Serial.print("Y");
        }
        else { 
           digitalWrite(motor3_Enable_Pin,LOW);
           digitalWrite(motor3_Direction_Pin,HIGH);
        }
    }
    
    if (inorout3 == 49) {
      if (digitalRead(motor3_Forward_LS)==HIGH){
        inorout3=50;
      }
      else {
        digitalWrite(motor3_Enable_Pin,LOW);
        digitalWrite(motor3_Direction_Pin,LOW);
      }
    }

    if (inorout3 == 50){
      digitalWrite(motor3_Enable_Pin,HIGH);
    }



// Delay and Run




    delay_val1 = map(drive1abs,1,500,500,1)/500;
    delay_val2 = map(drive2abs,1,500,500,1)/500;
    delay_val3 = map(drive3abs,1,500,500,1)/500;



          //Motor 1
  if(setpt1[count1]+pressureThresh < pressure1 || setpt1[count1]-pressureThresh > pressure1){
  time_passed1 = micros()-timer1;
  if (time_passed1 >delay_val1){
  digitalWrite(motor1_Clock_Pin, HIGH);
//  delayMicroseconds(1);
    digitalWrite(motor1_Clock_Pin, LOW);
  timer1 = micros();
  }
}
  if(setpt1[count1]+pressureThresh > pressure1 && setpt1[count1]-pressureThresh < pressure1){
    SetPointOn1 = 1;
  }
  



  //Motor 2
  if(setpt2[count1]+pressureThresh < pressure2 || setpt2[count1]-pressureThresh > pressure2){
  time_passed2 = micros()-timer2;
  if (time_passed2 >delay_val2){
  digitalWrite(motor2_Clock_Pin, HIGH);
//  delayMicroseconds(1);
    digitalWrite(motor2_Clock_Pin, LOW);
  timer2 = micros();
  }
}
  if(setpt2[count1]+pressureThresh > pressure2 && setpt2[count1]-pressureThresh < pressure2){
    SetPointOn2 = 1;
  }


 //Motor 3
  if(setpt3[count1]+pressureThresh < pressure3 || setpt3[count1]-pressureThresh > pressure3){
  time_passed3 = micros()-timer3;
  if (time_passed3 >delay_val3){
  digitalWrite(motor3_Clock_Pin, HIGH);
//  delayMicroseconds(1);
    digitalWrite(motor3_Clock_Pin, LOW);
  timer3 = micros();
  }
}
  if(setpt3[count1]+pressureThresh > pressure3 && setpt3[count1]-pressureThresh < pressure3){
    SetPointOn3 = 1;
  }

//motor 1 check

//    if(SetPointOn1 == 0){
//    SetPointTimer1 = millis();
//  }

//  if(millis()-SetPointTimer1 > 2000){
//    SetPointOn1 = 0;
//    count1++;
//    if(count1==6){
//    count1=0;
//  }
//  }
  
//motor 2 check

//  if(SetPointOn2 == 0){
//    SetPointTimer2 = millis();
//  }

//  if(millis()-SetPointTimer2 > 10){
//    SetPointOn2 = 0;
//    count2++;
//    if(count2==13){
//    count2=0;
//  }
//  }


//motor 3 check
  
  if(SetPointOn1 == 0 || SetPointOn2 == 0 || SetPointOn3 == 0){
    SetPointTimer3 = millis();
  }

  if(millis()-SetPointTimer3 > 3000){
    SetPointOn1 = 0;
    SetPointOn2 = 0;
    SetPointOn3 = 0;
    count1++;
    if(count1==numPoints){
    count1=0;
  }
  }
 


//Serial.print(setpt1[count1]);
//Serial.print(" ");
//Serial.print(setpt2[count2]);
//Serial.print(" ");
//Serial.print(setpt3[count3]);
 Serial.print(pressure1);
  Serial.print(" ");
////  Serial.print(analogRead(A1)/1024.0*5.0);
//  Serial.print(delay_val1);
//  Serial.print(" ");
//  Serial.print(drive1abs);
//  Serial.print(" ");
//  Serial.print(inorout1);
//  Serial.print(" ");
  Serial.print(pressure2);
  Serial.print(" ");
  Serial.print(pressure3);
//Serial.print(" ");
//Serial.print(SetPointOn);
//Serial.print(" ");
//Serial.print(SetPointTimer);
//Serial.print(" ");
//Serial.print(count1);
//Serial.print(" ");
//Serial.print(pressure2);
//Serial.print(" ");
//Serial.print(setpt2[count2]);
//Serial.print(" ");
//Serial.print(pressure3);
//Serial.print(" ");
//Serial.print(setpt3[count3]);
Serial.print('\n');
}
}



