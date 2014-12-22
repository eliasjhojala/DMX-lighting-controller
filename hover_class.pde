


      ////////////////////HOVER/-/CLASS/////////////////////////////////////////////////////////////
      //                                                                                          //
      //    The plan:                                                                             //
      //    You should be able to declare a hoverable object in the public "register" through     //
      //    this class. Something like hover.declareObject("name", priority, bound_coords);       //
      //    It should keep track of all mousable elements and provide a neat way to quickly       //
      //    know who gets to capture the mouse.                                                   //
      //                                                                                          //
      //////////////////////////////////////////////////////////////////////////////////////////////




Mouse mouse = new Mouse();
//--Yes, you can assign multiple mice and assing elements to each of them.

class Mouse {
  AtomicInteger objectUid = new AtomicInteger();
  ArrayList<HoverableElement> elements = new ArrayList<HoverableElement>();
  
  boolean captured = false;
  HoverableElement capturedElement;
  
  
  Mouse() {
    
  }
  
  void declareElement(String name, int priority, int x1, int y1, int x2, int y2) {
    elements.add(new HoverableElement(name, priority, x1, y1, x2, y2, objectUid.incrementAndGet()));
  }
  
  //Add on top of an existing element, returns true if successful
  boolean declareElement(String name, String ontopof, int x1, int y1, int x2, int y2) {
    for(HoverableElement elm : elements) {
      if(elm.name.equals(ontopof)) {
        elements.add(new HoverableElement(name, elm.priority + 1, x1, y1, x2, y2, objectUid.incrementAndGet()));
        return true;
      }
    }
    return false;
  }
  
  //Removes element. Returns true if element of name 'name' is found and deleted.
  boolean removeElement(String name) {
    int index = getElementIndexByName(name);
    if(index != -1) {
      elements.remove(index);
      return true;
    }
    return false;
    
  }
  
  
  boolean elmIsHover(String objName) {
    HoverableElement targetElement = getElementByName(objName);
    if(targetElement != null) return targetElement.isHovered; else return false;
  }
  
  //Should be called every draw. Picks one element to assing a capture to.
  void refresh() {
    boolean[] ontop = new boolean[elements.size()];
    for(int i = 0; i < ontop.length; i++) {
      HoverableElement elm = elements.get(i);
      elm.isHovered = false;
      ontop[i] = isHover(elm.x1, elm.y1, elm.x2, elm.y2);
    }
    int curMax = -2147483648;
    int maxId = 0;
    boolean found = false;
    for(int i = 0; i < ontop.length; i++) {
      HoverableElement elm = elements.get(i);
      if(ontop[i] && elm.priority > curMax) {
        curMax = elm.priority;
        maxId = i;
        found = true;
        break;
      }
    }
    if(found) elements.get(maxId).isHovered = true;
    if(mousePressed) {
      if(!captured && found) {
        captured = true;
        capturedElement = elements.get(maxId);
      }
    } else captured = false;
  }
  
  HoverableElement getElementByName(String name) {
    for(HoverableElement elm : elements) {
      if(elm.name.equals(name)) return elm;
    }
    return null;
  }
  
  int getElementIndexByName(String name) {
    for(int i = 0; i < elements.size(); i++) {
      if(elements.get(i).name = name) return i;
    }
    return -1;
  }
  
}


class HoverableElement {
  
  String name;        //Identifier
  int x1, y1, x2, y2; //Coordinates on screen
  int priority;       //priority
  
  int uid;            //unique identifier
  
  boolean isHovered;
  
  HoverableElement(String N, int P, int X1, int Y1, int X2, int Y2, int UID) {
    name = N;
    priority = P;
    x1 = X1; y1 = Y1;
    x2 = X2; y2 = Y2;
    uid = UID;
  }
  
}
