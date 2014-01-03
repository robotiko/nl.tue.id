import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;
PFont font;

//latest vertex coordinates
float Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Ex, Ey, Fx, Fy;

float AB = 100;
float AD = 125;
float AF = 85;
float BE = 100;
float angleFAB = 100;
float angleDAB = 77;
float angleABE = 125;

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "TCCTCC" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
  
  o.left(15);
  
  o.setPosition(650, 350);
  tesselate(0.7);

  o.setPosition(200, 650);
  drawPiece(2);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();
  
  for(int i=0; i<4; i++){
    o.pushState();
    for(int j=0; j<2; j++){
    setOfTwo(scale);
    o.shift(hHeading, hDistance);
    }
    o.popState();
    o.shift(vHeading, vDistance);
  }
  
  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Shift the arbitrary line AB to DC.
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  o.remember("B");
  Bx = o.xcor(); By = o.ycor();
  
  //DC
  o.recall("A");
  o.shift(o.heading()-angleDAB, AD*scale);
  Dx = o.xcor(); Dy = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  // Draw from A a C-line to the arbitrary point F
  
  //AF
  o.recall("A");
  o.left(angleFAB);
  o.up(); o.forward(AF*scale); o.down();
  Fx = o.xcor(); Fy = o.ycor();
  cline(Ax, Ay, Fx, Fy, "AM1.svg");
  
  //connect F by a second C-line to D.
  
  //FD
  cline(Fx, Fy, Dx, Dy, "FM2.svg");
  
  //Draw a third C-line from B to the freely chosen point E 
  
  //BE
  o.recall("B");
  o.left(180-angleABE);
  o.up(); o.forward(BE*scale); o.down();
  Ex = o.xcor(); Ey = o.ycor();
  cline(Bx, By, Ex, Ey, "BM3.svg");

  
  //and close the figure by means of a fourth C-line CE.
  
  //EC
  cline(Ex, Ey, Cx, Cy, "EM4.svg");
   
  o.popState();
  
  if(annotate) drawArrow(scale);
}


void cline(float x1, float y1, float x2, float y2, String svg){
  o.pushState();
  
  float mx = (x1 + x2)/2;
  float my = (y1 + y2)/2;
  
  o.setPosition(x1, y1);
  float d = o.distance(mx, my);
  o.setHeading(o.towards(mx, my));
  o.beginPath(svg); o.forward(d); o.endPath();
  
  o.setPosition(x2, y2);
  o.setHeading(o.towards(mx, my));
  o.beginPath(svg); o.forward(d); o.endPath();  
 
  o.popState();
  
}

void setOfTwo(float scale){
  o.pushState();
  
  o.left(180);
  drawPiece(scale);
  float _Bx = Bx, _By = By;
  
  o.setPosition(Fx, Fy);
  o.left(180);
  drawPiece(scale);
  
  vDistance = o.distance(Dx, Dy);
  vHeading = 180 + o.towards(Dx, Dy);
  
  o.setPosition(_Bx, _By);
  hDistance = o.distance(Ex, Ey);
  hHeading = o.towards(Ex, Ey);
  
  o.popState();
}

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx+Ex+Fx)/6, (Ay+By+Cy+Dy+Ey+Fy)/6);
  o.right(90);
  o.backward(10*scale);
  o.left(135);
  o.forward(4*scale);
  o.backward(4*scale);
  o.right(135);
  o.forward(20*scale);
  o.stamp(8*scale);  
  o.popState();
  popStyle();
} 

void drawIntro(){
  pushStyle();
     textFont(font,32);
     fill(0);
     text("No.7, Basic Type TCCTCC",200,50);
     textFont(font,16);
     text("Shift the arbitrary line AB to DC. Draw from A a C-line to the arbitrary point F;"
    + " connect F by a second C-line to D. "
    + "Draw a third C-line from B to the freely chosen point E and close the figure by means of a fourth C-line CE. "
         , 200, 100,700,200); 
     text("Number of arbitrary lines: 4\nNetwork: 333333,\n2 Positions."
         , 650, 180,700,100); 
  popStyle();
}


void drawPoints(){
  pushStyle();
  o.pushState();
  textFont(font,16);
  textAlign(CENTER, CENTER);
  fill(255,0,55);
  o.setPenColor(0,0,255);
  
  drawPoint("A", Ax, Ay, -15, 15);
  drawPoint("B", Bx, By, 15, 15);  
  drawPoint("C", Cx, Cy, 15, -15);  
  drawPoint("D", Dx, Dy, -15, -15);
  drawPoint("E", Ex, Ey, 15, 0);
  drawPoint("F", Fx, Fy, -15, 0);

  drawPoint("M1", (Fx+Ax)/2, (Fy+Ay)/2, 25, 0);  
  drawPoint("M2", (Fx+Dx)/2, (Fy+Dy)/2, -25, 0);   
  drawPoint("M3", (Bx+Ex)/2, (By+Ey)/2, 15, -20);  
  drawPoint("M4", (Cx+Ex)/2, (Cy+Ey)/2, 0, -20);  
 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}

