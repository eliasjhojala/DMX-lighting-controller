//Tässä välilehdessä tulostetaan mustalle taustalle valkoisin tekstein dim-arvot, sekä muutamien muiden muuuttujien arvoja

boolean showOutputAsNumbers; 
 
public class secondApplet extends PApplet {
  
  PVector offset = new PVector(0, 0);

  public void setup() {
    size(600, 900);
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
  
  
  
    
  translate(100, 0);
  fill(255, 255, 255);
  
  
    text("allChannels[1]", 105, 10);
    for(int i = 0; i < 24; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[1][i], 110, i*15+25);
  }
    text("allChannels[2]", 205, 10);
    for(int i = 0; i < 24; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[2][i], 210, i*15+25);
  }
    text("allChannels[3]", 305, 10);
    for(int i = 0; i < 24; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[3][i], 310, i*15+25);
  }
  text("allChannels[4]", 405, 10);
    for(int i = 0; i < 24; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[4][i], 410, i*15+25);
  }
  text("allChannels[5]", 505, 10);
    for(int i = 0; i < 24; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[5][i], 510, i*15+25);
  }
  text("memory", 605, 10);
  int a = 0;
    for(int i = 0; i < numberOfMemories; i++) {
      if(memoryValue[i] != 0) {
      a++;
      fill(255, 255, 255);
      text(i + ":" + memoryValue[i], 610, a*15+25);
      }
      else if(valueOfMemory[i] != 0) {
      a++;
      fill(255, 255, 255);
      text(i + ":" + valueOfMemory[i], 610, a*15+25);
      }
  }
  }
  if(addr != null) { 
  text(addr, 800, 100);
  }


  for(int id = 0; id <= 1; id++) {
    for(int i = 0; i < mhx50_createFinalChannelValues[id].length; i++) {
      text(mhx50_createFinalChannelValues[id][i], 800+id*200, 200+15*i);
    }
  }



}
  
  /*
   * TODO: something like on Close set f to null, this is important if you need to 
   * open more secondapplet when click on button, and none secondapplet is open.
   */
   
  void mouseDragged() {
    offset.y += mouseY-pmouseY;
    offset.x += mouseX-pmouseX;
  }
  void keyPressed() {
    if(keyCode == DOWN) { offset.y += 100; }
    if(keyCode == UP) { offset.y -= 100; }
    if(keyCode == LEFT) { offset.x -= 100; }
    if(keyCode == RIGHT) { offset.x += 100; }
    if(key == 'r') { offset = new PVector(0, 0); }
  }
}


