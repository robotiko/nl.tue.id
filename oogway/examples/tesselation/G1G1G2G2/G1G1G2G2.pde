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
float angleABC = 88;
float angleBCD = 78;

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "G1G1G2G2" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
  //if(annotate) showGrid();
   
  o.left(80);
  
  o.setPosition(650, 400);
  tesselate(0.9);

  o.setPosition(350, 600);
  drawPiece(2);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();

  for (int i=0; i<4; i++) {
    o.pushState();
    for (int j=0; j<2; j++) {
      groupPositions(scale);
      o.shift(hHeading, hDistance);
    }
    o.popState();
    o.shift(vHeading, vDistance);
    if(i%2==0) o.shift(180+hHeading, hDistance);
  }

  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Move the arbitrary line AB by glide-reflection so that it connects to BC.
  
  //AB
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  //BC
  o.left(180-angleABC);
  o.beginReflection();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  o.endReflection();
  Cx = o.xcor(); Cy = o.ycor();
  
  //Draw one more arbitrary line CD, D being anywhere on the perpendicular bisector MD of AC.
  
  //CD 
  float CD = AB * sin(radians(angleABC/2)) / sin(radians(angleABC/2+angleBCD));
  o.left(180-angleBCD);
  o.beginPath("CD.svg"); o.forward(CD*scale); o.endPath();
  Dx = o.xcor(); Dy = o.ycor();
  
  //DA
  o.setHeading(o.towards(Ax, Ay));
  o.beginReflection();
  o.beginPath("CD.svg"); o.forward(o.distance(Ax, Ay)); o.endPath();   
  o.endReflection();
      
  o.popState();
  
  if(annotate) drawArrow(scale);
}


void groupPositions(float scale){
  o.pushState();
  
  drawPiece(scale);
  float _Dx = Dx, _Dy = Dy;
  
  vHeading = 180 + o.towards(Cx, Cy);
  vDistance = o.distance(Cx, Cy);
  
  o.setHeading(o.towards(Bx, By));
  o.right(angleABC);
  o.up(); o.forward(AB*scale); o.down();
  o.right(180);
  o.beginReflection();
  drawPiece(scale);
  o.endReflection();
  
  hHeading = 180 + o.towards(_Dx, _Dy);
  hDistance = o.distance(_Dx, _Dy);

  o.popState();
}

