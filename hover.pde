
 

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


long lastRMBc = 0;
long lastLMBc = 0;

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
  
  /////////////////////////BRIDGED MODE////
  boolean bridgedMode = false;
  Mouse bridgedModeParent;
  String bridgedModeName;
  
  int bridgedX, bridgedY; //Offset in parent
  int bridgedW, bridgedH; //Height and width in parent
  
  //Initialize the mouse in a bridged mode, where THIS mouse is a sub-mouse to the parent mouse specified
  Mouse(Mouse parent, String nameInParent, int priority, int x_off, int y_off, int w, int h) {
    initializeBridge(parent, nameInParent, priority, x_off, y_off, w, h);
  }
  
  Mouse(Mouse parent, String nameInParent, String onTopOf, int x_off, int y_off, int w, int h) {
    initializeBridge(parent, nameInParent, parent.getElementByName(onTopOf).priority+1, x_off, y_off, w, h);
  }
  
  void initializeBridge(Mouse parent, String nameInParent, int priority, int x_off, int y_off, int w, int h) {
    bridgedMode = true;
    bridgedModeParent = parent;
    bridgedX = x_off; bridgedY = y_off;
    bridgedW = w;     bridgedH = h;
    parent.declareElement(nameInParent, priority, x_off, y_off, x_off+w, y_off+h);
    
  }
  
  void refreshBridged(int newX, int newY) {
    bridgedX = newX;
    bridgedY = newY;
    bridgedModeParent.updateElement(bridgedModeName, newX, newY, newX+bridgedW, newY+bridgedH);
    firstCaptureFrame = bridgedModeParent.firstCaptureFrame;
    if(bridgedMode) refresh(mouseX + bridgedX, mouseY + bridgedY);
  }
  
  void refreshBridged() {
    refreshBridged(bridgedX, bridgedY);
  }
  
  //////////////////////////////////////////
  
  void declareElement(String name, int priority, int x1, int y1, int x2, int y2) {
    elements.add(new HoverableElement(name, priority, x1, y1, x2, y2));
  }
  
  //Add on top of an existing element, returns true if successful
  boolean declareElement(String name, String ontopof, int x1, int y1, int x2, int y2) {
    HoverableElement elm = getElementByName(ontopof);
    if(elm != null) {
      elements.add(new HoverableElement(name, elm.priority + 1, x1, y1, x2, y2));
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
  boolean declareUpdateElementRelative(String name, String ontopof, int x1, int y1, int x2, int y2, PGraphics g) {
    return declareUpdateElement(name, ontopof, iScreenX(x1, y1, g), iScreenY(x1, y1, g), iScreenX(x1 + x2, y1 + y2, g), iScreenY(x1 + x2, y1 + y2, g));
  }
  
  void declareUpdateElement(String name, int priority, int x1, int y1, int x2, int y2) {
    if(!updateElement(name, x1, y1, x2, y2)) {
      declareElement(name, priority, x1, y1, x2, y2);
      
    }
  }
  void declareUpdateElementRelative(String name, int priority, int x1, int y1, int x2, int y2, PGraphics g) {
    declareUpdateElement(name, priority, iScreenX(x1, y1, g), iScreenY(x1, y1, g), iScreenX(x1 + x2, y1 + y2, g), iScreenY(x1 + x2, y1 + y2, g));
  }
  
  boolean declareUpdateElementRelative(String name, String ontopof, int x1, int y1, int x2, int y2) {
    return declareUpdateElementRelative(name, ontopof, x1, y1, x2, y2, g);
  }
  void declareUpdateElementRelative(String name, int priority, int x1, int y1, int x2, int y2) {
    declareUpdateElementRelative(name, priority, x1, y1, x2, y2, g);
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
  
  boolean setElementExpire(String name, int newExpire) {
    HoverableElement elm = getElementByName(name);
    if(elm != null) {
      elm.expires = newExpire;
      return true;
    } else return false;
  }
  
  
  boolean elmIsHover(String objName) {
    HoverableElement targetElement = getElementByName(objName);
    if(targetElement != null) return targetElement.isHovered; else return false;
  }
  
  void refresh() {
    refresh(mouseX, mouseY);
  }
  
  //Should be called every draw. Picks one element to assing a capture to.
  void refresh(float mouseX, float mouseY) {
    firstCaptureFrame = false;
    boolean[] ontop = new boolean[elements.size()];
    for(int i = 0; i < ontop.length; i++) {
      HoverableElement elm = elements.get(i);
      elm.isHovered = false;
      ontop[i] = isHoverAB(elm.x1, elm.y1, elm.x2, elm.y2);
    }
    int curMax = Integer.MIN_VALUE;
    int maxId = 0;
    boolean found = false;
    for(int i = 0; i < elements.size(); i++) {
      HoverableElement elm = elements.get(i);
      
      //Handle expiration
      boolean doNotContinue = false;
      if(elm.expires != -1)
        if(elm.expires > 0)  elm.expires--; else { elements.remove(i); doNotContinue = true; }
      
      if(!doNotContinue) {
        boolean bridgedPass = true;
        if(bridgedMode) {
          bridgedPass = bridgedModeParent.elmIsHover(bridgedModeName);
        }
        
        if(ontop[i] && elm.priority > curMax && elm.enabled && bridgedPass) {
          curMax = elm.priority;
          maxId = i;
          found = true;
        }
      }
      
      
    }
    if(found) {
      for(int i = 0; i < elements.size(); i++)
        if(ontop[i] && elements.get(i).priority == curMax)
          elements.get(i).isHovered = true;
          //If Mouse is on top of the element and it has the same priority as the other highest-priority elements currently Moused over, select it
    }
    if(mousePressed) {
      if(elements.get(maxId).autoCapture) capture(elements.get(maxId));
      
      
    } else captured = false;
  }
  
  //Use this if elements autoCapture is not on
  void capture(HoverableElement elm) {
    boolean bridgedPass = true;
    if(bridgedMode) {
      bridgedPass = bridgedModeParent.isCaptured(bridgedModeName);
    }
    if(elm.isHovered && !captured && elm.enabled && bridgedPass) {
        captured = true;
        capturedElement = elm;
        firstCaptureFrame = true;
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
  
  boolean enabled;    //Is element currently visible and clickable
  
  int expires = -1;
  
  boolean isHovered;  //Is element selected as the one to be hovered (not direct indication of capture)
  
  //You have to modify this manually
  boolean autoCapture = true;    //Is element automatically captured during refresh if it is selected or can an external source decide whether it should capture?
  
  HoverableElement(String N, int P, int X1, int Y1, int X2, int Y2) {
    name = N;
    priority = P;
    x1 = X1; y1 = Y1;
    x2 = X2; y2 = Y2;
    enabled = true;
  }
  
  
  
}

