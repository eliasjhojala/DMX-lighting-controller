class Color {
  int red, green, blue, white;
  Color(int r, int g, int b) {
    red = r;
    green = g;
    blue = b;
  }
  Color(int r, int g, int b, int w) {
    red = r;
    green = g;
    blue = b;
    white = w;
  }
  int getRed() { return red; }
  int getGreen() { return green; }
  int getBlue() { return blue; }
  int getWhite() { return white; }
}
