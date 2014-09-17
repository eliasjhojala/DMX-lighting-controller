//Tässä välilehdessä pyöritetään automaattisia, manuaalisia ja musiikin tahdissa pyöriviä chaseja
/* IDEA JOLLA TÄMÄN SAA TOIMIMAAN:
ENSIN LASKETAAN AKTIIVISET MEMORYT JA SEN JÄLKEEN JOKA ISKULLA FOR LOOPPI
*/

boolean bigBeat = false;

void detectBeat() {
      beat.detect(in.mix); //minim-kirjaston beatintunnistuskomentoihin tarvittava komento
      millisNow[10] = millis();
      if (((beat.isKick() && beat.isSnare()) || (beat.isKick() && beat.isHat()) || (beat.isHat() && beat.isSnare()))) {
        if(beat.isKick() && beat.isSnare() && beat.isHat()) {
          bigBeat = true;
           millisOld[11] = millis();
        }
        biitti = true;
        millisOld[10] = millis();
      }
      else {
        if(millisNow[10] - millisOld[10] > 50) {
          biitti = false;
          bigBeat = false;
          millisOld[10] = millis();
        }
      }
}

void beatDetectionDMX(int memoryNumber, int value) { //chase/soundtolight funktion aloitus
    detectBeat();
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
    
    
    else if(chaseModeByMemoryNumber[i] == 2 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 2)) {
      freqSoundToLight(i, value);
    }
    
    
    else if(chaseModeByMemoryNumber[i] == 3 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 3)) {
      if((keyPressed == true && key == ' ' && keyReleased == true) || (chaseStepChanging[i] == true && chaseFade > 0) || nextStepPressed == true) {
        
        
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
        }
    }
  }
}
    
    }

void stepChange(int memoryNumber, int value, boolean useFade, boolean changeSteppiii) {

  if(useFade == true) {
    if(changeSteppiii == true) {
      chaseBright1[memoryNumber]++;
      chaseBright2[memoryNumber] = 255 - chaseBright1[memoryNumber];
      
      if(chaseBright1[memoryNumber] > chaseFade) {
        chaseBright1[memoryNumber] = 0;
        steppi[memoryNumber]++;
        steppi1[memoryNumber] = steppi[memoryNumber] - 1;
        chaseStepChanging[memoryNumber] = false;
      }
      
      chaseBright2[memoryNumber] = round(map(chaseBright1[memoryNumber], 0, chaseFade, 0, 255));
      
      if(steppi[memoryNumber] > soundToLightSteps[memoryNumber]) {
        steppi[memoryNumber] = 1; steppi1[memoryNumber] = soundToLightSteps[memoryNumber];
      }
    }
  preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], round(map(chaseBright2[memoryNumber], 0, 255, 0, value)));
  preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], round(map(255 - chaseBright2[memoryNumber], 0, 255, 0, value)));
  //memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = chaseBright2[memoryNumber];
  //memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 255 - chaseBright2[memoryNumber];
  
  
  }
  else {
    if(changeSteppiii == true) {
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
  //  memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = 255;
  //  memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 0;
  }
}



void stepChangeRev(int memoryNumber, int value, boolean useFade, boolean changeStep) {

if(useFade == true) {
  if(changeStep == true) {

    chaseBright1[memoryNumber]--;
    chaseBright2[memoryNumber] = 255 - chaseBright1[memoryNumber];
    
    if(chaseBright1[memoryNumber] < 1) {
      chaseBright1[memoryNumber] = chaseFade;
      steppi[memoryNumber]--;
      steppi1[memoryNumber] = steppi[memoryNumber] + 1;
      chaseStepChangingRev[memoryNumber] = false;
      
    }
    
    chaseBright2[memoryNumber] = round(map(chaseBright1[memoryNumber], 0, chaseFade, 0, 255));
    
    if(steppi[memoryNumber] < 1) {
      steppi[memoryNumber] = soundToLightSteps[memoryNumber]; steppi1[memoryNumber] = 1;
    }
    print("chaseBright1: ");
    print(chaseBright1[memoryNumber]);
    print("               chaseBright2: ");
    print(chaseBright2[memoryNumber]);
    println(); println();
  }
    preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], round(map(chaseBright2[memoryNumber], 0, 255, 0, value)));
    preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], round(map(255 - chaseBright2[memoryNumber], 0, 255, 0, value)));
//memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = chaseBright2[memoryNumber];
//memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 255 - chaseBright2[memoryNumber];


}
else {
//  if(changeStep == true) {
//    steppi[memoryNumber]++;
//    steppi1[memoryNumber] = steppi[memoryNumber] - 1;
//    if(steppi[memoryNumber] > soundToLightSteps[memoryNumber]) {
//      steppi[memoryNumber] = 1;
//      steppi1[memoryNumber] = soundToLightSteps[memoryNumber];
//    }
//  }
//  preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], round(map(255, 0, 255, 0, value)));
//  preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], 0);
////  memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = 255;
////  memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 0;
}
}




void freqSoundToLight(int memoryNumber, int value) {
  if(memoryValue[memoryNumber] != 0) {
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
 
void stop()
{
  // always close Minim audio classes when you are finished with them
  //song.close();
  in.close();
  // alway s stop Minim before exiting
  minim.stop();
 
  super.stop();
} 
