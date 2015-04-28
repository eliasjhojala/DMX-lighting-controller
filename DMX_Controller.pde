boolean loadAllDataInSetup = false;                                                                                                                                       //|
boolean showMode = false;                                                                                                                                                 //|
boolean showModeLocked = false;                                                                                                                                           //|
boolean showSockets = false;                                                                                                                                              //|
boolean printMode = false; //This changes theme which could be usable if you want to print the visualisation                                                              //|
boolean useCOM = false; //Onko tietokoneeseen kytketty arduino ja enttec DMX usb pro - are arduino and enttec in use                                                      //|
boolean use3D = false;                                                                                                                                                    //|
boolean showOutputAsNumbers = false;                                                                                                                                      //|
boolean useEnttec = false; //Onko enttec usb dmx pro käytössä - is enttec DMX Usb pro in use                                                                              //|
boolean useAnotherArduino = false;                                                                                                                                        //|
                                                                                                                                                                          //|
boolean useMaschine = false;                                                                                                                                              //|
boolean useNewLowerMenu = false;                                                                                                                                          //|
boolean showOldBottomMeu = false;                                                                                                                                         //|
                                                                                                                                                                          //|
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------//|
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------//|


boolean sketchFullScreen() {
  return true;
}

int touchOscIncoming = 8000;

boolean freeze = false;


boolean nextStepPressed = false;
boolean revStepPressed = false;

boolean blackOut = false;


//ID CHANGE
//Create variables for changing fixture id

int numberOfAllFixtures = 81;

void exit() {
  if(launchpad != null) try { launchpad.clearLeds(); } catch (Exception e) { e.printStackTrace(); }
}

//Asetetaan arvot fixturen ID:n muttamiseen tarkoitetuille muuttujille
void setFixtureChannelsAtSoftwareBegin() {
  for(int i = 0; i < numberOfAllFixtures; i++) {
    bottomMenuOrder[i] = i;
  }
}

import themidibus.*;
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html


import themidibus.*;
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
MidiBus myBus; // The MidiBus
MidiBus Maschine;

boolean[] noteOn = new boolean[10000];


import java.util.concurrent.atomic.AtomicInteger;


//--------------------------------------------------------------------------------------------------Moving head variables---------------------------------------------------------

int[][] mhx50_RGB_color_Values = { { 255, 255, 255 }, { 255, 255, 0 }, { 255, 100, 255 }, { 0, 100, 0 }, { 255, 0, 255 }, { 0, 0, 255 }, { 0, 255, 0 }, { 255, 30, 0 }, { 0, 0, 100 } };
int[] mhx50_color_values = { 5, 12, 19, 26, 33, 40, 47, 54, 62 }; //white, yellow, lightpink, green, darkpink, lightblue, lightgreen, red, dark blue
String[] mhx50_color_names = { "white", "yellow", "lightpink", "green", "darkpink", "lightblue", "lightgreen", "red", "blue" };

int[] mhx50_gobo_values = { 6, 14, 22, 30, 38, 46, 54, 62 };
int[] mhx50_autoProgram_values = { 6, 22, 6, 38, 6, 54, 6, 70, 6, 86, 6, 102, 6, 118, 6, 134, 6, 150, 6, 166, 6, 182, 6, 198, 6, 214, 6, 230, 6, 247, 6, 254 };

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






import javax.swing.JFrame; //Käytetään frame-kirjastoa, jonka avulla voidaan luoda monta ikkunaa

ThreeDeeWindow s1;

PFrame1 f = new PFrame1(this, 500, 500); //Luodaan toinenkin uusi ikkuna





int pageRotation = 0; //How much is page rotated (0-360)

int memoryMenu = 0; //Memorymenu offset

int numberOfMemories = 300; //How much are there memories used in software



//Näiden avulla voidaan tehdä master-liut memoreille ja fixtuureille
//Tällä hetkellä (5.9.2014) ne eivät kumminkaan ole vielä käytössä
int memoryMasterValue = 255; //Memorien master-muuttuja
int fixtureMasterValue = 255; //Fixtuurien master-muuttuja


int chaseSpeed = 500;
int chaseFade = 255;


boolean getPaths = false;

String loadPath = "";
String savePath = "";



boolean mouseLocked = false; //Onko hiiri lukittu jollekin tietylle alueelle
String mouseLocker; //Mille alueelle hiiri on lukittu

long[] millisNow = new long[100]; //Nykyinen aika   --> Käytetään delayta sijaistavissa komennoissa
long[] millisOld = new long[100]; //Edellinen aika  --> Käytetään delayta sijaistavissa komennoissa

boolean keyReleased = false; //Onko näppäin vapautettu


boolean useMemories = true; //Käytetäänkö presettejä ohjelmassa

int chaseMode; //1 = s2l, 2 = manual, 3 = auto

boolean makingSoundToLightFromPreset = false; //Ollaanko tällä hetkellä tekemässä sound to light presettiä
boolean selectingSoundToLight = false; //Ollaanko tällä hetkellä valitsemassa sound to light modea (EI KÄYTÖSSÄ)
int soundToLightNumero = 1; //Sound to lightin järjestysnumero (EI KÄYTÖSSÄ)



boolean mouseReleased = false;

int oldMouseX;
int oldMouseY;

float x_siirto = 0; //Visualisaation sijainnin muutos vaakasuunnassa
float y_siirto = 0; //Visualisaation sijainnin muutos pystysuunnassa
float zoom = 100; //Visualisaation zoomauksen muutos

boolean upper; //enttec dmx usb pro ch +12



//---------------------------------------------CHANNELS----------------------------------------------------//|||
//---------------------------------------------------------------------------------------------------------//|||
//---------------------------------------------------------------------------------------------------------//|||
                                                                                                           //|||
int outputChannels = 80;                                                                                   //|||
int channels = outputChannels;                                                                             //|||
                                                                                                           //|||
int enttecDMXchannels = 600; //DMX kanavien määrä                                                          //|||
int touchOSCchannels = 72; //touchOSC kanavien määrä                                                       //|||
int controlP5channels = 12; //tietokoneen faderien määrä                                                   //|||
                                                                                                           //|||
int[] enttecDMXchannel = new int[enttecDMXchannels+1]; //DMX kanavan arvo                                  //|||
int[] touchOSCchannel = new int[touchOSCchannels+1]; //touchOSC kanavan arvo                               //|||
int[] controlP5channel = new int[controlP5channels+1]; //tietokoneen faderien arvo                         //|||
                                                                                                           //|||
                                                                                                           //|||
//Vanhojen arvojen avulla tarkistetaan onko arvo muuttunut,                                                //|||
//jolloin arvoa ei tarvitse lähettää eteenpäin, ellei se ole muuttunut                                     //|||
int[] enttecDMXchannelOld = new int[enttecDMXchannels+1]; //DMX kanavan vanha arvo                         //|||
int[] touchOSCchannelOld = new int[touchOSCchannels+1]; //touchOSC kanavan vanha arvo                      //|||
int[] controlP5channelOld = new int[controlP5channels+1]; //tietokoneen faderien vanha arvo                //|||
                                                                                                           //|||
int[][] allChannels = new int[6][48*2];                                                                    //|||
int[][] allChannelsOld = new int[6][48*2];                                                                 //|||
                                                                                                           //|||
int controlP5place = 1; //tietokoneen faderien ohjaamat kanavat                                            //|||
int enttecDMXplace = 1; //DMX ohjatut kanavat                                                              //|||
int touchOSCplace = 1; //touchOSC ohjatut kanavat                                                          //|||
//---------------------------------------------------------------------------------------------------------//|||
//---------------------------------------------------------------------------------------------------------//|||
//---------------------------------------------------------------------------------------------------------//|||
             
             


//------------------------------OSC-------------------------//|
//touchOSC kirjastot                                        //|
import oscP5.*;                                             //|
import netP5.*;                                             //|
                                                            //|
//import method class                                       //|
import java.lang.reflect.Method;                            //|
                                                            //|
OscP5 oscP5;                                                //|
                                                            //|
NetAddress Remote;                                          //|
int portOutgoing = 9000;                                    //|
String remoteIP = "192.168.0.12"; //iPadin ip-osoite        //|
//----------------------------OSC END-----------------------//|



//------------------------------------s2l---------------------------------------//|
                                                                                //|
//sound to light kirjastot                                                      //|
import ddf.minim.spi.*;                                                         //|
import ddf.minim.signals.*;                                                     //|
import ddf.minim.*;                                                             //|
import ddf.minim.analysis.*;                                                    //|
import ddf.minim.ugens.*;                                                       //|
import ddf.minim.effects.*;                                                     //|
                                                                                //|
Minim minim;                                                                    //|
AudioPlayer song;                                                               //|
AudioInput in;                                                                  //|
BeatDetect beat;                                                                //|
                                                                                //|
FFT fft;                                                                        //|
                                                                                //|
int buffer_size = 1024;  // also sets FFT size (frequency resolution)           //|
float sample_rate = 44100;                                                      //|
                                                                                //|
//------------------------------------------------------------------------------//|



float[] lastY;
float[] lastVal;



import processing.serial.*; //Käytetään processingin serial kirjastoa arduinon kanssa kommunikointia varten

FixtureArray fixtures = new FixtureArray();
fixture[] fixtureForSelected = new fixture[1];

//New system for organizing the boxes in the bottom menu. Array index = fixture id, data = fixture location
int[] bottomMenuOrder = new int[numberOfAllFixtures];


int[] ch = new int[512];


int[] vals = new int[600];
boolean cycleStart = false;
int counter;
boolean error = false;
int[] check = { 126, 5, 14, 0, 0, 0 };

boolean move = false;
boolean moveLamp = false;

boolean mouseClicked = false;
int lampToMove;

void initializeCOM() {
  useCOM = false;
  useEnttec = false;
}



Serial myPort;  // The serial port


String fileSeparator = java.io.File.separator;
String actualSketchPath;

void setup() {
  trusses = new Truss[10];
  for(int i = 0; i < trusses.length; i++) {
    trusses[i] = new Truss();
  }
  
  s1.noLoop();

  loadCoreData();
  actualSketchPath = sketchPath("");
  //Initialize mouseLocker to prevent nullPointers
  mouseLocker = "";
  
  
  size(displayWidth, displayHeight); //Annetaan ikkunan kooksi sama kuin nykyisen näytön koko
  frameRate(60);
  background(0, 0, 0);
  stroke(255, 255, 255);


  thread("initializeCOM");
  
  

  //--------------------------------------Setup commands of minim library----------------------------------------
    minim = new Minim(this);
    in = minim.getLineIn(Minim.MONO,buffer_size,sample_rate);
    beat = new BeatDetect(in.bufferSize(), in.sampleRate());

    fft = new FFT(in.bufferSize(), in.sampleRate());
    fft.logAverages(16, 2);
    fft.window(FFT.HAMMING);
  //------------------------------------------------------------------------------------------------------------
  
  frame.setResizable(true);

  oscP5 = new OscP5(this,touchOscIncoming);
  
  setuppi();

  if(useMaschine) {
    //This is used to get data from the Maschine Mikro
    Maschine = new MidiBus(this, "Maschine Mikro MK2 In", "Maschine Mikro MK2 Out");
    thread("initializeMaschine");
  }
  
  thread("ylavalikkoSetup");
  colorWashSetup();
  memoryCreator = new MemoryCreationBox(false);
  createFixtureProfiles();
  subWindowHandler = new SubWindowHandler();
  
  
  s1.loop();
  
  
}
