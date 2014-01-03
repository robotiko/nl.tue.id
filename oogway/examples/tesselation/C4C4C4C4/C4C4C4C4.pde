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
      setOfFour(scale);
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



void setOfFour(float scale){
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

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx)/4, (Ay+By+Cy+Dy)/4);
  o.setHeading(180+o.towards(Ax, Ay));
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
     text("No.15, Basic Type C4C4C4C4",200,50);
     textFont(font,16);
     text("Turn in the arbitrary line AB around A by 90 degrees into the position AC. "
     + "Let D be the fourth point of the square ABDC. "
     + "Choose a second arbitrary line CD and turn it around D by 90 degrees into the position DB."
        , 200, 100,700,200);
     text("Number of arbitrary lines: 2\nNetwork: 4444\n4 Positions."
         , 650, 200,700,100); 
  popStyle();
}


void drawPoints(){
  pushStyle();
  o.pushState();
  textFont(font,16);
  textAlign(CENTER, CENTER);
  fill(255,0,55);
  o.setPenColor(0,0,255);
  
  drawPoint("A", Ax, Ay, -15, -15);
  drawPoint("B", Bx, By, 15, -15);  
  drawPoint("C", Cx, Cy, -15, 15);  
  drawPoint("D", Dx, Dy, 15, 15);  
 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}

