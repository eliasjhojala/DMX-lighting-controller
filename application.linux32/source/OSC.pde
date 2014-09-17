void oscEvent(OscMessage theOscMessage){
  String addr = theOscMessage.addrPattern();
  float val = theOscMessage.get(0).floatValue();

  int digitalValue = int(val);


for(int i = 1; i <= touchOSCchannels; i++) {
  String nimi = "/1/fader" + str(i);
  String nimi1 = "/1/push" + str(i);
  String nimi2 = "/5/fader" + str(i-24);
  String nimi3 = "/5/push" + str(i-24);
  String nimi4 = "/6/fader" + str(i-36);
  String nimi5 = "/6/push" + str(i-36);
  if(addr.equals(nimi) || addr.equals(nimi2)) {
    touchOSCchannel[i] = digitalValue;
  }
  if(addr.equals(nimi1) || addr.equals(nimi3)) {
    touchOSCchannel[i] = round(map(digitalValue, 0, 1, 1, 255));
  }
  if(addr.equals(nimi4)) {
    touchOSCchannel[i] = digitalValue;
  }
  if(addr.equals(nimi5)) {
    touchOSCchannel[i] = round(map(digitalValue, 0, 1, 1, 255));
  }
  
  
  
   if(addr.equals("/nextstep")) {
     if(digitalValue == 1) {
      nextStepPressed = true;
     }
   }
   if(addr.equals("/revstep")) {
     if(digitalValue == 1) {
      revStepPressed = true;
     }
   }
  
  
  
  
 if(addr.equals("/4/fader25")) {
    movingHeadDim = digitalValue;
     for(int iii = 0; iii < channels; iii++) {
   if(fixtureType1[iii] == 13) {
     dim[iii+1] = digitalValue;
   }
 }
 }

 
if(addr.equals("/4/xy1")){
 movingHeadTilt = int(theOscMessage.get(0).floatValue());
 movingHeadPan = int(theOscMessage.get(1).floatValue());
 for(int iii = 0; iii < channels; iii++) {
   if(fixtureType1[iii] == 14) {
     dim[iii+1] = int(theOscMessage.get(1).floatValue());
     rotTaka[iii] = int(theOscMessage.get(1).floatValue());
   }
   if(fixtureType1[iii] == 15) {
     dim[iii+1] = int(theOscMessage.get(0).floatValue());
     rotX[iii] = int(theOscMessage.get(0).floatValue());
   }
 }
}
}

}
