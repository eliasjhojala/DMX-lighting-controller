import java.util.Collection;

ScreenHandler screen = new ScreenHandler();

class ScreenHandler {
  ArrayList<ImageBuffer> imageBuffers;
  ArrayList<DrawnArea> changedAreas;
  ScreenHandler() {
    imageBuffers = new ArrayList<ImageBuffer>();
    changedAreas = new ArrayList<DrawnArea>();
  }
  
  
  void draw() {
    for(DrawnArea drawnArea : changedAreas) {
      for(ImageBuffer imageBuffer : imageBuffers) {
        if(drawnArea.intersectsWith(imageBuffer)) {
          int areaX = int(drawnArea.start.x);
          int areaY = int(drawnArea.start.y);
          int areaW = int(drawnArea.size.x);
          int areaH = int(drawnArea.size.y);
          int bufferX = areaX - int(imageBuffer.location.x);
          int bufferY = areaY - int(imageBuffer.location.y);
          image(imageBuffer.buffer, areaX, areaY, areaW, areaH, bufferX, bufferY, areaW, areaH);
          // image(imageBuffer.buffer, bufferX, bufferY);
        }
      }
    }
    changedAreas.clear();
  }
  
  void reportChangedAreas(Collection<DrawnArea> areas) {
    changedAreas.addAll(areas);
  }
  
  ImageBuffer registerNewBuffer(int x, int y, int w, int h, int o) {
    if(o == 0) o = imageBuffers.size();
    ImageBuffer newBuffer = new ImageBuffer(this, x, y, w, h, o);
    imageBuffers.add(newBuffer);
    return newBuffer;
  }
}

class ImageBuffer {
  PVector location, size;
  PGraphics buffer;
  ScreenHandler parent;
  
  // This value will be linked to a pane manager
  int orderIndex;
  
  ImageBuffer(ScreenHandler parent, int x, int y, int w, int h, int orderIndex) {
    this.parent = parent;
    location = new PVector(x, y);
    size = new PVector(w, h);
    this.orderIndex = orderIndex;
    buffer = createGraphics(w, h);
  }
  
  PGraphics beginDraw() {
    buffer.beginDraw();
    return buffer;
  }
  
  void endDraw(Collection<DrawnArea> areas) {
    buffer.endDraw();
    parent.reportChangedAreas(areas);
  }
  
  void endDraw(DrawnArea area) {
    ArrayList<DrawnArea> areas = new ArrayList<DrawnArea>();
    areas.add(area);
    endDraw(areas);
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
  
  void updateDimens(int w, int h) {
    size = new PVector(w, h);
    PGraphics oldBuffer = buffer;
    buffer = createGraphics(int(size.x), int(size.y));
    // Preserve old buffer
    buffer.beginDraw();
    buffer.image(oldBuffer, 0, 0);
    buffer.endDraw();
    oldBuffer.dispose();
  }
}

class DrawnArea {
  PVector start, end, size;
  DrawnArea(ImageBuffer sourceBuffer, float x, float y, float w, float h) {
    x += sourceBuffer.location.x;
    y += sourceBuffer.location.y;
    start = new PVector(x, y);
    size = new PVector(w, h);
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
