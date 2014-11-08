
int userId = 2; //Määritellään millä tietokoneella ohjelmaa käytetään 1 = Elias mac, 2 = Roope, 3 = Elias laptop - what pc are you using?
boolean roopeAidilla = false; //Onko Roope äidillänsä? Hieman eri asetukset.


boolean printMode = false; //This changes theme which could be usable if you want to print the visualisation
boolean useCOM = false; //Onko tietokoneeseen kytketty arduino ja enttec DMX usb pro - are arduino and enttec in use
boolean useEnttec = true; //Onko enttec usb dmx pro käytössä - is enttec DMX Usb pro in use
boolean useAnotherArduino = false;

boolean useMaschine = false;

int arduinoBaud = 115200; //Arduinon baudRate (serial.begin(115200);
int arduinoBaud2 = 9600;

int arduinoIndex = 8; //Arduinon COM-portin järjestysnumero
int arduinoIndex2 = 10;
int enttecIndex = 0; // Enttecin USB DMX palikan COM-portin järjestysnumero

int touchOscInComing = 8000;

boolean[][] allowChannel = new boolean[10][512];

void setAllowedChannels() {
  for(int i = 0; i < 512; i++) {
    for(int ij = 0; ij < 10; ij++) {
      allowChannel[ij][i] = true;
    }
  }
  for(int i = 0; i < 15; i++) {
    allowChannel[1][i] = false;
  }
  for(int i = 15; i < 40; i++) {
    allowChannel[1][i] = true;
  }
  for(int i = 40; i < 512; i++) {
    allowChannel[1][i] = false;
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
boolean useSolo = true; //Käytetäänkö soloa - is solo in use at all


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




//------------------------------------------------------------------------------------------------------------------------------------------------Moving head variables----------------------------------------------------------------------------------------------------------------------------------------------------------------
int[][] mhx50_createFinalChannelValues = new int[2][14];
int[][][] mhx50_createFinalPresetValues = new int[16][2][14];

int mhx50_s2l_step;
int[] mhx50_s2l_presets = new int[500];
int mmhx50_s2l_numberOfPresets = 0;
boolean mhx50_saves2l;
boolean mhx50_saves2lfirstTime;
boolean mhx50_plays2l;

boolean mhx50_posDuplicate = false;
boolean mhx50_posMirror = true;
boolean mhx50_duplicate = true;

boolean savePreset = false;
boolean changeValues = true;

int[] mhx50_panValue = { 0, 0 };
int[] mhx50_tiltValue = { 0, 0 };
int[] mhx50_panFineValue = { 0, 0 };
int[] mhx50_tiltFineValue = { 0, 0 };
int[] mhx50_responseSpeedValue = { 0, 0 };
int[] mhx50_dimmerValue = { 0, 0 };
int[] mhx50_shutterValue = { 0, 0 };

int[] mhx50_color = { 0, 0 };
int[] mhx50_colorNumber = { 0, 0 };



int[][] mhx50_RGB_color_Values = { { 255, 255, 255 }, { 255, 255, 0 }, { 255, 100, 255 }, { 0, 100, 0 }, { 255, 0, 255 }, { 0, 0, 255 }, { 0, 255, 0 }, { 255, 30, 0 }, { 0, 0, 100 } };
int[] mhx50_color_values = { 5, 12, 19, 26, 33, 40, 47, 54, 62 }; //white, yellow, lightpink, green, darkpink, lightblue, lightgreen, red, dark blue
String[] mhx50_color_names = { "white", "yellow", "lightpink", "green", "darkpink", "lightblue", "lightgreen", "red", "blue" };

int[] mhx50_gobo_values = { 6, 14, 22, 30, 38, 46, 54, 62 };
int[] mhx50_goboNumber = { 0, 0 };
int[] mhx50_goboValue = { 0, 0 };

int[] mhx50_goboRotationValue = { 0, 0 };

int[] mhx50_focusValue = { 0, 0 };
int[] mhx50_prismValue = { 0, 0 };

int[] mhx50_autoProgram_values = { 6, 22, 6, 38, 6, 54, 6, 70, 6, 86, 6, 102, 6, 118, 6, 134, 6, 150, 6, 166, 6, 182, 6, 198, 6, 214, 6, 230, 6, 247, 6, 254 };
int[] mhx50_autoProgramNumber = { 0, 0 };
int[] mhx50_autoProgramValue = { 0, 0 };

int[] mhx50_resetValue = { 0, 0 };




int[]  mhx50_panValueOld = { 0, 0 };
int[]  mhx50_tiltValueOld = { 0, 0 };
int[]  mhx50_panFineValueOld = { 0, 0 };
int[]  mhx50_tiltFineValueOld = { 0, 0 };
int[]  mhx50_responseSpeedValueOld = { 0, 0 };
int[]  mhx50_colorOld = { 0, 0 };
int[]  mhx50_shutterValueOld = { 0, 0 };
int[]  mhx50_dimmerValueOld = { 0, 0 };
int[]  mhx50_goboValueOld = { 0, 0 };
int[]  mhx50_goboRotationValueOld = { 0, 0 };
int[]  mhx50_resetValueOld = { 0, 0 };
int[]  mhx50_autoProgramValueOld = { 0, 0 };
int[]  mhx50_prismValueOld = { 0, 0 };
int[]  mhx50_focusValueOld = { 0, 0 };


boolean midiPositionButtonPressed;



//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






import javax.swing.JFrame; //Käytetään frame-kirjastoa, jonka avulla voidaan luoda monta ikkunaa

PFrame f1 = new PFrame();; //Luodaan uusi ikkuna
secondApplet1 s1;

PFrame1 f = new PFrame1();; //Luodaan toinenkin uusi ikkuna
secondApplet s;





boolean biitti = false;

int pageRotation = 0; //How much is page rotated (0-360)

int memoryMenu = 0; //Memorymenun kohta (mistä numerosta alkaa)

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

String loadPath = "mopodiskovalot2/";
String savePath = "mopodiskovalot2/";



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

boolean presetMenu = false; //Onko presetmenu näkyvissä







int presetNumero = 1; 
boolean makingPreset = false; //Tarkistaa ollaanko presettiä luomassa parhaillaan
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

int[] soundToLightValues = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 30, 34, 38, 42, 46, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 250, 240, 230, 220, 210, 200, 190, 180, 170, 160, 150, 140, 130, 120, 110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
 
int[] steppi = new int[numberOfMemories];
int[] steppi1 = new int[numberOfMemories];

boolean mouseReleased = false;

int oldMouseX;
int oldMouseY;

int x_siirto = 0; //Visualisaation sijainnin muutos vaakasuunnassa
int y_siirto = 0; //Visualisaation sijainnin muutos pystysuunnassa
int zoom = 100; //Visualisaation zoomauksen muutos

boolean upper; //enttec dmx usb pro ch +12

//----------------------------------------------------------------Moving headin muuttujia--------------------------------------------------------------------------------
//--------------------------------------------------5.9.2014 nämä eivät ole käytössä-------------------------------------------------------------------------------------
int movingHeadPanChannel = 501; //Moving headin pan-kanava
int movingHeadPan; //Moving headin pan arvo

int movingHeadTiltChannel = 500; //Moving headin tilt-kanava
int movingHeadTilt; //Moving headin tilt arvo

int movingHeadDimChannel = 10; //Moving headin dim-kanava
int movingHeadDim; //Moving headin dim arvo

int movingHeadRed = 255; //Moving headin väri visualisaatiossa
int movingHeadGreen = 255; //Moving headin väri visualisaatiossa
int movingHeadBlue = 0; //Moving headin väri visualisaatiossa

boolean useMovingHead = false; //Käytetäänkö moving headia ohjelmassa

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

int outputChannels = 80;
int channels = outputChannels;

int enttecDMXchannels = 600; //DMX kanavien määrä
int touchOSCchannels = 72; //touchOSC kanavien määrä
int controlP5channels = 12; //tietokoneen faderien määrä

int[] enttecDMXchannel = new int[enttecDMXchannels+1]; //DMX kanavan arvo
int[] touchOSCchannel = new int[touchOSCchannels+1]; //touchOSC kanavan arvo
int[] controlP5channel = new int[controlP5channels+1]; //tietokoneen faderien arvo


//Vanhojen arvojen avulla tarkistetaan onko arvo muuttunut, 
//jolloin arvoa ei tarvitse lähettää eteenpäin, ellei se ole muuttunut
int[] enttecDMXchannelOld = new int[enttecDMXchannels+1]; //DMX kanavan vanha arvo
int[] touchOSCchannelOld = new int[touchOSCchannels+1]; //touchOSC kanavan vanha arvo
int[] controlP5channelOld = new int[controlP5channels+1]; //tietokoneen faderien vanha arvo

int[][] allChannels = new int[6][48];
int[][] allChannelsOld = new int[6][48];

int controlP5place = 1; //tietokoneen faderien ohjaamat kanavat
int enttecDMXplace = 1; //DMX ohjatut kanavat
int touchOSCplace = 1; //touchOSC ohjatut kanavat



int maxStepsInChase = outputChannels*2;
int[][] chase1 = new int[5][maxStepsInChase];
int[] chaseSteps = new int[maxStepsInChase];



import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

ControlFrame cf;

int def;


//sound to light kirjastot
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//touchOSC kirjastot
import oscP5.*;
import netP5.*;

OscP5 oscP5;

NetAddress Remote;
int portOutgoing = 9000; 
String remoteIP = "192.168.0.12"; //iPadin ip-osoite

//----------------------------------------------------------------------------sound to light asetuksia ---------------------------------------------------------------------------
Minim minim;
AudioPlayer song;
AudioInput in;
BeatDetect beat;

FFT fft;

int buffer_size = 1024;  // also sets FFT size (frequency resolution)
float sample_rate = 44100;

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



float[] lastY;
float[] lastVal;



import processing.serial.*; //Käytetään processingin serial kirjastoa arduinon kanssa kommunikointia varten
Serial arduinoPort;
Serial arduinoPort2;


//----------------Tämä lähettää kaiken datan ohjelmasta ulospäin lukuunottamatta iPadille kulkevaa dataa--------------------------------------------
//----------------Tämän muuttamiseen ei pitäisi olla mitään syytä ellei Arduinossa olevaa ohjelmaa vaihdeta-----------------------------------------
void setDmxChannel(int channel, int value) {
  if(useCOM == true) { //Tarkistetaan halutaanko dataa lähettää ulos ohjelmasta
    // Convert the parameters into a message of the form: 123c45w where 123 is the channel and 45 is the value
    // then send to the Arduino
    if(allowChannel[0][channel]) {
      arduinoPort.write( str(channel) + "c" + str(constrain(value, 0, 255)) + "w" );
    }
    if(useAnotherArduino) {
      if(allowChannel[1][channel]) {
        arduinoPort2.write( str(channel) + "c" + str(constrain(value, 0, 255)) + "w" );
      }
    }
  }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------

fixture[] fixtures = new fixture[numberOfAllFixtures];

//New system for organizing the boxes in the bottom menu. Array index = fixture id, data = fixture location
int[] bottomMenuOrder = new int[numberOfAllFixtures];

// 1 = par64; 2 = pieni fresu; 3 = keskikokoinen fresu; 4 = iso fresu; 5 = floodi; 6 = linssi; 7 = haze; 8 = haze fan; 9 = strobe; 10 = strobe freq; 11 = fog; 12 = pinspot; 13 = moving head  dim; 14 = moving head pan; 15 = moving head tilt;
int[] fixtureType1 = { 3, 4, 4, 1, 1, 1, 1, 4, 4, 3, 6, 6, 5, 5, 5, 5, 1, 1, 1, 7, 71, 8, 81, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };

//visualisaation fixtuurien sijainnit
//int[] xEtu = { 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600 }; //etuansan fixtuurien sijainnit sivusuunnassa
int[] xTaka = new int[numberOfAllFixtures]; //taka-ansan fixtuurien sijainnit sivusuunnassa
int[] yTaka = new int[numberOfAllFixtures]; //taka-ansan fixtuurien sijainnit korkeussuunnassa
//int[] yEtu = { 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 }; //etuansan fixtuurien sijainnit sivusuunnassa

//visualisaation fixtuurien värit
int[] red = { 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255 }; 
int[] green = { 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255 };
int[] blue = { 0, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255  };

int[] y = { 500, 200 };
int[] rotTaka = { 20, 15, 10, 5, 0, 0, 0, 0, -5, -10, -15, -20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int ansaTaka = 32;
int ansaEtu = 12;
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

int[] dmxChannel = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 13, 14, 14, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83 }; //Fixtuurien todelliset DMX-kanavat
int[] channel = new int[channels+2];

int[] memoryData;
boolean[] memoryIsZero;

boolean move = false;
boolean moveLamp = false;

boolean mouseClicked = false;
int lampToMove;

int[][] recVal = new int[1000000][12];

boolean rec;
boolean play;

int countteri;

long recStartMillis;

int playStep;

//--------------------------------------Chase muuttujat-----------------------------------
int chaseStep1 = 1;
int chaseStep2;
int[] chaseBright1 = new int[numberOfMemories];
int[] chaseBright2 = new int[numberOfMemories];
int chaseLamp1;
int chaseLamp2;

boolean chaseFirstTime = true;

boolean chase;
boolean dmxSoundToLight = false;

//----------------------------------------------------------------------------------------


Serial myPort;  // The serial port





void setup() {
  setAllowedChannels();
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
    
    
    for(int i = 1; i < 512; i++) { //Toistetaan 512 kertaa (yhden DMX-universumin maksimi kanavien määrä)
      dim[i] = 0; //nollataan muuttujan dim[] arvot
    }
    for(int i = 0; i < channels; i++) {
      channel[i] = dmxChannel[i]; //asetetaan muuttujalle channel[] samat arvot kuin muuttujalla dmxChannel[]
    }
    
    
      if(useEnttec == true) {
      myPort = new Serial(this, Serial.list()[enttecIndex], 115000);
      }
      if(useCOM == true) {
      arduinoPort = new Serial(this, Serial.list()[arduinoIndex], arduinoBaud);
      if(useAnotherArduino == true) {
        arduinoPort2 = new Serial(this, Serial.list()[arduinoIndex2], arduinoBaud2);
      }
    }
    
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
    initializeMaschine();
  }
}


