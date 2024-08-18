

// import libraries                                                          // 960 is middle x-cordinate
//540 is middle y-cordinate
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;

int minutes = 0;
int seconds = 20;
int currentMillis;
int interval=1000;
int previousMillis=0;
int minutesOptellen=0;
int secondsOptellen=1;
int waitStartUp = 8000;
float states;

int dataAmount = 0;
float dataRate = 0;

String TF = "FALSE";
String Parachute = "UNDEPLOYED";

color TFColor =color(255, 0, 0);
color ParachuteColor = color(255, 0, 0);


String serialPortName = "COM8";
boolean mockupSerial = false;
boolean reading=false;
float maxY1;
float minY1;
float maxY2;
float minY2;
float maxY3;
float minY3;
float maxY4;
float minY4;
float maxY5;
float minY5;
float maxY6;
float minY6;
float maxY7;
float minY7;
float maxY8;
float minY8;
PImage Cadcamatic;
PImage VTI;
color RandKleur = color(38, 39, 46, 255);
color TextColor = color(228, 228, 230, 255);
color RawdataColor = color(72, 194, 149, 255);

float [] minScaleGyro= new float[3];
float [] maxScaleGyro= new float[3];
float [] minScaleAccel= new float[3];
float [] maxScaleAccel= new float[3];
float maxAlt=0;
float maxAccel = 0;
float minPressure =0;
float drukknop;



PFont   font;
PImage img;

Serial serialPort; // Serial port object

ControlP5 cp5;

// Settings for the plotter are saved in this file
JSONObject plotterConfigJSON;

Graph LineGraph1 = new Graph(60, 300, 695, 215, color (187, 225, 250));// GYRO X,Y,Z
Graph LineGraph2 = new Graph(60, 635, 695, 215, color (187, 225, 250));// Accel X,Y,Z
//Graph LineGraph3 = new Graph(845, 300, 695, 215, color (187, 225, 250));
Graph LineGraph4=  new Graph(845, 635, 695, 215, color(187, 225, 250));
float[][] lineGraphValues = new float[10][100]; 
float[] lineGraphSampleNumbers = new float[100];
color[] graphColors = new color[8];
color   BackgroundColor=color(18, 19, 24, 255);  
color   StrokeColor=color(38, 39, 46, 255);  
// helper for saving the executing path
String topSketchPath = "";


void setup() {

  Cadcamatic = loadImage("logo_cadcamatic.png");
  //VTI = loadImage("logo_VTI.png");
  surface.setTitle("Live telemtry");
  //size(1000, 700);
  fullScreen();
  frameRate(120);
  // set line graph colors
  graphColors[0] = color(20, 130, 255, 255);
  graphColors[1] = color(225, 72, 73, 255); 
  graphColors[2] = color(194, 55, 182, 255);
  graphColors[3] = color(20, 130, 255, 255);
  graphColors[4] = color(225, 72, 73, 255);
  graphColors[5] = color(194, 55, 182, 255);
  graphColors[6] = color(20, 130, 255, 255);
  graphColors[7] = color(20, 130, 255, 255);

  // settings save file
  topSketchPath = sketchPath();
  plotterConfigJSON = loadJSONObject(topSketchPath+"/plotter_config.json");
  // gui
  cp5 = new ControlP5(this);




  // init charts
  setChartSettings();
  //x-as values
  for (int k=0; k<lineGraphValues[0].length; k++) {
    lineGraphValues[0][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }
  for (int k=0; k<lineGraphValues[1].length; k++) {
    lineGraphValues[1][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }
  for (int k=0; k<lineGraphValues[2].length; k++) {
    lineGraphValues[2][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }
  for (int k=0; k<lineGraphValues[3].length; k++) {
    lineGraphValues[3][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }
  for (int k=0; k<lineGraphValues[4].length; k++) {
    lineGraphValues[4][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }
  for (int k=0; k<lineGraphValues[5].length; k++) {
    lineGraphValues[5][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }
  for (int k=0; k<lineGraphValues[6].length; k++) {
    lineGraphValues[6][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }

  for (int k=0; k<lineGraphValues[7].length; k++) {
    lineGraphValues[7][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }
  for (int k=0; k<lineGraphValues[8].length; k++) {
    lineGraphValues[8][k] = 0;
    lineGraphSampleNumbers[k] = k;
  }

  // start serial communication
  try {
    serialPort = new Serial(this, serialPortName, 115200);
  }
  catch (RuntimeException e) {
    background(68, 68, 68);
    //exit();
  }



  // build the gui
}

byte[] inBuffer = new byte[100]; // holds serial message
int i = 0; // loop variable


//-----------------------------------------------------------------------------------------------------------//

void draw() {
  /* Read serial and update values */
  try {
    if (mockupSerial || serialPort.available() > 0) {
      String myString = " ";
      if (!mockupSerial) {
        try {
          serialPort.readBytesUntil('\n', inBuffer);
        }
        catch (Exception e2) {
        }
        myString = new String(inBuffer);
        dataAmount++;
        
      } else {
        //myString = mockupSerialFunction();
      }
      if (maxY1 < max(lineGraphValues[0])) {
        maxY1 = max(lineGraphValues[0]);
        maxScaleGyro[0]=maxY1;
      } else if (minY1 > min(lineGraphValues[0])) {
        minY1 = min(lineGraphValues[0]);
        minScaleGyro[0]=minY1;
      }

      if (maxY2 < max(lineGraphValues[1])) {
        maxY2 = max(lineGraphValues[1]);
        maxScaleGyro[1]=maxY2;
      } else if (minY2 > min(lineGraphValues[1])) {
        minY2 = min(lineGraphValues[1]);
        minScaleGyro[1]=minY2;
      }

      if (maxY3 < max(lineGraphValues[2])) {
        maxY3 = max(lineGraphValues[2]);
        maxScaleGyro[2]=maxY3;
      } else if (minY3 > min(lineGraphValues[2])) {
        minY3 = min(lineGraphValues[2]);
        minScaleGyro[2]=minY3;
      }

      if (LineGraph1.yMax <max(maxScaleGyro)) {
        LineGraph1.yMax=max(maxScaleGyro);
      }
      if (LineGraph1.yMin>min(minScaleGyro)) {
        LineGraph1.yMin=min(minScaleGyro);
      }



      if (maxY4 < max(lineGraphValues[3])) {
        maxY4 = max(lineGraphValues[3]);
        maxScaleAccel[0]=maxY4;
      } else if (minY4 > min(lineGraphValues[3])) {
        minY4 = min(lineGraphValues[3]);
        minScaleAccel[0]=minY4;
      }

      if (maxY5 < max(lineGraphValues[4])) {
        maxY5 = max(lineGraphValues[4]);
        maxScaleAccel[1]=maxY5;
      } else if (minY5 > min(lineGraphValues[4])) {
        minY5 = min(lineGraphValues[4]);
        minScaleAccel[1]=minY5;
      }

      if (maxY6 < max(lineGraphValues[5])) {
        maxY6 = max(lineGraphValues[5]);
        maxScaleAccel[2]=maxY6;
      } else if (minY6 > min(lineGraphValues[5])) {
        minY6 = min(lineGraphValues[5]);
        minScaleAccel[2]=minY6;
      }

      if (LineGraph2.yMax < max(maxScaleAccel)) LineGraph2.yMax=max(maxScaleAccel);
      if (LineGraph2.yMin > min(minScaleAccel)) LineGraph2.yMin=min(minScaleAccel);


      if (maxY7 < max(lineGraphValues[6])) {
        maxY7 = max(lineGraphValues[6]);
        //LineGraph3.yMax=maxY7;
      } else if (minY7 > min(lineGraphValues[6])) {
        minY7 = min(lineGraphValues[6]);
        //LineGraph3.yMin=minY7;
      }
        minY7 = (min(lineGraphValues[6])-10);
        //LineGraph3.yMin=minY7;

      if (maxY8 < max(lineGraphValues[7])) {
        maxY8 = max(lineGraphValues[7]);
        LineGraph4.yMax=maxY8;
      } else if (minY6 > min(lineGraphValues[7])) {
        minY8 = min(lineGraphValues[7]);
        LineGraph4.yMin=minY8;
      }



      // split the string at delimiter (space)
      String[] nums = split(myString, " ");

      // count number of bars and line graphs to hide
      // build a new array to fit the data to show
      for ( int i = 0; i < 9; i++) { 
        for (int k=0; k<lineGraphValues[i].length-1; k++) {
          lineGraphValues[i][k] = lineGraphValues[i][k+1];
        }
      }

      if (millis() > waitStartUp) {
        for (int i=0; i <9; i++) {
          lineGraphValues[i][lineGraphValues[i].length-1] = float(nums[i]);
        }
      }
      background(BackgroundColor); 
      drawRect(60, 60, 250, 120, 1, 0, "");
      drawRect(401, 60, 270, 120, 2, color(68, 68, 68), "");
      drawRect(764, 60, 1120, 120, 4, 0, "");
      dataRate();
      drawRect(1631, 300, 250, 550, 5, 0, "");
      drawRect(60, 970, 695, 50, 6, 0, "");
      try{
        updateState(float(nums[8]), 60, 230);
        states = float(nums[8]);
      }catch(ArrayIndexOutOfBoundsException e){
        updateState(0, 60, 230);
        states = 0;
      }
      
      //print(lineGraphValues[9][lineGraphValues[9].length-1]);
      image(Cadcamatic, 830, 940, 512, 96.5);
      //image(VTI, 1450, 950, 280, 76);
    }


    // draw the line graphs
    LineGraph1.DrawAxis();
    LineGraph2.DrawAxis();
    //LineGraph3.DrawAxis();
    LineGraph4.DrawAxis();
    if (millis()> waitStartUp) {
      for (int i=0; i<3; i++) {
        LineGraph1.GraphColor = graphColors[i];

        LineGraph1.LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
      }
      for (int i=3; i<6; i++) { //accel
        LineGraph2.GraphColor = graphColors[i];

        LineGraph2.LineGraph(lineGraphSampleNumbers, lineGraphValues[i]);
      }
      //LineGraph3.GraphColor = graphColors[6];
      LineGraph4.GraphColor = graphColors[7];
      //LineGraph3.LineGraph(lineGraphSampleNumbers, lineGraphValues[6]);
      LineGraph4.LineGraph(lineGraphSampleNumbers, lineGraphValues[7]);
    }
  }


  catch(NullPointerException e) {
  }
  
}


// called each time the chart settings are changed by the user 
void setChartSettings() {
  //LineGraph1.xLabel=""; //x-as legende
  LineGraph1.yLabel=""; //y-as legende
  LineGraph1.Title="Gyro X,Y,Z"; //titel van grafiek
  LineGraph1.xDiv=5;  //aantal onderverdelingen van x-as
  LineGraph1.xMax=0; //x-as einde
  LineGraph1.xMin=-50;  //x-as begin
  LineGraph1.yMax=180;//int(getPlotterConfigString("lgMaxY")); //y-as max
  LineGraph1.yMin=-180;//int(getPlotterConfigString("lgMinY")); //y-as min

  // LineGraph2.xLabel=""; //x-as legende
  LineGraph2.yLabel=""; //y-as legende
  LineGraph2.Title="Accel X,Y,Z"; //titel van grafiek
  LineGraph2.xDiv=5;  //aantal onderverdelingen van x-as
  LineGraph2.xMax=0; //x-as einde
  LineGraph2.xMin=-50;  //x-as begin
  LineGraph2.yMax=int(getPlotterConfigString("lgMaxY")); //y-as max
  LineGraph2.yMin=int(getPlotterConfigString("lgMinY")); //y-as min

  /*LineGraph3.yLabel=""; //y-as legende
  LineGraph3.Title="Pressure"; //titel van grafiek
  LineGraph3.xDiv=5;  //aantal onderverdelingen van x-as
  LineGraph3.xMax=0; //x-as einde
  LineGraph3.xMin=-50;  //x-as begin
  LineGraph3.yMax=int(getPlotterConfigString("lgMaxY")); //y-as max
  LineGraph3.yMin=int(getPlotterConfigString("lgMinY")); //y-as min*/


  LineGraph4.yLabel=""; //y-as legende
  LineGraph4.Title="Height"; //titel van grafiek
  LineGraph4.xDiv=5;  //aantal onderverdelingen van x-as
  LineGraph4.xMax=0; //x-as einde
  LineGraph4.xMin=-50;  //x-as begin
  LineGraph4.yMax=2; //y-as max
  LineGraph4.yMin=-0.1; //y-as min
}
// handle gui actions
//-----------------------------------------------------------------------------------
// get gui settings from settings file
String getPlotterConfigString(String id) {
  String r = "";
  try {
    r = plotterConfigJSON.getString(id);
  } 
  catch (Exception e) {
    r = "";
  }
  return r;
}
void drawRect(float x, float y, float breedte, float hoogte, int functie, color kleur, String inhoud) {


  if (functie == 1) {
    noFill();
    color(187, 225, 250);
    stroke(StrokeColor);
    strokeWeight(3);
    rect(x-60*1, y-60, breedte+60*1.5, hoogte+60*2, 8);
    font = createFont("Bahnschrift", 18);
    textFont(font);
    textAlign(CENTER); 
    textSize(18);
    float c=textWidth("Live data");
    fill(BackgroundColor); 
    color(0);
    stroke(0);
    strokeWeight(0);
    rect(x+breedte/2-c/2, y-35, c, 0);                         // Heading Rectangle  
    textSize(50);
    fill(TextColor);
    text("Live data", x-60 +(breedte+60*1.5)/2, y-15);
    int se = second();
    int mi = minute();
    int ho = hour();
    int da = day();
    int mo = month();
    int ye = year();
    textAlign(LEFT);
    textSize(30);
    text(da + "/" + mo +"/"+ye, x-30, y+30);
    text(ho + ":" + mi +":"+se, x-30, y+75);
  }
  if (functie == 2) {
    int secondMillis = currentMillis - previousMillis;
    fill(BackgroundColor); 
    //color(187, 225, 250);
    stroke(RandKleur);
    strokeWeight(3);
    rect(x-60*1, y-60, breedte+60*1.5, hoogte+60*2, 8);
    textAlign(CENTER);
    textSize(18);
    float c=textWidth("Live data");
    fill(kleur); 
    color(0);
    stroke(0);
    strokeWeight(0);
    rect(x+breedte/2-c/2, y-35, c, 0);                         // Heading Rectangle  
    textSize(50);
    fill(TextColor);
    text("Countdown", x-60+(breedte+60*1.5)/2, y-15);
    textAlign(LEFT);
    textSize(30);
    /*if (drukknop==0.00) {
      textSize(30);
      textAlign(CENTER, CENTER);
      text(secondMillis, x-60 + (breedte+60*1.5)/2, y+20 +(hoogte+60*2)/2);
      if (minutes>=0&seconds>=0) {
        currentMillis=millis();
        if (currentMillis - previousMillis> interval) {
          previousMillis = currentMillis;
          seconds--;
        }
        textSize(70);
        textAlign(CENTER, CENTER);
        if (seconds<10) {
          textSize(70);
          textAlign(CENTER, CENTER);
          text("T-" + minutes + ":0" + seconds, x-60 + (breedte+60*1.5)/2, y-60 +(hoogte+60*2)/2);
        } else {
          textSize(70);
          textAlign(CENTER, CENTER);
          text("T-" + minutes + ":" + seconds, x-60 + (breedte+60*1.5)/2, y-60 +(hoogte+60*2)/2);
        }

        if (seconds<0) {
          minutes=minutes-1;
          seconds=59;
        }
        if (minutes==0&seconds==0) {
          textSize(50);
          fill(0, 255, 0);
          text("launch", x-60 + (breedte+60*1.5)/2, y+105);
        }
      } else {
        currentMillis=millis();

        if (currentMillis - previousMillis> interval) {
          previousMillis = currentMillis;
          secondsOptellen++;
        }
        textSize(70);
        textAlign(CENTER, CENTER);
        if (secondsOptellen<10) {
          text("T+" + minutesOptellen + ":0" + secondsOptellen, x-60 + (breedte+60*1.5)/2, y-60 +(hoogte+60*2)/2);
        } else {
          text("T+" + minutesOptellen + ":" + secondsOptellen, x-60 + (breedte+60*1.5)/2, y-60 +(hoogte+60*2)/2);
        }

        if (secondsOptellen==60) {
          minutesOptellen=minutesOptellen +1;
          secondsOptellen=0;
        }
      }
    } else {
      textAlign(CENTER, CENTER);
      textSize(70);
      text("T-" + minutes + ":" + seconds, x-60 + (breedte+60*1.5)/2, y-60 +(hoogte+60*2)/2);
      minutes = 0;
      seconds = 20;
    }*/
  }
  if (functie ==3) {
    strokeWeight(0);
    stroke(RandKleur);
    fill(kleur);
    rect(x-60*1, y-60, breedte+60*1.5, hoogte, 8);
    textSize(50);
    fill(TextColor);
    textAlign(CENTER, CENTER);
    text(inhoud, x-60+(breedte+60*1.5)/2, y-60 +hoogte/2);
  }
  if (functie==4) {
    float altitude = lineGraphValues[7][lineGraphValues[7].length-1];
    if (altitude> maxAlt) {
      maxAlt = altitude;
    }
    float accel = lineGraphValues[4][lineGraphValues[4].length-1];
    if (accel>maxAccel) {
      maxAccel = accel;
    }
    float pressure = lineGraphValues[6][lineGraphValues[6].length-1];
    if (pressure<minPressure) {
      minPressure = pressure;
    }

    noFill();
    strokeWeight(3);
    stroke(RandKleur);
    fill(BackgroundColor);
    rect(x-60*1, y-60, breedte+60*1.5, hoogte+60*2, 8);
    textSize(50);
    fill(TextColor);
    textAlign(LEFT, TOP);
    textAlign(CENTER);
    text("Information", x-60 +(breedte +60*1.5)/2, y-15);
    textSize(30); 
    textAlign(LEFT);
    text("Pin Pullout: ", x-50, y+40);
    text("Parachute: ", x-50, y+80);
    text("Max Height: ", x+350, y+40);
    text("Max Accel: ", x+350, y+80);
    text("Min pressure: ", x+350, y+120);
    text("Power: ", x+750, y+40);
    text("Data rate: ", x+750, y+80);
    text("Frequency: ", x+750, y+120);
    textAlign(LEFT);
    fill(TFColor);
    text(TF, x+110, y+40);
    fill(ParachuteColor);
    text(Parachute, x+110, y+80);
    fill(RawdataColor);
    text(maxAlt +"m", x+540, y+40);
    text(maxAccel +"m/s²", x+540, y+80);
    text(minPressure +"Pa", x+540, y+120);
    textAlign(LEFT);
    text("23 dBm", x+900, y+40);
    //text("14 Hz", x+900, y+80);
    text("868 MHz", x+900, y+120);


    // pin pullout text
    if (states ==1.00) {
      TF = "TRUE";
      TFColor = color(0, 255, 0);
      fill(TFColor);
      textAlign(LEFT);
      text(TF, x+110, y+40);
      TFColor = color(0, 255, 0);
    } 

    if (states==3.00) {
      Parachute ="DEPLOYED";
      ParachuteColor = color(0, 255, 0);
      fill(ParachuteColor);
      textAlign(LEFT);
      text(Parachute, x+110, y+80);
    }
  }
  if (functie==5) { //function for raw data
    strokeWeight(3);
    stroke(RandKleur);
    fill(BackgroundColor);
    rect(x-60*1, y-60, breedte+60*1.5, hoogte+2*60, 8);
    textSize(50);
    fill(TextColor);
    textAlign(CENTER);
    text("Raw Data", x-60 + (breedte +60*1.5)/2, y-5);
    rawdata(1630, 350);
    stroke(RandKleur);
    strokeWeight(1);
    line(1571, 310, 1911, 310);
  }
  if (functie==6) {
    strokeWeight(3);
    stroke(RandKleur);
    fill(BackgroundColor);
    rect(x-60*1, y-60, breedte +60*1.5, hoogte+2*60, 8);
    textSize(30);
    fill(TextColor);
    textAlign(LEFT);
    text(": GyroX and AccelX", x-60 +(breedte +60*1.5)/2, y-17.5);
    stroke(graphColors[0]);
    line(x, y-25, x+300, y-25);
    textSize(30);
    fill(TextColor);
    textAlign(LEFT);
    text(": GyroY and AccelY", x-60 +(breedte +60*1.5)/2, y+25);
    stroke(graphColors[1]);
    line(x, y+17.5, x+300, y+17.5);
    text(": GyroZ and AccelZ", x-60 +(breedte +60*1.5)/2, y+67, 5);
    stroke(graphColors[2]);
    line(x, y+60, x+300, y+60);
  }
}

void updateState(float state, int x, int y) {
  textSize(50);
  textAlign(CENTER, CENTER);
  if (state == 0) {
    drawRect(x, y, 250, 60, 3, color(128, 0, 128), "IDLE");
  } else if (state ==1) {
    drawRect(x, y, 250, 60, 3, color(255, 0, 0), "ARMED");
  } else if (state ==2) {
    drawRect(x, y, 250, 60, 3, color(255, 255, 0), "BOOST");
  } else if (state ==3) {
    drawRect(x, y, 250, 60, 3, color(0, 180, 25), "RECOVERY");
  } else if (state ==4) {
    drawRect(x, y, 250, 60, 3, color(30, 100, 100), "TOUCHDOWN");
  } else {
    drawRect(x, y, 250, 60, 3, color(100, 100, 100), "None");
  }
}
void rawdata(int x, int y) { 

  stroke(187, 225, 250);
  strokeWeight(1);

  textSize(30);
  fill(TextColor);
  textAlign(LEFT);
  text("Gyro X : ", x-50, y);
  text("Gyro Y : ", x-50, y+40);
  text("Gyro Z : ", x-50, y+80);
  fill(RawdataColor);
  textAlign(CENTER);
  text(lineGraphValues[0][lineGraphValues[0].length-1], x+150, y);
  text(lineGraphValues[1][lineGraphValues[1].length-1], x+150, y+40);
  text(lineGraphValues[2][lineGraphValues[2].length-1], x+150, y+80);
  stroke(187, 225, 250);
  strokeWeight(1);
  fill(TextColor);
  textSize(30);
  textAlign(LEFT);
  text("Accel X : ", x-50, y+170);
  text("Accel Y : ", x-50, y+210);
  text("Accel Z : ", x-50, y+250);
  fill(RawdataColor);
  textAlign(CENTER);
  text(lineGraphValues[3][lineGraphValues[3].length-1], x+150, y+170);
  text(lineGraphValues[4][lineGraphValues[4].length-1], x+150, y+210);
  text(lineGraphValues[5][lineGraphValues[5].length-1], x+150, y+250);
  fill(TextColor);
  textAlign(LEFT);
  text("Pressure: ", x-50, y+330);
  fill(RawdataColor);
  textAlign(CENTER);
  text(lineGraphValues[6][lineGraphValues[6].length-1], x+150, y+330);
  fill(TextColor);
  textAlign(LEFT);
  text("Heigth: ", x-50, y+400);
  fill(RawdataColor);
  textAlign(CENTER);
  text(lineGraphValues[7][lineGraphValues[7].length-1], x+150, y+400);
  fill(TextColor);
  textAlign(LEFT);
  text("Temp: ", x-50, y+470);
  fill(RawdataColor);
  textAlign(CENTER);
  text("16°C", x+150, y+470);
  //text("Frame rate: " + int(frameRate), x+150, y+540);
}

void dataRate(){
        currentMillis=millis();
        if (currentMillis - previousMillis> interval) {
          previousMillis = currentMillis;
          dataRate = float(dataAmount)/float((interval/1000));
          dataAmount = 0;
        }
        textSize(30); 
        fill(RawdataColor);
        textAlign(LEFT);
        text(dataRate + " Hz", 764+900, 60+80);
}
