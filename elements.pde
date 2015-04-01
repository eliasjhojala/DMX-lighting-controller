final int ELEMENT_TYPE_RECTANGLE = 0;
final int ELEMENT_TYPE_ELLIPSE = 1;
final int ELEMENT_TYPE_CIRCLE = 2;

ArrayList<Element> elements = new ArrayList<Element>();

void elementsSetup() {
	//elements.add(new Element(ELEMENT_TYPE_RECTANGLE, new PVector(100, 100), new PVector(1000, 500), color(255, 255, 0)));
}

void createNewElement() {
	elements.add(new Element());
}

XML elementsAsXML() {
  String data = "<elements></elements>";
  XML xml = parseXML(data);
  for(int i = 0; i < elements.size(); i++) {
    xml = xml.addChild(elements.get(i).getXML());
    xml.setInt("id", i);
    xml = xml.getParent();
  }
  return xml;
}

void XMLtoElements(XML xml) {
  XML[] blocks = xml.getChildren();
  int a = 0;
  for(int i = 0; i < blocks.length; i++) {
    if(!trim(blocks[i].toString()).equals("")) {
      Element elm = new Element();
      elm.XMLtoObject(blocks[i]);
      elements.add(elm);
    }
  }
}

void saveElementsToXML() {
  saveXML(elementsAsXML(), "XML/elements.xml");
}

void loadElementsFromXML() {
  XMLtoElements(loadXML("XML/elements.xml"));
  elementController.open = false;
}

class Element {
	PVector location, size;
	int type;
	color col;
	
	Element() {
		location = new PVector(0, 0);
        size = new PVector(30, 30);
        col = color(100, 100, 100);
        type = ELEMENT_TYPE_RECTANGLE;
		elementController.open = true;
		elementController.elementToControl(this);
	}
	
	Element(int type, PVector location, PVector size, color col) {
		setLocation(location);
		setSize(size);
		setType(type);
		setColor(col);
	}
	
	XML getXML() {
		String data = "<element></element>";
		XML xml = parseXML(data);
		try { 
                  xml.addChild(PVectorAsXML("size", size));
                  xml.addChild(PVectorAsXML("location", location)); 
                  xml.addChild(colorAsXML("color", col));
                }
                catch (Exception e) {}
		return xml;
	} 

        void XMLtoObject(XML xml) {
          size = xmlAsPvector("size", xml);
          location = xmlAsPvector("location", xml);
          col = xmlAsColor("color", xml);
        }
	
	void setColor(color c) {
		this.col = c;
	}
	
	void setType(int t) {
		this.type = t;
	}
	
	void setSize(PVector s) {
		this.size = s;
	}
	
	void setLocation(PVector l) {
		this.location = l;
	}
	
	void setLocationOffset(PVector os) {
		location.x += os.x;
		location.y += os.y;
                location.z += os.z;
                if(elementController.element == this) { elementController.setLocationToControllers(location); }
	}
	
	void setSizeOffset(PVector os) {
		size.x += os.x;
		size.y += os.y;
                size.x += os.z;
                if(elementController.element == this) { elementController.setSizeToControllers(size); }
	}

        void draw3D() {
          translate(location.x, location.y, location.z);
          switch(type) {
              case ELEMENT_TYPE_RECTANGLE:
                  fill(255, 255, 255);
                  Box(size);
              break;
          }
          
        }
        
        void Box(PVector size) {
          box(round(size.x)*5, round(size.y)*5, round(size.z)*5);
        }
	
	void draw() {
		switch(type) {
			case ELEMENT_TYPE_RECTANGLE:
				pushMatrix();
					translate(location.x, location.y);
					fill(col);
					rect(0, 0, size.x, size.y);
					
					if(!showMode) {
						pushStyle();
							stroke(100);
							for(int i = 0; i < 5; i++) {
								line(size.x-1, size.y-i*3-1, size.x-i*3-1, size.y-1);
							}
						popStyle();
						
						String mouseNameBase = "Element" + this.toString();
						String mouseNameWhole = mouseNameBase + "whole";
						String mouseNameCorner = mouseNameBase + "corner";
						mouse.declareUpdateElementRelative(mouseNameWhole, 10, 0, 0, round(size.x), round(size.y));
						mouse.declareUpdateElementRelative(mouseNameCorner, 11, round(size.x)-10, round(size.y)-10, 20, 20);
						mouse.setElementExpire(mouseNameWhole, 2);
						mouse.setElementExpire(mouseNameCorner, 2);
						boolean captured = mouse.isCaptured(mouseNameWhole);
						boolean capturedAtCorner = mouse.isCaptured(mouseNameCorner);
						if(captured && !capturedAtCorner) {
							if(mouseButton == LEFT) {
								setLocationOffset(new PVector(mouseX - pmouseX, mouseY - pmouseY));
							}
							else if(mouseButton == RIGHT) {
								elementController.open = true;
								elementController.elementToControl(this);
                                                                elementController.setLocationToControllers(location);
                                                                elementController.setSizeToControllers(size);
                                                                elementController.setColorToControllers(col);
							}
						}
						else if(capturedAtCorner) {
							setSizeOffset(new PVector(mouseX - pmouseX, mouseY - pmouseY));
						}
						if(mouse.elmIsHover(mouseNameCorner) || capturedAtCorner) { cursor(CROSS); }
						else if(mouse.elmIsHover(mouseNameWhole) || captured) { cursor(MOVE); }
						else { cursor(ARROW); }
					}
				popMatrix();
			break;
		}
	}
	
}


ElementController elementController = new ElementController();

class ElementController {
	Window window;
	int locX, locY, w, h;
	boolean open;
	
	IntController xS, yS, zS, xL, yL, zL;
        LocationController locationController;
	
	
	ElementController() {
		locX = 0; locY = 0; w = 500; h = 500;
		
		xS = new IntController("ElementControllerWindow:xS");
		yS = new IntController("ElementControllerWindow:yS");
		zS = new IntController("ElementControllerWindow:zS");
		xL = new IntController("ElementControllerWindow:xL");
		yL = new IntController("ElementControllerWindow:yL");
		zL = new IntController("ElementControllerWindow:zL");
		
		window = new Window("ElementControllerWindow", new PVector(w, h), this);
                locationController = new LocationController();
	}
	
	Element element;


	void elementToControl(Element element) {
		this.element = element;
	}


	
	void draw(PGraphics g, Mouse mouse, boolean isTranslated) {
		window.draw(g, mouse);
		g.translate(60, 60);
		if(element != null) {
			{ //RGB picker
				g.pushMatrix();
					if(sliderChanged(g, mouse, 0)) { setColor(color(getColorValue(0), green, blue)); }
					g.translate(50, 0);
					if(sliderChanged(g, mouse, 1)) { setColor(color(red, getColorValue(1), blue)); }
					g.translate(50, 0);
					if(sliderChanged(g, mouse, 2)) { setColor(color(red, green, getColorValue(2))); }
				g.popMatrix();
			} //End of RGB picker
                        LocationController lC = locationController;
                        g.pushMatrix();
                          g.translate(200, 0);
                          lC.draw(g, mouse);
    			    if(lC.locXchanged()) setLocationX(lC.getLocX());
                            if(lC.locYchanged()) setLocationX(lC.getLocY());
                            if(lC.locZchanged()) setLocationX(lC.getLocZ());
                            if(lC.sizeXchanged()) setSizeX(lC.getSizeX());
                            if(lC.sizeYchanged()) setSizeY(lC.getSizeY());
                            if(lC.sizeZchanged()) setSizeZ(lC.getSizeZ());
                          
                        g.popMatrix();
		}
	}
	
	void setSizeX(int val) {
          element.size.x = val;
	}
	void setSizeY(int val) {
          element.size.y = val;
	}
	void setSizeZ(int val) {
          element.size.z = val;
	}
	void setLocationX(int val) {
          element.location.x = val;
	}
	void setLocationY(int val) {
          element.location.y = val;
	}
	void setLocationZ(int val) {
          element.location.z = val;
	}

        void setLocationToControllers(PVector loc) {
          LocationController lC = locationController;
            lC.setLocationToControllers(loc);
        }
        
        void setSizeToControllers(PVector s) {
          LocationController lC = locationController;
            lC.setSizeToControllers(s);
        }
        
        void setColorToControllers(color c) {
          red = round(red(c));
          green = round(green(c));
          blue = round(blue(c));
        }
	
	boolean sliderChanged(PGraphics g, Mouse mouse, int c) {
		int h = 0;
		g.strokeWeight(3);
		g.stroke(255, 230);
		g.fill(200);
		g.rect(0, 0, 30, 200);
		switch(c) {
			case 0: g.fill(255, 0, 0); h = red; break;
			case 1: g.fill(0, 255, 0); h = green; break;
			case 2: g.fill(0, 0, 255); h = blue; break;
		}
		g.rect(0, 200, 30, map(h, 0, 255, 0, -200));
		mouse.declareUpdateElementRelative("ElementControllerSlider" + str(c), 100000, 0, 0, 30, 200, g);
		if(mouse.isCaptured("ElementControllerSlider" + str(c))) {
			return true;
		}
		return false;
	}
	
	int red, green, blue;
	
	int getColorValue(int c) {
		int os = pmouseY-mouseY;
		switch(c) {
			case 0:
				red += os;
				red = constrain(red, 0, 255);
			return red;
			case 1:
				green += os;
				green = constrain(green, 0, 255);
			return green;
			case 2:
				blue += os;
				blue = constrain(blue, 0, 255);
			return blue;
		}
		return 0;
	}
	
	
	void setColor(color c) {
              element.setColor(c);
	}
}

class LocationController {
  IntController xS, yS, zS, xL, yL, zL;
  
  boolean sizeXchanged, sizeYchanged, sizeZchanged;
  boolean locationXchanged, locationYchanged, locationZchanged;
  
  PVector size, location;
  
  LocationController() {
    xS = new IntController("LocationController"+this.toString()+":xS");
    yS = new IntController("LocationController"+this.toString()+":yS");
    zS = new IntController("LocationController"+this.toString()+":zS");
    xL = new IntController("LocationController"+this.toString()+":xL");
    yL = new IntController("LocationController"+this.toString()+":yL");
    zL = new IntController("LocationController"+this.toString()+":zL");
    size = new PVector(0, 0);
    location = new PVector(0, 0);
  }
  
  
  void draw(PGraphics g, Mouse mouse) {
    { //Location and size controllers
    try {
        g.pushMatrix();
          g.pushMatrix();
            xS.draw(g, mouse); if(xS.valueHasChanged()) { setSizeX(xS.getValue()); }
            g.translate(0, 30);
            yS.draw(g, mouse); if(yS.valueHasChanged()) { setSizeY(yS.getValue()); }
            g.translate(0, 30);
            zS.draw(g, mouse); if(zS.valueHasChanged()) { setSizeZ(zS.getValue()); }
          g.popMatrix();
          g.translate(100, 0);
          g.pushMatrix();
            xL.draw(g, mouse); if(xL.valueHasChanged()) { setLocationX(xL.getValue()); }
            g.translate(0, 30);
            yL.draw(g, mouse); if(yL.valueHasChanged()) { setLocationY(yL.getValue()); }
            g.translate(0, 30);
            zL.draw(g, mouse); if(zL.valueHasChanged()) { setLocationZ(zL.getValue()); }
          g.popMatrix();
        g.popMatrix();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
      } //End of location and size controllers
  }
  
  void setSizeX(int val) {
     sizeXchanged = true;
     size.x = val;
  }
  void setSizeY(int val) {
     sizeYchanged = true;
     size.y = val;
  }
  void setSizeZ(int val) {
     sizeZchanged = true;
     size.z = val;
  }
  void setLocationX(int val) {
     locationXchanged = true;
     location.x = val;
  }
  void setLocationY(int val) {
     locationYchanged = true;
     location.y = val;
  }
  void setLocationZ(int val) {
     locationZchanged = true;
     location.z = val;
  }
  
  boolean locXchanged() {
    boolean toReturn = locationXchanged;
    locationXchanged = false;
    return toReturn;
  }
  boolean locYchanged() {
    boolean toReturn = locationYchanged;
    locationYchanged = false;
    return toReturn;
  }
  boolean locZchanged() {
    boolean toReturn = locationZchanged;
    locationZchanged = false;
    return toReturn;
  }
  boolean sizeXchanged() {
    boolean toReturn = sizeXchanged;
    sizeXchanged = false;
    return toReturn;
  }
  boolean sizeYchanged() {
    boolean toReturn = sizeYchanged;
    sizeYchanged = false;
    return toReturn;
  }
  boolean sizeZchanged() {
    boolean toReturn = sizeZchanged;
    sizeZchanged = false;
    return toReturn;
  }
  
  int getLocX() { return round(location.x); }
  int getLocY() { return round(location.y); }
  int getLocZ() { return round(location.z); }
  int getSizeX() { return round(size.x); }
  int getSizeY() { return round(size.y); }
  int getSizeZ() { return round(size.z); }
  
  void setLocationToControllers(PVector loc) {
      xL.setValue(loc.x);
      yL.setValue(loc.y);
      zL.setValue(loc.z);
  }
  
  void setSizeToControllers(PVector s) {
      xS.setValue(s.x);
      yS.setValue(s.y);
      zS.setValue(s.z);
  }
}
