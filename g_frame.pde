//Tässä välilehdessä tulostetaan mustalle taustalle valkoisin tekstein dim-arvot, sekä muutamien muiden muuuttujien arvoja

boolean showOutputAsNumbers;

public class secondApplet extends PApplet {

  public void setup() {
    size(600, 900);
  }
  public void draw() {
    if(showOutputAsNumbers == true) {
    background(0, 0, 0);
    fill(255, 255, 255);
    text("DMX", 5, 10);
    for(int i = 0; i < 40; i++) {
      fill(255, 255, 255);
      text(i + ":" + valueToDmx[i], 10, i*15+25);
  }
    translate(100, 0);
  fill(255, 255, 255);
  text("DMX", 5, 10);
  for(int i = 0; i < 40; i++) {
      fill(255, 255, 255);
      text(i+40 + ":" + valueToDmx[i+40], 10, i*15+25);
  }
  translate(100, 0);
  fill(255, 255, 255);
  text("DMX", 5, 10);
  for(int i = 0; i < 40; i++) {
      fill(255, 255, 255);
      text(i+40+40 + ":" + valueToDmx[i+40+40], 10, i*15+25);
  }
  
  
  
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


for(int i = 0; i < mhx50_color_values.length; i++) {
    if(mhx50_color[0] == mhx50_color_values[i]) {
      text("true" + i, 800, 800);
    }
    else {
      text("false", 800, 850);
    }
  }

}
  
  /*
   * TODO: something like on Close set f to null, this is important if you need to 
   * open more secondapplet when click on button, and none secondapplet is open.
   */
}


