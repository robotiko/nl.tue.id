import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;
PFont font;

//latest A, B, C, D coordinates
float ax, ay, bx, by, cx, cy, dx, dy;
float ab = 100;
float ad = 100;
float degreeDAB = 80;

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
  o.setPosition(o.xcor(), o.ycor() + 250);
  tesselate(1);

  o.home();
  o.setPosition(200, o.ycor()+200);
  abcd(2);
  
  if(annotate) drawDashlines(2);  
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();
  for (int i = 0; i<3; i++) {
    abcd(scale);
    float x = dx, y = dy;   
    for (int j = 1; j<3; j++) {
      o.setPosition(bx, by);
      abcd(scale);
    }
    o.setPosition(x,y);
  }
  o.popState();
}

void abcd(float scale) {
  o.pushState();
  
  //arbitrary line AB
  ax = o.xcor(); ay = o.ycor();
  o.beginPath("AB.svg");  o.forward(ab*scale);  o.endPath();
  bx = o.xcor(); by = o.ycor();
  
  //shift AB to DC
  o.setPosition(ax, ay);
  o.left(degreeDAB);
  o.up(); o.forward(ad*scale); o.down();
  dx = o.xcor(); dy = o.ycor();
  o.right(degreeDAB);
  o.beginPath("AB.svg");  o.forward(ab*scale);  o.endPath();
  cx = o.xcor(); cy = o.ycor();
  
  //Another arbitrary line from A to D
  o.setPosition(ax, ay);
  o.left(degreeDAB);
  o.beginPath("AD.svg");  o.forward(ad*scale);  o.endPath();
  
  //shift AD to BC;
  o.setPosition(bx, by);
  o.beginPath("AD.svg");  o.forward(ad*scale);  o.endPath();

  o.popState();
  
  if(annotate) drawArrow(scale);
}


void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((ax+bx+cx+dx)/4, (ay+by+cy+dy)/4);
  o.right(180-degreeDAB);
  o.backward(10*scale);
  o.forward(20*scale);
  o.stamp(8*scale);  
  o.popState();
  popStyle();
}  

void drawIntro(){
  pushStyle();
     textFont(font,32);
     fill(0);
     text("Nr.1, Basic Type TTTT",200,50);
     textFont(font,16);
     text("Shift the arbitrary line AB to DC, such that ABCD are the corners of a parallelogram "
    + "translation vector AD). Draw another arbitrary line from A to D and shift it into the position "
    + "BC (translation vector AB)."
         , 200, 100,700,200); 
     text("Number of arbitrary lines: 2\nNetwork: 4444\n1 Position"
         , 650, 200,700,100); 
         popStyle();
}

void drawDashlines(float scale){
  pushStyle();
  o.pushState();
  textFont(font,16);
  fill(255,0,55);
  o.setPenColor(0,0,255);
  
  o.setPosition(ax, ay);
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  text("A", o.xcor()+10, o.ycor());
  o.left(degreeDAB);   
  o.beginDash(); o.forward(ad*scale); o.endDash();
  text("D", o.xcor()+10, o.ycor());
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  
  o.setPosition(bx, by);
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  text("B", o.xcor()+10, o.ycor());
  o.beginDash(); o.forward(ad*scale); o.endDash();
  text("C", o.xcor()+10, o.ycor());
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

