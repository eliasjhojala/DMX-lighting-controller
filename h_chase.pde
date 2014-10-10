//Tässä välilehdessä pyöritetään automaattisia, manuaalisia ja musiikin tahdissa pyöriviä chaseja
/* IDEA JOLLA TÄMÄN SAA TOIMIMAAN:
ENSIN LASKETAAN AKTIIVISET MEMORYT JA SEN JÄLKEEN JOKA ISKULLA FOR LOOPPI
*/
boolean chasePause = false;

void detectBeat() {
      beat.detect(in.mix); //beat detect command of minim library
      biitti = beat.isKick();
}

void beatDetectionDMX(int memoryNumber, int value) { //chase/soundtolight funktion aloitus
    if(chaseModeByMemoryNumber[memoryNumber] >= 0 && chaseModeByMemoryNumber[memoryNumber] <= 6) { //tarkistetaan chasemode (1 = beat detect, 2 = eq, 3 = manual chase, 4 = autochase, 5 = beat detect wave
     for(int i = 1; i < numberOfMemories; i++) { //Käydään läpi kaikki memoryt
       value = memoryValue[i]; //arvo on tällä hetkellä käsiteltävän memoryn arvo
    if(chaseModeByMemoryNumber[i] == 1 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 1)) {
      if(biitti == true || (chaseStepChanging[i] == true && chaseFade > 0)) { //Tarkistetaan tuleeko biitti tai onko fade menossa
        if(memoryValue[i] > 0) { //Tarkistetaan onko memory päällä
        if(chaseStepChanging[i] == false) { //Tarkisetaan eikö fade ole vielä alkanut
          chaseStepChanging[i] = true; //Kirjoitetaan muistiin, että fade on menossa
        }
        if(chaseFade > 0) { //Jos crossFade on yli nolla
          stepChange(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        else {
          stepChange(i, value, false, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        }
      }
      else {
        stepChange(i, value, true, false); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
      }
    }
    
    if(chaseModeByMemoryNumber[i] == 8 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 8)) {
      if(biitti == true || (fallingEdgeChaseStepChangin[i] == true && chaseFade > 0)) { //Tarkistetaan tuleeko biitti tai onko fade menossa
        if(memoryValue[i] > 0) { //Tarkistetaan onko memory päällä
        if(fallingEdgeChaseStepChangin[i] == false) { //Tarkisetaan eikö fade ole vielä alkanut
          fallingEdgeChaseStepChangin[i] = true; //Kirjoitetaan muistiin, että fade on menossa
        }
        if(chaseFade > 0) { //Jos crossFade on yli nolla
          fallingEdgeChase(i, value, true, true); //fallingEdgeChase(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        else {
          fallingEdgeChase(i, value, false, true); //fallingEdgeChase(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        }
      }
      else {
        fallingEdgeChase(i, value, true, false); //fallingEdgeChase(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
      }
    }
    
    
    else if(chaseModeByMemoryNumber[i] == 2 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 2)) {
      freqSoundToLight(i, value);
    }
    
    
    else if(chaseModeByMemoryNumber[i] == 3 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 3)) {
      if((keyPressed == true && key == ' ' && keyReleased == true) || (chaseStepChanging[i] == true && chaseFade > 0) || nextStepPressed == true || noteOn[48] == true) {
      
        chaseStepChangingRev[i] = false;
        if(memoryValue[i] > 0) { //Tarkistetaan onko memory päällä
        if(chaseStepChanging[i] == false) { //Tarkisetaan eikö fade ole vielä alkanut
          chaseStepChanging[i] = true; //Kirjoitetaan muistiin, että fade on menossa
        }
        if(chaseFade > 0) { //Jos crossFade on yli nolla
          stepChange(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        else {
          stepChange(i, value, false, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        }
        lastStepDirection = 1;
      }
      else if(lastStepDirection == 1) {
        stepChange(i, value, true, false); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
      }
      if(revStepPressed == true || (chaseStepChangingRev[i] == true && chaseFade > 0)) {

        chaseStepChanging[i] = false;
       
        
        if(memoryValue[i] > 0) { //Tarkistetaan onko memory päällä
        if(chaseStepChangingRev[i] == false) { //Tarkisetaan eikö fade ole vielä alkanut
          chaseStepChangingRev[i] = true; //Kirjoitetaan muistiin, että fade on menossa
        }
        if(chaseFade > 0) { //Jos crossFade on yli nolla
          stepChangeRev(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        else {
          stepChangeRev(i, value, false, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
        }
        lastStepDirection = 2;
      }
      else if(lastStepDirection == 2) {
          stepChangeRev(i, value, true, false); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        }
    }
    
    
    else if(chaseModeByMemoryNumber[i] == 4 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 4)) {
      millisNow[5] = millis();
     // if(millisNow[5] - millisOld[5] > chaseSpeed || chaseMoving == true) {
        stepChange(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade käytössä, halutaanko steppiä vaihtaa)
        millisOld[5] = millisNow[5];
     // }

    }
    
    
    else if(chaseModeByMemoryNumber[i] == 5 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 5)) {
      if(biitti == true) {
        millisNow[7] = millis();
        if(millisNow[7] - millisOld[7] > 200) {
              wave = true;
              millisOld[7] = millisNow[7];
        }
      }
    }
    
    
    else if((chaseModeByMemoryNumber[i] == 6 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 6)) && memoryValue[i] > 0 ) {
      if(biitti == true) { //Jos tulee biitti presetti laitetaan päälle
     
            preset(soundToLightPresets[i][1], valueOfMemory[i]);
            preset(soundToLightPresets[i][2], valueOfMemory[i]);
      }
      else { //Jos ei ole biittiä presetti sammutetaan
              preset(soundToLightPresets[i][1], 0);
              preset(soundToLightPresets[i][2], 0);
              millisOld[20] = millisNow[20];
        }
    }
    
    else if((chaseModeByMemoryNumber[i] == 7 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 7)) && memoryValue[i] > 0 ) {
      manualStepChange(memoryNumber);
    }
    
  }
}
}

void stepChange(int memoryNumber, int value, boolean useFade, boolean changeSteppiii) {
  //Brightness idea: brightnessin maksimiarvo on alunperin chaseFade, joka voi olla esim 10
  //Brightness 2 arvo on mapattu brightnestin arvo niin että kun brightnestin arvo
  //on sama kuin chaseFaden arvo niin brightness 2 arvo on 255
  if(useFade == true) { //Check if fade is not zero
    if(changeSteppiii == true && !chasePause) { //Check if step is changing to another
      chaseBright1[memoryNumber]++; //Change brightness
      chaseBright2[memoryNumber] = 255 - chaseBright1[memoryNumber];
      
      if(chaseBright1[memoryNumber] > chaseFade) { //Check if actual brightness goes over the brightness we ant
        chaseBright1[memoryNumber] = 0; //Puts brightness to zero
        steppi[memoryNumber]++; //Changes step to next
        steppi1[memoryNumber] = steppi[memoryNumber] - 1; //Changes steppi1 value
        chaseStepChanging[memoryNumber] = false; //Step is not changing anymore
      }
      
      chaseBright2[memoryNumber] = round(map(chaseBright1[memoryNumber], 0, chaseFade, 0, 255)); //Maps chasebright to right value
      
      if(steppi[memoryNumber] > soundToLightSteps[memoryNumber]) {
        steppi[memoryNumber] = 1; steppi1[memoryNumber] = soundToLightSteps[memoryNumber];
      }
    }
    preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], round(map(255 - chaseBright2[memoryNumber], 0, 255, 0, value))); //Gives right value (inverted value) to previous step
    preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], round(map(chaseBright2[memoryNumber], 0, 255, 0, value))); //Gives right value to current step
  }
  
  //Älä välitä tämän elsen sisällä olevasta koodista, se suoritetaan vain jos fade on nollassa
  else {
    if(changeSteppiii == true && !chasePause) {
      steppi[memoryNumber]++;
      steppi1[memoryNumber] = steppi[memoryNumber] - 1;
      if(steppi[memoryNumber] > soundToLightSteps[memoryNumber]) {
        steppi[memoryNumber] = 1;
        steppi1[memoryNumber] = soundToLightSteps[memoryNumber];
        chaseStepChanging[memoryNumber] = false;
      }
    }
    preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], round(map(255, 0, 255, 0, value)));
    preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], 0);
  }
}



void stepChangeRev(int memoryNumber, int value, boolean useFade, boolean changeStep) {

  if(useFade == true) {
    if(changeStep == true && !chasePause) {
      
      chaseBright1[memoryNumber]++; //Change brightness
      chaseBright2[memoryNumber] = 255 - chaseBright1[memoryNumber];
      
      if(chaseBright1[memoryNumber] > chaseFade) { //Check if actual brightness goes over the brightness we ant
        chaseBright1[memoryNumber] = 0; //Puts brightness to zero
        steppi[memoryNumber]--;
        steppi1[memoryNumber] = steppi[memoryNumber] + 1;
        chaseStepChangingRev[memoryNumber] = false;
        lastStepDirection = 2;
      }
      
      chaseBright2[memoryNumber] = round(map(chaseBright1[memoryNumber], 0, chaseFade, 0, 255)); //Maps chasebright to right value
      
      if(steppi[memoryNumber] < 1) {
        steppi[memoryNumber] = soundToLightSteps[memoryNumber]; steppi1[memoryNumber] = 1;
      }
    }
    preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], 255 - round(map(255 - chaseBright2[memoryNumber], 0, 255, 0, value)));
    preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], 255 - round(map(chaseBright2[memoryNumber], 0, 255, 0, value)));
    
  }
}




void freqSoundToLight(int memoryNumber, int value) {
  if(memoryValue[memoryNumber] != 0 && !chasePause) {
  fft.forward(in.mix);
    
    millisNow[1] = millis();
    //if(millisNow[1] - millisOld[1] > 0) {
      
    for(int iii = 0; iii <= soundToLightSteps[memoryNumber]; iii++) {
      float val11 = sqrt(fft.getAvg(iii*round((20/(soundToLightSteps[memoryNumber]+1)))));
        if(val11 < 500) {
          if(iii*20/(soundToLightSteps[memoryNumber]+1) > 10 && round(map(200*val11, 0, 300, 0, value)) < soundToLightValues.length) {
            preset(soundToLightPresets[memoryNumber][iii], soundToLightValues[round(map(200*val11, 0, 300, 0, value))]);
          }
          else if(round(map(100*val11, 0, 300, 0, value)) < soundToLightValues.length) {
            preset(soundToLightPresets[memoryNumber][iii], soundToLightValues[round(map(100*val11, 0, 300, 0, value))]);
          }
          
        }
        
    }
    
    millisOld[1] = millisNow[1];
  }
}


void manualStepChange(int memoryNumber) {
  int crossFaderi = round(map(chaseFade*1.3+20, 0, 255, 0, soundToLightSteps[memoryNumber]));
  if(crossFaderi > soundToLightSteps[memoryNumber]) {
    preset(soundToLightPresets[memoryNumber][soundToLightSteps[memoryNumber]], 0);
  }
  else {
    preset(soundToLightPresets[memoryNumber][constrain(crossFaderi, 0, soundToLightSteps[memoryNumber])], constrain(round(map(chaseFade*1.3+20, 0, 255/soundToLightSteps[memoryNumber], 0, 255)) - round(map(chaseFade*1.3+20, 0, 255, 0, soundToLightSteps[memoryNumber]))*255 + 130, 0, 255));
  }
  preset(soundToLightPresets[memoryNumber][constrain(crossFaderi-1, 0, soundToLightSteps[memoryNumber])], constrain(255 - (round(map(chaseFade*1.3+20, 0, 255/soundToLightSteps[memoryNumber], 0, 255)) -  round(map(chaseFade*1.3+20, 0, 255, 0, soundToLightSteps[memoryNumber]))*255 + 130), 0, 255));
}



void fallingEdgeChase(int memoryNumber, int value, boolean useFade, boolean changeSteppiii) {
  //Brightness idea: brightnessin maksimiarvo on alunperin chaseFade, joka voi olla esim 10
  //Brightness 2 arvo on mapattu brightnestin arvo niin että kun brightnestin arvo
  //on sama kuin chaseFaden arvo niin brightness 2 arvo on 255
  if(useFade == true) { //Check if fade is not zero
    if(changeSteppiii == true && !chasePause) { //Check if step is changing to another
      chaseBright1[memoryNumber]++; //Change brightness
      chaseBright2[memoryNumber] = 255 - chaseBright1[memoryNumber];
      
      if(chaseBright1[memoryNumber] > chaseFade) { //Check if actual brightness goes over the brightness we ant
        chaseBright1[memoryNumber] = 0; //Puts brightness to zero
        steppi[memoryNumber]++; //Changes step to next
        fallingEdgeChaseStepChangin[memoryNumber] = false; //Step is not changing anymore
      }
      
      chaseBright2[memoryNumber] = round(map(chaseBright1[memoryNumber], 0, chaseFade, 0, 255)); //Maps chasebright to right value
      
      if(steppi[memoryNumber] > soundToLightSteps[memoryNumber]) {
        steppi[memoryNumber] = 1;
      }
      preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], constrain(round(map(255 - chaseBright2[memoryNumber], 0, 255, 0, value)), 0, 255)); //Gives right value (inverted value) to previous step
    }
    
  }
}

 
void stop() {
  //stop minim audio
  in.close();
  minim.stop();
  super.stop();
} 
