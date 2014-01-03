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
float BC = 125;
float angleDAB = 75;

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "TCTC" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate) font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
  
  o.left(15);
  
  o.setPosition(650, 300);
  tesselate(0.8);

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
  
  //Shift the arbitrary line AB to DC so that drawPiece are the corners of a parallelogram.
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  //DC
  o.recall("A");
  o.shift(o.heading()-angleDAB, BC*scale);
  Dx = o.xcor(); Dy = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  // Connect A to D using a C-line. Place a second (independent of the previous) 
  // C-line (same end point distances) from B to C.
  
  //AD
  cline(Ax, Ay, Dx, Dy, "AM1.svg");
  
  //BC
  cline(Bx, By, Cx, Cy, "BM2.svg");
   
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
  
  o.setPosition(Dx, Dy);
  o.left(180);
  drawPiece(scale);
  
  hDistance = 2*AB*scale;
  hHeading = o.heading();
  
  vDistance = BC*scale;
  vHeading = o.heading() + 180 - angleDAB;

  o.popState();
}

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx)/4, (Ay+By+Cy+Dy)/4);
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
     text("No.5, Basic Type TCTC",200,50);
     textFont(font,16);
     text("Shift the arbitrary line AB to DC so that drawPiece are the corners of a parallelogram. Connect A to D using a C-line."
    + "Place a second (independent of the previous) C-line (same end point distances) from B to C. "
         , 200, 100,700,200); 
     text("Number of arbitrary lines: 3\nNetwork: 4444,\n2 Positions."
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

  drawPoint("M1", (Dx+Ax)/2, (Dy+Ay)/2, 25, 0);  
  drawPoint("M2", (Bx+Cx)/2, (By+Cy)/2, -25, -15);  
  
 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}




