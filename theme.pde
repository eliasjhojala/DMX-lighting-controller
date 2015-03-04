Themes themes = new Themes();

class Themes {
  RectTheme window;
  Themes() {
    window = new RectTheme(color(255, 230), color(0, 200), 3, true);
  }
}


class RectTheme {
  color fill;
  color stroke;
  int strokeWeight;
  boolean drawStroke;
  
  RectTheme(color fill, color stroke, int stokeWeight, boolean drawStroke) {
    this.fill = fill;
    this.stroke = stroke;
    this.strokeWeight = strokeWeight;
    this.drawStroke = drawStroke;
  }
  
  void setTheme(PGraphics g, Mouse mouse) {
    g.fill(fill);
    if(drawStroke) {
      g.stroke(stroke);
      g.strokeWeight(strokeWeight);
    }
    else {
      g.noStroke();
    }
  }
}

class TextTheme {
  color fill;
  int size;
  TextTheme(color fill, int size) {
    this.fill = fill;
    this.size = size;
  }
  
  void setTheme(PGraphics g, Mouse mouse) {
    g.fill(fill);
    g.textSize(size);
  }
}
