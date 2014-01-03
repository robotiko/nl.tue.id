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
  beginRecord(PDF, "C3C3C3C3" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
   
  o.right(120);
  
  o.setPosition(650, 400);
  tesselate(0.7);

  o.setPosition(400, 500);
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
      setOfThree(scale);
      o.shift(hHeading, hDistance);
      if (j%2==0)o.shift(180+vHeading, vDistance);
    }

    o.popState();
    o.shift(vHeading, vDistance);
  }

  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Turn the arbitrary line AB around A over 120 degrees into the position AC.
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  //AC
  o.recall("A");
  o.right(120);
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  // Let D be the refection-point of A with respect to the line through B and C.
  o.recall("A");
  o.mirrorPosition(Bx, By, Cx, Cy);
  Dx = o.xcor(); Dy = o.ycor();
  
  //Connect D to B by an arbitrary line and turn it around D by 120 degrees into the position DC.
  
  //DB
  o.setHeading(o.towards(Bx, By));
  o.beginPath("DB.svg"); o.forward(o.distance(Bx, By)); o.endPath();  
  
  //DC
  o.setPosition(Dx, Dy);
  o.setHeading(o.towards(Cx, Cy));
  o.beginPath("DB.svg"); o.forward(o.distance(Cx, Cy)); o.endPath();   
      
  o.popState();
  
  if(annotate) drawArrow(scale);
}


void setOfThree(float scale){
  o.pushState();
  
  drawPiece(scale);
  
  o.pushState();
  o.setPosition(Cx, Cy);
  vHeading = o.towards(Bx, By);
  vDistance = o.distance(Bx, By);
  o.popState();
  
  o.mirrorPosition(Dx, Dy, Bx, By);
  o.right(120);  
  drawPiece(scale);
  
  o.pushState();
  o.setPosition(Bx, By);
  hHeading = o.towards(Cx, Cy);
  hDistance = o.distance(Cx, Cy);
  o.popState();

  o.mirrorPosition(Dx, Dy, Bx, By);
  o.right(120);
  drawPiece(scale);
  
  o.popState();
}


