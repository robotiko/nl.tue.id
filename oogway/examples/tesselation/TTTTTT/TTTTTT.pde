import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;
PFont font;

//latest vertex coordinates
float ax, ay, bx, by, cx, cy, dx, dy, ex, ey, fx, fy;
float ab = 70;
float af = 70;
float ad = 100;
float be;
float degreeABx = 5;
float degreeFAx = 105;
float degreeEBx;


void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "TTTTTT" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate) font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
  o.setPosition(o.xcor(), o.ycor() + 300);
  tesselate(1);

  o.home();
  o.setPosition(200, o.ycor()+250);
  abecdf(2);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();


  endRecord();
}

void tesselate(float scale) {
  o.pushState();
  for (int i = 0; i<3; i++) {
    abecdf(scale);
    float x = dx, y = dy;   
    for (int j = 1; j<3; j++) {
      o.setPosition(ex, ey);
      abecdf(scale);
    }
    o.setPosition(x,y);
  }
  o.popState();
}

void abecdf(float scale) {
  o.pushState();
  
  //arbitrary line AB
  o.remember("A");
  ax = o.xcor(); ay = o.ycor();
  ab(scale);
  bx = o.xcor(); by = o.ycor();
  
  //shift AB to DC
  o.recall("A");
  o.shift(-90, ad*scale);
  dx = o.xcor(); dy = o.ycor();
  ab(scale);
  cx = o.xcor(); cy = o.ycor();
  
  //arbitrary line AF
  o.recall("A");
  af(scale);
  fx = o.xcor(); fy = o.ycor();
  
  //Shift AF to EC (Translation vector AE)
  float degreeFCx = o.towards(cx, cy);
  float distanceFC = o.distance(cx, cy);
  o.recall("A");
  o.shift(degreeFCx, distanceFC);
  ex = o.xcor(); ey = o.ycor();
  af(scale);
  
  //draw BE
  o.setPosition(bx, by);
  be = o.distance(ex, ey);
  degreeEBx = o.towards(ex, ey);
  o.remember("B");
  be();
  
  //Move BE to FD (translation vector BF)
  o.recall("B");
  o.shift(o.towards(fx, fy), o.distance(fx, fy));
  be();

  o.popState();
  
  if(annotate) drawArrow(scale);
}

void ab(float scale){
  o.left(degreeABx);
  o.beginPath("AB.svg");  o.forward(ab*scale);  o.endPath();
}

void af(float scale){
  o.left(degreeFAx);
  o.beginPath("AF.svg");  o.forward(af*scale);  o.endPath(); 
}

void be(){
  o.setHeading(degreeEBx);
  o.beginPath("BE.svg");  o.forward(be);  o.endPath();
}

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((ax+bx+cx+dx+ex+fx)/6, (ay+by+cy+dy+ey+fy)/6);
  o.right(90);
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
     text("No.2, Basic Type TTTTTT",200,50);
     textFont(font,16);
     text("Shift the arbitrary line AB to DC. Shift the arbitrary line AF (F arbitrary) to EC (Translation "
    + "vector AE). Move a third arbitrary line BE to FD (translation vector BF) . "
         , 200, 100,700,200); 
     text("Number of arbitrary lines: 3\nNetwork: 333333\n1 Position"
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
  
  drawPoint("A", ax, ay, 0, 15);
  drawPoint("B", bx, by, 0, 15);  
  drawPoint("C", cx, cy, 15, -15);  
  drawPoint("D", dx, dy, -15, -15);  
  drawPoint("E", ex, ey,  15, 0);  
  drawPoint("F", fx, fy, -15, 0);
  
 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}

