
void chanelConfig() {
  for(int i = 0; i < enttecDMXchannels; i++) {
    ch[i] = allChannels[1][i];
  }
  for(int i = 0; i < touchOSCchannels; i++) {
    ch[i+enttecDMXchannels] = allChannels[2][i];
  }
  for(int i = 0; i < controlP5channels; i++) {
    ch[i+enttecDMXchannels+touchOSCchannels] = allChannels[3][i];
  }
}
