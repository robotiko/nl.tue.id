import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;
PFont font;

//latest vertex coordinates
float Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Ex, Ey;

float AC = 100;
float BD = 60;
float angleABD = 105;


//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "CC3C3C6C6" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
   
  o.left(30);
  
  o.setPosition(600, 320);
  tesselate(0.4);

  o.setPosition(250, 420);
  drawPiece(2);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();

  for (int i=0; i<4; i++) {
    o.pushState();
    for (int j=0; j<4; j++) {
      setOfSix(scale);
      o.shift(hHeading, hDistance);
      if(j%2==0) o.shift(vHeading, vDistance);
    }
    o.popState();
    o.shift(vHeading, vDistance);
    //if(i%2==0) o.shift(180+hHeading, hDistance);
  }

  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  // Turn the arbitrary line AC around A by 120 degrees into the position AB.
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.beginPath("AC.svg"); o.forward(AC*scale); o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  //AC
  o.recall("A");
  o.right(120);
  o.beginPath("AC.svg"); o.forward(AC*scale); o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  // Draw from B towards an arbitrary point D the arbitrary line BD
  
  //BD
  o.left(180-angleABD);
  o.beginPath("BD.svg"); o.forward(BD*scale); o.endPath();
  Dx = o.xcor(); Dy = o.ycor();
  
  //and turn it around D in the same turning direction by 60 degrees in the position DE.
  
  //DE
  o.left(120);
  o.up(); o.forward(BD*scale); o.down();
  Ex = o.xcor(); Ey = o.ycor();
  o.beginPath("BD.svg"); o.backward(BD*scale); o.endPath();

  //Complete the figure by a C-line EC.
  
  //EC
  cline(Ex, Ey, Cx, Cy, "EM.svg");
      
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

void setOfSix(float scale){
  o.pushState();
  
  drawPiece(scale);
  float _Dx = Dx, _Dy = Dy;
  
  o.right(120);
  drawPiece(scale);
  float Mx = (Ex+Cx)/2, My = (Ey+Cy)/2;
  float _Ex = Ex, _Ey = Ey;
  
  o.right(120);
  drawPiece(scale);
  
  o.pushState();
  o.setPosition(Dx, Dy);
  vHeading = o.towards(_Dx, _Dy);
  vDistance = o.distance(_Dx, _Dy);
  o.popState();
  
  o.setHeading(o.towards(Mx, My));
  o.up(); o.forward(2*o.distance(Mx, My)); o.down();
  
  o.setHeading(o.towards(_Ex, _Ey));
  drawPiece(scale);  
  
  o.right(120);
  drawPiece(scale);
  
  o.pushState();
  o.setPosition(Dx, Dy);
  hHeading = o.towards(_Dx, _Dy);
  hDistance = o.distance(_Dx, _Dy);
  o.popState();
  
  o.right(120);
  drawPiece(scale);
   
  o.popState();
}

void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx+Ex)/5, (Ay+By+Cy+Dy+Ey)/5);
  o.setHeading(o.towards(Ax, Ay));
  //o.backward(10*scale);
  o.shift(o.towards(Ax, Ay), 10*scale);
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
     text("No.13, Basic Type CC3C3C6C6",200,50);
     textFont(font,16);
     text("Turn the arbitrary line AC around A by 120 degrees into the position AB. "
    + "Draw from B towards an arbitrary point D the arbitrary line BD "
    + "and turn it around D in the same turning direction by 60 degrees in the position DE. "
    + "Complete the figure by a C-line EC. "
         , 200, 100,700,200);
     text("Number of arbitrary lines: 3\nNetwork: 63333\n6 Positions."
         , 650, 200, 700, 100); 
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
  drawPoint("B", Bx, By, -15, 0);  
  drawPoint("C", Cx, Cy, 15, 0);  
  drawPoint("D", Dx, Dy, 15, 0);  
  drawPoint("E", Ex, Ey, 15, 0); 
  
  drawPoint("M", (Ex+Cx)/2, (Ey+Cy)/2, 15, 15);

  ellipse(o.xcor(), o.ycor(), 10 , 10);
  o.popState();
  popStyle();
}

void drawPoint(String text, float x, float y, float a, float b){
    ellipse(x, y, 10 , 10);
    text(text, x+a, y + b);
}

