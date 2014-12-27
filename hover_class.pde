


      ////////////////////HOVER/-/CLASS/////////////////////////////////////////////////////////////
      //                                                                                          //
      //    The plan:                                                                             //
      //    You should be able to declare a hoverable object in the public "register" through     //
      //    this class. Something like hover.declareObject("name", priority, bound_coords);       //
      //    It should keep track of all mousable elements and provide a neat way to quickly       //
      //    know who gets to capture the mouse.                                                   //
      //                                                                                          //
      //////////////////////////////////////////////////////////////////////////////////////////////
      //                                                                                          //
      //    How to use:                                                                           //
      //    To declare an element you can use:                                                    //
      //    mouse.declareElement(String name, int priority, int x1, int y1, int x2, int y2);      //
      //    or                                                                                    //
      //    mouse.declareElement(String name, String ontopof, int x1, int y1, int x2, int y2);    //
      //    where ontopof is the name of the element you want to place this element on top.       //
      //                                                                                          //
      //    To update an elements location you can use:                                           //
      //    mouse.updateElement(String name, int x1, int y1, int x2, int y2);                     //
      //    The name has to be the same as what it was when you created it.                       //
      //                                                                                          //
      //    You can change other preferences directly by getting the desired element like this:   // 
      //    mouse.getElementByName(String name).autoCapture = false;                              //
      //    where autocapture can be anything in the HoverableElement class.                      //
      //    autoCapture determines whether the object is automatically catpured or will           //
      //    the owner do it when it's "ready".                                                    //
      //                                                                                          //
      //    More advanced solutions:                                                              //
      //                                                                                          //
      //    declareUpdateElement(String name, int priority, int x1, int y1, int x2, int y2);      //
      //    and                                                                                   //
      //    declareUpdateElement(String name, String ontopof, int x1, int y1, int x2, int y2);    //
      //    These methods sort-of passively create an element if it doesn't exist and updates     //
      //    otherwise. This is useful if your element moves a lot.                                //
      //                                                                                          //
      //    Finally, the important things:                                                        //
      //                                                                                          //
      //    mouse.removeElement(String name); for deleting your element.                          //
      //                                                                                          //
      //    mouse.isCaptured(String name); for checking if your element gets the capture.         //
      //                                                                                          //
      //////////////////////////////////////////////////////////////////////////////////////////////




Mouse mouse = new Mouse();
//--Yes, you can assign multiple mice and assing elements to each of them seperately.

class Mouse {
  AtomicInteger objectUid = new AtomicInteger();
  ArrayList<HoverableElement> elements = new ArrayList<HoverableElement>();
  
  boolean captured = false;
  HoverableElement capturedElement;
  boolean firstCaptureFrame = false;
  
  
  Mouse() {
    
  }
  
  void declareElement(String name, int priority, int x1, int y1, int x2, int y2) {
    elements.add(new HoverableElement(name, priority, x1, y1, x2, y2, objectUid.incrementAndGet()));
  }
  
  //Add on top of an existing element, returns true if successful
  boolean declareElement(String name, String ontopof, int x1, int y1, int x2, int y2) {
    HoverableElement elm = getElementByName(ontopof);
    if(elm != null) {
      elements.add(new HoverableElement(name, elm.priority + 1, x1, y1, x2, y2, objectUid.incrementAndGet()));
      return true;
    }
    return false;
  }
  
  //Only declare if already existing, otherwise change the existing one. Returns true if successfull.
  boolean declareUpdateElement(String name, String ontopof, int x1, int y1, int x2, int y2) {
    HoverableElement elm = getElementByName(ontopof);
    if(elm != null) declareUpdateElement(name, elm.priority+1, x1, y1, x2, y2); else return false;
    return true;
  }
  
  void declareUpdateElement(String name, int priority, int x1, int y1, int x2, int y2) {
    if(!updateElement(name, x1, y1, x2, y2)) {
      declareElement(name, priority, x1, y1, x2, y2);
      
    }
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
  
  boolean updateElement(String name, int x1, int y1, int x2, int y2) {
    HoverableElement elm = getElementByName(name);
    if(elm != null) {
      elm.x1 = x1; elm.y1 = y1;
      elm.x2 = x2; elm.y2 = y2;
      return true;
    } else return false;
  }
  
  
  boolean elmIsHover(String objName) {
    HoverableElement targetElement = getElementByName(objName);
    if(targetElement != null) return targetElement.isHovered; else return false;
  }
  
  //Should be called every draw. Picks one element to assing a capture to.
  void refresh() {
    firstCaptureFrame = false;
    boolean[] ontop = new boolean[elements.size()];
    for(int i = 0; i < ontop.length; i++) {
      HoverableElement elm = elements.get(i);
      elm.isHovered = false;
      ontop[i] = isHoverAB(elm.x1, elm.y1, elm.x2, elm.y2);
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
      }
      
      //Handle expiration
      if(elm.expires != -1) if(elm.expires > 0) elm.expires--; else elements.remove(i);
    }
    if(found) {
      for(int i = 0; i < elements.size(); i++)
        if(ontop[i] && elements.get(i).priority == curMax)
          elements.get(i).isHovered = true;
          //If Mouse is on top of the element and it has the same priority as the other highest-priority elements currently Moused over, select it
    }
    if(mousePressed) {
      if(elements.get(maxId).autoCapture) capture(elements.get(maxId));
      firstCaptureFrame = true;
      
    } else captured = false;
  }
  
  //Use this if elements autoCapture is not on
  void capture(HoverableElement elm) {
    if(elm.isHovered && !captured) {
        captured = true;
        capturedElement = elm;
    }
  }
  
  boolean isCaptured(HoverableElement elm) {
    return captured && capturedElement == elm;
  }
  
  boolean isCaptured(String name) {
    return isCaptured(getElementByName(name));
  }
  
  HoverableElement getElementByName(String name) {
    for(HoverableElement elm : elements) {
      if(elm.name.equals(name)) return elm;
    }
    return null;
  }
  
  int getElementIndexByName(String name) {
    for(int i = 0; i < elements.size(); i++) {
      if(elements.get(i).name.equals(name)) return i;
    }
    return -1;
  }
  
}

/////////////////////////////////////////////////////////////////////////////////////////////////

class HoverableElement {
  
  String name;        //Identifier
  int x1, y1, x2, y2; //Coordinates on screen
  int priority;       //priority
  
  int uid;            //unique identifier
  
  int expires = -1;
  
  boolean isHovered;  //Is element selected as the one to be hovered (not direct indication of capture)
  
  //You have to modify this manually
  boolean autoCapture = true;    //Is element automatically captured during refresh if it is selected or can an external source decide whether it should capture?
  
  HoverableElement(String N, int P, int X1, int Y1, int X2, int Y2, int UID) {
    name = N;
    priority = P;
    x1 = X1; y1 = Y1;
    x2 = X2; y2 = Y2;
    uid = UID;
  }
  
  
  
}

