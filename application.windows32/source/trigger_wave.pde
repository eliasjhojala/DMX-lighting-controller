

/*
  
  void calculateWave() {
    //Take old wave data from slider values
//    for (int i = 0; i < 12; i++) {
//      cp5.controller("a" + str(i + 1)).setValue(cp5.controller("a" + str(i + 1)).getValue() - waveData[i]);
//    }
    
    waveData = new int[12 + waveLength];
    for (int i = 0; i < 12 + waveLength; i++) {
      if (waveLocation[i] == true) {
        //Wave peak
        if (i >= waveRange11 - 1 && i <= waveRange12 - 1) {
          waveData[i] = 255;
        }
        
        //Left & Right sides of wave peak
        for (int w = 1; w <= waveLength; w++) {
          int val = 255 - 255 / waveLength * w;
          
          if (i - w <= waveRange12 - 1 && i - w >= waveRange11 - 1 && waveData[i - w] < val) {
            waveData[i - w] = val;
          }
          
          if (i + w <= waveRange12 - 1 && i + w >= waveRange11 - 1 && waveData[i + w] < val) {
            waveData[i + w] = val;
          }
        }
      }
    }
    
    //Add wave data to slider values
//    for (int i = 0; i < 12; i++) {
//      cp5.controller("a" + str(i + 1)).setValue(cp5.controller("a" + str(i + 1)).getValue() + waveData[i]);
//    }
    
    //Push all values to the right if waveCurrentStep > waveStep
    if (waveCurrentStep > waveStep) {
      waveCurrentStep = 1;
      //I could just do waveLocationTemp = waveLocation, but that (I believe) assigns the same memory location for both arrays
      boolean[] waveLocationTemp = new boolean[12 + waveLength];
      for (int i = 0; i < 12 + waveLength; i++) {
        waveLocationTemp[i] = waveLocation[i];
      }
      
      waveLocation[0] = false;
      for (int i = 1; i < 12 + waveLength; i++) {
        waveLocation[i] = waveLocationTemp[i - 1];
      }
    } else {waveCurrentStep++;}
  }








//void triggerWave() {
//  if(wave == true) {
//    activeWaves++;
//        for(int i = 0; i < activeWaves; i++) {
//          if(waveStep[i] < 14) {
//            waveStep[i]++;
//            if(waveStep[i]-2 >= 0)  { dim[waveStep[i]-2] = 0; }
//            if(waveStep[i]-1 >= 0 && waveStep[i] <= 12)  { dim[waveStep[i]-1] = 100; }
//            if(waveStep[i] <= 12)   { dim[waveStep[i]] = 255; }
//            if(waveStep[i]+1 <= 12) { dim[waveStep[i]+1] = 100; }
//            
//          }
//          else {
//            waveStep[i] = 0;
//          }
//      }
//      if(waveStep[activeWaves] > 13) {
//        wave = false;
//      }
//  }
//  else {
//    activeWaves = 0;
//  }
//}


*/
