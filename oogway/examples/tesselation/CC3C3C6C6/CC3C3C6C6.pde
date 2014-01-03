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
      groupPositions(scale);
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

void groupPositions(float scale){
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

