final int ELEMENT_TYPE_RECTANGLE = 0;
final int ELEMENT_TYPE_ELLIPSE = 1;
final int ELEMENT_TYPE_CIRCLE = 2; 

ArrayList<Element> elements = new ArrayList<Element>();

void elementsSetup() {
	elements.add(new Element(ELEMENT_TYPE_RECTANGLE, new PVector(100, 100), new PVector(1000, 500), color(255, 255, 0)));
}

class Element {
	PVector location, size;
	int type;
	color col;
	
	Element(int type, PVector location, PVector size, color col) {
		setLocation(location);
		setSize(size);
		setType(type);
		setColor(col);
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
	}
	
	void setSizeOffset(PVector os) {
		size.x += os.x;
		size.y += os.y;
	}
	
	void draw() {
		switch(type) {
			case ELEMENT_TYPE_RECTANGLE:
				pushMatrix();
					translate(location.x, location.y);
					fill(col);
					rect(0, 0, size.x, size.y);
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
						}
					}
					else if(capturedAtCorner) {
						setSizeOffset(new PVector(mouseX - pmouseX, mouseY - pmouseY));
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
	
	
	ElementController() {
		locX = 0; locY = 0; w = 500; h = 500;
		window = new Window("ElementControllerWindow", new PVector(w, h), this);
	}
	
	java.lang.Object element;
	
	Class elementClass;
	
	void elementToControl(java.lang.Object element) {
		this.element = element;
                elementClass = element.getClass();
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
					if(sliderChanged(g, mouse, 2)) { setColor(color(red, blue, getColorValue(2))); }
				g.popMatrix();
			} //End of RGB picker
		}
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
              try {
					elementClass.getDeclaredMethod("setColor", color.class).invoke(element, c);
              }
              catch (Exception e) {
                e.printStackTrace();
              }
	}
}
