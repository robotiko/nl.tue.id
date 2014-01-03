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
float BC = 160;
float CD = 90;
float angleABC = 80;
float angleBCD = 55;

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "CCCC" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate) font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);

  o.setPosition(700, 300);
  o.left(170);
  tesselate(0.8);

  o.setPosition(400, 350);
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
    if(i%2==0)o.shift(180+hHeading, hDistance);
  }
  
  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Let AB and BC be two mutually independent C-lines with the common endpoint B.
  
  //AB
  Ax = o.xcor(); Ay = o.ycor();
  o.up(); o.forward(AB*scale); o.down();
  Bx = o.xcor(); By = o.ycor();
  cline(Ax, Ay, Bx, By, "AM1.svg");
  
  //BC
  o.left(180-angleABC);
  o.up(); o.forward(BC*scale); o.down();
  Cx = o.xcor(); Cy = o.ycor();
  cline(Bx, By, Cx, Cy, "BM2.svg");
  
  //Draw from C an arbitrary third and from A another arbitrary fourth C-line 
  // towards the freely selected point D.
  
  //CD
  o.left(180-angleBCD);
  o.up(); o.forward(CD*scale); o.down();
  Dx = o.xcor(); Dy = o.ycor();
  cline(Cx, Cy, Dx, Dy, "CM3.svg");
  
  //DA
  cline(Dx, Dy, Ax, Ay, "DM4.svg");
  
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
  
  drawPiece(scale);
  float _Bx = Bx, _By = By;
  
  o.setPosition(Dx, Dy);
  o.left(180);
  drawPiece(scale);
  
  o.setPosition(Dx, Dy);
  vDistance = o.distance(Bx, By);
  vHeading = o.towards(Bx, By);
  
  o.setPosition(_Bx, _By);
  hDistance = o.distance(Cx, Cy);
  hHeading = o.towards(Cx, Cy);
  

  o.popState();
}

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx)/4, (Ay+By+Cy+Dy)/4);
  //o.right(90);
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
     text("Nr.4, Basic Type CCCC",200,50);
     textFont(font,16);
     text("Let AB and BC be two mutually independent C-lines with the common endpoint B. Draw from C an arbitrary"
    + "third and from A another arbitrary fourth C-line towards the freely selected point D. "
         , 200, 100,700,200); 
     text("Number of arbitrary lines: 4\nNetwork: 4444\n2 Positions"
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
  drawPoint("B", Bx, By, -15, 0);  
  drawPoint("C", Cx, Cy, 0, 15);  
  drawPoint("D", Dx, Dy, 15, 0);

  drawPoint("M1", (Ax+Bx)/2, (Ay+By)/2, 0, -25);
  drawPoint("M2", (Bx+Cx)/2, (By+Cy)/2, -25, 0);  
  drawPoint("M3", (Cx+Dx)/2, (Cy+Dy)/2, 25, 0);  
  drawPoint("M4", (Dx+Ax)/2, (Dy+Ay)/2, 25, 0);    
 
  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}



