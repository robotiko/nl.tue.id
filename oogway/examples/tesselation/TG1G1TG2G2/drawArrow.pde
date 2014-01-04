
void drawArrow(float scale) {
  o.pushState();

  o.setPosition((Ax+Bx+Cx+Dx)/4, (Ay+By+Cy+Dy)/4);

  o.setHeading(o.towards((Ax+Bx)/2, (Ay+By)/2));
  if (o.isReflecting()) {
    o.setStamp("halfarrow.svg");
  }
  else {
    o.setStamp("fullarrow.svg");
  }
  o.stamp(16*scale);

  o.popState();
} 

