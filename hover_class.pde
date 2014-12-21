


      ////////////////////HOVER/-/CLASS/////////////////////////////////////////////////////////////
      //                                                                                          //
      //    The plan:                                                                             //
      //    You should be able to declare a hoverable object in the public "register" through     //
      //    this class. Something like hover.declareObject("name", priority, bound_coords);       //
      //    It should keep track of all mousable elements and provide a neat way to quickly       //
      //    know who gets to capture the mouse.                                                   //
      //                                                                                          //
      //////////////////////////////////////////////////////////////////////////////////////////////

import java.util.concurrent.atomic.*;


Mouse mouse = new Mouse();


class Mouse {
  AtomicInteger objectUid = new AtomicInteger();
  ArrayList<HoverableElement> elements = new ArrayList<HoverableElement>();
  
  Mouse() {
    
  }
  
  void declareObject(String name, int priority, int x1, int y1, int x2, int y2) {
    elements.add(new HoverableElement(name, priority, x1, y1, x2, y2, objectUid.incrementAndGet()));
  }
  
  //Add on top of an existing element, returns true if successful
  boolean declareObject(String name, String ontopof, int x1, int y1, int x2, int y2) {
    for(HoverableElement elm : elements) {
      if(elm.name.equals(ontopof)) {
        elements.add(new HoerableElement(name, elm.priority + 1, x1, y1, x2, y2, objectUid.incrementAndGet()));
        return true;
      }
    }
    return false;
  }
  
  
  boolean isHover(String objName) {
    for(HoverableElement elm : elements) {
    }
  }
  
}


class HoverableElement {
  
  String name;        //Identifier
  int x1, y1, x2, y2; //Coordinates on screen
  int priority;       //priority
  
  int uid;            //unique identifier
  
  HoverableElement(String N, int P, int X1, int Y1, int X2, int Y2, int UID) {
    name = N;
    priority = P;
    x1 = X1; y1 = Y1;
    x2 = X2; y2 = Y2;
    uid = UID;
  }
  
}
