////This tab controls mhx50 moving head
///*CHANNELS
//
//1 0…255 Rotation (pan) (0° to max. value of the Pan range: 180°, 270° or 540°)
//2 0…255 Inclination (tilt) (0° to max. value of the Tilt range: 90°, 180° or 270°)
//3 0…255 Fine adjustment for rotation (pan)
//4 0…255 Fine adjustment for inclination (tilt)
//5 0…255 Response speed (normal to slow)
//6 Colour wheel
//    0…6 White
//    7…13 Yellow
//    14…20 Pink
//    21…27 Green
//    28…34 Peachblow
//    35…41 Blue
//    42…48 Kelly-green
//    49…55 Red
//    56…63 Dark blue
//    64…70 White + yellow
//    71…77 Yellow + pink
//    78…84 Pink + green
//    85…91 Green + peachblow
//    92…98 Peachblow + blue
//    99…105 Blue + kelly-green
//    106…112 Kelly-green + red
//    113…119 Red + dark blue
//    120…127 Dark blue + white
//    128…191 Rainbow effect in positive rotation direction, increasing speed
//    192…255 Rainbow effect in negative rotation direction, increasing speed
//7 Shutter
//    0…3 Closed (blackout)
//    4…7 Open
//    8…215 Strobe effect, increasing speed
//    216…255 Open
//8 0…255 Mechanical dimmer (0 to 100 %)
//9 Gobo wheel
//    0…7 Open
//    8…15 Gobo 2
//    16…23 Gobo 3
//    24…31 Gobo 4
//    32…39 Gobo 5
//    40…47 Gobo 6
//    48…55 Gobo 7
//    56…63 Gobo 8
//    64…71 Gobo 8 shake, increasing speed
//    72…79 Gobo 7 shake, increasing speed
//    80…87 Gobo 6 shake, increasing speed
//    88…95 Gobo 5 shake, increasing speed
//    96…103 Gobo 4 shake, increasing speed
//    104…111 Gobo 3 shake, increasing speed
//    112…119 Gobo 2 shake, increasing speed
//    120…127 Open
//    128…191 Rainbow effect in positive rotation direction, increasing speed
//    192…255 Rainbow effect in negative rotation direction, increasing speed
//10 Gobo rotation
//    0…63 Gobo fixed
//    64…147 Positive rotation direction, increasing speed
//    148…231 Negative rotation direction, increasing speed
//    232…255 Gobo bouncing
//11 Special functions
//    0…7 Unused
//    8…15 Blackout during pan or tilt movement
//    16…23 No blackout during pan or tilt movement
//    24…31 Blackout during colour wheel movement
//    32…39 No blackout during colour wheel movement
//    40…47 Blackout during gobo wheel movement
//    48…55 No blackout during gobo wheel movement
//    56…87 Unused
//    88…95 Blackout during movement
//    96…103 Reset pan
//    104…111 Reset tilt
//    112…119 Reset colour wheel
//    120…127 Reset gobo wheel
//    128…135 Reset gobo rotation
//    136…143 Reset prism
//    144…151 Reset focus
//    152…159 Reset all channels
//    160…255 Unused
//12 Built-in programmes
//    0…7 Unused
//    8…23 Program 1
//    24…39 Program 2
//    40…55 Program 3
//    56…71 Program 4
//    72…87 Program 5
//    88…103 Program 6
//    104…119 Program 7
//    120…135 Program 8
//    136…151 Sound control 1
//    152…167 Sound control 2
//    168…183 Sound control 3
//    184…199 Sound control 4
//    200…215 Sound control 5
//    216…231 Sound control 6
//    232…247 Sound control 7
//    248…255 Sound control 8
//13 Prism
//    0…7 Unused
//    8…247 Rotating prism, increasing speed
//    248…255 Prism fixed
//14 0…255 Focus
//
//*/
//
//void mhx50_movingHeadLoop() { //This loops in every draw
////  if(mhx50_plays2l) { mhx50_playS2l(); } //Make sound to light effect if it is on
//
//
//  for(int id = 0; id <= 1; id++) {
//    for(int i = 0; i < 14; i++) {
//      valueToDmx[60+id*20+i] = mhx50_createFinalChannelValues[id][i];
//    }
//  }
//  
//  
//  for(int i = 0; i < 14; i++) {
//    sendOscToAnotherPc(100+i, mhx50_createFinalChannelValues[0][i]);
//  }
//  for(int i = 0; i < 14; i++) {
//    sendOscToAnotherPc(115+i, mhx50_createFinalChannelValues[1][i]);
//  }
//  
//  if(midiPositionButtonPressed) {
//    mhx50_finalChannelValuesCreate(0);
//    mhx50_finalChannelValuesCreate(1);
//  }
//  
//}
//
//
///* void movingHeadOptionsCheck(String address, int value, int value2) { //This void checks all the controllers from touchosc which affects to moving head
//
//  if(address.equals("/6/MH_posMirror")) { mhx50_posMirror = boolean(value); } //Set right value to posMirror boolean which means that pan data is mirrored and tilt duplicated
//  if(address.equals("/6/MH_posDuplicate")) { mhx50_posDuplicate = boolean(value); } //Set right value to posDuplivate boolean which means that position data is duplicated
//  if(address.equals("/6/MH_duplicate")) { mhx50_duplicate = boolean(value); } //Set right value to duplicate boolean which means that all data but position is duplicated
//  
//  if(address.equals("/7/saves2l")) { mhx50_saves2l = true; mhx50_saves2lfirstTime = true; } //Check if saves2l button is pressed and tells the other program it by variables
//  if(address.equals("/7/ok")) { mhx50_saves2l = false; } //If ok is pressed then saving s2l is ready and not true anymore
//  if(address.equals("/7/plays2l")) { //check if plays2l is pressed
//    if(value == 1) {
//      if(mhx50_plays2l) {
//        mhx50_plays2l = false;
//      }
//      else {
//        mhx50_plays2l = true;
//      }
//    }
//  }
//  
//  if(address.equals("/7/savePreset1") || address.equals("/7/savePreset2")) { savePreset = true; } //Check if savePreset is pressed and tells it the other program by savePreset variable
//  
//  
//  //Check all the preset buttons
//  for(int ij = 1; ij <= 2; ij++) { //Goes through all the mhx50 fixtures
//    for(int i = 0; i <= 15; i++) { //Goes through all the presetbuttons
//      if(address.equals("/7/preset" + str(i) + "_" + str(ij)) && value == 1) { //Check if button is pressed
//        if(savePreset) { //If savepresed is true then saves presed to presetplace which you clicked 
//          savePreset(i, ij-1);
//        }
//        else if(mhx50_saves2l) { //If saves2l is true then adds the preset you clicked to s2l
//          mmhx50_s2l_numberOfPresets++;
//          if(mhx50_saves2lfirstTime) { //If you created new s2l then resets mmhx50_s2l_numberOfPresets variable
//            mmhx50_s2l_numberOfPresets = 0;
//            mhx50_saves2lfirstTime = false;
//          }
//          mhx50_s2l_presets[mmhx50_s2l_numberOfPresets] = i;
//        }
//        else { //Shows preset if you just clicked preset without savePreset or saves2l
//          changeValues = false;
//          showPreset(i, ij-1);     
//        }  
//      }
//    }
//  }
//  
//  
//  for(int id = 0; id <= 1; id++) { //Goes through all the mhx50 fixtures 
//  
//      //CH 1: Pan
//      if(address.equals("/7/xy" + str(id+1)) || address.equals("/8/xy" + str(id+1))) { mhx50_pan(value2, id); } //Changes pan value
//      //CH 2: Tilt
//      if(address.equals("/7/xy" + str(id+1)) || address.equals("/8/xy" + str(id+1))) { mhx50_tilt(value, id); } //Changes tilt value
//      //CH 3: Fine adjustment for rotation (pan)
//      mhx50_panFine(0, id); //Sets panFine value to zero
//      //CH 4: Fine adjustment for inclination (tilt)
//      mhx50_tiltFine(0, id); //Sets tiltFine value to zero
//      //CH 5: Response speed
//      mhx50_responseSpeed(0, id); //Sets responseSpeed to zero which means the fastest possible
//      
//      //CH 6: Colour wheel
//      mhx50_colorChange(address, id); //Check color buttons every round
//      if(address.equals("/8/rainbow" + str(id+1))) { rainbow(value, id); } //Color rainbow
//      
//      //CH 7: Shutter
//      if(address.equals("/8/blackOut" + str(id+1)) && value == 1) { mhx50_blackOut(id); } //Check if blackout is presset
//      if(address.equals("/8/openShutter" + str(id+1)) && value == 1) { mhx50_openShutter(id); } //Check if open is pressed
//      if(address.equals("/8/strobe" + str(id+1))) { mhx50_strobe(value, id); } //Check if strobe slider is over zero
//      
//      //CH 8: Mechanical dimmer
//      if(address.equals("/7/dimmer" + str(id+1)) || address.equals("/8/dimmer" + str(id+1))) { mhx50_dimmer(value, id); } //Changes dimmer value
//      
//      //CH 9: Gobo wheel
//      if(address.equals("/8/noGobo" + str(id+1)) && value == 1) { mhx50_noGobo(id); } //Gobowheel open
//      if(address.equals("/8/goboUp" + str(id+1)) && value == 1) { mhx50_goboUp(id); } //Next gobo
//      if(address.equals("/8/goboDown" + str(id+1)) && value == 1) { mhx50_goboDown(id); } //Reverse gobo
//      if(address.equals("/8/goboRainbowUp" + str(id+1))) { mhx50_goboRainbowUp(value, id); } //Gobowheel positive rotation
//      if(address.equals("/8/goboRainbowDown" + str(id+1))) { mhx50_goboRainbowDown(value, id); } //Gobowheel negative rotation
//      
//      //CH 10: Gobo rotation
//      if(address.equals("/8/goboRotationUp" + str(id+1))) { mhx50_goboRotationUp(value, id); } //Gobo positive rotation
//      if(address.equals("/8/goboRotationDown" + str(id+1))) { mhx50_goboRotationDown(value, id); } //Gobo negative rotation
//      if(address.equals("/8/goboNoRotation" + str(id+1)) && value == 1) { mhx50_goboNoRotation(id); } //No gobo rotation
//      if(address.equals("/8/goboBouncing" + str(id+1)) && value == 1) { mhx50_goboBouncing(id); } //Gobo bouncing
//      
//      //CH 11: Special functions
//      if(address.equals("/8/reset" + str(id+1))) { mhx50_reset(value, id); } //Check ig reset button is pressed and resets all the channels in moving head
//      
//      //CH 12: Built-in programmes
//      if(address.equals("/8/autoProgram" + str(id+1)) && value == 1) { mhx50_autoProgram(id); } //Next autoProgram
//      
//      //CH 13: Prism
//      if(address.equals("/8/prism" + str(id+1))) { mhx50_prism(value, id); } //Change prism value
//      
//      //CH 14: Focus
//      if(address.equals("/8/focus" + str(id+1))) { mhx50_focus(value, id); } //Change focus value
//      
//    
//      mhx50_finalChannelValuesCreate(id); //Create array where is located all the mhx50 channels
//  
//  }
//} */
//
//
//void mhx50_pan(int value, int id) { mhx50_panValue[id] = value; } //Changes panValue
//void mhx50_tilt(int value, int id) { mhx50_tiltValue[id] = value; } //Changes tiltValue
//
//void mhx50_panFine(int value, int id) { mhx50_panFineValue[id] = value; } //Changes panFineValue which is for moving moving head smoothly
//void mhx50_tiltFine(int value, int id) { mhx50_tiltFineValue[id] = value; } //Changes tiltFineValue which is for moving moving head smoothly
//
//void mhx50_responseSpeed(int value, int id) { mhx50_responseSpeedValue[id] = value; } //Changes responseSpeed which affects to moving speed
//
//void mhx50_dimmer(int value, int id) { mhx50_dimmerValue[id] = value; } //Changes dimmerValue which affects to moving head brightness
//
//void mhx50_colorChange(String address, int id) {
//  //This void goes through all the color buttons and gives right color values to mhx50
//  for(int i = 0; i < mhx50_color_names.length; i++) {
//    if(address != null) {
//    if(address.equals("/8/" + mhx50_color_names[i] + str(id + 1))) {
//      mhx50_color[id] = mhx50_color_values[i]; //Gives right value to moving head color channel
//      if(mhx50_colorOld[id] != mhx50_color[id]) {
//      if(mhx50_duplicate == true) {
//        if(id == 0) {
//          mhx50_colorNumber[0] = i; //This is to show right rgb values in visualisation
//          mhx50_colorNumber[1] = i; break; //This is to show right rgb values in visualisation
//        }
//      }
//      else {
//        mhx50_colorNumber[id] = i; break; //This is to show right rgb values in visualisation
//      }
//      }
//      mhx50_colorOld[id] = mhx50_color[id];
//    }
//    }
//  }
//}
//
//void rainbow(int value, int id) {
//  if(value < -5) { mhx50_color[id] = round(map(value, 0, -100, 128, 191)); } //Rainbow to negative direction
//  else if(value > 5) { mhx50_color[id] = round(map(value, 0, 100, 192, 255)); } //Rainbow to positive direction
//  else  { mhx50_color[id] = 5; } //No rainbow
//}
//
//void mhx50_noGobo(int id) { mhx50_goboValue[id] = 5; } //Gobowheel open
//void mhx50_goboUp(int id) {
//  //This void changes gobo to next and counts right value to gobowheel channel
//  mhx50_goboNumber[id]++;
//  if(mhx50_goboNumber[id] >= mhx50_gobo_values.length) {
//    mhx50_goboNumber[id] = 0;
//  }
//  mhx50_goboValue[id] = mhx50_gobo_values[mhx50_goboNumber[id]];
//}
//void mhx50_goboDown(int id) {
//  //This void changes gobo to previous and counts right value to gobowheel channel
//  mhx50_goboNumber[id]--;
//  if(mhx50_goboNumber[id] < 0) {
//    mhx50_goboNumber[id] = mhx50_gobo_values.length - 1;
//  }
//  mhx50_goboValue[id] = mhx50_gobo_values[mhx50_goboNumber[id]];
//}
//void mhx50_goboRainbowUp(int value, int id) { mhx50_goboValue[id] = round(map(value, 0, 100, 128, 191)); } //This void makes gobowheel rotate positive direction with various speed
//void mhx50_goboRainbowDown(int value, int id) { mhx50_goboValue[id] = round(map(value, 0, 100, 192, 255)); } //This void makes gobowheel rotate negative direction with various speed
//
//void mhx50_goboRotationUp(int value, int id) { mhx50_goboRotationValue[id] = round(map(value, 0, 100, 64, 147)); }  //This void makes gobo rotate positive direction with various speed
//void mhx50_goboRotationDown(int value, int id) { mhx50_goboRotationValue[id] = round(map(value, 0, 100, 148, 231)); } //This void makes gobo rotate negative direction with various speed
//void mhx50_goboNoRotation(int id) { mhx50_goboRotationValue[id] = 20; } //This void stops rotating gobo
//void mhx50_goboBouncing(int id) { mhx50_goboRotationValue[id] = 245; } //This void makes gobo bouncing
//void mhx50_autoProgram(int id) {
//  //This void counts autoprogram number and sets autoProgram channel to right value
//  mhx50_autoProgramNumber[id]++;
//  if(mhx50_autoProgramNumber[id] >= mhx50_autoProgram_values.length) {
//    mhx50_goboNumber[id] = 0;
//  }
//  mhx50_autoProgramValue[id] = mhx50_autoProgram_values[mhx50_autoProgramNumber[id]];
//}
//void mhx50_prism(int value, int id) { mhx50_prismValue[id] = value; } //Changes prism value
//void mhx50_focus(int value, int id) { mhx50_focusValue[id] = value; } //Changes focus value
//
//void mhx50_reset(int value, int id) {
//  //This void sends reset singnal to moving head
//  if(value == 0) { mhx50_resetValue[id] = 0; }
//  else { mhx50_resetValue[id] = 154; }
//}
//void mhx50_blackOut(int id) { mhx50_shutterValue[id] = 1; } //Blackout with shutter
//void mhx50_openShutter(int id) { mhx50_shutterValue[id] = 5; } //Open shutter
//void mhx50_strobe(int value, int id) { mhx50_shutterValue[id] = round(map(value, 0, 100, 8, 215)); } //Strobe with shutter
//
//
//
//
////This void makes array to send to DMX
//void mhx50_finalChannelValuesCreate(int id) {
//  //--------------------------------------------------------------------------------------------------------------------------------Making right position values begins-------------------------------------------------------------------------------------------------------------------------------
//  if(mhx50_posMirror == true) {
//    if(id == 0) {
//      if(mhx50_panValueOld[0] != mhx50_panValue[0])    { mhx50_createFinalChannelValues[0][0] = round(map(mhx50_panValue[0], 0, 255, 255, 0)); mhx50_createFinalChannelValues[1][0] = mhx50_panValue[0]; }
//      if(mhx50_tiltValueOld[0] != mhx50_tiltValue[0])  { mhx50_createFinalChannelValues[0][1] = mhx50_tiltValue[0]; mhx50_createFinalChannelValues[1][1] = mhx50_tiltValue[0]; }
//      
//      mhx50_panValueOld[0] = mhx50_panValue[0];
//      mhx50_tiltValueOld[0] = mhx50_tiltValue[0];
//    }
//  }
//  else 
//  if(mhx50_posDuplicate == true) {
//    if(mhx50_panValueOld[0] != mhx50_panValue[0])    { mhx50_createFinalChannelValues[0][0] = mhx50_panValue[0]; mhx50_createFinalChannelValues[1][0] = mhx50_panValue[0]; }
//    if(mhx50_tiltValueOld[0] != mhx50_tiltValue[0])  { mhx50_createFinalChannelValues[0][1] = mhx50_tiltValue[0]; mhx50_createFinalChannelValues[1][1] = mhx50_tiltValue[0]; }
//    
//    mhx50_panValueOld[0] = mhx50_panValue[0];
//    mhx50_tiltValueOld[0] = mhx50_tiltValue[0];
//  }
//  else {
//    if(mhx50_panValueOld[id] != mhx50_panValue[id])    { mhx50_createFinalChannelValues[id][0] = mhx50_panValue[id]; }
//    if(mhx50_tiltValueOld[id] != mhx50_tiltValue[id])  { mhx50_createFinalChannelValues[id][1] = mhx50_tiltValue[id]; }
//    
//    mhx50_panValueOld[id] = mhx50_panValue[id];
//    mhx50_tiltValueOld[id] = mhx50_tiltValue[id];
//  }
//  
//  //---------------------------------------------------------------------------------------------------------------------------------Making right position values ends---------------------------------------------------------------------------------------------------------------------------------
//  
//  
//  
//  if(mhx50_duplicate == true) { //If duplicate is true then give same data to both moving heads
//    if(mhx50_panFineValueOld[0] != mhx50_panFineValue[0])                                   { mhx50_createFinalChannelValues[0][2] = mhx50_panFineValue[0]; mhx50_createFinalChannelValues[1][2] = mhx50_panFineValue[0]; }
//    if(mhx50_tiltFineValueOld[0] != mhx50_tiltFineValue[0])                                 { mhx50_createFinalChannelValues[0][3] = mhx50_tiltFineValue[0]; mhx50_createFinalChannelValues[1][3] = mhx50_tiltFineValue[0]; }
//    if(mhx50_responseSpeedValueOld[0] != mhx50_responseSpeedValue[0])                       { mhx50_createFinalChannelValues[0][4] = mhx50_responseSpeedValue[0]; mhx50_createFinalChannelValues[1][4] = mhx50_responseSpeedValue[0]; }
//    if(mhx50_colorOld[0] != mhx50_color[0])                                                 { mhx50_createFinalChannelValues[0][5] = mhx50_color[0]; mhx50_createFinalChannelValues[1][5] = mhx50_color[0]; }
//    if(mhx50_shutterValueOld[0] != mhx50_shutterValue[0])                                   { mhx50_createFinalChannelValues[0][6] = mhx50_shutterValue[0]; mhx50_createFinalChannelValues[1][6] = mhx50_shutterValue[0]; }
//    if(mhx50_dimmerValueOld[0] != round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster))) { mhx50_createFinalChannelValues[0][7] = round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster)); mhx50_createFinalChannelValues[1][7] = round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster)); }
//    if(mhx50_goboValueOld[0] != mhx50_goboValue[0])                                         { mhx50_createFinalChannelValues[0][8] = mhx50_goboValue[0]; mhx50_createFinalChannelValues[1][8] = mhx50_goboValue[0]; }
//    if(mhx50_goboRotationValueOld[0] != mhx50_goboRotationValue[0])                         { mhx50_createFinalChannelValues[0][9] = mhx50_goboRotationValue[0]; mhx50_createFinalChannelValues[1][9] = mhx50_goboRotationValue[0]; }
//    if(mhx50_resetValueOld[0] != mhx50_resetValue[0])                                       { mhx50_createFinalChannelValues[0][10] = mhx50_resetValue[0]; mhx50_createFinalChannelValues[1][10] = mhx50_resetValue[0]; }
//    if(mhx50_autoProgramValueOld[0] != mhx50_autoProgramValue[0])                           { mhx50_createFinalChannelValues[0][11] = mhx50_autoProgramValue[0]; mhx50_createFinalChannelValues[1][11] = mhx50_autoProgramValue[0]; }
//    if(mhx50_prismValueOld[0] != mhx50_prismValue[0])                                       { mhx50_createFinalChannelValues[0][12] = mhx50_prismValue[0]; mhx50_createFinalChannelValues[1][12] = mhx50_prismValue[0]; }
//    if(mhx50_focusValueOld[0] != mhx50_focusValue[0])                                       { mhx50_createFinalChannelValues[0][13] = mhx50_focusValue[0]; mhx50_createFinalChannelValues[1][13] = mhx50_focusValue[0]; }
//   
//   mhx50_panFineValueOld[0] = mhx50_panFineValue[0];
//   mhx50_tiltFineValueOld[0] = mhx50_tiltFineValue[0];
//   mhx50_responseSpeedValueOld[0] = mhx50_responseSpeedValue[0];
//   mhx50_colorOld[0] = mhx50_color[0];
//   mhx50_shutterValueOld[0] = mhx50_shutterValue[0];
//   mhx50_dimmerValueOld[0] = round(map(mhx50_dimmerValue[0], 0, 255, 0, grandMaster));
//   mhx50_goboValueOld[0] = mhx50_goboValue[0];
//   mhx50_goboRotationValueOld[0] = mhx50_goboRotationValue[0];
//   mhx50_resetValueOld[0] = mhx50_resetValue[0];
//   mhx50_autoProgramValueOld[0] = mhx50_autoProgramValue[0];
//   mhx50_prismValueOld[0] = mhx50_prismValue[0];
//   mhx50_focusValueOld[0] = mhx50_focusValue[0];
//  }
//  else { //If duplicate is not true then give the separate data to moving heads
//    if(mhx50_panFineValueOld[id] != mhx50_panFineValue[id])                                   { mhx50_createFinalChannelValues[id][2] = mhx50_panFineValue[id]; }
//    if(mhx50_tiltFineValueOld[id] != mhx50_tiltFineValue[id])                                 { mhx50_createFinalChannelValues[id][3] = mhx50_tiltFineValue[id]; }
//    if(mhx50_responseSpeedValueOld[id] != mhx50_responseSpeedValue[id])                       { mhx50_createFinalChannelValues[id][4] = mhx50_responseSpeedValue[id]; }
//    if(mhx50_colorOld[id] != mhx50_color[id])                                                 { mhx50_createFinalChannelValues[id][5] = mhx50_color[id]; }
//    if(mhx50_shutterValueOld[id] != mhx50_shutterValue[id])                                   { mhx50_createFinalChannelValues[id][6] = mhx50_shutterValue[id]; }
//    if(mhx50_dimmerValueOld[id] != round(map(mhx50_dimmerValue[id], 0, 255, 0, grandMaster))) { mhx50_createFinalChannelValues[id][7] = round(map(mhx50_dimmerValue[id], 0, 255, 0, grandMaster)); }
//    if(mhx50_goboValueOld[id] != mhx50_goboValue[id])                                         { mhx50_createFinalChannelValues[id][8] = mhx50_goboValue[id]; }
//    if(mhx50_goboRotationValueOld[id] != mhx50_goboRotationValue[id])                         { mhx50_createFinalChannelValues[id][9] = mhx50_goboRotationValue[id]; }
//    if(mhx50_resetValueOld[id] != mhx50_resetValue[id])                                       { mhx50_createFinalChannelValues[id][10] = mhx50_resetValue[id]; }
//    if(mhx50_autoProgramValueOld[id] != mhx50_autoProgramValue[id])                           { mhx50_createFinalChannelValues[id][11] = mhx50_autoProgramValue[id]; }
//    if(mhx50_prismValueOld[id] != mhx50_prismValue[id])                                       { mhx50_createFinalChannelValues[id][12] = mhx50_prismValue[id]; }
//    if(mhx50_focusValueOld[id] != mhx50_focusValue[id])                                       { mhx50_createFinalChannelValues[id][13] = mhx50_focusValue[id]; }   
//  }
//}
//
////Saves current values to preset array
//void savePreset(int presetNumber, int id) {
//  for(int i = 0; i < 13; i++) {
//    mhx50_createFinalPresetValues[presetNumber][id][i] = mhx50_createFinalChannelValues[id][i];
//  }
//  savePreset = false;
//}
//
////Changes current values from preset array
//void showPreset(int presetNumber, int id) {
//  for(int i = 0; i < 13; i++) {
//     mhx50_createFinalChannelValues[0][i] = mhx50_createFinalPresetValues[presetNumber][0][i]; //Give values to mh 0
//     mhx50_createFinalChannelValues[1][i] = mhx50_createFinalPresetValues[presetNumber][1][i]; //Give values to mh 1
//  }
//  
//  checkColorNumber(0); //Change colornumber of mh 0 for visualisation
//  checkColorNumber(1); //Change colornumber of mh 1 for visualisation
//}
//
//
////Check color number for visualisation
//void checkColorNumber(int id) {
//  for(int i = 0; i < mhx50_color_values.length; i++) { //Goes through every possible value
//    if(mhx50_createFinalChannelValues[id][5] == mhx50_color_values[i]) {
//      mhx50_colorNumber[id] = i; break;
//    }
//  }
//  
//}
//
//
////Sound to light changes preset to next by detecting beats
//void mhx50_playS2l() {
//  millisNow[10] = millis();
//  if(biitti == true && millisNow[10] - millisOld[10] > 200) { //Check is there 200 millis passed from previous stepchange
//    mhx50_s2l_step++; //Changes step to next
//    if(mhx50_s2l_step > mmhx50_s2l_numberOfPresets) { //Check if step is too high
//      mhx50_s2l_step = 0; //Set step to zero if it's too high
//    }
//    showPreset(mhx50_s2l_presets[mhx50_s2l_step], 0); //Shows right preset
//    millisOld[10] = millisNow[10]; //Saves current time
//  }
//}
