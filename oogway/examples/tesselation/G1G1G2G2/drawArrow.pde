
void drawArrow(float scale) {
  o.pushState();
  
  o.setPosition((Ax+Bx+Cx+Dx)/4, (Ay+By+Cy+Dy)/4);

  o.setHeading(o.towards(Dx, Dy));
  if (o.isReflecting()) {
    o.setStamp("halfarrow.svg");
  }
  else {
    o.setStamp("fullarrow.svg");
  }
  o.stamp(16*scale);
  
  o.popState();
} 


