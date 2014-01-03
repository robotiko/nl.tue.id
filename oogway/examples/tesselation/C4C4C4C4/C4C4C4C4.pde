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

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "C4C4C4C4" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
   
  o.setPosition(550, 300);
  tesselate(0.6);

  o.setPosition(200, 350);
  drawPiece(2);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();

  for (int i=0; i<3; i++) {
    o.pushState();
    for (int j=0; j<3; j++) {
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
  
  //Turn in the arbitrary line AB around A by 90 degrees into the position AC.
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  //AC
  o.recall("A");
  o.right(90);
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  // Let D be the fourth point of the square ABDC. 
  // Choose a second arbitrary line CD and turn it around D by 90 degrees into the position DB.
  
  //CD
  o.left(90);
  o.beginPath("CD.svg"); o.forward(AB*scale); o.endPath();
  Dx = o.xcor(); Dy = o.ycor();

  //BD
  o.setPosition(Bx, By);
  o.setHeading(o.towards(Dx, Dy));
  o.beginPath("CD.svg"); o.forward(AB*scale); o.endPath();
      
  o.popState();
  
  if(annotate) drawArrow(scale);
}



void groupPositions(float scale){
  o.pushState();
  
  drawPiece(scale);
  
  hHeading = o.towards(Bx, By);
  hDistance = 2 * o.distance(Bx, By);
  
  vHeading = o.towards(Cx, Cy);
  vDistance = 2 * o.distance(Cx, Cy);  
  
  o.mirrorPosition(Bx, By, Dx, Dy);
  o.right(90);
  drawPiece(scale);
   
  o.mirrorPosition(Bx, By, Dx, Dy);
  o.right(90);
  drawPiece(scale);

  o.mirrorPosition(Bx, By, Dx, Dy);
  o.right(90);
  drawPiece(scale);
  
  o.popState();
}

