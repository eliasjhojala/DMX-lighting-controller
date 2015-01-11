int userId = 3; //Määritellään millä tietokoneella ohjelmaa käytetään 1 = Elias mac, 2 = Roope, 3 = Elias laptop - what pc are you using?                                 //|
boolean roopeAidilla = true; //Onko Roope äidillänsä? Hieman eri asetukset.                                                                                               //|
                                                                                                                                                                          //|
boolean showMode = true;                                                                                                                                                  //|
                                                                                                                                                                          //| 
boolean printMode = false; //This changes theme which could be usable if you want to print the visualisation                                                              //|
boolean useCOM = true; //Onko tietokoneeseen kytketty arduino ja enttec DMX usb pro - are arduino and enttec in use                                                       //|
boolean useEnttec = true; //Onko enttec usb dmx pro käytössä - is enttec DMX Usb pro in use                                                                               //|
boolean useAnotherArduino = false;                                                                                                                                        //|
                                                                                                                                                                          //|
boolean useMaschine = false;                                                                                                                                              //|
                                                                                                                                                                          //|
int arduinoBaud = 115200; //Arduinon baudRate (serial.begin(115200);                                                                                                      //|
int arduinoBaud2 = 9600;                                                                                                                                                  //|
                                                                                                                                                                          //|
int arduinoIndex = 0; //Arduinon COM-portin järjestysnumero                                                                                                               //|
int arduinoIndex2 = 10;                                                                                                                                                   //|
int enttecIndex = 1; // Enttecin USB DMX palikan COM-portin järjestysnumero                                                                                               //|
                                                                                                                                                                          //|
int touchOscInComing = 8000;                                                                                                                                              //|
                                                                                                                                                                          //|
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------//|
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------//|




boolean freeze = false;


boolean[][] allowChannel = new boolean[10][512];

void setAllowedChannels() {
  for(int i = 0; i < 512; i++) {
    for(int ij = 0; ij < 10; ij++) {
      allowChannel[ij][i] = true;
    }
  }
}

fixtureInput[] fixtureInputs = new fixtureInput[2];



boolean nextStepPressed = false;
boolean revStepPressed = false;
int lastStepDirection;

int[] valueOfDimBeforeBlackout = new int[1000];
boolean blackOut = false;

int soloMemory = 11; //Memorypaikka, joka on solo - solomemory's memoryplace
boolean soloWasHere = false; //Oliko Solo äsken käytössä
boolean useSolo = false; //Käytetäänkö soloa - is solo in use at all


//ID CHANGE
//Create variables for changing fixture id

int numberOfAllFixtures = 81;

//Asetetaan arvot fixturen ID:n muttamiseen tarkoitetuille muuttujille
void setFixtureChannelsAtSoftwareBegin() {
  for(int i = 0; i < numberOfAllFixtures; i++) {
    bottomMenuOrder[i] = i;
  }
}

import themidibus.*; 
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html

MidiBus myBus; // The MidiBus
MidiBus Maschine;

boolean[] noteOn = new boolean[10000];


import java.util.concurrent.atomic.AtomicInteger;


//--------------------------------------------------------------------------------------------------Moving head variables---------------------------------------------------------
int[][] mhx50_createFinalChannelValues = new int[2][14];
int[][][] mhx50_createFinalPresetValues = new int[16][2][14];


boolean mhx50_posDuplicate = false;
boolean mhx50_posMirror = true;
boolean mhx50_duplicate = true;

boolean savePreset = false;
boolean changeValues = true;



int[][] mhx50_RGB_color_Values = { { 255, 255, 255 }, { 255, 255, 0 }, { 255, 100, 255 }, { 0, 100, 0 }, { 255, 0, 255 }, { 0, 0, 255 }, { 0, 255, 0 }, { 255, 30, 0 }, { 0, 0, 100 } };
int[] mhx50_color_values = { 5, 12, 19, 26, 33, 40, 47, 54, 62 }; //white, yellow, lightpink, green, darkpink, lightblue, lightgreen, red, dark blue
String[] mhx50_color_names = { "white", "yellow", "lightpink", "green", "darkpink", "lightblue", "lightgreen", "red", "blue" };

int[] mhx50_gobo_values = { 6, 14, 22, 30, 38, 46, 54, 62 };

int[] mhx50_autoProgram_values = { 6, 22, 6, 38, 6, 54, 6, 70, 6, 86, 6, 102, 6, 118, 6, 134, 6, 150, 6, 166, 6, 182, 6, 198, 6, 214, 6, 230, 6, 247, 6, 254 };

boolean midiPositionButtonPressed;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






import javax.swing.JFrame; //Käytetään frame-kirjastoa, jonka avulla voidaan luoda monta ikkunaa

PFrame f1 = new PFrame(); //Luodaan uusi ikkuna
secondApplet1 s1;

PFrame1 f = new PFrame1(this); //Luodaan toinenkin uusi ikkuna
secondApplet s;





boolean biitti = false;

int pageRotation = 0; //How much is page rotated (0-360)

int memoryMenu = 0; //Memorymenu offset

int numberOfMemories = 100; //How much are there memories used in software



//Näiden avulla voidaan tehdä master-liut memoreille ja fixtuureille
//Tällä hetkellä (5.9.2014) ne eivät kumminkaan ole vielä käytössä
int memoryMasterValue = 255; //Memorien master-muuttuja
int fixtureMasterValue = 255; //Fixtuurien master-muuttuja


boolean[] presetValueChanged = new boolean[1000];

boolean[] buttonValues = new boolean[100];
String[] buttonText = new String[100];

boolean[] chaseStepChanging = new boolean[numberOfMemories];
boolean[] chaseStepChangingRev = new boolean[numberOfMemories];
boolean[] fallingEdgeChaseStepChangin = new boolean[numberOfMemories];

int chaseSpeed = 500;
int chaseFade = 255;

boolean toRotateFixture;
boolean toChangeFixtureColor; 
int changeColorFixtureId = 0;

boolean getPaths = false;

String loadPath = "";
String savePath = "";



boolean mouseLocked = false; //Onko hiiri lukittu jollekin tietylle alueelle
String mouseLocker; //Mille alueelle hiiri on lukittu

int[] valueOfMemory = new int[1000];
int[] valueOfMemoryBeforeSolo = new int[1000];
int[] valueOfChannelBeforeSolo = new int[1000];

int[] memoryType = new int[1000]; //Memoryn tyyppi (1 = preset, 2 = sound to light)
int[] chaseModeByMemoryNumber = new int[1000];

long[] millisNow = new long[100]; //Nykyinen aika   --> Käytetään delayta sijaistavissa komennoissa
long[] millisOld = new long[100]; //Edellinen aika  --> Käytetään delayta sijaistavissa komennoissa

boolean keyReleased = false; //Onko näppäin vapautettu


boolean useMemories = true; //Käytetäänkö presettejä ohjelmassa

int[][] memory = new int[numberOfMemories][512]; //Memory [numero][fixtuurin arvo]
int[] memoryValue = new int[numberOfMemories]; //Tämänhetkinen memoryn arvo

int[][] preset = new int[numberOfMemories][512]; //Preset [numero][fixtuurin arvo]
int[] presetValue = new int[numberOfMemories]; //Tämänhetkinen presetin arvo
int[] presetValueOld = new int[numberOfMemories]; //Tämänhetkinen presetin arvo

int chaseMode; //1 = s2l, 2 = manual, 3 = auto

int[] soundToLightSteps = new int[numberOfMemories];
int[][] soundToLightPresets = new int[numberOfMemories][numberOfMemories];
boolean makingSoundToLightFromPreset = false; //Ollaanko tällä hetkellä tekemässä sound to light presettiä
boolean selectingSoundToLight = false; //Ollaanko tällä hetkellä valitsemassa sound to light modea (EI KÄYTÖSSÄ)
int soundToLightNumero = 1; //Sound to lightin järjestysnumero (EI KÄYTÖSSÄ)



boolean mouseReleased = false;

int oldMouseX;
int oldMouseY;

int x_siirto = 0; //Visualisaation sijainnin muutos vaakasuunnassa
int y_siirto = 0; //Visualisaation sijainnin muutos pystysuunnassa
int zoom = 100; //Visualisaation zoomauksen muutos

boolean upper; //enttec dmx usb pro ch +12

//----------------------------------------------------------------Moving headin muuttujia--------------------------------------------------------------------------------
//--------------------------------------------------5.9.2014 nämä eivät ole käytössä-------------------------------------------------------------------------------------
int movingHeadPan; //Moving headin pan arvo
int movingHeadTilt; //Moving headin tilt arvo

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------





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
int[][] allChannels = new int[6][48];                                                                      //|||
int[][] allChannelsOld = new int[6][48];                                                                   //|||
                                                                                                           //|||
int controlP5place = 1; //tietokoneen faderien ohjaamat kanavat                                            //|||
int enttecDMXplace = 1; //DMX ohjatut kanavat                                                              //|||
int touchOSCplace = 1; //touchOSC ohjatut kanavat                                                          //|||
//---------------------------------------------------------------------------------------------------------//|||
//---------------------------------------------------------------------------------------------------------//|||
//---------------------------------------------------------------------------------------------------------//|||
             
             
             
             
             
             
             
                                                                                                           
                                                                                                          
import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

ControlFrame cf;

int def;


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
Serial arduinoPort;
Serial arduinoPort2;


//----------------Tämä lähettää kaiken datan ohjelmasta ulospäin lukuunottamatta iPadille kulkevaa dataa----------------//|
//----------------Tämän muuttamiseen ei pitäisi olla mitään syytä ellei Arduinossa olevaa ohjelmaa vaihdeta-------------//|
void setDmxChannel(int channel, int value) {                                                                            //|
  if(useCOM == true) { //Tarkistetaan halutaanko dataa lähettää ulos ohjelmasta                                         //|
    // Convert the parameters into a message of the form: 123c45w where 123 is the channel and 45 is the value          //|
    // then send to the Arduino                                                                                         //|
    if(allowChannel[0][channel]) {                                                                                      //|
      arduinoPort.write( str(channel) + "c" + str(constrain(value, 0, 255)) + "w" );                                    //|
    }                                                                                                                   //|
    if(useAnotherArduino) {                                                                                             //|
      if(allowChannel[1][channel]) {                                                                                    //|
        arduinoPort2.write( str(channel) + "c" + str(constrain(value, 0, 255)) + "w" );                                 //| 
      }                                                                                                                 //|
    }                                                                                                                   //|
  }                                                                                                                     //|
}                                                                                                                       //|
//----------------------------------------------------------------------------------------------------------------------//|

FixtureArray fixtures = new FixtureArray();
fixture[] fixtureForSelected = new fixture[1];

//New system for organizing the boxes in the bottom menu. Array index = fixture id, data = fixture location
int[] bottomMenuOrder = new int[numberOfAllFixtures];

int[] y = { 500, 200 };
int ansaTaka = 32;
int[] valueToDmx = new int[512]; //fixtuurien kirkkaus todellisuudessa (dmx output), sekä visualisaatiossa
int[] valueToDmxOld = new int[512]; //fixtuurien kirkkaus todellisuudessa (dmx output), sekä visualisaatiossa
int[] dim = new int[512]; //fixtuurien kirkkaus todellisuudessa (dmx output), sekä visualisaatiossa
int[] dimOld = new int[512];
int[] dimInput = new int[512];
int[] ch = new int[512];


int[] vals = new int[600];
boolean cycleStart = false;
int counter;
boolean error = false;
int[] check = { 126, 5, 14, 0, 0, 0 };

int[] memoryData;
boolean[] memoryIsZero;

boolean move = false;
boolean moveLamp = false;

boolean mouseClicked = false;
int lampToMove;

//--------------------------------------Chase muuttujat-----------------------------------
int chaseStep1 = 1;
int chaseStep2;
int[] chaseBright1 = new int[numberOfMemories];
int[] chaseBright2 = new int[numberOfMemories];

boolean chase;

void initializeCOM() {
  try {
    if(useEnttec == true) {
      myPort = new Serial(this, Serial.list()[enttecIndex], 115000);
    }
  }
  catch(Exception e) {
    useEnttec = false;
  }
  try {
    if(useCOM == true) {
      arduinoPort = new Serial(this, Serial.list()[arduinoIndex], arduinoBaud);
      if(useAnotherArduino == true) {
        arduinoPort2 = new Serial(this, Serial.list()[arduinoIndex2], arduinoBaud2);
      }
    }
  }
  catch(Exception e) {
    useCOM = false;
  }
}

//----------------------------------------------------------------------------------------


Serial myPort;  // The serial port


String fileSeparator = java.io.File.separator;
String actualSketchPath;

void setup() {

  loadCoreData();
  actualSketchPath = sketchPath("");
  //Initialize mouseLocker to prevent nullPointers
  mouseLocker = "";
  thread("setAllowedChannels");
  memoryIsZero = new boolean[channels];
  if(getPaths == true) { //Jos ladattavien ja tallennettavien tiedostojen polut halutaan tarkistaa tiedostosta
    String lines100[] = loadStrings("C:\\DMXcontrolsettings\\savePath.txt"); //Luetaan savePath.txt:stä tiedot muuttujaan lines100[]
    savePath = lines100[0]; //savePath muuttujan arvoksi annetaan savePath.txt:n ensimmäinen rivi
    
    String lines101[] = loadStrings("C:\\DMXcontrolsettings\\loadPath.txt"); //Luetaan loadPath.txt:stä tiedot muuttujaan lines100[]
    loadPath = lines101[0]; //loadPath muuttujan arvoksi annetaan savePath.txt:n ensimmäinen rivi
  }
  
  cp5 = new ControlP5(this); //luodaan controlFrame-ikkuna
  
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("Control", 500,500);
  
    size(displayWidth, displayHeight); //Annetaan ikkunan kooksi sama kuin nykyisen näytön koko
    background(0, 0, 0);
    stroke(255, 255, 255);
    ansat(); //Piirretään  ansat
    
    
    
    
    
    
    thread("initializeCOM");  
    
    minim = new Minim(this);

    //---------------------------------------------------------Beat detectin setup-komennot---------------------------------------------------------
      in = minim.getLineIn(Minim.MONO,buffer_size,sample_rate);
      beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  
      fft = new FFT(in.bufferSize(), in.sampleRate());
      fft.logAverages(16, 2);
      fft.window(FFT.HAMMING);
    //----------------------------------------------------------------------------------------------------------------------------------------------
    
    
    //---------------------------------------------------------Touchoscin setup-komennot------------------------------------------------------------
      oscP5 = new OscP5(this, touchOscInComing); 
      frame.setResizable(true);
      Remote = new NetAddress(remoteIP,portOutgoing);
    //----------------------------------------------------------------------------------------------------------------------------------------------
    
    setuppi();
    
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 1, "KeyRig 49"); // Create a new MidiBus with no input device - you will have to change the input here
  
  
  if(useMaschine) {
    //This is used to get data from the Maschine Mikro
    Maschine = new MidiBus(this, "Maschine Mikro MK2 In", "Maschine Mikro MK2 Out");
    thread("initializeMaschine");
  }
  thread("ylavalikkoSetup");
  colorWashSetup();
  
  memoryCreator = new memoryCreationBox(false);
  
  createFixtureProfiles();
  
}


