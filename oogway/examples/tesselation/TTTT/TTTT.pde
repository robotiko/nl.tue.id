import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;
PFont font;

//latest vertex coordinates
float Ax, Ay, Bx, By, Cx, Cy, Dx, Dy;
float AB = 100;
float AD = 125;
float angleBAD = 75;

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "TTTT" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate) font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
  showGrid();
  
  o.left(15); 
  
  o.setPosition(600, 480);
  tesselate(0.8);

  o.setPosition(200, 600);
  drawPiece(1.5);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();
  
  for(int i=0; i<3; i++){
    o.pushState();
    for(int j=0; j<4; j++){
    groupPositions(scale);
    o.shift(hHeading, hDistance);
    }
    o.popState();
    o.shift(vHeading, vDistance);
  }
  
  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Shift the arbitrary line AB to DC, such that ABCD are the corners of a parallelogram 
  //(Translation vector AD).
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AB.svg");  o.forward(AB*scale);  o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  //DC
  o.recall("A");
  o.shift(o.heading()-angleBAD, AD*scale);
  Dx = o.xcor(); Dy = o.ycor();
  o.beginPath("AB.svg");  o.forward(AB*scale);  o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  //Draw another arbitrary line from A to D and shift it into the  
  //position BC (translation vector AB).
  
  //AD 
  o.setPosition(Ax, Ay);
  o.setHeading(o.towards(Dx, Dy));
  o.beginPath("AD.svg");  o.forward(o.distance(Dx, Dy));  o.endPath(); 

  
  //BC
  o.setPosition(Bx, By);
  o.setHeading(o.towards(Cx, Cy));
  o.beginPath("AD.svg");  o.forward(o.distance(Cx, Cy));  o.endPath(); 

  o.popState();
  
  if(annotate) drawArrow(scale);
}

void groupPositions(float scale){
  o.pushState();
  
  drawPiece(scale);
  
  hHeading = o.towards(Bx, By);
  hDistance = o.distance(Bx, By);
  
  vHeading = 180+o.towards(Dx, Dy);
  vDistance = o.distance(Dx, Dy);
  
  o.popState();
}

