import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;

//latest A, B, C coordinates
float ax, ay, bx, by, cx, cy;

float ab = 100;
float degreeABC = 75;

PFont font;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); 
  smooth();
  beginRecord(PDF, "CGG" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if (annotate) font = createFont("Comic Sans MS", 32);
}

void draw() {
  background(255);
  o.setPosition(o.xcor()+80, o.ycor()+250);
  tesselate(0.7);

  o.home();
  o.setPosition(200, o.ycor()+250);
  drawPiece(2.5);

  if (annotate) drawIHM();
  if (annotate) textABC();
  if (annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();

  float step = ab*scale*cos(radians(degreeABC/2))*2;
  for (int i=0; i<3; i++) {
    pair(scale);
    float bx0 = bx, by0 = by;
    float ax0 = ax, ay0 = ay;
    for (int j=1; j<3; j++) {
      o.setPosition(cx + step, cy);
      pair(scale);
    }
    o.setPosition(bx0, by0);
    for (int j=0; j<3; j++) {
      pairReflected(scale);
      o.setPosition(cx + step, cy);
    }
    o.setPosition(ax0, ay0);
  }

  o.popState();
}

void drawPiece(float scale) {
  o.pushState();

  //arbitrary line AB
  ax=o.xcor(); 
  ay = o.ycor();
  o.left(degreeABC/2);
  o.pathForward(ab*scale, "AB.svg"); 
  bx=o.xcor(); 
  by = o.ycor();

  //glide reflection of AB until it connects to the position BC,
  //where the angle ABC (degreeABC) is arbitrary.
  o.left(180-degreeABC);
  o.beginReflection(); 
  o.pathForward(ab*scale, "AB.svg");
  o.endReflection();
  cx = o.xcor(); 
  cy = o.ycor();

  //close the figure by a C-line CA
  o.setHeading(o.towards(ax, ay));
  float am = o.distance(ax, ay)/2;
  o.pathForward(am, "CM.svg");
  o.setPosition(ax, ay);
  o.setHeading(o.towards(cx, cy));
  o.pathForward(am, "CM.svg");

  o.popState();

  if (annotate) drawArrow(scale);
}

void pair(float scale) {
  o.pushState();
  drawPiece(scale);
  o.setPosition(cx, cy);
  o.left(180);
  drawPiece(scale);
  o.popState();
}

void pairReflected(float scale) {
  o.pushState();
  o.left(180);
  o.beginReflection(); 
  pair(scale); 
  o.endReflection();
  o.popState();
}

void drawIHM() {
  pushStyle();
  o.pushState();
  textFont(font, 16);
  fill(0, 0, 255);

  float ac = o.distance(cx, cy);

  o.setPenColor(0, 0, 255);
  o.setPosition((ax+bx)/2, ay);
  ellipse(o.xcor(), o.ycor(), 10, 10);
  text("I", o.xcor()+10, o.ycor());
  o.left(90);

  o.beginDash();
  o.forward(ac);
  ellipse(o.xcor(), o.ycor(), 10, 10);
  text("H", o.xcor()+10, o.ycor());  
  o.endDash();

  float mx = (ax+cx)/2, my = (ay+cy)/2;
  ellipse(mx, my, 10, 10);
  text("M", mx + 10, my);  

  o.popState(); 
  popStyle();
}

void textABC() {
  pushStyle();

  textFont(font, 16);
  fill(255, 0, 0);

  ellipse(ax, ay, 10, 10);
  text("A", ax + 10, ay);

  ellipse(bx, by, 10, 10);
  text("B", bx + 10, by);  

  ellipse(cx, cy, 10, 10);
  text("C", cx + 10, cy);   

  popStyle();
}

void drawArrow(float scale) {
  o.pushState();

  o.setPosition((ax+bx+cx)/3, (ay+by+cy)/3);
  o.left(180);
  if (o.isReflecting()) {
    o.setStamp("halfarrow.svg");
  }
  else {
    o.setStamp("fullarrow.svg");
  }
  o.stamp(16*scale);

  o.popState();
}

/*
void drawArrow(float scale){
 o.pushState();
 
 if(o.isReflecting()){
 o.setPenColor(0,0,255);
 fill(0,0,255);
 }
 else{
 o.setPenColor(255,0,0);
 fill(255,0,0);
 }
 
 o.setPosition((ax+bx+cx)/3, (ay+by+cy)/3);
 
 o.left(180);
 o.backward(8*scale);
 o.forward(16*scale);
 o.setStamp(o.OARROWRIGHT);
 o.stamp(8*scale);
 
 o.popState(); 
 }
 */

void drawIntro() {
  pushStyle();
  fill(0);
  textFont(font, 32);
  text("No.21, Basic Type CGG", 200, 50);
  textFont(font, 16);
  text("Bring the arbitrary line AB by glide reflection until it connects to the position BC, where the "
    +"angle ABC is arbitrary (axis of glide reflection IH parallel to AC at equal distance from A "
    +" and B). Close the figure by a C-line CA."
    , 200, 100, 700, 200); 
  text("Network 666,\n"
    +"4 positionings."
    , 650, 250, 700, 100); 
  popStyle();
}

