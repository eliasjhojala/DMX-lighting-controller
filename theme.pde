Themes themes = new Themes();

class Themes {
  ShapeTheme window;
  ShapeTheme bubble;
  ColorTheme bubbleColor;
  
  color topMenuTheme = color(222, 0, 0);
  color topMenuTheme2 = color(200, 0, 0);
  color topMenuAccent = color(150, 0, 0);
  
  /*
  Bubble: stroke color(150, 0, 0);
  */
  

  Themes() {
    window = new ShapeTheme(color(255, 230), color(0, 200), 3, true);
    
    bubbleColor = new ColorTheme(color(200, 0, 0), color(222, 0, 0), color(222, 0, 0));
    bubble = new ShapeTheme(bubbleColor, color(150, 0, 0), 2, true);
  }
}


class ShapeTheme {
  color fill;
  color stroke;
  int strokeWeight;
  boolean drawStroke;
  
  boolean fillAsTheme;
  boolean strokeAsTheme;
  
  ColorTheme fillTheme;
  ColorTheme strokeTheme;
  
  ShapeTheme(color fill, color stroke, int stokeWeight, boolean drawStroke) {
    this.fill = fill;
    this.stroke = stroke;
    this.strokeWeight = strokeWeight;
    this.drawStroke = drawStroke;
    this.fillAsTheme = false;
    this.strokeAsTheme = false;
  }
  
  ShapeTheme(ColorTheme fillTheme, color stroke, int stokeWeight, boolean drawStroke) {
    this.fillTheme = fillTheme;
    this.stroke = stroke;
    this.strokeWeight = strokeWeight;
    this.drawStroke = drawStroke;
    this.fillAsTheme = true;
    this.strokeAsTheme = false;
  }
  
  ShapeTheme(ColorTheme fillTheme, ColorTheme strokeTheme, int stokeWeight, boolean drawStroke) {
    this.fillTheme = fillTheme;
    this.strokeTheme = strokeTheme;
    this.strokeWeight = strokeWeight;
    this.drawStroke = drawStroke;
    this.fillAsTheme = true;
    this.strokeAsTheme = true;
  }
  
  ShapeTheme(color fill, ColorTheme strokeTheme, int stokeWeight, boolean drawStroke) {
    this.fill = fill;
    this.strokeTheme = strokeTheme;
    this.strokeWeight = strokeWeight;
    this.drawStroke = drawStroke;
    this.fillAsTheme = false;
    this.strokeAsTheme = true;
  }
  
  void setTheme(PGraphics g, Mouse mouse, boolean hover, boolean active) {
    if(fillAsTheme) {
      fillTheme.fillColor(g, mouse, hover, active);
    }
    else {
      g.fill(fill);
    }
    if(strokeAsTheme) {
      if(drawStroke) {
        strokeTheme.strokeColor(g, mouse, hover, active);
      }
    }
    else {
      if(drawStroke) {
        g.stroke(stroke);
        g.strokeWeight(strokeWeight);
      }
      else {
        g.noStroke();
      }
    }
  }

  void setTheme(PGraphics g, Mouse mouse) {
    setTheme(g, mouse, false, false);
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


class ColorTheme {
  color neutral;
  color hovered;
  color active;
  ColorTheme(color neutral, color hovered, color active) {
    this.neutral = neutral;
    this.hovered = hovered;
    this.active = active;
  }
  
  void fillColor(PGraphics g, Mouse mouse, boolean hover, boolean pressed) {
    if(hover && !pressed) { g.fill(hovered); }
    else if(pressed) { g.fill(active); }
    else { g.fill(neutral); }
  }
  
  void strokeColor(PGraphics g, Mouse mouse, boolean hover, boolean pressed) {
    if(hover && !pressed) { g.stroke(hovered); }
    else if(pressed) { g.stroke(active); }
    else { g.stroke(neutral); }
  }
  
  void fillColor(boolean hover, boolean pressed) {
    if(hover && !pressed) { fill(hovered); }
    else if(pressed) { fill(active); }
    else { fill(neutral); }
  }
  
  void strokeColor(boolean hover, boolean pressed) {
    if(hover && !pressed) { stroke(hovered); }
    else if(pressed) { stroke(active); }
    else { stroke(neutral); }
  }
  
  
  
}
