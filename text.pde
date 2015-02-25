//Window to show values of some variables for debugging

boolean showOutputAsNumbers; 
 
public class secondApplet extends PApplet {
  
  PVector offset = new PVector(0, 0);

  public void setup() {
    size(600, 900);
    frameRate(4);
  }
  public void draw() {
    translate(offset.x, offset.y);
    if(showOutputAsNumbers == true) {
    background(0, 0, 0);
    fill(255, 255, 255);   
     
     
     for(int j = 0; j <= 5; j++) { 
        text("DMX", 5, 10);
          pushMatrix();
            for(int i = j*100; i < (j+1)*100; i++) {
              if(i <= DMX_CHAN_LENGTH) { //DMX protocol max channel
                fill(255, 255, 255);
                translate(0, 12);
                text(i + ":" + DMXforOutput[constrain(i, 0, DMXforOutput.length-1)], 10, 10);
              }
            }
          popMatrix();
        translate(100, 0);
     }
     
   
  
  
 fill(255, 255, 255);
  
   text("touchOSCchannels", 105, 10);
    for(int i = 0; i <= 24; i++) {
      fill(255, 255, 255);
      text(i + ":" + touchOSCchannel[i], 110, i*15+25);
  }

    
  translate(130, 0);
  fill(255, 255, 255);
  
  for(int j = 1; j <= 5; j++) {
    text("allChannels[" + str(j) + "]", j*100+5, 10);
    for(int i = 0; i < 24; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[1][i], 100*j+10, i*15+25);
    }
  }

  }
}
  
  /*
   * TODO: something like on Close set f to null, this is important if you need to 
   * open more secondapplet when click on button, and none secondapplet is open.
   */
   
  void mouseDragged() {
    frameRate(10);
    offset.y += mouseY-pmouseY;
    offset.x += mouseX-pmouseX;
  }
  void mouseReleased() {
    frameRate(4);
  }
  void keyPressed() {
    if(keyCode == DOWN) { offset.y += 100; }
    if(keyCode == UP) { offset.y -= 100; }
    if(keyCode == LEFT) { offset.x -= 100; }
    if(keyCode == RIGHT) { offset.x += 100; }
    if(key == 'r') { offset = new PVector(0, 0); }
    if(key==27) { key=0; }
  }
}


