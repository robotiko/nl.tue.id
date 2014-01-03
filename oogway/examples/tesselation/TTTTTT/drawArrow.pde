
void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx+Dx+Ex+Fx)/6, (Ay+By+Cy+Dy+Ey+Fy)/6);
  o.right(90);
  o.backward(10*scale);
  o.forward(20*scale);
  o.stamp(8*scale);  
  o.popState();
  popStyle();
} 

