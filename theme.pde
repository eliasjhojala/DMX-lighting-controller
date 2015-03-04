Themes themes = new Themes();

class Themes {
  ShapeTheme window;
  
  color topMenuTheme = color(222, 0, 0);
  color topMenuTheme2 = color(200, 0, 0);
  color topMenuAccent = color(150, 0, 0);
  
  /*
  Bubble: stroke color(150, 0, 0);
  */
  

  Themes() {
    window = new ShapeTheme(color(255, 230), color(0, 200), 3, true);
    bubble = new ShapeTheme(color(222, 0, 0), color(150, 0, 0), 2, true);
  }
}


class ShapeTheme {
  color fill;
  color stroke;
  int strokeWeight;
  boolean drawStroke;
  
  ShapeTheme(color fill, color stroke, int stokeWeight, boolean drawStroke) {
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

class colorTheme {
  color neutral;
  color hovered;
  color active;
  colorTheme(color neutral, color hovered, color active) {
    this.neutral = neutral;
    this.hovered = hovered;
    this.active = active;
  }
  
  void setColor(PGraphics g, boolean hover, boolean pressed) {
    if(hover && !pressed) {
      g.fill(hovered);
    }
    else if(pressed) {
      g.fill(active);
    }
    else {
      g.fill(neutral);
    }
  }
}
