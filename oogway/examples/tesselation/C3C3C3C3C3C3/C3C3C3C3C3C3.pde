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
float CD = 60;
float angleACD = 130;


//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "C3C3C3C3C3C3" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
   
  o.left(60);
  
  o.setPosition(600, 370);
  tesselate(0.7);

  o.setPosition(150, 450);
  drawPiece(1.5);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();
  
  for(int i=0; i<2; i++){
    o.pushState();
    for(int j=0; j<2; j++){
    setOfThree(scale);
    o.shift(hHeading, hDistance);
    }
    
    o.popState();
    o.shift(vHeading, vDistance);

  }
  
  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Turn the arbitrary line AB by 120 degrees into the position AC.
  
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
  
  // Turn another arbitrary line CD(D arbitrary) around D by 120 degrees into the position DE.
  
  //CD
  o.left(180-angleACD);
  o.beginPath("CD.svg"); o.forward(CD*scale); o.endPath();
  Dx = o.xcor(); Dy = o.ycor();
  
  //DE
  o.left(60);
  o.up(); o.forward(CD*scale); o.down();
  Ex = o.xcor(); Ey = o.ycor();
  o.beginPath("CD.svg"); o.backward(CD*scale); o.endPath();
  
  //F is the third corner of the equilateral triangle ADF, the angle EFB being equal to 120 degrees.
  o.setPosition(Dx, Dy);
  o.setHeading(o.towards(Ax, Ay));
  o.right(60);
  o.up(); o.forward(o.distance(Ax, Ay)); o.down();
  Fx = o.xcor(); Fy = o.ycor();
  
  //EF
  o.setPosition(Ex, Ey);
  o.setHeading(o.towards(Fx, Fy));
  o.beginPath("EF.svg"); o.forward(o.distance(Fx, Fy)); o.endPath();  
  
  //BF
  o.setPosition(Bx, By);
  o.setHeading(o.towards(Fx, Fy));
  o.beginPath("EF.svg"); o.forward(o.distance(Fx, Fy)); o.endPath();  
      
  o.popState();
  
  if(annotate) drawArrow(scale);
}


void setOfThree(float scale){
  o.pushState();
  
  drawPiece(scale);
  float _Fx = Fx, _Fy = Fy;
 
  o.right(120);
  drawPiece(scale);
  float _Fx_ = Fx, _Fy_ = Fy;
  
  o.right(120);
  drawPiece(scale);
  
  o.setPosition(Fx, Fy);
  hHeading = o.towards(_Fx, _Fy);
  hDistance = o.distance(_Fx, _Fy);
  
  vHeading = o.towards(_Fx_, _Fy_);
  vDistance = o.distance(_Fx_, _Fy_);
  
  o.popState();
}

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx+Ex+Fx)/6, (Ay+By+Cy+Dy+Ey+Fy)/6);
  o.setHeading(o.towards(Ax, Ay));
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
     text("Nr.9, Basic Type C3C3C3C3C3C3",200,50);
     textFont(font,16);
     text("Turn the arbitrary line AB by 120 degrees into the position AC."
    + " Turn another arbitrary line CD(D arbitrary) around D by 120 degrees into the position DE."
    + " F is the third corner of the equilateral triangle ADF, the angle EFB being equal to 120 degrees."
    + " Turn a third arbitrary line FE around F by 120 degrees into the position FB."
         , 200, 100,700,200);
     text("Number of arbitrary lines: 3\nNetwork: 333333,\n3 Positions."
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
  
  drawPoint("A", Ax, Ay, -15, 0);
  drawPoint("B", Bx, By, 0, -15);  
  drawPoint("C", Cx, Cy, 0, 15);  
  drawPoint("D", Dx, Dy, 0, 15);
  drawPoint("E", Ex, Ey, 15, 0);  
  drawPoint("F", Fx, Fy, 15, 0);
 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}

