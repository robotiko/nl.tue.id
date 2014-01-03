import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;
PFont font;

//latest vertex coordinates
float Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Ex, Ey;

float AB = 100;
float CD = 85;
float angleACD = 125;

//for tesselation the sets
float hDistance, hHeading;
float vDistance, vHeading;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "CC4C4C4C4" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate)font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
  
  o.right(45);
  
  o.setPosition(650, 450);
  tesselate(0.7);

  o.setPosition(300, 350);
  drawPiece(1.5);
  
  if(annotate) drawPoints();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();

  for (int i=0; i<2; i++) {
    o.pushState();
    for (int j=0; j<2; j++) {
      groupPositions(scale);
      o.shift(hHeading, hDistance);
    }
    o.popState();
    o.shift(vHeading, vDistance);
  }

  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Turn the arbitrary line AB around A by 90 Degrees into the position AC. 
  
  //AB
  o.remember("A");
  Ax = o.xcor(); Ay = o.ycor();
  o.forward(AB*scale, "AB.svg"); o.endPath();
  Bx = o.xcor(); By = o.ycor();
  
  //AC
  o.recall("A");
  o.right(90);
  o.beginPath("AB.svg"); o.forward(AB*scale); o.endPath();
  Cx = o.xcor(); Cy = o.ycor();
  
  // Draw another arbitrary line from C to the arbitrary point D
  // and turn it 90 degrees into the position DE.
  
  //CD
  o.left(180-angleACD);
  o.beginPath("CD.svg"); o.forward(CD*scale); o.endPath();
  Dx = o.xcor(); Dy = o.ycor();

  //DE
  o.left(90);
  o.up(); o.forward(CD*scale); o.down();
  Ex = o.xcor(); Ey = o.ycor();
  o.beginPath("CD.svg"); o.backward(CD*scale); o.endPath();  

  //Complete the figure by a C-line EB.
  
  //EB
  cline(Ex, Ey, Bx, By, "EM.svg");
      
  o.popState();
  
  if(annotate) drawArrow(scale);
}


void groupPositions(float scale){
  o.pushState();
  
  drawPiece(scale);
  
  float Mx = (Ex+Bx)/2, My = (Ey+By)/2;
  vHeading = o.towards(Mx, My);
  vDistance = 2 * o.distance(Mx, My);  
  
  o.right(90);
  drawPiece(scale);
   

  o.right(90);
  drawPiece(scale);

  o.right(90);
  drawPiece(scale);
  
  Mx = (Ex+Bx)/2; My = (Ey+By)/2;
  hHeading = o.towards(Mx, My);
  hDistance = 2 * o.distance(Mx, My);  
  
  o.popState();
}



