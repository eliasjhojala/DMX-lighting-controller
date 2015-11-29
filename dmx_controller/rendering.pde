import java.util.Collection;
import java.util.TreeMap;

ScreenHandler screen = new ScreenHandler();

class ScreenHandler {
  TreeMap<Integer, ImageBuffer> imageBuffers;
  ArrayList<DrawnArea> changedAreas;
  ScreenHandler() {
    imageBuffers = new TreeMap<Integer, ImageBuffer>();
    changedAreas = new ArrayList<DrawnArea>();
  }
  
  
  void draw() {
    for(DrawnArea drawnArea : changedAreas) {
      for(ImageBuffer imageBuffer : imageBuffers.values()) {
        if(drawnArea.intersectsWith(imageBuffer)) {
          int areaX = int(drawnArea.start.x);
          int areaY = int(drawnArea.start.y);
          int areaW = int(drawnArea.size.x);
          int areaH = int(drawnArea.size.y);
          int bufferX = areaX - int(imageBuffer.location.x);
          int bufferY = areaY - int(imageBuffer.location.y);
          image(imageBuffer.buffer.get(bufferX, bufferY, areaW, areaH), areaX, areaY);
        }
      }
    }
    changedAreas.clear();
  }
  
  void reportChangedAreas(Collection<DrawnArea> areas) {
    changedAreas.addAll(areas);
  }
  
  ImageBuffer registerNewBuffer(String name, int x, int y, int w, int h, int o) {
    ImageBuffer newBuffer = new ImageBuffer(this, x, y, w, h, name);
    if(o >= 0) {
      imageBuffers.put(o, newBuffer);
    } else {
      imageBuffers.put(imageBuffers.lastKey()+1, newBuffer);
    }
    return newBuffer;
  }
  
  // Force everything to be redrawn (theme swap for example)
  void redrawEverything() {
    // TODO
  }
}

class ImageBuffer {
  PVector location, size;
  private PGraphics buffer;
  ScreenHandler parent;
  ArrayList<DrawnArea> areas;
  
  String debugName; // Not unique
  
  ImageBuffer(ScreenHandler parent, int x, int y, int w, int h, String name) {
    this.parent = parent;
    location = new PVector(x, y);
    size = new PVector(w, h);
    buffer = createGraphics(w, h);
    areas = new ArrayList<DrawnArea>();
    debugName = name;
  }
  
  PGraphics beginDraw() {
    buffer.beginDraw();
    areas.clear();
    return buffer;
  }
  
  // Choose one: Supply collection yourself || only one changed area || use built-in ArrayList
  void endDraw(Collection<DrawnArea> areas) {
    buffer.endDraw();
    parent.reportChangedAreas(areas);
  }
  
  void endDraw(DrawnArea area) {
    ArrayList<DrawnArea> areas = new ArrayList<DrawnArea>();
    areas.add(area);
    endDraw(areas);
  }
  
  void endDraw() {
    endDraw(areas);
    areas.clear();
  }
  
  void addArea(float x, float y, float w, float h) {
    areas.add(new DrawnArea(this, x, y, w, h));
  }
  
  void updateLocation(int x, int y) {
    ArrayList<DrawnArea> areas = new ArrayList<DrawnArea>();
    // Refresh all pixels in old area
    areas.add(new DrawnArea(this, 0, 0, size.x, size.y));
    location = new PVector(x, y);
    // Refresh all pixels in new area
    areas.add(new DrawnArea(this, 0, 0, size.x, size.y));
    parent.reportChangedAreas(areas);
  }
  
  void updateDimens(int w, int h, boolean preserve) {
    size = new PVector(w, h);
    PGraphics oldBuffer = buffer;
    buffer = createGraphics(int(size.x), int(size.y));
    // Preserve old buffer
    if(preserve) {
      buffer.beginDraw();
      buffer.image(oldBuffer, 0, 0);
      buffer.endDraw();
    }
    oldBuffer.dispose();
  }
}

class DrawnArea {
  PVector start, end, size;
  DrawnArea(ImageBuffer sourceBuffer, float x, float y, float w, float h) {
    x += sourceBuffer.location.x;
    y += sourceBuffer.location.y;
    start = new PVector(x-3, y-3);
    size = new PVector(w+6, h+6);
    end = PVector.add(start, size);
    
    sourceBuffer = null;
  }
  
  // Redraw whole buffer
  DrawnArea(ImageBuffer sourceBuffer) {
    start = new PVector().set(sourceBuffer.location);
    size = new PVector().set(sourceBuffer.size);
    end = PVector.add(start, size);
  }
  
  boolean intersectsWith(ImageBuffer imageBuffer) {
    return rectIntersect(start, size, imageBuffer.location, imageBuffer.size);
  }
}
