
void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx)/3, (Ay+By+Cy)/3);
  o.setHeading(o.towards((Ax+Bx)/2, (Ay+By)/2));
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

