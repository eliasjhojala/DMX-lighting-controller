/* Using theme classes 

You can create new ShapeTheme with one of the followings command
new ShapeTheme(color,       color,       int,          boolean);
new ShapeTheme(ColorTheme,  color,       int,          boolean);
new ShapeTheme(ColorTheme,  ColorTheme,  int,          boolean);
new ShapeTheme(color,       ColorTheme,  int,          boolean);

And here is explanations of variables
new ShapeTheme(fillColor,   strokeColor, strokeWeight, drawStroke);

If you use color it don't change if object is hovered or clicked
If you use ColorTheme it changes when object is hovered or clicked

When you want to set some theme to your code you only have to 
call function themes.themeName.setTheme(g, mouse, isHovered, isPressed);
or function   themes.themeName(g, mouse);

Creating colorTheme is pretty easy also. It can be created calling function
new ColorTheme(neutralColor, hoveredColor, activeColor);
where all the variables are type color

*/

Themes themes = new Themes();

class Themes {
  ShapeTheme window;
  ShapeTheme bubble;
  ColorTheme bubbleColor;
  ShapeTheme button;
  ColorTheme buttonColor;
  
  color topMenuTheme = color(222, 0, 0);
  color topMenuTheme2 = color(200, 0, 0);
  color topMenuAccent = color(150, 0, 0);


  Themes() {
    window = new ShapeTheme(color(255, 230), color(150), 3, true);
    
    buttonColor = new ColorTheme(color(20, 50, 255), color(20, 70, 255), color(30, 100, 255));
    button = new ShapeTheme(buttonColor, color(0, 0, 255, 200), 2, false);
    
    bubbleColor = new ColorTheme(color(200, 0, 0), color(222, 0, 0), color(222, 0, 0));
    bubble = new ShapeTheme(bubbleColor, color(150, 0, 0), 2, true);
  }
}


class ShapeTheme {
  color fill, stroke;
  int strokeWeight;
  boolean drawStroke;
  
  boolean fillAsTheme, strokeAsTheme;
  ColorTheme fillTheme, strokeTheme;
  
  ShapeTheme(color fill, color stroke, int strokeWeight, boolean drawStroke) {
    this.fill = fill; this.stroke = stroke; this.strokeWeight = strokeWeight; this.drawStroke = drawStroke;
    this.fillAsTheme = false; this.strokeAsTheme = false;
  }
  
  ShapeTheme(ColorTheme fillTheme, color stroke, int strokeWeight, boolean drawStroke) {
    this.fillTheme = fillTheme; this.stroke = stroke; this.strokeWeight = strokeWeight; this.drawStroke = drawStroke;
    this.fillAsTheme = true; this.strokeAsTheme = false;
  }
  
  ShapeTheme(ColorTheme fillTheme, ColorTheme strokeTheme, int strokeWeight, boolean drawStroke) {
    this.fillTheme = fillTheme; this.strokeTheme = strokeTheme; this.strokeWeight = strokeWeight; this.drawStroke = drawStroke;
    this.fillAsTheme = true; this.strokeAsTheme = true;
  }
  
  ShapeTheme(color fill, ColorTheme strokeTheme, int strokeWeight, boolean drawStroke) {
    this.fill = fill; this.strokeTheme = strokeTheme; this.strokeWeight = strokeWeight; this.drawStroke = drawStroke;
    this.fillAsTheme = false; this.strokeAsTheme = true;
  }
  
  void setTheme(PGraphics g, Mouse mouse, boolean hover, boolean active) {
    if(fillAsTheme) { fillTheme.fillColor(g, mouse, hover, active); }
    else { g.fill(fill); }
    if(drawStroke) {
      if(strokeAsTheme) { strokeTheme.strokeColor(g, mouse, hover, active); }
      else { g.stroke(stroke); g.strokeWeight(strokeWeight); }
    }
    else { noStroke(); }
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
  
  void setTheme() {
    fill(fill);
    textSize(size);
  }
}


class ColorTheme {
  color neutral, hovered, active;

  ColorTheme(color neutral, color hovered, color active) {
    this.neutral = neutral; this.hovered = hovered; this.active = active;
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
