

// Returns true if pointer is between start and end
boolean inBds1D(float pointer, float start, float end) {
  if(start > end) {
    float end_ = end;
    end = start;
    start = end_;
  }
  return pointer >= start && pointer <= end;
}

// Return true if pointer{x, y} is inside rectangle{sX, sY, eX, eY} (point a, point b)
boolean inBds2D(float pX, float pY, float sX, float sY, float eX, float eY) {
  return inBds1D(pX, sX, eX) && inBds1D(pY, sY, eY);
}

// Returns ture if pointer{x, y} is inside rectangle{x, y, w, h} (starting point, size)
boolean inBounds(float pointerX, float pointerY, float x, float y, float w, float h) {
  return inBds2D(pointerX, pointerY, x, y, x+w, y+h);
}

// Returns true if rect1{x, y, w, h} intersects with rect2{x, y, w, h} (starting point, size)
boolean rectIntersect(float rect1x, float rect1y, float rect1w, float rect1h, float rect2x, float rect2y, float rect2w, float rect2h) {
  float rect1xB = rect1x + rect1w, rect1yB = rect1y + rect1h;
  float rect2xB = rect2x + rect2w, rect2yB = rect2y + rect2h;
  return rect1x <= rect2xB && rect1xB >= rect2x
      && rect1y <= rect2yB && rect1yB >= rect2y;
}

// Same as above, but with PVectors
boolean rectIntersect(PVector rect1location, PVector rect1size, PVector rect2location, PVector rect2size) {
  return rectIntersect(rect1location.x, rect1location.y, rect1size.x, rect1size.y, rect2location.x, rect2location.y, rect2size.x, rect2size.y);
}
