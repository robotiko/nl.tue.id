
void drawArrow(float scale){
  pushStyle();
  o.pushState();
  fill(255,0,0);
  o.setPenColor(255,0,0);
  o.setPosition((Ax+Bx+Cx)/3, (Ay+By+Cy)/3);
  o.setHeading(180+o.towards(Ax, Ay));
  o.backward(5*scale);
  o.left(135);
  o.forward(4*scale);
  o.backward(4*scale);
  o.right(135);
  o.forward(10*scale);
  o.stamp(8*scale);  
  o.popState();
  popStyle();
} 
