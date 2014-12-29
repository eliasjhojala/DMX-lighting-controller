void checkThemeMode() {
  fill(0, 0, 0);
  if(printMode == true) { //Tarkistetaan onko tulostusmode päällä - check if printmode is on 
    background(255, 255, 255); //Jos tulostusmode on päällä taustaväri on valkoinen - if printmode is on then background is white
    stroke(0, 0, 0); //Jos tulostusmode on päällä kuvioiden reunat ovat mustia - if printmode is on then strokes are black 
  }
  else { 
    background(0); //Jos tulostusmode on pois päältä taustaväri on musta - if printmode is off then background is black
    stroke(255, 255, 255); //Jos tulostusmode on pois päältä kuvoiden reunat ovat valkoisia - if printmode is off then strokes are white
  }
} 
