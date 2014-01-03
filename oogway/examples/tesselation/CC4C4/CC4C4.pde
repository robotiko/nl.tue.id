import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;
PFont font;

//latest vertex coordinates
float Ax, Ay, Bx, By, Cx, Cy;

float AB = 100;

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "CC4C4" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
   
  o.left(135);
  
  o.setPosition(600, 370);
  tesselate(0.8);

  o.setPosition(340, 500);
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
  
  //Turn the arbitrary line AB in A by an angle of 90 degrees into the position AC 
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  //AC
  o.recall("A");
  o.left(90);
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  // and connect C to B by a C-line.
  
  //BC
  cline(Bx, By, Cx, Cy, "BM.svg");
      
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

void setOfFour(float scale){
  o.pushState();
  
  drawPiece(scale);
  
  o.pushState();
  o.setPosition(Bx, By);
  vHeading = o.towards(Cx, Cy);
  vDistance = o.distance(Cx, Cy);
  o.popState();
 
  o.right(90);
  drawPiece(scale);
  
  o.pushState();
  o.setPosition(Cx, Cy);
  hHeading = o.towards(Bx, By);
  hDistance = o.distance(Bx, By);
  o.popState();
  
  o.right(90);
  drawPiece(scale);
 
  o.right(90);
  drawPiece(scale);
  
  o.popState();
}

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx)/3, (Ay+By+Cy)/3);
  o.setHeading(180+o.towards(Ax, Ay));
  o.backward(5*scale);
  o.left(135);
  o.forward(4*scale);
  o.backward(4*scale);
  o.right(135);
  o.forward(10*scale);
  o.stamp(8*scale);  
  o.popState();
  popStyle();
} 

void drawIntro(){
  pushStyle();
     textFont(font,32);
     fill(0);
     text("No.14, Basic Type CC4C4",200,50);
     textFont(font,16);
     text("Turn the arbitrary line AB in A by an angle of 90 degrees into the position AC "
    + "and connect C to B by a C-line."
        , 200, 100,700,200);
     text("Number of arbitrary lines: 2\nNetwork: 884\n4 Positions."
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
  
  drawPoint("A", Ax, Ay, 15, 0);
  drawPoint("B", Bx, By, 0, -20);  
  drawPoint("C", Cx, Cy, 0, 15);  

 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}

