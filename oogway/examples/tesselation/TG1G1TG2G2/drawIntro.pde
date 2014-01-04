
void drawIntro() {
  pushStyle();
  textFont(font, 32);
  fill(0);
  text("No.18, Basic Type TG1G1TG2G2", 200, 50);
  textFont(font, 16);
  text("Shift the arbitrary line AB to DC. "
    + "Connect A to a point E by an arbitrary line and glide-reflect AE towards ED. "
    + "Complete the figure by another pair of glide-reflected and connected lines BF, FC"
    , 200, 100, 700, 200);
  text("Number of arbitrary lines: 3\nNetwork: 333333\n2 Positions."
    , 650, 180, 700, 100); 
  popStyle();
}

