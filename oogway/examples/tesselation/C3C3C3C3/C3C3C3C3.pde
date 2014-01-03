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

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx)/4, (Ay+By+Cy+Dy)/4);
  o.setHeading(o.towards(Dx, Dy));
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
     text("No.8, Basic Type C3C3C3C3",200,50);
     textFont(font,16);
     text("Turn the arbitrary line AB around A over 120 degrees into the position AC."
    + " Let D be the refection-point of A with respect to the line through B and C."
    + " Connect D to B by an arbitrary line and turn it around D by 120 degrees into the position DC."
         , 200, 100,700,200);
     text("Number of arbitrary lines: 2\nNetwork: 6363,\n3 Positions."
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
  
  drawPoint("A", Ax, Ay, 15, 0);
  drawPoint("B", Bx, By, 0, 15);  
  drawPoint("C", Cx, Cy, 0, -20);  
  drawPoint("D", Dx, Dy, -15, 0);
 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}

