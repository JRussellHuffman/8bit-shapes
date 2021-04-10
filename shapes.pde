import processing.svg.*;

String[] quantumCorpusLoad;
String[] finalQuantumArray;
color black = color(0);
color white = color(255);
int canvasWidth = 1000;
int canvasHeight = 1000;
int startingX;
int startingY;
int shots = 8192; //max is 8192
int lineSize = 20;
Boolean simulate = true; // true for simulated data. false for real data
String dataSource = "text_file_from_quantum_computer";

int shapeSize = 50;
int startingPosition = 700; //there are 8000 shots and this piece only uses 36. This shifts the starting point to use those other shots to make new compositions
int bitstringLength = 8;


void setup() {
  frameRate(120);
  //beginRecord(SVG, dataSource +"-starting_" + startingPosition + ".svg"); //uncomment this and "endrecord()" to save as SVG
  size(1000,1000);
  loadPixels();
  pixelDensity(2);
  if (simulate) {
    createReadings();
  } else {
    parseCorpus();
  }
  ;
  background(255);
  noFill();
  shapeMode(CENTER);
  
  startingX = canvasWidth/2;
  startingX = shapeSize*2;
  startingY = canvasHeight/2;
  startingY = shapeSize*2;
  
  

  //render it all at once
  for (int i = 0+startingPosition; i < 36+startingPosition; i++) { //normally i < shots
    drawLine(finalQuantumArray[i]);
  }
  
  //endRecord();
  
    
  //export image to same folder as this file
  //save(dataSource+"_loop.png");
  //println("exported!");
  
  
}

//void draw() {
  
  
//  if(activeLine < shots) {
//    drawLine(finalQuantumArray[activeLine]);
//    activeLine++;
//  }
  
//}

 //<>//
void createReadings() {
  Simulator simulator = new Simulator(0.1);
  
  QuantumCircuit phiPlus = new QuantumCircuit(bitstringLength, bitstringLength);
  
  for (int i = 0; i < bitstringLength; i++) {
    phiPlus.h(i);
    phiPlus.measure(i, i);
  }
  //phiPlus.cx(0, 1);

  List<String> measurements = new ArrayList();
  for (int i = 0; i < shots; i++) {
    Map<String,Integer> counts = (Map)simulator.simulate(phiPlus, 1, "counts");
    String firstKey = counts.keySet().iterator().next();
    measurements.add(firstKey);
  }
  finalQuantumArray = measurements.toArray(new String[0]);
  //println(finalQuantumArray);
} //<>//

void parseCorpus() {
  quantumCorpusLoad = loadStrings("output-"+dataSource+".txt");
  finalQuantumArray = quantumCorpusLoad[0].replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
}


void drawLine(String n) {
  
  char qb[] = new char[bitstringLength];
  
  //println(n.charAt(0));
  if (!simulate) {
    for (int i = 0; i < qb.length; i ++) {
      qb[i] = n.charAt(i+1); //there is an extra character in the real data 
      //println(qb[i]);
    }
  } else {
    for (int i = 0; i < qb.length; i ++) {
      qb[i] = n.charAt(i);
    }
  }
  
  
  int binary1='1';
  char c = (char)binary1; 
  

  if (qb[0] == c) {
    ellipse(startingX, startingY, shapeSize+10, shapeSize+10); //circle
  } 
  if (qb[1] == c) {
    square(startingX-(shapeSize/2), startingY-(shapeSize/2), shapeSize); //square
  } 
  if (qb[2] == c) {
    star(startingX, startingY, shapeSize-10, shapeSize-10, 3); //hexagon
  } 
  if (qb[3] == c) {
    star(startingX, startingY, shapeSize-20, shapeSize, 2); //diamond long
  } 
  if (qb[4] == c) {
    star(startingX, startingY, shapeSize, shapeSize-20, 2); //diamond tall
  } 
  if (qb[5] == c) {
    line(startingX, startingY-(shapeSize/2)+10, startingX, startingY+(shapeSize/2)-10); //vertical line
  } 
  if (qb[6] == c) {
    line(startingX-(shapeSize/2)+10, startingY, startingX+(shapeSize/2)-10, startingY); //horizontal line
  } 
  if (qb[7] == c) {
    triangle(startingX, startingY-30, startingX-30, startingY+20, startingX+30, startingY+20);
  }
  
  if (startingX < canvasWidth-(shapeSize*3)) { //if starting x hasn't reached the right of the page yet
    startingX += (shapeSize*3);
  } else {
    startingX = shapeSize*2;
    startingY += (shapeSize*3); //go down on the starting Y
  }
  
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
