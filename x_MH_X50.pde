/*CHANNELS

1 0…255 Rotation (pan) (0° to max. value of the Pan range: 180°, 270° or 540°)
2 0…255 Inclination (tilt) (0° to max. value of the Tilt range: 90°, 180° or 270°)
3 0…255 Fine adjustment for rotation (pan)
4 0…255 Fine adjustment for inclination (tilt)
5 0…255 Response speed (normal to slow)
6 Colour wheel
    0…6 White
    7…13 Yellow
    14…20 Pink
    21…27 Green
    28…34 Peachblow
    35…41 Blue
    42…48 Kelly-green
    49…55 Red
    56…63 Dark blue
    64…70 White + yellow
    71…77 Yellow + pink
    78…84 Pink + green
    85…91 Green + peachblow
    92…98 Peachblow + blue
    99…105 Blue + kelly-green
    106…112 Kelly-green + red
    113…119 Red + dark blue
    120…127 Dark blue + white
    128…191 Rainbow effect in positive rotation direction, increasing speed
    192…255 Rainbow effect in negative rotation direction, increasing speed
7 Shutter
    0…3 Closed (blackout)
    4…7 Open
    8…215 Strobe effect, increasing speed
    216…255 Open
8 0…255 Mechanical dimmer (0 to 100 %)
9 Gobo wheel
    0…7 Open
    8…15 Gobo 2
    16…23 Gobo 3
    24…31 Gobo 4
    32…39 Gobo 5
    40…47 Gobo 6
    48…55 Gobo 7
    56…63 Gobo 8
    64…71 Gobo 8 shake, increasing speed
    72…79 Gobo 7 shake, increasing speed
    80…87 Gobo 6 shake, increasing speed
    88…95 Gobo 5 shake, increasing speed
    96…103 Gobo 4 shake, increasing speed
    104…111 Gobo 3 shake, increasing speed
    112…119 Gobo 2 shake, increasing speed
    120…127 Open
    128…191 Rainbow effect in positive rotation direction, increasing speed
    192…255 Rainbow effect in negative rotation direction, increasing speed
10 Gobo rotation
    0…63 Gobo fixed
    64…147 Positive rotation direction, increasing speed
    148…231 Negative rotation direction, increasing speed
    232…255 Gobo bouncing
11 Special functions
    0…7 Unused
    8…15 Blackout during pan or tilt movement
    16…23 No blackout during pan or tilt movement
    24…31 Blackout during colour wheel movement
    32…39 No blackout during colour wheel movement
    40…47 Blackout during gobo wheel movement
    48…55 No blackout during gobo wheel movement
    56…87 Unused
    88…95 Blackout during movement
    96…103 Reset pan
    104…111 Reset tilt
    112…119 Reset colour wheel
    120…127 Reset gobo wheel
    128…135 Reset gobo rotation
    136…143 Reset prism
    144…151 Reset focus
    152…159 Reset all channels
    160…255 Unused
12 Built-in programmes
    0…7 Unused
    8…23 Program 1
    24…39 Program 2
    40…55 Program 3
    56…71 Program 4
    72…87 Program 5
    88…103 Program 6
    104…119 Program 7
    120…135 Program 8
    136…151 Sound control 1
    152…167 Sound control 2
    168…183 Sound control 3
    184…199 Sound control 4
    200…215 Sound control 5
    216…231 Sound control 6
    232…247 Sound control 7
    248…255 Sound control 8
13 Prism
    0…7 Unused
    8…247 Rotating prism, increasing speed
    248…255 Prism fixed
14 0…255 Focus

*/


void movingHeadOptionsCheck(String address, int value, int value2) {

  if(address.equals("/6/MH_posMirror")) {
    mhx50_posMirror = boolean(value);
  }
  if(address.equals("/6/MH_posDuplicate")) {
    mhx50_posDuplicate = boolean(value);
  }
  if(address.equals("/6/MH_duplicate")) {
    mhx50_duplicate = boolean(value);
  }
  
  if(address.equals("/7/savePreset1") || address.equals("/7/savePreset2")) {
    savePreset = true;
  }
  
  for(int ij = 1; ij <= 2; ij++) {
  for(int i = 0; i < 15; i++) {
    if(address.equals("/7/preset" + str(i) + "_" + str(ij)) && value == 1) {
      if(savePreset) {
        savePreset(i, ij-1);
      }
      else {
        changeValues = false;
        showPreset(i, ij-1);
        
      }
      
    }
  }
  }
  
  
  for(int id = 0; id <= 1; id++) {
  
      //CH 1: Pan
      if(address.equals("/7/xy" + str(id+1)) || address.equals("/8/xy" + str(id+1))) { mhx50_pan(value2, id); }
      //CH 2: Tilt
      if(address.equals("/7/xy" + str(id+1)) || address.equals("/8/xy" + str(id+1))) { mhx50_tilt(value, id); }
      //CH 3: Fine adjustment for rotation (pan)
      mhx50_panFine(0, id);
      //CH 4: Fine adjustment for inclination (tilt)
      mhx50_tiltFine(0, id);
      //CH 5: Response speed
      mhx50_responseSpeed(0, id);
      
      //CH 6: Colour wheel
      mhx50_colorChange(address, id);
      if(address.equals("/8/rainbow" + str(id+1))) { rainbow(value, id); } //Color rainbow
      
      //CH 7: Shutter
      if(address.equals("/8/blackOut" + str(id+1)) && value == 1) { mhx50_blackOut(id); }
      if(address.equals("/8/openShutter" + str(id+1)) && value == 1) { mhx50_openShutter(id); }
      if(address.equals("/8/strobe" + str(id+1))) { mhx50_strobe(value, id); }
      
      //CH 8: Mechanical dimmer
      if(address.equals("/7/dimmer" + str(id+1)) || address.equals("/8/dimmer" + str(id+1))) { mhx50_dimmer(value, id); }
      
      //CH 9: Gobo wheel
      if(address.equals("/8/noGobo" + str(id+1)) && value == 1) { mhx50_noGobo(id); } //Gobowheel open
      if(address.equals("/8/goboUp" + str(id+1)) && value == 1) { mhx50_goboUp(id); } //Next gobo
      if(address.equals("/8/goboDown" + str(id+1)) && value == 1) { mhx50_goboDown(id); } //Reverse gobo
      if(address.equals("/8/goboRainbowUp" + str(id+1))) { mhx50_goboRainbowUp(value, id); } //Gobowheel positive rotation
      if(address.equals("/8/goboRainbowDown" + str(id+1))) { mhx50_goboRainbowDown(value, id); } //Gobowheel negative rotation
      
      //CH 10: Gobo rotation
      if(address.equals("/8/goboRotationUp" + str(id+1))) { mhx50_goboRotationUp(value, id); } //Gobo positive rotation
      if(address.equals("/8/goboRotationDown" + str(id+1))) { mhx50_goboRotationDown(value, id); } //Gobo negative rotation
      if(address.equals("/8/goboNoRotation" + str(id+1)) && value == 1) { mhx50_goboNoRotation(id); } //No gobo rotation
      if(address.equals("/8/goboBouncing" + str(id+1)) && value == 1) { mhx50_goboBouncing(id); } //Gobo bouncing
      
      //CH 11: Special functions
      if(address.equals("/8/reset" + str(id+1))) { mhx50_reset(value, id); }
      
      //CH 12: Built-in programmes
      if(address.equals("/8/autoProgram" + str(id+1)) && value == 1) { mhx50_autoProgram(id); } //Next autoProgram
      
      //CH 13: Prism
      if(address.equals("/8/prism" + str(id+1))) { mhx50_prism(value, id); } //Change prism value
      
      //CH 14: Focus
      if(address.equals("/8/focus" + str(id+1))) { mhx50_focus(value, id); } //Change focus value
      
    
      mhx50_finalChannelValuesCreate(id);
  
  }
}


void mhx50_pan(int value, int id) {
  mhx50_panValue[id] = value;
}

void mhx50_tilt(int value, int id) {
  mhx50_tiltValue[id] = value;
}

void mhx50_panFine(int value, int id) {
  mhx50_panFineValue[id] = value;
}

void mhx50_tiltFine(int value, int id) {
  mhx50_tiltFineValue[id] = value;
}

void mhx50_responseSpeed(int value, int id) {
  mhx50_responseSpeedValue[id] = value;
}

void mhx50_dimmer(int value, int id) {
  mhx50_dimmerValue[id] = value;
}

void mhx50_colorChange(String address, int id) {
  for(int i = 0; i < mhx50_color_names.length; i++) {
    if(address != null) {
    if(address.equals("/8/" + mhx50_color_names[i] + str(id + 1))) {
      mhx50_color[id] = mhx50_color_values[i]; 
      if(mhx50_colorOld[id] != mhx50_color[id]) {
      if(mhx50_duplicate == true) {
        if(id == 0) {
          mhx50_colorNumber[0] = i;
          mhx50_colorNumber[1] = i; break;
        }
      }
      else {
        mhx50_colorNumber[id] = i; break;
      }
      }
      mhx50_colorOld[id] = mhx50_color[id];
    }
    }
  }
}

void rainbow(int value, int id) {
  if(value < 0) {
    mhx50_color[id] = round(map(value, 0, -100, 128, 191));
  }
  else if(value > 0) {
    mhx50_color[id] = round(map(value, 0, 100, 192, 255));
  }
  else if(value == 0) {
    mhx50_color[id] = 5;
  }
}

void mhx50_noGobo(int id) {
  mhx50_goboValue[id] = 5;
}
void mhx50_goboUp(int id) {
  mhx50_goboNumber[id]++;
  if(mhx50_goboNumber[id] >= mhx50_gobo_values.length) {
    mhx50_goboNumber[id] = 0;
  }
  mhx50_goboValue[id] = mhx50_gobo_values[mhx50_goboNumber[id]];
}
void mhx50_goboDown(int id) {
  mhx50_goboNumber[id]--;
  if(mhx50_goboNumber[id] < 0) {
    mhx50_goboNumber[id] = mhx50_gobo_values.length - 1;
  }
  mhx50_goboValue[id] = mhx50_gobo_values[mhx50_goboNumber[id]];
}
void mhx50_goboRainbowUp(int value, int id) {
  mhx50_goboValue[id] = round(map(value, 0, 100, 128, 191));
}
void mhx50_goboRainbowDown(int value, int id) {
  mhx50_goboValue[id] = round(map(value, 0, 100, 192, 255));
}
void mhx50_goboRotationUp(int value, int id) {
  mhx50_goboRotationValue[id] = round(map(value, 0, 100, 64, 147));
}
void mhx50_goboRotationDown(int value, int id) {
  mhx50_goboRotationValue[id] = round(map(value, 0, 100, 148, 231));
}
void mhx50_goboNoRotation(int id) {
  mhx50_goboRotationValue[id] = 20;
}
void mhx50_goboBouncing(int id) {
  mhx50_goboRotationValue[id] = 245;
}
void mhx50_autoProgram(int id) {
  mhx50_autoProgramNumber[id]++;
  if(mhx50_autoProgramNumber[id] >= mhx50_autoProgram_values.length) {
    mhx50_goboNumber[id] = 0;
  }
  mhx50_autoProgramValue[id] = mhx50_autoProgram_values[mhx50_autoProgramNumber[id]];
}
void mhx50_prism(int value, int id) {
  mhx50_prismValue[id] = value;
}
void mhx50_focus(int value, int id) {
  mhx50_focusValue[id] = value;
}

void mhx50_reset(int value, int id) {
  if(value == 0) {
    mhx50_resetValue[id] = 0;
  }
  else {
    mhx50_resetValue[id] = 154;
  }
}
void mhx50_blackOut(int id) {
  mhx50_shutterValue[id] = 1;
}
void mhx50_openShutter(int id) {
  mhx50_shutterValue[id] = 5;
}
void mhx50_strobe(int value, int id) {
  mhx50_shutterValue[id] = round(map(value, 0, 100, 8, 215));
}

void mhx50_finalChannelValuesCreate(int id) {
  if(mhx50_posMirror == true) {
    if(id == 0) {
      if(mhx50_panValueOld[0] != mhx50_panValue[0])    { mhx50_createFinalChannelValues[0][0] = mhx50_panValue[0]; }
      if(mhx50_tiltValueOld[0] != mhx50_tiltValue[0])  { mhx50_createFinalChannelValues[0][1] = mhx50_tiltValue[0]; }
      
      mhx50_panValueOld[0] = mhx50_panValue[0];
      mhx50_tiltValueOld[0] = mhx50_tiltValue[0];
      
      if(mhx50_panValueOld[1] != mhx50_panValue[0]*(-1)) { mhx50_createFinalChannelValues[1][0] = mhx50_panValue[0]*(-1); }
      if(mhx50_tiltValueOld[1] != mhx50_tiltValue[0])    { mhx50_createFinalChannelValues[1][1] = mhx50_tiltValue[0]; }
      
      mhx50_panValueOld[1] = mhx50_panValue[0]*(-1);
      mhx50_tiltValueOld[1] = mhx50_tiltValue[0];
    }
  }
  else if(mhx50_posDuplicate == true) {
    if(mhx50_panValueOld[0] != mhx50_panValue[0])    { mhx50_createFinalChannelValues[0][0] = mhx50_panValue[0]; mhx50_createFinalChannelValues[1][0] = mhx50_panValue[0]; }
    if(mhx50_tiltValueOld[0] != mhx50_tiltValue[0])  { mhx50_createFinalChannelValues[0][1] = mhx50_tiltValue[0]; mhx50_createFinalChannelValues[1][1] = mhx50_tiltValue[0]; }
    
    mhx50_panValueOld[0] = mhx50_panValue[0];
    mhx50_tiltValueOld[0] = mhx50_tiltValue[0];
  }
  else {
    if(mhx50_panValueOld[id] != mhx50_panValue[id])    { mhx50_createFinalChannelValues[id][0] = mhx50_panValue[id]; }
    if(mhx50_tiltValueOld[id] != mhx50_tiltValue[id])  { mhx50_createFinalChannelValues[id][1] = mhx50_tiltValue[id]; }
    
    mhx50_panValueOld[id] = mhx50_panValue[id];
    mhx50_tiltValueOld[id] = mhx50_tiltValue[id];
  }
  
  
  
  
  if(mhx50_duplicate == true) {
    if(mhx50_panFineValueOld[0] != mhx50_panFineValue[0])                                   { mhx50_createFinalChannelValues[0][2] = mhx50_panFineValue[0]; mhx50_createFinalChannelValues[1][2] = mhx50_panFineValue[0]; }
    if(mhx50_tiltFineValueOld[0] != mhx50_tiltFineValue[0])                                 { mhx50_createFinalChannelValues[0][3] = mhx50_tiltFineValue[0]; mhx50_createFinalChannelValues[1][3] = mhx50_tiltFineValue[0]; }
    if(mhx50_responseSpeedValueOld[0] != mhx50_responseSpeedValue[0])                       { mhx50_createFinalChannelValues[0][4] = mhx50_responseSpeedValue[0]; mhx50_createFinalChannelValues[1][4] = mhx50_responseSpeedValue[0]; }
    if(mhx50_colorOld[0] != mhx50_color[0])                                                 { mhx50_createFinalChannelValues[0][5] = mhx50_color[0]; mhx50_createFinalChannelValues[1][5] = mhx50_color[0]; }
    if(mhx50_shutterValueOld[0] != mhx50_shutterValue[0])                                   { mhx50_createFinalChannelValues[0][6] = mhx50_shutterValue[0]; mhx50_createFinalChannelValues[1][6] = mhx50_shutterValue[0]; }
    if(mhx50_dimmerValueOld[0] != round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster))) { mhx50_createFinalChannelValues[0][7] = round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster)); mhx50_createFinalChannelValues[1][7] = round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster)); }
    if(mhx50_goboValueOld[0] != mhx50_goboValue[0])                                         { mhx50_createFinalChannelValues[0][8] = mhx50_goboValue[0]; mhx50_createFinalChannelValues[1][8] = mhx50_goboValue[0]; }
    if(mhx50_goboRotationValueOld[0] != mhx50_goboRotationValue[0])                         { mhx50_createFinalChannelValues[0][9] = mhx50_goboRotationValue[0]; mhx50_createFinalChannelValues[1][9] = mhx50_goboRotationValue[0]; }
    if(mhx50_resetValueOld[0] != mhx50_resetValue[0])                                       { mhx50_createFinalChannelValues[0][10] = mhx50_resetValue[0]; mhx50_createFinalChannelValues[1][10] = mhx50_resetValue[0]; }
    if(mhx50_autoProgramValueOld[0] != mhx50_autoProgramValue[0])                           { mhx50_createFinalChannelValues[0][11] = mhx50_autoProgramValue[0]; mhx50_createFinalChannelValues[1][11] = mhx50_autoProgramValue[0]; }
    if(mhx50_prismValueOld[0] != mhx50_prismValue[0])                                       { mhx50_createFinalChannelValues[0][12] = mhx50_prismValue[0]; mhx50_createFinalChannelValues[1][12] = mhx50_prismValue[0]; }
    if(mhx50_focusValueOld[0] != mhx50_focusValue[0])                                       { mhx50_createFinalChannelValues[0][13] = mhx50_focusValue[0]; mhx50_createFinalChannelValues[1][13] = mhx50_focusValue[0]; }
   
   mhx50_panFineValueOld[0] = mhx50_panFineValue[0];
   mhx50_tiltFineValueOld[0] = mhx50_tiltFineValue[0];
   mhx50_responseSpeedValueOld[0] = mhx50_responseSpeedValue[0];
   mhx50_colorOld[0] = mhx50_color[0];
   mhx50_shutterValueOld[0] = mhx50_shutterValue[0];
   mhx50_dimmerValueOld[0] = round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster));
   mhx50_goboValueOld[0] = mhx50_goboValue[0];
   mhx50_goboRotationValueOld[0] = mhx50_goboRotationValue[0];
   mhx50_resetValueOld[0] = mhx50_resetValue[0];
   mhx50_autoProgramValueOld[0] = mhx50_autoProgramValue[0];
   mhx50_prismValueOld[0] = mhx50_prismValue[0];
   mhx50_focusValueOld[0] = mhx50_focusValue[0];
  }
  else {
    if(mhx50_panFineValueOld[id] != mhx50_panFineValue[id])                                   { mhx50_createFinalChannelValues[id][2] = mhx50_panFineValue[id]; }
    if(mhx50_tiltFineValueOld[id] != mhx50_tiltFineValue[id])                                 { mhx50_createFinalChannelValues[id][3] = mhx50_tiltFineValue[id]; }
    if(mhx50_responseSpeedValueOld[id] != mhx50_responseSpeedValue[id])                       { mhx50_createFinalChannelValues[id][4] = mhx50_responseSpeedValue[id]; }
    if(mhx50_colorOld[id] != mhx50_color[id])                                                 { mhx50_createFinalChannelValues[id][5] = mhx50_color[id]; }
    if(mhx50_shutterValueOld[id] != mhx50_shutterValue[id])                                   { mhx50_createFinalChannelValues[id][6] = mhx50_shutterValue[id]; }
    if(mhx50_dimmerValueOld[id] != round(map(mhx50_dimmerValue[id], 0, 255, 0, grandMaster))) { mhx50_createFinalChannelValues[id][7] = round(map(mhx50_dimmerValue[id], 0, 255, 0, grandMaster)); }
    if(mhx50_goboValueOld[id] != mhx50_goboValue[id])                                         { mhx50_createFinalChannelValues[id][8] = mhx50_goboValue[id]; }
    if(mhx50_goboRotationValueOld[id] != mhx50_goboRotationValue[id])                         { mhx50_createFinalChannelValues[id][9] = mhx50_goboRotationValue[id]; }
    if(mhx50_resetValueOld[id] != mhx50_resetValue[id])                                       { mhx50_createFinalChannelValues[id][10] = mhx50_resetValue[id]; }
    if(mhx50_autoProgramValueOld[id] != mhx50_autoProgramValue[id])                           { mhx50_createFinalChannelValues[id][11] = mhx50_autoProgramValue[id]; }
    if(mhx50_prismValueOld[id] != mhx50_prismValue[id])                                       { mhx50_createFinalChannelValues[id][12] = mhx50_prismValue[id]; }
    if(mhx50_focusValueOld[id] != mhx50_focusValue[id])                                       { mhx50_createFinalChannelValues[id][13] = mhx50_focusValue[id]; }   
  }
}

void savePreset(int presetNumber, int id) {
  for(int i = 0; i < 13; i++) {
    mhx50_createFinalPresetValues[presetNumber][id][i] = mhx50_createFinalChannelValues[id][i];
  }
  savePreset = false;
}

void showPreset(int presetNumber, int id) {
  for(int i = 0; i < 13; i++) {
     mhx50_createFinalChannelValues[id][i] = mhx50_createFinalPresetValues[presetNumber][id][i];
  }
  checkColorNumber(id);
}



void checkColorNumber(int id) {
  for(int i = 0; i < mhx50_color_values.length; i++) {
    if(mhx50_createFinalChannelValues[id][5] == mhx50_color_values[i]) {
      mhx50_colorNumber[id] = i; break;
    }
  }
  
}
