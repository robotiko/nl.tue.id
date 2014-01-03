import processing.pdf.*;
import nl.tue.id.oogway.*;

int XSIZE=int(3.6*297);
int YSIZE=int(3.6*210);

boolean annotate = true;

Oogway o;

//latest A, B, C coordinates
float ax, ay, bx, by, cx, cy;

float ab = 100;
float ac = 80;
float degreeBAC= 75;

PFont font;

void setup() {
  size(XSIZE, YSIZE);
  o = new Oogway(this);
  noLoop(); smooth();
  beginRecord(PDF, "CCC" + (annotate?"_Annotated.pdf":".pdf"));
  o.setPenColor(0);
  o.setPenSize(2);
  if(annotate) font = createFont("Comic Sans MS",32); 
}

void draw() {
  background(255);
  
  o.setPosition(o.xcor()+270, 330);
  tesselate(1);

  o.setPosition(200, 300);
  drawPiece(3);
  
  if(annotate) textABC();
  if(annotate) textMMM();
  if(annotate) drawIntro();

  endRecord();
}

void tesselate(float scale) {
  o.pushState();
 
  for(int i=0; i<3; i++){
    o.setHeading(0);
    pair(scale);
    float ax0 = ax, ay0 = ay;
    o.setPosition(ax, ay);
    float headingAC = o.towards(cx, cy);
    float ac = o.distance(cx, cy);
    for(int j=0; j<2; j++){
      o.setPosition(bx, by);
      o.setHeading(headingAC);
      o.up(); o.forward(ac); o.down();
      o.setHeading(0);
      pair(scale);
    }
    o.setPosition(ax0, ay0);
  }
  
  o.popState();
}

void drawPiece(float scale) {
  o.pushState();
  
  //Let AB be a C-line
  ax=o.xcor(); ay = o.ycor();
  o.right(90);
  o.beginPath("AM3.svg");  o.forward(ab*scale/2); o.endPath();
  o.up(); o.forward(ab*scale/2); o.down();
  bx=o.xcor(); by = o.ycor();
  o.left(180);
  o.beginPath("AM3.svg");  o.forward(ab*scale/2); o.endPath();
  
   //Draw another C-line from A to C
  o.setPosition(ax, ay);
  o.right(180-degreeBAC);
  o.beginPath("AM1.svg");  o.forward(ac*scale/2); o.endPath();
  o.up(); o.forward(ac*scale/2); o.down();
  cx=o.xcor(); cy = o.ycor();
  o.left(180);
  o.beginPath("AM1.svg");  o.forward(ac*scale/2); o.endPath();
  
  //Draw a third C-line from B to C
  o.setPosition(bx, by);
  float bm = o.distance(cx, cy)/2;
  o.setHeading(o.towards(cx, cy));
  o.beginPath("BM2.svg");  o.forward(bm); o.endPath();
  o.up(); o.forward(bm); o.down();
  o.left(180);
  o.beginPath("BM2.svg");  o.forward(bm); o.endPath();
  
  o.popState();
  
  if(annotate) drawArrow(scale);
}

void pair(float scale){
  o.pushState();
  drawPiece(scale);
  o.setPosition(bx, by);
  o.right(180);
  drawPiece(scale);
  o.popState();
}

void textABC(){
  pushStyle();

  textFont(font,16);
  fill(255,0,0);
  
  ellipse(ax, ay, 10 , 10);
  text("A", ax + 10, ay);
  
  ellipse(bx, by, 10 , 10);
  text("B", bx + 10, by);  

  ellipse(cx, cy, 10 , 10);
  text("C", cx + 10, cy);   
  
  popStyle();
}

void textMMM(){
  pushStyle();

  textFont(font,16);
  fill(0,0,255);
  
  float x = (ax+bx)/2;
  float y = (ay+by)/2;
  ellipse(x, y, 10 , 10);
  text("M1", x + 10, y);
  
  x = (ax+cx)/2;
  y = (ay+cy)/2;
  ellipse(x, y, 10 , 10);
  text("M3", x + 10, y);

  x = (bx+cx)/2;
  y = (by+cy)/2;
  ellipse(x, y, 10 , 10);
  text("M2", x + 10, y);  
  
  popStyle();
}

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
  //o.setStamp(o.OARROWRIGHT);
  o.stamp(8*scale);

  o.popState(); 
}

void drawIntro(){
  pushStyle();
  fill(0);
     textFont(font,32);
     text("Nr.3, Basic Type CCC",200,50);
     textFont(font,16);
     text("Let AB be a C-line. Draw from A another, and from B a third C-line towards the point C, "
     + "which is chosen freely (but not lying on the straight line through A and B)."
         , 200, 100,700,200); 
     text("Number of arbitrary lines: 3\nNetwork: 666\n2 Positions"
         , 650, 200,700,100); 
  popStyle();
}

