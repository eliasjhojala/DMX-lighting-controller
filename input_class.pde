class input {
  int dimmer; //dimmer value
  int red, green, blue; //color values
  int pan, tilt, panFine, tiltFine; //rotation values
  int rotationX, rotationZ;
  int colorWheel, goboWheel, goboRotation, prism, focus, shutter, strobe, responseSpeed, autoPrograms, specialFunctions; //special values for moving heads etc.
  int haze, fan, fog; //Pyro values

  void receiveOSC(int value1, int value2, int address) {
        for(int id = 0; id <= 1; id++) { //Goes through all the controller groups
        
            //CH 1: Pan
            if(address.equals("/7/xy" + str(id+1)) || address.equals("/8/xy" + str(id+1))) { mhx50_pan(value2, id); } //Changes pan value
            //CH 2: Tilt
            if(address.equals("/7/xy" + str(id+1)) || address.equals("/8/xy" + str(id+1))) { mhx50_tilt(value, id); } //Changes tilt value
            //CH 3: Fine adjustment for rotation (pan)
            mhx50_panFine(0, id); //Sets panFine value to zero
            //CH 4: Fine adjustment for inclination (tilt)
            mhx50_tiltFine(0, id); //Sets tiltFine value to zero
            //CH 5: Response speed
            mhx50_responseSpeed(0, id); //Sets responseSpeed to zero which means the fastest possible
            
            //CH 6: Colour wheel
            mhx50_colorChange(address, id); //Check color buttons every round
            if(address.equals("/8/rainbow" + str(id+1))) { rainbow(value, id); } //Color rainbow
            
            //CH 7: Shutter
            if(address.equals("/8/blackOut" + str(id+1)) && value == 1) { mhx50_blackOut(id); } //Check if blackout is presset
            if(address.equals("/8/openShutter" + str(id+1)) && value == 1) { mhx50_openShutter(id); } //Check if open is pressed
            if(address.equals("/8/strobe" + str(id+1))) { mhx50_strobe(value, id); } //Check if strobe slider is over zero
            
            //CH 8: Mechanical dimmer
            if(address.equals("/7/dimmer" + str(id+1)) || address.equals("/8/dimmer" + str(id+1))) { mhx50_dimmer(value, id); } //Changes dimmer value
            
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
            if(address.equals("/8/reset" + str(id+1))) { mhx50_reset(value, id); } //Check ig reset button is pressed and resets all the channels in moving head
            
            //CH 12: Built-in programmes
            if(address.equals("/8/autoProgram" + str(id+1)) && value == 1) { mhx50_autoProgram(id); } //Next autoProgram
            
            //CH 13: Prism
            if(address.equals("/8/prism" + str(id+1))) { mhx50_prism(value, id); } //Change prism value
            
            //CH 14: Focus
            if(address.equals("/8/focus" + str(id+1))) { mhx50_focus(value, id); } //Change focus value
            
          
            
  
        }
    }
}
