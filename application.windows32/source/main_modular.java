import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import javax.swing.JFrame; 
import java.awt.Frame; 
import java.awt.BorderLayout; 
import controlP5.*; 
import ddf.minim.spi.*; 
import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.ugens.*; 
import ddf.minim.effects.*; 
import oscP5.*; 
import netP5.*; 
import processing.serial.*; 
import java.io.File.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main_modular extends PApplet {


int userId = 1; //M\u00e4\u00e4ritell\u00e4\u00e4n mill\u00e4 tietokoneella ohjelmaa k\u00e4ytet\u00e4\u00e4n 1 = Elias, 2 = Roope - what pc are you using?
boolean roopeAidilla = true; //Onko Roope \u00e4idill\u00e4ns\u00e4? Hieman eri asetukset.

boolean printMode = false; //This changes theme which could be usable if you want to print the visualisation
boolean useCOM = false; //Onko tietokoneeseen kytketty arduino ja enttec DMX usb pro - are arduino and enttec in use
boolean useEnttec = false; //Onko enttec usb dmx pro k\u00e4yt\u00f6ss\u00e4 - is enttec DMX Usb pro in use

int arduinoBaud = 115200; //Arduinon baudRate (serial.begin(115200);)


boolean nextStepPressed = false;
boolean revStepPressed = false;
int lastStepDirection;

int[] valueOfDimBeforeBlackout = new int[1000];
boolean blackOut = false;

int soloMemory = 11; //Memorypaikka, joka on solo - solomemory's memoryplace
boolean soloWasHere = false; //Oliko Solo \u00e4sken k\u00e4yt\u00f6ss\u00e4
boolean useSolo = true; //K\u00e4ytet\u00e4\u00e4nk\u00f6 soloa - is solo in use at all


//ID CHANGE
//Create variables for changing fixture id

int numberOfAllFixtures = 40;
int[] fixtureIdOriginal = new int[numberOfAllFixtures];
int[] fixtureIdNow = new int[numberOfAllFixtures];
int[] fixtureChannelOriginal = new int[numberOfAllFixtures];
int[] fixtureChannelNow = new int[numberOfAllFixtures];

int[] fixtureIdNowTemp = new int[numberOfAllFixtures];
int[] fixtureIdNewTemp = new int[numberOfAllFixtures];
int[] fixtureIdOldTemp = new int[numberOfAllFixtures];

int[] fixtureIdPlaceInArray = new int[numberOfAllFixtures];

//Asetetaan arvot fixturen ID:n muttamiseen tarkoitetuille muuttujille
public void setFixtureChannelsAtSoftwareBegin() {
  for(int i = 0; i < numberOfAllFixtures; i++) {
    fixtureIdOriginal[i] = i;
    fixtureIdNow[i] = i;
    fixtureChannelOriginal[i] = i;
    fixtureChannelNow[i] = i + 1;
    fixtureIdPlaceInArray[i] = i;
  }
}







 //K\u00e4ytet\u00e4\u00e4n frame-kirjastoa, jonka avulla voidaan luoda monta ikkunaa

PFrame f1 = new PFrame();; //Luodaan uusi ikkuna
secondApplet1 s1;

PFrame1 f = new PFrame1();; //Luodaan toinenkin uusi ikkuna
secondApplet s;



boolean biitti = false;

int pageRotation = 0; //How much is page rotated (0-360)

int memoryMenu = 0; //Memorymenun kohta (mist\u00e4 numerosta alkaa)

int numberOfMemories = 100; //How much are there memories used in software



//N\u00e4iden avulla voidaan tehd\u00e4 master-liut memoreille ja fixtuureille
//T\u00e4ll\u00e4 hetkell\u00e4 (5.9.2014) ne eiv\u00e4t kumminkaan ole viel\u00e4 k\u00e4yt\u00f6ss\u00e4
int memoryMasterValue = 255; //Memorien master-muuttuja
int fixtureMasterValue = 255; //Fixtuurien master-muuttuja


boolean[] presetValueChanged = new boolean[1000];

boolean[] buttonValues = new boolean[100];
String[] buttonText = new String[100];

boolean[] chaseStepChanging = new boolean[numberOfMemories];
boolean[] chaseStepChangingRev = new boolean[numberOfMemories];

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

long[] millisNow = new long[100]; //Nykyinen aika   --> K\u00e4ytet\u00e4\u00e4n delayta sijaistavissa komennoissa
long[] millisOld = new long[100]; //Edellinen aika  --> K\u00e4ytet\u00e4\u00e4n delayta sijaistavissa komennoissa

boolean keyReleased = false; //Onko n\u00e4pp\u00e4in vapautettu

boolean presetMenu = false; //Onko presetmenu n\u00e4kyviss\u00e4


int arduinoIndex = 8; //Arduinon COM-portin j\u00e4rjestysnumero
int enttecIndex = 1; // Enttecin USB DMX palikan COM-portin j\u00e4rjestysnumero




int presetNumero = 1; 
boolean makingPreset = false; //Tarkistaa ollaanko presetti\u00e4 luomassa parhaillaan
boolean useMemories = true; //K\u00e4ytet\u00e4\u00e4nk\u00f6 presettej\u00e4 ohjelmassa

int[][] memory = new int[1000][512]; //Memory [numero][fixtuurin arvo]
int[] memoryValue = new int[1000]; //T\u00e4m\u00e4nhetkinen memoryn arvo

int[][] preset = new int[1000][512]; //Preset [numero][fixtuurin arvo]
int[] presetValue = new int[1000]; //T\u00e4m\u00e4nhetkinen presetin arvo
int[] presetValueOld = new int[1000]; //T\u00e4m\u00e4nhetkinen presetin arvo

int chaseMode; //1 = s2l, 2 = manual, 3 = auto

int[] soundToLightSteps = new int[1000];
int[][] soundToLightPresets = new int[1000][1000];
boolean makingSoundToLightFromPreset = false; //Ollaanko t\u00e4ll\u00e4 hetkell\u00e4 tekem\u00e4ss\u00e4 sound to light presetti\u00e4
boolean selectingSoundToLight = false; //Ollaanko t\u00e4ll\u00e4 hetkell\u00e4 valitsemassa sound to light modea (EI K\u00c4YT\u00d6SS\u00c4)
int soundToLightNumero = 1; //Sound to lightin j\u00e4rjestysnumero (EI K\u00c4YT\u00d6SS\u00c4)

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
//--------------------------------------------------5.9.2014 n\u00e4m\u00e4 eiv\u00e4t ole k\u00e4yt\u00f6ss\u00e4-------------------------------------------------------------------------------------
int movingHeadPanChannel = 501; //Moving headin pan-kanava
int movingHeadPan; //Moving headin pan arvo

int movingHeadTiltChannel = 500; //Moving headin tilt-kanava
int movingHeadTilt; //Moving headin tilt arvo

int movingHeadDimChannel = 10; //Moving headin dim-kanava
int movingHeadDim; //Moving headin dim arvo

int movingHeadRed = 255; //Moving headin v\u00e4ri visualisaatiossa
int movingHeadGreen = 255; //Moving headin v\u00e4ri visualisaatiossa
int movingHeadBlue = 0; //Moving headin v\u00e4ri visualisaatiossa

boolean useMovingHead = false; //K\u00e4ytet\u00e4\u00e4nk\u00f6 moving headia ohjelmassa

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

int outputChannels = 32;
int channels = outputChannels;

int enttecDMXchannels = 12; //DMX kanavien m\u00e4\u00e4r\u00e4
int touchOSCchannels = 72; //touchOSC kanavien m\u00e4\u00e4r\u00e4
int controlP5channels = 12; //tietokoneen faderien m\u00e4\u00e4r\u00e4

int[] enttecDMXchannel = new int[enttecDMXchannels+1]; //DMX kanavan arvo
int[] touchOSCchannel = new int[touchOSCchannels+1]; //touchOSC kanavan arvo
int[] controlP5channel = new int[controlP5channels+1]; //tietokoneen faderien arvo


//Vanhojen arvojen avulla tarkistetaan onko arvo muuttunut, 
//jolloin arvoa ei tarvitse l\u00e4hett\u00e4\u00e4 eteenp\u00e4in, ellei se ole muuttunut
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







private ControlP5 cp5;

ControlFrame cf;

int def;


//sound to light kirjastot







//touchOSC kirjastot



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



 //K\u00e4ytet\u00e4\u00e4n processingin serial kirjastoa arduinon kanssa kommunikointia varten
Serial arduinoPort;


//----------------T\u00e4m\u00e4 l\u00e4hett\u00e4\u00e4 kaiken datan ohjelmasta ulosp\u00e4in lukuunottamatta iPadille kulkevaa dataa--------------------------------------------
//----------------T\u00e4m\u00e4n muuttamiseen ei pit\u00e4isi olla mit\u00e4\u00e4n syyt\u00e4 ellei Arduinossa olevaa ohjelmaa vaihdeta-----------------------------------------
public void setDmxChannel(int channel, int value) {
  if(useCOM == true) { //Tarkistetaan halutaanko dataa l\u00e4hett\u00e4\u00e4 ulos ohjelmasta
    // Convert the parameters into a message of the form: 123c45w where 123 is the channel and 45 is the value
    // then send to the Arduino
    arduinoPort.write( str(channel) + "c" + str(value) + "w" );
  }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------



// 1 = par64; 2 = pieni fresu; 3 = keskikokoinen fresu; 4 = iso fresu; 5 = floodi; 6 = linssi; 7 = haze; 8 = haze fan; 9 = strobe; 10 = strobe freq; 11 = fog; 12 = pinspot; 13 = moving head  dim; 14 = moving head pan; 15 = moving head tilt;
int[] fixtureType1 = { 3, 4, 4, 1, 1, 1, 1, 4, 4, 3, 6, 6, 5, 5, 5, 5, 1, 1, 1, 7, 71, 8, 81, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };

//visualisaation fixtuurien sijainnit
//int[] xEtu = { 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600 }; //etuansan fixtuurien sijainnit sivusuunnassa
int[] xTaka = { 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 620, 640, 680, 700, 720, 740 }; //taka-ansan fixtuurien sijainnit sivusuunnassa
int[] yTaka = { 700, 700, 700, 700, 700, 700, 700, 700, 700, 700, 700, 700, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300, 300 }; //taka-ansan fixtuurien sijainnit korkeussuunnassa
//int[] yEtu = { 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100 }; //etuansan fixtuurien sijainnit sivusuunnassa

//visualisaation fixtuurien v\u00e4rit
int[] red = { 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255 }; 
int[] green = { 0, 0, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255 };
int[] blue = { 0, 255, 0, 0, 255, 0, 0, 255, 0, 0,  255, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255  };

int[] y = { 500, 200 };
int[] rotTaka = { 20, 15, 10, 5, 0, 0, 0, 0, -5, -10, -15, -20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int ansaTaka = 30;
int ansaEtu = 12;
int[] dim = new int[512]; //fixtuurien kirkkaus todellisuudessa (dmx output), sek\u00e4 visualisaatiossa
int[] dimOld = new int[512];
int[] dimInput = new int[512];
int[] ch = new int[512];


int[] vals = new int[31];
boolean cycleStart = false;
int counter;
boolean error = false;
int[] check = { 126, 5, 14, 0, 0, 0 };

int[] dmxChannel = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 13, 14, 14, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 }; //Fixtuurien todelliset DMX-kanavat
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





public void setup() {
  memoryIsZero = new boolean[channels];
  if(getPaths == true) { //Jos ladattavien ja tallennettavien tiedostojen polut halutaan tarkistaa tiedostosta
    String lines100[] = loadStrings("C:\\DMXcontrolsettings\\savePath.txt"); //Luetaan savePath.txt:st\u00e4 tiedot muuttujaan lines100[]
    savePath = lines100[0]; //savePath muuttujan arvoksi annetaan savePath.txt:n ensimm\u00e4inen rivi
    
    String lines101[] = loadStrings("C:\\DMXcontrolsettings\\loadPath.txt"); //Luetaan loadPath.txt:st\u00e4 tiedot muuttujaan lines100[]
    loadPath = lines101[0]; //loadPath muuttujan arvoksi annetaan savePath.txt:n ensimm\u00e4inen rivi
  }
  
  cp5 = new ControlP5(this); //luodaan controlFrame-ikkuna
  
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("Control", 500,500);
  
    size(displayWidth, displayHeight); //Annetaan ikkunan kooksi sama kuin nykyisen n\u00e4yt\u00f6n koko
    background(0, 0, 0);
    stroke(255, 255, 255);
    ansat(); //Piirret\u00e4\u00e4n  ansat
    
    
    for(int i = 1; i < 512; i++) { //Toistetaan 512 kertaa (yhden DMX-universumin maksimi kanavien m\u00e4\u00e4r\u00e4)
      dim[i] = 0; //nollataan muuttujan dim[] arvot
    }
    for(int i = 0; i < channels; i++) {
      channel[i] = dmxChannel[i]; //asetetaan muuttujalle channel[] samat arvot kuin muuttujalla dmxChannel[]
    }
    
    if(useCOM == true) {
      if(useEnttec == true) {
      myPort = new Serial(this, Serial.list()[enttecIndex], 115000);
      }
      arduinoPort = new Serial(this, Serial.list()[arduinoIndex], arduinoBaud);
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
      oscP5 = new OscP5(this, 8000); 
      frame.setResizable(true);
      Remote = new NetAddress(remoteIP,portOutgoing);
    //----------------------------------------------------------------------------------------------------------------------------------------------
    
    setuppi();
}


//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 on koko ohjelman ydin, eli draw-loop

int oldMouseX1;
int oldMouseY1;

int grandMaster = 50;
int oldGrandMaster = 40;
public void draw() {
  checkThemeMode();
  
  setDimAndMemoryValuesAtEveryDraw(); //Set dim and memory values
  arduinoSend(); //Send dim-values to arduino, which sends them to DMX-shield
  
  drawMainWindow(); //Draw fixtures (tab main_window)
  
  ylavalikko(); //top menu
  alavalikko(); //bottom menu
  sivuValikko(); //right menu
}
public void drawMainWindow() {
  pushMatrix();
    //T\u00c4SS\u00c4 K\u00c4\u00c4NNET\u00c4\u00c4N JA SIIRRET\u00c4\u00c4N N\u00c4KYM\u00c4 OIKEIN - DO ROTATE AND TRANSFORM RIGHT
   
   
   //Transform
   
   
   translate(width/2, height/2);
   translate(x_siirto, y_siirto); //Siirret\u00e4\u00e4n sivua oikean verran - move page
   scale(PApplet.parseFloat(zoom)/100); //Skaalataan sivua oikean verran - scale page
   rotate(radians(pageRotation)); //K\u00e4\u00e4nnet\u00e4\u00e4n sivua oikean verran - rotate page
   translate(-width/2, -height/2); //move page back
   translate(0, 50); //Siirret\u00e4\u00e4n kaikkea alasp\u00e4in yl\u00e4valikon verran - move all the objects down because top menu
   
   
   
   
       //T\u00c4SS\u00c4 PIIRRET\u00c4\u00c4N ANSAT - DRAW TRUSSES
      ansat();
      
      //Just using the rotation of PVectors, it already exists, so why not use it?
      PVector mouseRotated = new PVector(mouseX, mouseY);
      mouseRotated.rotate(radians(-pageRotation));
      
      if(moveLamp) {
        mouseLocked = true;
        mouseLocker = "main";
      }
      
      for(int i = 0; i < ansaTaka; i++) {
        pushMatrix();
            if(move && (!mouseLocked || mouseLocker == "main")) {
                if(!mouseClicked) {
                  if(moveLamp == true) {
                   if(lampToMove < ansaTaka) {
                    xTaka[lampToMove] = xTaka[lampToMove] + (PApplet.parseInt(mouseRotated.x) - oldMouseX1) * 100 / zoom - ansaX[ansaParent[lampToMove]];
                    yTaka[lampToMove] = yTaka[lampToMove] + (PApplet.parseInt(mouseRotated.y) - oldMouseY1) * 100 / zoom;
                    
                  }
            
                  moveLamp = false;
                  }
                    
                }
        
              if(moveLamp == true) {
                mouseLocked = true;
                mouseLocker = "main";
                if(i == lampToMove) { translate(xTaka[lampToMove] + ((PApplet.parseInt(mouseRotated.x) - oldMouseX1) * 100 / zoom), yTaka[lampToMove] + (PApplet.parseInt(mouseRotated.y) - oldMouseY1) * 100 / zoom + ansaY[ansaParent[lampToMove]]); }
                else { translate(xTaka[i]+ansaX[ansaParent[i]], yTaka[i]+ansaY[ansaParent[i]]); }
              }
              else { translate(xTaka[i]+ansaX[ansaParent[i]], yTaka[i]+ansaY[ansaParent[i]]); }
            }
            
            
            else { translate(xTaka[i]+ansaX[ansaParent[i]], yTaka[i]+ansaY[ansaParent[i]]); }


           if(fixtureType1[i] != 14) { rotate(radians(rotTaka[i])); }
           kalvo(round(map(red[i], 0, 255, 0, dim[channel[i]])), round(map(green[i], 0, 255, 0, dim[channel[i]])), round(map(blue[i], 0, 255, 0, dim[channel[i]])));
            
            
            
            if(move && (!mouseLocked || mouseLocker == "main")) {
              if(mouseClicked) {
                mouseLocked = true;
                mouseLocker = "main";
              
              
              //Get dimensions for the current fixture
              int[] fixSize = getFixtureSize(i);
              
              //IF cursor is hovering over i:th fixtures bounding box AND fixture should be drawn AND mouse is clicked
              if(isHover(0, 0, fixSize[0], fixSize[1]) && fixSize[2] == 1 && mouseClicked) {
               
                if(mouseButton == RIGHT) { toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = fixtureIdOriginal[i]; }
                else if(mouseReleased) {
                  oldMouseX1 = PApplet.parseInt(mouseRotated.x);
                  oldMouseY1 = PApplet.parseInt(mouseRotated.y);
                  lampToMove = i;
                  moveLamp = true;
                  mouseReleased = false;
                }
              }
            }
          }
              
              
              drawFixture(i);
            //
        popMatrix();
        if(mouseReleased) { mouseLocked = false; }
      }
      popMatrix();
}
public void setDimAndMemoryValuesAtEveryDraw() {
     for(int i = 0; i < channels; i++) {
    dim[i] = round(map(dimInput[i], 0, 255, 0, grandMaster));
  }
  memoryType[1] = 4; //Ensimm\u00e4isess\u00e4 memorypaikassa on grandMaster - there is grandMaster in a first memory place
  memoryType[2] = 5; //Toisessa memorypaikassa on fade - there is fade in second memory place
  
  
  
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  dmxCheck(); //Read dmx input from enttec
  dmxToDim(); //Set input to dimInput variable
  
  
  //-------------------------Set memories to their values. If solomemory is on all the others will be of-------------------------
  
  memoryData = new int[channels];
  for(int i = 0; i < numberOfMemories; i++) {
    if(useSolo == true) {
      if(valueOfMemory[soloMemory] < 10) {
        if(soloWasHere == true) {
          memory(i, valueOfMemoryBeforeSolo[i]);
          dimInput[i] = valueOfChannelBeforeSolo[i];
          soloWasHere = false;
        }
        else {
          if(valueOfMemory[i] > 0) {
            memory(i, valueOfMemory[i]);
          }
        }
      }
      else {
        soloWasHere = true;
        if(soloWasHere == false) {
          if(i == soloMemory && valueOfMemory[i] != 0) {
            memory(i, valueOfMemory[i]);
          }
          else {
            if(valueOfMemory[i] != 0 || dim[i] != 0) {
              valueOfMemoryBeforeSolo[i] = valueOfMemory[i];
              valueOfChannelBeforeSolo[i] = dim[i];
            }
            memory(i, 0);
            dimInput[i] = 0; 
          }
        }
        else {
          if(i == soloMemory && valueOfMemory[i] != 0) {
            memory(i, valueOfMemory[i]);
          }
        }
        
      }
    }
    else {
      if(valueOfMemory[i] > 0) {
        memory(i, valueOfMemory[i]);
      }
    }
  }
  
  
  
  for (int i = 0; i < channels; i++) {
    if (memoryData[i] != 0 || memoryIsZero[i] == false) {
      dimInput[i] = memoryData[i];
      if (memoryData[i] == 0) {memoryIsZero[i] = true;} else {memoryIsZero[i] = false;}
    }
  }
  
  //----------------------------------------------------------------------------------------------------------------------------
  
  
  //---------------------------------------------------------blackOut and-------------------------------------------------------
  
  if(blackOut == true)  { //Tarkistetaan onko blackout p\u00e4\u00e4ll\u00e4 - check if blackout is on
     grandMaster = 0; //if blackout is on then grandMaster will be zero
  }
  
   if(fullOn == true)  { //Tarkistetaan onko fullon p\u00e4\u00e4ll\u00e4 - check if fullOn is on
     for(int i = 0; i < channels; i++) { //K\u00e4yd\u00e4\u00e4n kaikki kanavat l\u00e4pi
       dimInput[i] = 255; //Asetetaan kanavan arvoksi nolla - set all of the channels to zero
     }
  }
}
//CONTROL WINDOW CODE//---->

   //This file is based on:
   /**
   * ControlP5 Controlframe
   * with controlP5 2.0 all java.awt dependencies have been removed
   * as a consequence the option to display controllers in a separate
   * window had to be removed as well. 
   * this example shows you how to create a java.awt.frame and use controlP5
   *
   * by Andreas Schlegel, 2012
   * www.sojamo.de/libraries/controlp5
   *
   */

 
 //This file is a part of a DMX control sweet. This part of the program uses specific variables. THIS IS NOT A STANDALONE PROGRAM
 
 
 /*
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */
 
boolean wave = false;

public ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(theWidth, theHeight);
  f.setLocation(100, 100);
  f.setResizable(true);
  f.setVisible(true);
  return p;
}

//Comments from original file
  // the ControlFrame class extends PApplet, so we 
  // are creating a new processing applet inside a
  // new frame with a controlP5 object loaded

public class ControlFrame extends PApplet {

  int w, h;
  
  int pressedButton1 = 0;
  int pressedButton2 = 0;
 
  boolean effChaser;
  boolean effChaserOld = false;
  
  XML presets;
  int[] targetDim = new int[13]; // 0 = master
  boolean reachedTarget = true;
  
  int childrenLength = 0;
  public void savePresets() {
    
    saveXML(presets, savePath + "cp5Presets.xml");
  }
  
  //Self explanatory...
  boolean successLoad = false;
  public void loadPresets() {
    //Load raw XML data
      //This will throw an error if there is no file, but it shouldn't interrupt execution.
    XML loadedXML = loadXML(loadPath + "cp5Presets.xml");
    
    //Check if load was succesful
    if(loadedXML != null) {presets = loadedXML; successLoad = true;} else {presets = parseXML("<root></root>"); successLoad = false;}
    
    int offset = 0;
    
    if (successLoad) {offset -= 2;} else {offset = 0;}
    
    //What? Why such an equation? Well, the getChildCount is weird... (Spent 2 hours trying to figure this out)
    if (presets.getChildCount() > 2) {offset += - ((presets.getChildCount() - 1) / 2) + 1;}
    childrenLength = presets.getChildCount() + offset;
    addButtonsForNewPresets();
    
  }
  int preRow;
  int checkedPresets = 0;
  public void addButtonsForNewPresets() {
    //for every unprocessed preset, create a new button
    for (int i = checkedPresets; i < childrenLength; i++) {
      // if the width of checked presets - prerow * width exceeds window width, add a new row
      if (checkedPresets * 25 + 20 + 20 - preRow * (width - 25) > width) {preRow++;}
      cp5.addButton("preset" + str(i + 1))
     .setLabel(str(i + 1))
     .setValue(0)
     .setPosition(10 + checkedPresets * 25 - preRow * (width - 25), aY + aHeight + 45 + preRow * 30)
     .setSize(20, 20)
     .moveTo("default")
     ;
     checkedPresets ++;
    }
  }
  
  //  A Slider params:
        int maxi = 0;
        int aXoffset = 10;
        int aY = 30;
        int aWidth = 14;
        int aHeight = 100;
    //  /params
  
  int createdAnsaZBoxes = 0;
  int createdAnsaXBoxes = 0;
  int createdAnsaYBoxes = 0;
  int createdAnsaTypeBoxes = 0;
  
  ///////////////////////////////////////////////////////////
  public void setup() {
    
    if(!dataLoaded) {
      loadSetupData();
      loadAllData();
    }
    
    //startof: Setup
    //set window size according to parameters
    size(w, h);
    //set window framerate (This will affect Wave and Preset transition times! Change cautiously.)
    frameRate(25);
    //load ControlP5 (The control element library) (It's great, by the way!)
    cp5 = new ControlP5(this);
    
    
    
    //From original file. Kept it here for reference
      // create a slider
      // parameters:
      // name, minValue, maxValue, defaultValue, x, y, width, height
    
    //CREATE UI ELEMENTS
    
    //Tab: Control
    cp5.tab("default").setLabel("Control");
    
    //A Sliders
    
    
    //Create A Sliders
    for (int i = 1; i <= 12; i++) {
    cp5.addSlider("a" + str(i), 0, 255, 0, aXoffset + (i - 1) * (aWidth + 20), aY, aWidth, aHeight)
    .setLabel(str(i))
    .setDecimalPrecision(0)
    .moveTo("default");
    maxi = i;
    }
    
    //Create A Slider Master
    cp5.addSlider("am", 0, 255, 255, aXoffset + maxi * (aWidth + 20), aY, aWidth, aHeight)
    .setLabel("Master")
    .setDecimalPrecision(0)
    .moveTo("default");
     
     //Create A Preset Button
     cp5.addButton("asvPre")
     .setLabel("Save as Preset")
     .setValue(0)
     .setPosition(10, aY + aHeight + 20)
     .setSize(100, 20)
     .moveTo("default")
     ;
     
     //Create A Delete All Presets Button
     cp5.addButton("adelPre")
     .setLabel("Delete ALL presets")
     .setValue(0)
     .setPosition(this.w - 110, this.h - 60)
     .setSize(100, 20)
     .setColorForeground(color(200, 0, 0))
     .setColorActive(color(255, 0, 0))
     .moveTo("default")
     ;
     
     
    
     //Tab: Effects
     cp5.tab("effects").setLabel("Efektit");
     
     //Create chaser toggle
     cp5.addToggle("effChaser")
    .setLabel("Chaser")
    .setPosition(10, 20)
    .setSize(20, 20)
    .moveTo("effects")
    ;
    
    cp5.addTextlabel("waveEffLabel")
    .setText("Wave Effect")
    .setPosition(5, 80)
    .moveTo("effects")
    ;
    
    cp5.addRange("waveRange")
    .setLabel("Wave Range")
    .setPosition(10, 90)
    .setSize(100, 14)
    .setHandleSize(10)
    .setDecimalPrecision(0)
    .setRange(1, 12)
    .setRangeValues(1, 12)
    .moveTo("effects")
    ;
    
    cp5.addButton("waveTrigger")
     .setLabel("Trigger Wave")
     .setValue(0)
     .setPosition(10, 110)
     .setSize(100, 20)
     .moveTo("effects")
     ;
     
     cp5.addNumberbox("waveLengthBox")
    .setLabel("Wave Length")
    .setPosition(180, 90)
    .setSize(30, 14)
    .setDecimalPrecision(0)
    .setRange(1, 100)
    .setValue(3)
    .moveTo("effects")
    ;
    
    cp5.addNumberbox("waveStepBox")
    .setLabel("Wave Step")
    .setPosition(240, 90)
    .setSize(30, 14)
    .setDecimalPrecision(0)
    .setRange(1, 100)
    .setValue(2)
    .moveTo("effects")
    ;
    
    //Tab: Settings
    cp5.tab("settings").setLabel("Asetukset");
    
    //Label for Source Grouping
    cp5.addTextlabel("groupingLabel")
    .setText("Source grouping: ")
    .setPosition(10, 20)
    .moveTo("settings")
    ;
    
    //Create Grouping's numberBoxes
    cp5.addNumberbox("grouping1")
    .setSize(40, 10)
    .setRange(1, 5)
    .setPosition(10, 40)
    .setLabel("ControlP5")
    .moveTo("settings")
    ;
    cp5.addNumberbox("grouping2")
    .setSize(40, 10)
    .setRange(1, 5)
    .setPosition(60, 40)
    .setLabel("enttec DMX")
    .moveTo("settings")
    ;
    cp5.addNumberbox("grouping3")
    .setSize(40, 10)
    .setRange(1, 5)
    .setPosition(110, 40)
    .setLabel("Touch OSC")
    .moveTo("settings")
    ;
    
    //View rotation knob
      //Label for it
    cp5.addTextlabel("viewRotLabel")
    .setText("View Rotation")
    .setPosition(10, 80)
    .moveTo("settings")
    ;
    
    cp5.addKnob("viewRotKnob")
    .setRange(0, 360)
    .setPosition(20, 100)
    .setDecimalPrecision(0)
    .setLabel("")
    .setNumberOfTickMarks(36)
    .setTickMarkLength(4)
    .snapToTickMarks(true)
    .moveTo("settings")
    ;
    
    //Ansa Z nBoxes
    for (int i = 0; i < ansaZ.length; i++) {
      createdAnsaZBoxes ++;
      cp5.addNumberbox("ansaZ" + str(i))
      .setLabel("Ansa " + str(i) + " Z")
      .setPosition(20 + i * 105, 180)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(-10000, 10000)
      .setValue(ansaZ[i])
      .moveTo("settings")
      ;
    }
    
    for (int i = 0; i < ansaX.length; i++) {
      createdAnsaXBoxes ++;
      cp5.addNumberbox("ansaX" + str(i))
      .setLabel("Ansa " + str(i) + " X")
      .setPosition(20 + i * 105, 220)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(-10000, 10000)
      .setValue(ansaX[i])
      .moveTo("settings")
      ;
    }
    
    for (int i = 0; i < ansaY.length; i++) {
      createdAnsaYBoxes ++;
      cp5.addNumberbox("ansaY" + str(i))
      .setLabel("Ansa " + str(i) + " Y")
      .setPosition(20 + i * 105, 260)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(-10000, 10000)
      .setValue(ansaY[i])
      .moveTo("settings")
      ;
    }
    
    for (int i = 0; i < ansaType.length; i++) {
      createdAnsaTypeBoxes ++;
      cp5.addNumberbox("ansaType" + str(i))
      .setLabel("Ansa " + str(i) + " visibility")
      .setPosition(20 + i * 105, 300)
      .setSize(100, 14)
      .setDecimalPrecision(0)
      .setRange(0, 1)
      .setValue(ansaType[i])
      .moveTo("settings")
      ;
    }
    
    
    //Tab: Fixture color (Fixture settings, I should change that)
     cp5.tab("fixtSettings").setLabel("Fixture Settings").setVisible(false);
     
     //RGB Sliders
     cp5.addSlider("colorRed", 0, 255, 255, 10, 20, 14, 100)
    .setLabel("R")
    .moveTo("fixtSettings");
    
    cp5.addSlider("colorGreen", 0, 255, 255, 60, 20, 14, 100)
    .setLabel("G")
    .moveTo("fixtSettings");
    
    cp5.addSlider("colorBlue", 0, 255, 255, 110, 20, 14, 100)
    .setLabel("B")
    .moveTo("fixtSettings");
    
    //Rotation Knob
    cp5.addKnob("fixtRotation")
    .setRange(-90, 90)
    .setPosition(20, 150)
    .setDecimalPrecision(0)
    .setLabel("")
    .setNumberOfTickMarks(36)
    .setTickMarkLength(4)
    .snapToTickMarks(true)
    .moveTo("fixtSettings")
    ;
    //Rotation label
    cp5.addTextlabel("fixtRotationLabel")
    .setText("Rotation Z")
    .setPosition(20, 200)
    .moveTo("fixtSettings")
    ;
    
    //X rotation knob
    cp5.addKnob("fixtRotationX")
    .setRange(0, 360)
    .setPosition(80, 150)
    .setDecimalPrecision(0)
    .setLabel("")
    .setNumberOfTickMarks(36)
    .setTickMarkLength(4)
    .snapToTickMarks(true)
    .moveTo("fixtSettings")
    ;
    //Rotation label
    cp5.addTextlabel("fixtRotationXLabel")
    .setText("Rotation X")
    .setPosition(80, 200)
    .moveTo("fixtSettings")
    ;
    
    //Fixture Z location
    cp5.addNumberbox("fixtZ")
    .setLabel("Z Location")
    .setPosition(20, 300)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(-10000, 10000)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    //Fixture channel
    cp5.addNumberbox("fixtChan")
    .setLabel("Channel")
    .setPosition(150, 300)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(1, 511)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    
   cp5.addButton("fixtIdUp")
    .setLabel("+")
    .setPosition(320, 280)
    .setSize(20, 10)
    .moveTo("fixtSettings")
    ;
    
    cp5.addButton("fixtIdDown")
    .setLabel("-")
    .setPosition(320, 300)
    .setSize(20, 10)
    .moveTo("fixtSettings")
    ;
    
    
    //Fixture Parameter
    cp5.addNumberbox("fixtParam")
    .setLabel("Parameter")
    .setPosition(20, 330)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(-10000, 10000)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    //Fixture Parameter
    cp5.addNumberbox("ansaParent")
    .setLabel("ansaParent")
    .setPosition(20, 430)
    .setSize(100, 14)
    .setDecimalPrecision(0)
    .setRange(0, numberOfAnsas-1)
    .setValue(0)
    .moveTo("fixtSettings")
    ;
    
    
    //Fixture type Dropdown
    lb = cp5.addDropdownList("fixtType")
    .setPosition(180, 40)
    .setSize(200, 200)
    .setItemHeight(15)
    .setBarHeight(20)
    
    .moveTo("fixtSettings")
    ;
    
    lb.captionLabel().style().marginTop = 6;
    lb.captionLabel().style().marginLeft = 3;
    
    //Add dropdown items
    lb.addItem("Par64", 1);
    lb.addItem("Pieni Fresu", 2);
    lb.addItem("Kesk. Fresu", 3);
    lb.addItem("Iso Fresu", 4);
    lb.addItem("Flood", 5);
    lb.addItem("Linssi", 6);
    lb.addItem("Haze", 7);
    lb.addItem("Haze Fan", 8);
    lb.addItem("Strobe", 9);
    lb.addItem("Strobe Freq.", 10);
    lb.addItem("Fog", 11);
    lb.addItem("Pinspot", 12);
    lb.addItem("Moving Head Dim", 13);
    lb.addItem("Moving Head Pan", 14);
    lb.addItem("Moving Head Tilt", 15);
    
    
    //Create and define the tooltip
    cp5.getTooltip().setDelay(500);
    cp5.getTooltip().register("asvPre","Saves a new preset. ");
    //cp5.getTooltip().register("s2","Changes the Background");
    
    //Check the loadPresets void
    loadPresets();
    
    //endof: Setup
     

  }
  DropdownList lb;
  
  //////////////////////////////////////////////////////////////////////////////
  
  //The controlEvent void triggers also when the elements are created, so we have to make sure it doesn't execute the trigger at the first catch of a specific element. (asvPre and adelPre should not be fired at program launch)
  boolean deleteAll = false;
  boolean createNew = false;
  boolean Trigwave = false;
  
  public void controlEvent(ControlEvent theEvent) {
    //DropDownlists don't like .getName(), so we'll check that there is no error
    boolean error = false;
    try {
      theEvent.getController().getName();
    } catch(Exception e) {error = true;}
    
    //startof: Event catcher
    if(error != true) {
    //println(theEvent.getController().getName());
    if(theEvent.getController().getName() == "waveTrigger") {
      if (Trigwave == true) {
        // Old method
       //waveLocation[int(cp5.controller("waveRange").getArrayValue()[0]) - 1] = true;
       
       wave = true;
      }
      Trigwave = true;
    }
    //Create preset button pressed?
    if(theEvent.getController().getName() == "asvPre") {
      if (createNew == true) {
       aCreatePreset();
      }
      createNew = true;
    }
    //Delete all presets button pressed?
    if(theEvent.getController().getName() == "adelPre") {
      if (deleteAll == true) {
       aDeleteAllPresets();
      }
      deleteAll = true;
    }
    
    
    
    if(theEvent.getController().getName() == "fixtIdUp"){
      change_fixture_id(changeColorFixtureId);
      cp5.controller("fixtIdLabel").setStringValue(str(fixtureIdPlaceInArray[changeColorFixtureId]));
    }
    if(theEvent.getController().getName() == "fixtIdDown"){
      change_fixture_id_down(changeColorFixtureId);
      cp5.controller("fixtIdLabel").setStringValue(str(fixtureIdPlaceInArray[changeColorFixtureId]));
    }
    
    
    
    //Preset button pressed?
    if(theEvent.getController().getName().startsWith("preset")) {
      //Get preset id from controller name
      int presetId = PApplet.parseInt(theEvent.getController().getName().replace("preset", ""));
      //Load preset with parset id
      loadPreset(presetId);
    }
    
    
    
    
    //Update waveLength
    if(theEvent.getController().getName().startsWith("waveLengthBox")){
      waveLength = PApplet.parseInt(cp5.controller("waveLengthBox").getValue());
      waveData = new int[12 + waveLength];
      waveLocation = new boolean[12 + waveLength];
    }
    //Update waveStep
    if(theEvent.getController().getName().startsWith("waveStepBox")){
      waveStep = PApplet.parseInt(cp5.controller("waveStepBox").getValue());
    }
    }
    //endof: Event catcher
  }
   
   ///////////////////////////////////////////////////////////////////////////////////////////////
   
  //Load preset; params: id = Preset id
  public void loadPreset(int id) {
    
    //Set target values for main sliders
    for (int i = 1; i <= 12; i++) {
      targetDim[i] = PApplet.parseInt(presets.getChild("preset" + str(id)).getChild("chan" + str(i)).getContent());
    }
    //Reminder: 0 = master!; Set target value for master sliders
    targetDim[0] = PApplet.parseInt(presets.getChild("preset" + str(id)).getChild("master").getContent());
    
    //initialize toTarget (transition)
    reachedTarget = false;
    started = false;
    targetStep = 0;
  }
  
  
  
  //Note to self: This void gets triggered 25 times a second. (Unless computer can't keep up with 25 FPS) The animation will happen in 10 frames
  int targetStep = 0;
  int transitionSteps = 20;
  int[] targetFrom = new int[13];
  boolean started = false;
  public void toTarget() {
    //Check if we have a pending transition
    if (reachedTarget == false) {
      if (started == false) {
        //first step of animation -- saves original values for use later
        for (int i = 1; i <= 12; i++) {targetFrom[i] = PApplet.parseInt(cp5.controller("a" + str(i)).getValue());}
        targetFrom[0] = PApplet.parseInt(cp5.controller("am").getValue());
        started = true;
        
      }
      
      //Set sliders according to transition step
      //Set slider values to target at last step, because the transition might leave behind a slightly modified value of the original (Division inaccuracy)
      if(targetStep >= transitionSteps) {
        for (int i = 1; i <= 12; i++) {
          cp5.controller("a" + str(i)).setValue(targetDim[i]);
        }
        cp5.controller("am").setValue(targetDim[0]);
      } else {
        for (int i = 1; i <= 12; i++) {
          cp5.controller("a" + str(i)).setValue(targetFrom[i] + (targetDim[i] - targetFrom[i]) * 100 / transitionSteps * targetStep / 100);
        }
        cp5.controller("am").setValue(targetFrom[0] + (targetDim[0] - targetFrom[0]) * 100 / transitionSteps * targetStep / 100);
      }
      targetStep ++;
      if (targetStep >= transitionSteps + 1) {
        //Transition has finished
        reachedTarget = true;
      }
    }
    
  }
  
  public void aDeleteAllPresets() {
    //Delete the file
    File f = new File(savePath + "cp5Presets.xml");
    f.delete();
    //Remove the buttons
    
    for (int i = checkedPresets; i > 0; i--) {
      
      cp5.controller("preset" + str(i)).remove();
      
    }
    //Reset the count values
    childrenLength = 0;
    checkedPresets = 0;
    preRow = 0;
    //Reset the presets XML in memory
    presets = parseXML("<root></root>");
  }
  
  
  public void aCreatePreset() {
    //Here I went with a parseXML, because it was the simplest.
    
    childrenLength ++;
    //Start preset node
    String newVals = "<preset"+ str(childrenLength) +">";
    
    //Write channel nodes
    for (int i = 1; i <= 12; i++) {
      newVals = newVals + "<chan" + str(i) + ">" + str(PApplet.parseInt(cp5.controller("a" + str(i)).getValue())) + "</chan" + str(i) + ">";
    }
    //Write master node
    newVals = newVals + "<master>" + str(PApplet.parseInt(cp5.controller("am").getValue())) + "</master>";
    //Close preset node
    newVals = newVals + "</preset" + str(childrenLength) + ">";
    
    //add the structure to the presets XML variable
    presets.addChild(parseXML(newVals));
    
    //Save XML file & add a button for the new preset
    savePresets();
    addButtonsForNewPresets();
    
    //lowpriorityTODO: Add automatic reload if file changed
  }
  
  
  ////////////////////////////////////////////////////////////////////////////////////////
  
  int waveStep = 2;
  int waveCurrentStep = 1;
  int waveLength = 3;
  int[] waveData = new int[12 + waveLength];
  boolean[] waveLocation = new boolean[12 + waveLength];
  
  public void calculateWave() {
    //Take old wave data from slider values (So that this doesn't put the sliders to zero when there are no waves going on)
    for (int i = 0; i < 12; i++) {
      cp5.controller("a" + str(i + 1)).setValue(cp5.controller("a" + str(i + 1)).getValue() - waveData[i]);
    }
    
    waveData = new int[12 + waveLength];
    for (int i = 0; i < 12 + waveLength; i++) {
      if (waveLocation[i] == true) {
        //Wave peak
        if (i >= cp5.controller("waveRange").getArrayValue()[0] - 1 && i <= cp5.controller("waveRange").getArrayValue()[1] - 1) {
          waveData[i] = 255;
        }
        
        //Left & Right sides of wave peak
        for (int w = 1; w <= waveLength; w++) {
          int val = 255 - 255 / waveLength * w;
          
          if (i - w <= cp5.controller("waveRange").getArrayValue()[1] - 1 && i - w >= cp5.controller("waveRange").getArrayValue()[0] - 1 && waveData[i - w] < val) {
            waveData[i - w] = val;
          }
          
          if (i + w <= cp5.controller("waveRange").getArrayValue()[1] - 1 && i + w >= cp5.controller("waveRange").getArrayValue()[0] - 1 && waveData[i + w] < val) {
            waveData[i + w] = val;
          }
        }
      }
    }
    
    //Add wave data to slider values
    for (int i = 0; i < 12; i++) {
      cp5.controller("a" + str(i + 1)).setValue(cp5.controller("a" + str(i + 1)).getValue() + waveData[i]);
    }
    
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
  
  //////////////////////////////////////////////////////////////////////////
  
  //Just so that it wont start changing values unless the color change has been triggered atleast once.
  boolean fixtureColorChangeHasHappened = false;
  
  public void draw() {
    
    //startof: Draw
    
      if (typingPreset) {
        presetTypingCurrent ++;
        if(presetTypingCurrent >= presetTypingDelay * frameRate) {
          //Exit typing, as too much time has passed
          typedPreset = "";
          typingPreset = false;
          presetTypingCurrent = 0;
        }
      }
    
      //Make a step towards the target
      toTarget();
      //If wave trigger is true, generate a wave at first allowed position (minimum value of the waveRange range control), set wave trigger to false
      if(wave) {wave = false; waveLocation[PApplet.parseInt(cp5.controller("waveRange").getArrayValue()[0]) - 1] = true;}
      calculateWave();
      //Check for fixture color change initiation
      if (toChangeFixtureColor){
        fixtureColorChangeHasHappened = true;
        cp5.controller("colorRed").setValue(red[changeColorFixtureId]);
        cp5.controller("colorGreen").setValue(green[changeColorFixtureId]);
        cp5.controller("colorBlue").setValue(blue[changeColorFixtureId]);
        cp5.controller("fixtRotation").setValue(rotTaka[changeColorFixtureId]);
        cp5.controller("fixtRotationX").setValue(rotX[changeColorFixtureId]);
        cp5.controller("fixtZ").setValue(fixZ[changeColorFixtureId]);
        cp5.controller("fixtChan").setValue(channel[changeColorFixtureId]);
        cp5.controller("fixtParam").setValue(fixParam[changeColorFixtureId]);
        cp5.controller("ansaParent").setValue(ansaParent[changeColorFixtureId]);
        lb.setIndex(fixtureType1[changeColorFixtureId] - 1);
        //Make the color tab visible and activate it
        cp5.tab("fixtSettings").setVisible(true).setLabel("Fixture ID: " + str(changeColorFixtureId + 1));
        cp5.window(this).activateTab("fixtSettings");
        
        toChangeFixtureColor = false;
      }
      
      //Make the color tab invisible again when the user goes out of it
      if(cp5.tab("fixtSettings").isActive() == false) {cp5.tab("fixtSettings").setVisible(false);}
      
      //Set RGB values for selected fixture
      if (fixtureColorChangeHasHappened && cp5.tab("fixtSettings").isActive()) {
        red[changeColorFixtureId] = PApplet.parseInt(cp5.controller("colorRed").getValue());
        green[changeColorFixtureId] = PApplet.parseInt(cp5.controller("colorGreen").getValue());
        blue[changeColorFixtureId] = PApplet.parseInt(cp5.controller("colorBlue").getValue());
        rotTaka[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtRotation").getValue());
        rotX[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtRotationX").getValue());
        fixZ[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtZ").getValue());
        channel[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtChan").getValue());
        fixParam[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtParam").getValue());
        ansaParent[changeColorFixtureId] = PApplet.parseInt(cp5.controller("ansaParent").getValue());
        fixtureType1[changeColorFixtureId] = PApplet.parseInt(lb.getValue());
      }
      
      //Set ansa Z values according to NBoxes
      if(dataLoaded == true) {
        for (int i = 0; i < createdAnsaZBoxes; i++) {
          ansaZ[i] = PApplet.parseInt(cp5.controller("ansaZ" + str(i)).getValue());
        }
        for (int i = 0; i < createdAnsaXBoxes; i++) {
          ansaX[i] = PApplet.parseInt(cp5.controller("ansaX" + str(i)).getValue());
        }
        for (int i = 0; i < createdAnsaYBoxes; i++) {
          ansaY[i] = PApplet.parseInt(cp5.controller("ansaY" + str(i)).getValue());
        }
        for (int i = 0; i < createdAnsaTypeBoxes; i++) {
          ansaType[i] = PApplet.parseInt(cp5.controller("ansaType" + str(i)).getValue());
        }
      }
      
      
      //Update view rotation according to knob
      pageRotation = PApplet.parseInt(cp5.controller("viewRotKnob").getValue());
      
      
      //ACTUAL DRAWING HAPPENS HERE!!!
      //Redraw backround
      background(100, 100, 100);
      
      //update effect variables
      if (effChaserOld != effChaser) {chase = effChaser; effChaserOld = effChaser;} else {}
      
      
      
      //set place variables
      controlP5place = PApplet.parseInt(cp5.controller("grouping1").getValue());
      enttecDMXplace = PApplet.parseInt(cp5.controller("grouping2").getValue());
      touchOSCplace = PApplet.parseInt(cp5.controller("grouping3").getValue());
      
      //set light dimming from (A Sliders / 255 * A Master)
      for (int i = 1; i <= 12; i++) {
        controlP5channel[i] = PApplet.parseInt(cp5.controller("a" + str(i)).getValue() * (cp5.controller("am").getValue() / 255));
      }
 

  }
  
  ///////////////////////////////////////////////////////////////////////////////////
  
  String typedPreset = "";
  boolean typingPreset = false;
  //How long before typing is cleared out (in s)
  int presetTypingDelay = 10;
  int presetTypingCurrent = 0;
  public void keyPressed() {
    //If key is Enter (or return for macosx)
    if (keyCode == ENTER || keyCode == RETURN){
      if(typingPreset) {
        //If typed preset is not out of bounds
        if (PApplet.parseInt(typedPreset) <= checkedPresets && PApplet.parseInt(typedPreset) != 0) {loadPreset(PApplet.parseInt(typedPreset));}
        //Reset typing
        typedPreset = "";
        typingPreset = false;
        presetTypingCurrent = 0;
      }
      
    //C for cancel; Cancel typing
    } else if(key == 'c'){
      //Escape typing
      typedPreset = "";
      typingPreset = false;
      presetTypingCurrent = 0;
    } else {
      //See if key can be converted to an int
      boolean error = false;
      try {if(PApplet.parseInt(key) == 0) {error = true;}} catch(Exception e) {error = true;}
      //If there is no error, start preset activation sequence
      if (!error) {
        typingPreset = true;
        typedPreset = typedPreset + key;
        
      }
    }
    
    
    
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////
  //Frame info -- Not important
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = 500;
    h = 500;
  }
 

  public ControlP5 control() {
    return cp5;
  }
  
  
  ControlP5 cp5;

  Object parent;

  
}

//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 piirret\u00e4\u00e4n 3D-mallinnus
/*
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */

boolean rotateZopposite = true;

boolean use3D = false;

int userOneFrameRate = 30;
int userTwoFrameRate = 30;

int centerX;
int centerY;

String assetPath;
int[] rotX = { 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135 };
int[] fixZ = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

//0 = None, 1 = ansa 0, 2 = ansa 1
int[] ansaParent = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
int numberOfAnsas = 6;
int[] ansaZ = new int[numberOfAnsas];
int[] ansaX = new int[numberOfAnsas];
int[] ansaY = new int[numberOfAnsas];
int[] ansaType = new int[numberOfAnsas];


int[] fixParam = { 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45, 45 };

float camX = s1.width/2.0f, camY = s1.height/2.0f + 4000, camZ = 1000;
public class PFrame extends JFrame {
  public PFrame() {

    setBounds(0, 0, 600, 340);
    s = new secondApplet();
    add(s);
    s.init();
    
    show();
  }
}

//Begin 3D visualizer window class
public class secondApplet1 extends PApplet {
  

PShape par64Model;
PShape par64Holder;
PShape kFresu;
PShape iFresu;
PShape linssi;
PShape flood;
PShape floodCover;
PShape strobo;
PShape base;
PShape cone;

float par64ConeDiameter = 0.4f;
float pFresuConeDiameter = 0.7f;
float kFresuConeDiameter = 0.8f;
float iFresuConeDiameter = 0.8f;
float linssiConeDiameter = 0.8f;
float floodConeDiameter = 0.8f;
float stroboConeDiameter = 0.8f;

int lavaX = 460, lavaY = 250, lavaSizX = 1000, lavaSizY = 500, lavaH = 100;
boolean lava = false;


boolean[] stroboOn;

public void setup() {
  stroboOn = new boolean[ansaTaka];
  
  if(userId == 1) { //Jos Elias k\u00e4ytt\u00e4\u00e4
    assetPath = "/Users/elias/Dropbox/DMX controller/Roopen Kopiot/";
  }
  else { //Jos Roope k\u00e4ytt\u00e4\u00e4
    if(getPaths == true) {
      String lines100[] = loadStrings("C:\\DMXcontrolsettings\\assetPath.txt");
      assetPath = lines100[0];
    }
  }
  
  
  size(700, 500, P3D);
  
  
  //Asetetaan oikeat polut k\u00e4ytt\u00e4j\u00e4n mukaan
  
  String path = "";
  if(userId == 1) { //Jos Elias k\u00e4ytt\u00e4\u00e4
    path = assetPath + "Tallenteet/3D models/";
  }
  else { //Jos Roope k\u00e4ytt\u00e4\u00e4
    path = assetPath + "3D models\\";
  }
  
  par64Model = loadShape(path + "par64.obj");
  par64Holder = loadShape(path + "par64_holder.obj");
  kFresu = loadShape(path + "kFresu.obj");
  iFresu = loadShape(path + "iFresu.obj");
  linssi = loadShape(path + "linssi.obj");
  flood = loadShape(path + "flood.obj");
  floodCover = loadShape(path + "floodCover.obj");
  strobo = loadShape(path + "strobo.obj");
  base = loadShape(path + "base.obj");
  cone = loadShape(path + "cone.obj");
  
  cone.disableStyle();
  base.disableStyle();
  
  if(userId == 1) {frameRate(1);} else {frameRate(userTwoFrameRate);} 
  //frameRate(15);
  
  noLoop();
  if (frame != null) {
    frame.setResizable(false);
  }
  
}

int[] valoY = {100 + 70, 100 +140, 100 + 210, 100 + 280, 100 + 350, 100 + 420};
int valoScale = 20;



public void draw() {
  
  if(use3D == true) {
 
              background(0);
              lights();
              
              //Camera
              camera(camX, camY, camZ, width/2.0f+centerX, height/2.0f + 1500+centerY, -1000, 0, 0, -1);
              
              
              
              //Draw floor
              pushMatrix();
                translate(width/2, height/2+4000, -1000);
                noStroke();
                rotateX(radians(90));
                fill(50);
                scale(400, 400, 400);
                shape(base);
              popMatrix();
              
              
              //Draw ansas
              int[] ij = { ansaY.length, ansaX.length, ansaZ.length };
              for(int i = 0; i < min(ij); i++) {
                if(ansaType[i] == 1) {
                  pushMatrix();
                  translate(0, ansaY[i] * 5, ansaZ[i] + 82);
                  box(10000, 10, 10);
                  popMatrix();
                }
              }
              
              //Draw stage (lava)
              if(lava) {
                pushMatrix();
                translate(lavaX * 5 - 1000, lavaY * 5, -990 + lavaH);
                fill(70);
                box(lavaSizX * 5, lavaSizY * 5, lavaH * 2);
                popMatrix();
              }
              
              
              //Draw lights
              for (int i = 0; i < ansaTaka; i++) {
                //If light is of type par64 OR moving head dim
                if(fixtureType1[i] == 1 || fixtureType1[i] == 13){
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, par64ConeDiameter, red[i], green[i], blue[i], dim[channel[i]], -60, ansaParent[i], par64Model);
                } else 
                //If light is of type p. fresu ("small" F.A.L. fresnel)
                if(fixtureType1[i] == 2) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i] + 40, rotTaka[i], rotX[i], PApplet.parseInt(valoScale * 0.6f), pFresuConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], iFresu);
                } else 
                //If light is of type k. fresu (F.A.L. fresnel)
                if(fixtureType1[i] == 3) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, kFresuConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], kFresu);
                } else 
                //If light is of type i. fresu ("big" F.A.L. fresnel)
                if(fixtureType1[i] == 4) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, iFresuConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], iFresu);
                } else
                //If light is of type flood
                if(fixtureType1[i] == 5) {
                  drawFlood(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, floodConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], flood, fixParam[i]);
                } else
                //If light is of type linssi (linssi = lens)
                if(fixtureType1[i] == 6) {
                  drawLight(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], valoScale, linssiConeDiameter * map(fixParam[i], 45, -42, 2, 1), red[i], green[i], blue[i], dim[channel[i]], 120, ansaParent[i], linssi);
                } else
                //If light is of type strobo brightness
                if(fixtureType1[i] == 9) {
                  boolean stroboOnTemp = !stroboOn[i];
                  drawStrobo(xTaka[i], yTaka[i], fixZ[i], rotTaka[i], rotX[i], PApplet.parseInt(valoScale * 1.2f), stroboConeDiameter, red[i], green[i], blue[i], dim[channel[i]], 0, ansaParent[i], strobo, stroboOnTemp);
                  stroboOn[i] = stroboOnTemp;
                }
              }
              
              
              
              
}
}



public void drawLight(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, int coneR, int coneG, int coneB, int conedim, int coneZOffset, int parentAnsa, PShape lightModel) {
      //If light is parented to an ansa, offset Z height by ansas height
      if (parentAnsa != 0) {
        posZ += ansaZ[parentAnsa];
        posX += ansaX[parentAnsa];
        posY += ansaY[parentAnsa];
      }
      //Draw p64 holder
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(90));
      noStroke();
      scale(scale);
      shape(par64Holder);
      popMatrix();
      
      //Draw light itself
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      noStroke();
      scale(scale);
      shape(lightModel);
      popMatrix();
      
      //Draw light cone
      if(conedim > 0) {
        pushMatrix();
        translate(posX * 5 - 1000, posY * 5, posZ);
        rotateZ(radians(rotZ));
        rotateX(radians(rotX));
        //Cone offset
        translate(0, 0, coneZOffset);
        scale(scale * 100 * coneDiam, scale * 100  * coneDiam, scale * 100);
        //fill(255, 0, 0, 128);
        fill(coneR, coneG, coneB, conedim / 2);
        shape(cone);
        popMatrix();
      }
}


public void drawFlood(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, int coneR, int coneG, int coneB, int conedim, int coneZOffset, int parentAnsa, PShape lightModel, int LightParam) {
      //If light is parented to an ansa, offset Z height by ansas height
      if (parentAnsa != 0) {
        posZ += ansaZ[parentAnsa];
        posX += ansaX[parentAnsa];
        posY += ansaY[parentAnsa];
      }
      posY -= 20;
      //Draw p64 holder
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(90));
      noStroke();
      scale(scale);
      shape(par64Holder);
      popMatrix();
      
      //Draw light itself
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      noStroke();
      scale(scale);
      shape(lightModel);
      popMatrix();
      
      //Draw light "flaps"
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      translate(0, 12, 18);
      rotateX(radians(-LightParam));
      scale(scale);
      shape(floodCover);
      popMatrix();
      
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      translate(0, -30, 18);
      rotateX(radians(LightParam));
      scale(scale, scale * -1, scale);
      shape(floodCover);
      popMatrix();
      
      //Draw light cone
      if(conedim > 0) {
        pushMatrix();
        translate(posX * 5 - 1000, posY * 5, posZ);
        rotateZ(radians(rotZ));
        rotateX(radians(rotX));
        //Cone offset
        translate(0, 0, coneZOffset);
        scale(scale * 100 * coneDiam * 2, scale * 100  * coneDiam * map(LightParam, 45, -42, 1, 0), scale * 100);
        //fill(255, 0, 0, 128);
        fill(coneR, coneG, coneB, conedim / 2);
        shape(cone);
        popMatrix();
      }
}

public void drawStrobo(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, int coneR, int coneG, int coneB, int conedim, int coneZOffset, int parentAnsa, PShape lightModel, boolean stroboIsOn) {
      //If light is parented to an ansa, offset Z height by ansas height
      if (parentAnsa != 0) {
        posZ += ansaZ[parentAnsa];
        posX += ansaX[parentAnsa];
        posY += ansaY[parentAnsa];
      }
      
      //Draw light itself
      pushMatrix();
      translate(posX * 5 - 1000, posY * 5, posZ);
      rotateZ(radians(rotZ));
      rotateX(radians(rotX));
      noStroke();
      scale(scale);
      shape(lightModel);
      popMatrix();
 
      
      //Draw light cone
      if(conedim > 0 && stroboIsOn) {
        pushMatrix();
        translate(posX * 5 - 1000, posY * 5, posZ);
        rotateZ(radians(rotZ));
        rotateX(radians(rotX));
        //Cone offset
        translate(0, 0, coneZOffset);
        scale(scale * 100 * coneDiam * 2, scale * 100  * coneDiam, scale * 100);
        //fill(255, 0, 0, 128);
        fill(coneR, coneG, coneB, conedim / 2);
        shape(cone);
        popMatrix();
      }
}




 

public void mouseDragged()
{
    if(mouseButton == RIGHT) {
      centerX += (mouseX - pmouseX) * 5;
      centerY += (mouseY - pmouseY) * 10;
      
      translate(width/2.0f+centerX, height/2.0f + 1500+centerY, 0); 
      fill(255, 255, 0);
      box(50);
      translate((width/2.0f+centerX)*(-1), (height/2.0f + 1500+centerY)*(-1), 0); 
    }
    
    else {
      camX += (mouseX - pmouseX) * 5;
      camY += (mouseY - pmouseY) * 10;
    }
}
 
public void mousePressed() {
  if(use3D) {
    loop();
    frameRate(60);
  }
}
 
public void keyPressed()
{
  if (keyCode == UP) { camZ += 100; } 
  else if (keyCode == DOWN) { camZ -= 100; }
}



//End 3D visualizer window class
}

public class PFrame1 extends JFrame {
  public PFrame1() {
          setBounds(0, 0, 600, 340);
          setResizable(true);
          s1 = new secondApplet1();
          add(s1);
          s1.init();
          show();
  }
}

//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 tulostetaan mustalle taustalle valkoisin tekstein dim-arvot, sek\u00e4 muutamien muiden muuuttujien arvoja

boolean showOutputAsNumbers;

public class secondApplet extends PApplet {

  public void setup() {
    size(600, 900);
  }
  public void draw() {
    if(showOutputAsNumbers == true) {
    background(0, 0, 0);
    fill(255, 255, 255);
    text("DMX", 5, 10);
    for(int i = 0; i < channels; i++) {
      fill(255, 255, 255);
      text(i + ":" + dim[i], 10, i*15+25);
  }
    text("allChannels[1]", 105, 10);
    for(int i = 0; i < channels; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[1][i], 110, i*15+25);
  }
    text("allChannels[2]", 205, 10);
    for(int i = 0; i < channels; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[2][i], 210, i*15+25);
  }
    text("allChannels[3]", 305, 10);
    for(int i = 0; i < channels; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[3][i], 310, i*15+25);
  }
  text("allChannels[4]", 405, 10);
    for(int i = 0; i < channels; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[4][i], 410, i*15+25);
  }
  text("allChannels[5]", 505, 10);
    for(int i = 0; i < channels; i++) {
      fill(255, 255, 255);
      text(i + ":" + allChannels[5][i], 510, i*15+25);
  }
  text("memory", 605, 10);
  int a = 0;
    for(int i = 0; i < numberOfMemories; i++) {
      if(memoryValue[i] != 0) {
      a++;
      fill(255, 255, 255);
      text(i + ":" + memoryValue[i], 610, a*15+25);
      }
      else if(valueOfMemory[i] != 0) {
      a++;
      fill(255, 255, 255);
      text(i + ":" + valueOfMemory[i], 610, a*15+25);
      }
  }
  }
  }
  /*
   * TODO: something like on Close set f to null, this is important if you need to 
   * open more secondapplet when click on button, and none secondapplet is open.
   */
}


//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 py\u00f6ritet\u00e4\u00e4n automaattisia, manuaalisia ja musiikin tahdissa py\u00f6rivi\u00e4 chaseja
/* IDEA JOLLA T\u00c4M\u00c4N SAA TOIMIMAAN:
ENSIN LASKETAAN AKTIIVISET MEMORYT JA SEN J\u00c4LKEEN JOKA ISKULLA FOR LOOPPI
*/


public void detectBeat() {
      beat.detect(in.mix); //beat detect command of minim library
      if (beat.isKick()) { biitti = true; } //if beat is detected set biitti to true
      else { biitti = false; } //if not set biitti to false
}

public void beatDetectionDMX(int memoryNumber, int value) { //chase/soundtolight funktion aloitus
    detectBeat();
    if(chaseModeByMemoryNumber[memoryNumber] >= 0 && chaseModeByMemoryNumber[memoryNumber] <= 6) { //tarkistetaan chasemode (1 = beat detect, 2 = eq, 3 = manual chase, 4 = autochase, 5 = beat detect wave
     for(int i = 1; i < numberOfMemories; i++) { //K\u00e4yd\u00e4\u00e4n l\u00e4pi kaikki memoryt
       value = memoryValue[i]; //arvo on t\u00e4ll\u00e4 hetkell\u00e4 k\u00e4sitelt\u00e4v\u00e4n memoryn arvo
    if(chaseModeByMemoryNumber[i] == 1 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 1)) {

      if(biitti == true || (chaseStepChanging[i] == true && chaseFade > 0)) { //Tarkistetaan tuleeko biitti tai onko fade menossa
        if(memoryValue[i] > 0) { //Tarkistetaan onko memory p\u00e4\u00e4ll\u00e4
        if(chaseStepChanging[i] == false) { //Tarkisetaan eik\u00f6 fade ole viel\u00e4 alkanut
          chaseStepChanging[i] = true; //Kirjoitetaan muistiin, ett\u00e4 fade on menossa
        }
        if(chaseFade > 0) { //Jos crossFade on yli nolla
          stepChange(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
        }
        else {
          stepChange(i, value, false, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
        }
        }
      }
      else {
        stepChange(i, value, true, false); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
      }
    }
    
    
    else if(chaseModeByMemoryNumber[i] == 2 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 2)) {
      freqSoundToLight(i, value);
    }
    
    
    else if(chaseModeByMemoryNumber[i] == 3 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 3)) {
      if((keyPressed == true && key == ' ' && keyReleased == true) || (chaseStepChanging[i] == true && chaseFade > 0) || nextStepPressed == true) {
        
        
        chaseStepChangingRev[i] = false;
        if(memoryValue[i] > 0) { //Tarkistetaan onko memory p\u00e4\u00e4ll\u00e4
        if(chaseStepChanging[i] == false) { //Tarkisetaan eik\u00f6 fade ole viel\u00e4 alkanut
          chaseStepChanging[i] = true; //Kirjoitetaan muistiin, ett\u00e4 fade on menossa
        }
        if(chaseFade > 0) { //Jos crossFade on yli nolla
          stepChange(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
        }
        else {
          stepChange(i, value, false, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
        }
        }
        lastStepDirection = 1;
      }
      else if(lastStepDirection == 1) {
        stepChange(i, value, true, false); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
      }
      if(revStepPressed == true || (chaseStepChangingRev[i] == true && chaseFade > 0)) {
        chaseStepChanging[i] = false;
       
        
        if(memoryValue[i] > 0) { //Tarkistetaan onko memory p\u00e4\u00e4ll\u00e4
        if(chaseStepChangingRev[i] == false) { //Tarkisetaan eik\u00f6 fade ole viel\u00e4 alkanut
          chaseStepChangingRev[i] = true; //Kirjoitetaan muistiin, ett\u00e4 fade on menossa
        }
        if(chaseFade > 0) { //Jos crossFade on yli nolla
          stepChangeRev(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
        }
        else {
          stepChangeRev(i, value, false, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
        }
        }
         lastStepDirection = 2;
      }
      else if(lastStepDirection == 2) {
          stepChangeRev(i, value, true, false); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
        }
    }
    
    
    else if(chaseModeByMemoryNumber[i] == 4 || (chaseModeByMemoryNumber[i] == 0 && chaseMode == 4)) {
      millisNow[5] = millis();
     // if(millisNow[5] - millisOld[5] > chaseSpeed || chaseMoving == true) {
        stepChange(i, value, true, true); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
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
      if(biitti == true) { //Jos tulee biitti presetti laitetaan p\u00e4\u00e4lle
            preset(soundToLightPresets[i][1], valueOfMemory[i]);
            preset(soundToLightPresets[i][2], valueOfMemory[i]);
      }
      else { //Jos ei ole biitti\u00e4 presetti sammutetaan
            preset(soundToLightPresets[i][1], 0);
            preset(soundToLightPresets[i][2], 0);
        }
    }
  }
}
}

public void stepChange(int memoryNumber, int value, boolean useFade, boolean changeSteppiii) {

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
  }
}



public void stepChangeRev(int memoryNumber, int value, boolean useFade, boolean changeStep) {

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
    }
    preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], round(map(chaseBright2[memoryNumber], 0, 255, 0, value)));
    preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], round(map(255 - chaseBright2[memoryNumber], 0, 255, 0, value)));
  }
}




public void freqSoundToLight(int memoryNumber, int value) {
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
 
public void stop() {
  //stop minim audio
  in.close();
  minim.stop();
  super.stop();
} 
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 piirret\u00e4\u00e4n alavalikko, jossa n\u00e4kyy mm. fixtuurien nykyiset arvot
//Alavalikko toimii nyt hyvin ja fixture(i) voidia voi k\u00e4ytt\u00e4\u00e4 miss\u00e4 vain ohjelmassa
/*Jostain syyst\u00e4 id:n vaihtamisen kanssa on v\u00e4lill\u00e4 pieni\u00e4 ongelmia
se pit\u00e4isi selvitt\u00e4\u00e4*/

//Create variables for old mouse locations
int oldMouseX2;
int oldMouseY2;

public void alavalikko() {
  pushMatrix(); 
    translate(0, height-100); //alavalikko is located to bottom of the window
    //Upper row
    pushMatrix();
      for(int i = 0; i <= channels/2; i++) {
        translate(65, 0); //moves box to its place
        createFixtureBox(i); //Create fixture boxes including buttons and their functions
      }
    popMatrix();
    //Lower row
    pushMatrix();
      translate(0, 65); 
      for(int i = channels/2; i <= channels; i++) {
        translate(65, 0); //moves box to its place
        createFixtureBox(i); //Create fixture boxes including buttons and their functions
      }
    popMatrix(); 
  popMatrix();
}
public void createFixtureBox(int id) {
  drawFixtureRectangles(id); //draw fixtureboxes with buttons etc.
  checkFixtureBoxGo(id); //Check if you pressed go button button to set fixture on until jo release mouse
  checkFixtureBoxToggle(id); //Check if you pressed toggle button to set fixture on and off
  checkFixtureBoxSlider(id); //Check if you moved slider to change channels dimInput value
  checkFixtureBoxRightClick(id); //Check if you clicked right button at title to edit fixture settings
}

public void drawFixtureRectangles(int id) {
  String fixtuuriTyyppi = getFixtureName(fixtureIdNow[id]);
  
  fill(255, 255, 255); //White color for fixtureBox
  stroke(255, 255, 0); //Yellow corners for fixtureBox
  rect(0, 0, 60, -51); //The whole fixtureBox
  stroke(0, 0, 0); //black corners for other rects
  fill(0, 255, 0); //green color for title box
  rect(0, -40, 60, -15); //title box
  fill(0, 0, 0); //black color for title
  text(str(channel[fixtureIdNow[id]])+":" +fixtuuriTyyppi, 2, -44); //Title (fixture id and type texts)
  fill(0, 0, 255); //blue color for slider
  rect(0, 0, 10, (map(dimInput[channel[fixtureIdNow[id]]], 0, 255, 0, 30))*(-1)); //Draw slider
  fill(255, 255, 255); //white color for Go button
  rect(10, 0, 49, -15); //Draw Go button
  fill(0, 0, 0); //black color for Go text
  text("Go", 12, -3); //go text
  fill(255, 255, 255); //white color for toggle button
  rect(10, -15, 49, -15); //Draw Toggle button
  fill(0, 0, 0); //black color fot toggle text
  text("Toggle", 12, -18); //toggle text
  fill(255, 255, 255); //white color at end
}

public void checkFixtureBoxGo(int id) { //This void checks Go button
  if(isHover(10, 0, 49, -15)) { //Check if mouse is on go box
    if(mouseClicked) { //Check if mouse is clicked
      dimInput[channel[fixtureIdNow[id]]] = 255; //Set dimInput value to max
    }
    if(mouseReleased) { //Check if mouse is released
      mouseReleased = false; //Set mouseReleased to false 
      dimInput[channel[fixtureIdNow[id]]] = 0; //Set dimInput value to min
    }
  }
}
public void checkFixtureBoxToggle(int id) { //This void checks Toggle button
  if(isHover(10, -15, 49, -15) && mouseClicked && mouseReleased) { //Check if mouse is on toggle box and clicked and released before it
    mouseReleased = false; //Mouse isn't released anymore
    if(dimInput[channel[fixtureIdNow[id]]] == 255) { //Check if dimInput is 255
      dimInput[channel[fixtureIdNow[id]]] = 0; //If dimInput is at 255 then set it to zero
    }
    else {
      dimInput[channel[fixtureIdNow[id]]] = 255; //If dimInput is not at max value then set it to max
    }
  }
}
public void checkFixtureBoxSlider(int id) {
   if(isHover(0, 0, 10, -30) && mouseClicked) { //Check if mouse is on the slider rect
    if(mouseReleased) { //If you start dragging set oldMouse values current mouse values
      oldMouseX2 = mouseX;
      oldMouseY2 = mouseY;
      mouseReleased = false;
    }
      
      dimInput[channel[fixtureIdNow[id]]] += map(oldMouseY2 - mouseY, 0, 30, 0, 255); //Change dimInput value as much as you moved mouse
      dimInput[channel[fixtureIdNow[id]]] = constrain(dimInput[channel[fixtureIdNow[id]]], 0, 255); //Make sure that dimInput value is between 0-255 
      oldMouseX2 = mouseX; //Set oldMouseX2 to current mouseX
      oldMouseY2 = mouseY; //Set oldMouseY2 to current mouseY
  }
}

public void checkFixtureBoxRightClick(int id) {
   if(isHover(0, -40, 60, -15) && mouseClicked && mouseButton == RIGHT) { //Check if mouse is on the title box anf clicked
    toChangeFixtureColor = true; //Tells controlP5 to open fixtureSettings window
    toRotateFixture = true; //Tells controlP5 to open fixtureSettings window
    changeColorFixtureId = fixtureIdOriginal[id]; //Tells controlP5 which fixture to edit
  }
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 piirret\u00e4\u00e4n sivuvalikko, jossa n\u00e4kyy memorit ja niiden arvot, sek\u00e4 tyypit

public void sivuValikko() {
  if(mouseX > width-120 && mouseX < width && mouseY > 30) {
    mouseLocked = true; //Lukitsee hiiren, jottei se vaikuta muihin alueisiin
    mouseLocker = "sivuValikko"; //Kertoo hiiren olevan lukittu alueelle sivuValikko
  }
   if(mousePressed == true) {
    if(mouseX > width-120 && mouseX < width && mouseY > 30) {
      mouseLocked = true; //Lukitsee hiiren, jottei se vaikuta muihin alueisiin
      mouseLocker = "sivuValikko"; //Kertoo hiiren olevan lukittu alueelle sivuValikko
      if(round(map((mouseX-width+60), 1, 59, 0, 255)) >= 0) {
        memory(round((mouseY-30)/15)+memoryMenu, round(map((mouseX-width+60), 1, 59, 0, 255)));
        memoryValue[round((mouseY-30)/15)+memoryMenu] = round(map((mouseX-width+60), 1, 59, 0, 255));
      }
      else {
        if(mouseButton == RIGHT) {
          changeChaseModeByMemoryNumber(round((mouseY-30)/15)+memoryMenu);
        }
        else {
        memory(round((mouseY-30)/15)+memoryMenu, 0);
        memoryValue[round((mouseY-30)/15)+memoryMenu] = 0;
        }
      }
    }
    else {
      mouseLocked = false;
      mouseLocker = "";
    }
  }
  
  
  //Drawing
  pushMatrix();
  translate(width-60, 40);
  for(int i = 1; i <= height/15-5; i++) {
    if(memoryMenu < numberOfMemories+40) {
      translate(0, 15);
      memoryy(i+memoryMenu, memoryValue[i+memoryMenu]);
    }
  }
  popMatrix();
  
  
 
}
public void memoryy(int numero, int dimmi) {
  String nimi = "";
  if(memoryType[numero] == 1) { nimi = "prst"; }
  if(memoryType[numero] == 2) { nimi = "s2l"; }
  if(memoryType[numero] == 4) { nimi = "mstr"; }
  if(memoryType[numero] == 5) { nimi = "fade"; }
  if(memoryType[numero] == 6) { nimi = "wave"; }
  
  fill(255, 255, 255);
  stroke(255, 255, 0); //Yellow borders
  rect(0, -5, 60, 15); //White rect under slider bar
  fill(0, 255, 0); //Green color for title box
  rect(-60, -5, 60, 15); //Title box
  fill(0, 0, 0); //Black title text
  text(str(numero)+":"+nimi, -47, 7); //Title text (emory number and type text)
  fill(0, 0, 255); //Blue color for slider bar
  rect(0, -5, (map(dimmi, 0, 255, 0, 60))*(1), 15); //Slider bar
  fill(0, 0, 0); //Black color for text
  text(str(dimmi), 0, 7); //Value text
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 piirret\u00e4\u00e4n yl\u00e4valikko, ja k\u00e4sitell\u00e4\u00e4n sen nappuloiden komentoja 

public void ylavalikko() {
  if(move == false && mouseY < height - 200 && mouseY > 50 && mouseX < width-120 && (!mouseLocked || mouseLocker == "main")) { //Tarkistetaan mm. ettei hiiri ole lukittuna jollekin muulle alueelle
    mouseLocked = true;
    mouseLocker = "main";
    if(mouseClicked) {    
      movePage();
    }
  }
  if(!move) {
    oldMouseX = mouseX;
    oldMouseY = mouseY;
  }
  stroke(255, 255, 255); 
  if(mouseX > 0 && mouseX < width/4 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    fill(0, 0, 255);
    if(move == true) {
      move = false;
      delay(100);
    }
    else {
      move = true;
      delay(100);
    }
    mouseReleased = false;
  }
  else {
    fill(255, 0, 0);
  }
  rect(0, 0, width/4, 50);
  fill(255, 255, 255);
  if(move == true) {
    text("Now: Move and edit fixtures", 30, 20);
    text("Next: Move and zoom area", 30, 35);
  }
  else {
    text("Now: Move and zoom area", 30, 20);
    text("Next: Move and edit fixtures", 30, 35);
  }
  
  if(mouseX > width/4 && mouseX < width/4*2 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    if(mouseReleased == true) {
      mouseReleased = false;
      fill(0, 0, 255);
      for(int i = 0; i < numberOfMemories; i++) {
      if(memoryType[i] != 0) {
        presetNumero = i+1;
      }
    }
      makingPreset = true;
    }
  }
  else {
    fill(255, 0, 0);
  }
  
  
  rect(width/4*1, 0, width/4, 50);
  fill(255, 255, 255);
  text("Make preset from active fixtures", width/4+30, 30);
  if(mouseX > width/4*2 && mouseX < width/4*3 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    fill(0, 0, 255);
    for(int i = 0; i < numberOfMemories; i++) {
      if(memoryType[i] != 0) {
        presetNumero = i+1;
      }
    }
    makingSoundToLightFromPreset = true;
  }
  else {
    fill(255, 0, 0);
  }
  rect(width/4*2, 0, width/4, 50);
  fill(255, 255, 255);
  text("Make SoundToLight from active presets", width/4*2+30, 30);
  if(mouseX > width/4*3 && mouseX < width/4*4 && mouseY < 50 && mouseClicked && mouseReleased && (!mouseLocked || mouseLocker == "ylavalikko")) {
    fill(0, 0, 255);
    chaseMode++;
    if(chaseMode > 5) {
      chaseMode = 1;
    }
    mouseReleased = false;
  }
  else {
    fill(255, 0, 0);
  }
  rect(width/4*3, 0, width/4, 50);
  fill(255, 255, 255);
  text("chaseMode: " + str(chaseMode), width/4*3+30, 30);
  
  
  if(makingPreset == true) {
    fill(0, 0, 255);
    rect(width/2-300, height/2-200, 500, 200);
    fill(255, 255, 255);
    text("Valitse nuolin\u00e4pp\u00e4imill\u00e4 haluamasi memorypaikka", width/2-300+20, height/2-200+50);
    text("ja paina v\u00e4lily\u00f6nti\u00e4 (UP +1, DOWN -1, RIGHT +10, LEFT -10)", width/2-300+20, height/2-200+70);
    if(keyPressed == true && keyReleased == true) {
      keyReleased = false;
    if(keyCode == UP) {
      presetNumero++;
    }
    if(keyCode == DOWN) {
      presetNumero--;
    }
    if(keyCode == LEFT) {
      presetNumero = presetNumero - 10;
    }
    if(keyCode == RIGHT) {
      presetNumero = presetNumero + 10;
    }
    if(key == ' ') {
      makePreset(presetNumero);
      makingPreset = false;
    }
    if(key == 'x') {
      makingPreset = false;
      presetNumero--;
    }
    delay(100);
    }
    else {
      keyReleased = true;
    }
    fill(255, 255, 255);
    text("Valintasi: ",  width/2-300+20, height/2-200+90);
    text(str(presetNumero),  width/2-300+130, height/2-200+90);
  }
  
  if(makingSoundToLightFromPreset == true) {
    fill(0, 0, 255);
    rect(width/2-300, height/2-200, 500, 200);
    fill(255, 255, 255);
    text("Valitse nuolin\u00e4pp\u00e4imill\u00e4 haluamasi memorypaikka", width/2-300+20, height/2-200+50);
    text("ja paina v\u00e4lily\u00f6nti\u00e4 (UP +1, DOWN -1, RIGHT +10, LEFT -10)", width/2-300+20, height/2-200+70);
    if(keyPressed == true && keyReleased == true) {
    keyReleased = false;
    if(keyCode == UP) {
      presetNumero++;
    }
    if(keyCode == DOWN) {
      presetNumero--;
    }
    if(keyCode == LEFT) {
      presetNumero = presetNumero - 10;
    }
    if(keyCode == RIGHT) {
      presetNumero = presetNumero + 10;
    }
    if(key == ' ') {
      soundToLightFromPreset(presetNumero);
      makingSoundToLightFromPreset = false;
    }
    if(key == 'x') {
      makingSoundToLightFromPreset = false;
      presetNumero--;
    }
    delay(100);
    }
    else {
      keyReleased = true;
    }
    fill(255, 255, 255);
    text("Valintasi: ",  width/2-300+20, height/2-200+90);
    text(str(presetNumero),  width/2-300+130, height/2-200+90);
  }
  
  if(presetMenu == true) {
    fill(255, 255, 255);
    rect(width/2-200, 100, 500, 400);
    fill(0, 0, 255);
    stroke(0, 0, 0);
    for(int i = 0; i < 20; i++) {
      if(mouseX > width/2-200 && mouseX < width/2+200 && mouseY > 100+20*i && mouseY < 100+20*(i+1) && mouseClicked == true) {
        if(i == 1) { selectingSoundToLight = true; presetMenu = false; }
        fill(100, 100, 255);
      }
      else {
        fill(0, 0, 255);
      }
      rect(width/2-200, 100+20*i, 500, 20);
      fill(255, 255, 255);
      String teksti = "teksti";
      if(i == 1) { teksti = "Sound to lightin valinta"; }
      text(teksti, width/2-200+10, 100+20*(i+1)-2);
    }
    if(keyPressed == true) {
    if(key == 'x') {
      presetMenu = false;
    }
    }
    
  }
  
  if(selectingSoundToLight == true) {
    fill(0, 0, 255);
    rect(width/2-300, height/2-200, 500, 200);
    fill(255, 255, 255);
    text("Valitse nuolin\u00e4pp\u00e4imill\u00e4 haluamasi memorypaikka", width/2-300+20, height/2-200+50);
    text("ja paina v\u00e4lily\u00f6nti\u00e4 (UP +1, DOWN -1, RIGHT +10, LEFT -10)", width/2-300+20, height/2-200+70);
    text("0 on taajuuksiin perustuva Sound To Light", width/2-300+20, height/2-200+90);
    text("Muut ovat biitteihin perustuvia", width/2-300+20, height/2-200+110);
    if(keyPressed == true && keyReleased == true) {
    keyReleased = false;
    if(keyCode == UP) {
      soundToLightNumero++;
    }
    if(keyCode == DOWN) {
      soundToLightNumero--;
    }
    if(key == ' ') {
      selectingSoundToLight = false;
      
    }
    if(key == 'x') {
      selectingSoundToLight = false;
    }
    delay(100);
    }
    else {
      keyReleased = true;
    }
    fill(255, 255, 255);
    text("Valintasi: ",  width/2-300+20, height/2-200+130);
    text(str(soundToLightNumero),  width/2-300+130, height/2-200+130);
  }
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 luetaan tietokoneen omia sy\u00f6tt\u00f6laitteita, eli n\u00e4pp\u00e4imist\u00f6\u00e4 ja hiirt\u00e4

public void keyReleased() {
  keyReleased = true;
}
public void keyPressed() {
  if(key==27) { key=0; } //Otetaan esc-n\u00e4pp\u00e4in pois k\u00e4yt\u00f6st\u00e4. on kumminkin huomioitava, ett\u00e4 t\u00e4m\u00e4 toimii vain p\u00e4\u00e4ikkunassa
  if(key == 'm') {
    if(move == true) { move = false; moveLamp = false; delay(10); }
    else { zoom = 100; x_siirto = 0; y_siirto = 0; move = true; delay(10); }
  }
  if(key == '1') { lampToMove = 1; }
  if(key == 's') { saveAllData(); }
  if(key == 'l') { loadAllData(); }
  if(key == 'c') {
    for(int i = 0; i < channels; i++) {
      valueOfDimBeforeBlackout[i] = 0;
      valueOfDimBeforeFullOn[i] = 0;
    }
  }

  if(key == 'u') {
      if(upper == true) { enttecDMXplace = enttecDMXplace - 1; upper = false; }
      else { enttecDMXplace = enttecDMXplace + 1; upper = true; }
  } 
  
}


public void mousePressed() {
  mouseClicked = true;
}
public void mouseReleased() {
  mouseClicked = false;
  mouseReleased = true;
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 luetaan iPadilta touchOSC-ohjelman inputti

int multixy1_value;
int multixy1_value_old;
int multixy1_value_offset;

boolean fullOn; //Muuttuja, joka kertoo onko fullOn p\u00e4\u00e4ll\u00e4
int[] valueOfDimBeforeFullOn = new int[channels]; //Muuttuja johon kirjoitetaan kanavien arvot ennen kun ne laitetaan t\u00e4ysille
boolean blackOutButtonWasReleased;
int masterValueBeforeBlackout;

public void oscEvent(OscMessage theOscMessage) {
  
  String addr = theOscMessage.addrPattern(); //Luetaan touchOSCin elementin osoite
  float val = theOscMessage.get(0).floatValue(); //Luetaan touchOSCin elementin arvo

  int digitalValue = PApplet.parseInt(val); //muutetaan float intiksi

  
  for(int i = 1; i <= touchOSCchannels; i++) { //K\u00e4yd\u00e4\u00e4n kaikki touchOSCin kanavat (faderit) l\u00e4pi
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
  
  }
  
  
  
  
     /*
       Blackout toimintaperiaate:
       laitetaan grandMaster nollaan
     */
  
   if(addr.equals("/blackout")) { //Jos blackout nappia painetaan
       if(digitalValue == 1) {
         if(blackOut == true) { //Jos blackout on p\u00e4\u00e4ll\u00e4 otetaan se pois p\u00e4\u00e4lt\u00e4, eli palautetaan kanaville entiset arvot
            blackOut = false;
            memory(1, masterValueBeforeBlackout);
            valueOfMemory[1] = masterValueBeforeBlackout;
            memoryValue[1] = masterValueBeforeBlackout;
         }
         else { //Jos blackout ei ole p\u00e4\u00e4ll\u00e4 laitetaan se p\u00e4\u00e4lle eli laitetaan kanavat nolliin
           masterValueBeforeBlackout = grandMaster;
           blackOut = true;
           grandMaster = 0;
           valueOfMemory[1] = 0;
           memoryValue[1] = 0;
           memory(1, 0);
          
         }
       }
     }
     
     if(addr.equals("/strobenow")) {
       if(digitalValue == 1) {
         memory(soloMemory, 255);
       }
       else {
         memory(soloMemory, 0);
       }
     }
     
     
     if(addr.equals("/nextstep")) {
       if(digitalValue == 1) {
        nextStepPressed = true;
       }
       else {
        nextStepPressed = false;
       }
     }
     if(addr.equals("/revstep")) {
       if(digitalValue == 1) {
        revStepPressed = true;
       }
       else {
         revStepPressed = false;
       }
     }
     
     
     
     if(addr.equals("/chaseModeUp")) {
       if(digitalValue == 1) {
           chaseMode++;
          if(chaseMode > 5) {
            chaseMode = 1;
          }
          sendDataToIpad("/chaseMode", chaseMode);
       }
     }
     
     if(addr.equals("/chaseModeDown")) {
       if(digitalValue == 1) {
           chaseMode--;
          if(chaseMode < 1) {
            chaseMode = 5;
          }
          sendDataToIpad("/chaseMode", chaseMode);
       }
     }
     
     
   
     /*
       Fullon toimintaperiaate:
       fullon on toiminto, joka laittaa kaikkien kanavien arvot t\u00e4ysille.
       T\u00e4m\u00e4 tehd\u00e4\u00e4n my\u00f6s p\u00e4\u00e4loopissa (draw) niin pitk\u00e4\u00e4n kun fullOn = true,
       jotta arvoja ei ylikirjoiteta. Ennen kuin kaikki arvot laitetaan t\u00e4ysille
       kirjoitetaan niiden arvot muuttujaan (valueOfDimBeforeSolo[]), jotta
       ne voidaan palauttaa fullOnin p\u00e4\u00e4tytty\u00e4. Fullon-nappi toimii
       go-tyyppisesti, eli sit\u00e4 painettaessa fullOn menee p\u00e4\u00e4lle ja kun
       se p\u00e4\u00e4stet\u00e4\u00e4n irti fullOn sammuu.
     */
     
    
     
     if(addr.equals("/fullon")) {
       if(digitalValue == 0) {
          fullOn = false;
         for(int ii = 0; ii < channels; ii++) {
            dimInput[ii] = valueOfDimBeforeFullOn[ii];
          }
     
     }
     else {
       fullOn = true;
      for(int ii = 0; ii < channels; ii++) {
       valueOfDimBeforeFullOn[ii] = dim[ii];
        dimInput[ii] = 255;
      }
      
     }
       }
     
    
    /*
      Moving head toimintaperiaate:
      Moving headin ohjaamista varten on oma sivu touchOSCissa,
      jossa on sek\u00e4 xy-p\u00e4di ett\u00e4 faderi, jolla s\u00e4\u00e4det\u00e4\u00e4n kirkkautta.
      Moving headin oikea kanava tarkistetaan k\u00e4ym\u00e4ll\u00e4 l\u00e4pi kaikki kanavat
      ja katsomalla mink\u00e4 kanavan fixtuurityyppi on moving head.
      Sama tehd\u00e4\u00e4n siis dimmin, panin ja tiltin kanssa. Kun se ollaan
      saatu selville oikealle dim-muuttujalle annetaan touchOSCista 
      tullut arvo ja sen j\u00e4lkeen se l\u00e4hetet\u00e4\u00e4n DMX:\u00e4\u00e4n aivan kuten muutkin
      dim-arvot. Kuitenkin yksi ero on huomattava. Moving headin pan
      ja tilt dim-muuttujat vaikuttavat sek\u00e4 2D- ett\u00e4 3D-visualisaatiossa
      moving headina asentoon.
    */
    
    
   if(addr.equals("/4/fader25")) {
      movingHeadDim = digitalValue;
       for(int iii = 0; iii < channels; iii++) {
     if(fixtureType1[iii] == 13) {
       dim[iii+1] = digitalValue;
     }
   }
   }
  
   
  if(addr.equals("/4/xy1")){
   movingHeadTilt = PApplet.parseInt(theOscMessage.get(0).floatValue());
   movingHeadPan = PApplet.parseInt(theOscMessage.get(1).floatValue());
   for(int iii = 0; iii < channels; iii++) {
     if(fixtureType1[iii] == 14) {
       dim[iii+1] = PApplet.parseInt(theOscMessage.get(1).floatValue());
       rotTaka[iii] = PApplet.parseInt(theOscMessage.get(1).floatValue());
     }
     if(fixtureType1[iii] == 15) {
       dim[iii+1] = PApplet.parseInt(theOscMessage.get(0).floatValue());
       rotX[iii] = PApplet.parseInt(theOscMessage.get(0).floatValue());
     }
   }
  }
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 luetaan aikaisemmin tallennettuja tietoja csv-taulukkotiedostosta
boolean dataLoaded = false;
public void loadSetupData() {
  if(userId == 1) {
   table = loadTable("/Users/elias/Dropbox/DMX controller/main_for_two_pc/variables/settings.csv", "header"); //Eliaksen polku
  }
  else if(!roopeAidilla){
   table = loadTable("E:\\Dropbox\\DMX controller\\main_for_two_pc\\variables\\settings.csv", "header"); //Roopen polku
  } else table = loadTable("C:\\Users\\rpsal_000\\Dropbox\\DMX controller\\main_for_two_pc\\variables\\settings.csv", "header"); // Roope \u00e4idill\u00e4 -polku
  
  for (TableRow row : table.findRows("sendOscToAnotherPc", "variable_name")) { sendOscToAnotherPc = PApplet.parseBoolean(row.getString("value")); }
  for (TableRow row : table.findRows("sendOscToIpad", "variable_name")) { sendOscToIpad = PApplet.parseBoolean(row.getString("value")); }
  for (TableRow row : table.findRows("sendMemoryToIpad", "variable_name")) { sendMemoryToIpad = PApplet.parseBoolean(row.getString("value")); }
  for (TableRow row : table.findRows("useCOM", "variable_name")) { useCOM = PApplet.parseBoolean(row.getString("value")); }
  for (TableRow row : table.findRows("showOutputAsNumbers", "variable_name")) { showOutputAsNumbers = PApplet.parseBoolean(row.getString("value")); }
  for (TableRow row : table.findRows("use3D", "variable_name")) { use3D = PApplet.parseBoolean(row.getString("value")); }
  for (TableRow row : table.findRows("loadAllDataInSetup", "variable_name")) { loadAllDataInSetup = PApplet.parseBoolean(row.getString("value")); }
  
}

public void loadAllData() {
    loadSetupData();
    
    if(userId == 1) {
     table = loadTable("/Users/elias/Dropbox/DMX controller/main_modular/variables/pikkusten_disko.csv", "header"); //Eliaksen polku
    }
    else if(!roopeAidilla) {
     table = loadTable("E:\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv", "header"); //Roopen polku
    } else table = loadTable("C:\\Users\\rpsal_000\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv", "header"); //Roope \u00e4idill\u00e4 -polku
  
  
  //  for (TableRow row1 : table1.rows()) {
  //    
  //    int id = row1.getInt("id");
  //    String variable_name = row1.getString("variable_name");
  //    String value = row1.getString("value");
  //    String D1 = row1.getString("1D");
  //    if(variable_name == "xTaka") {
  //      xTaka[int(D1)] = int(value);
  //    }
  //    if(variable_name == "yTaka") {
  //      yTaka[int(D1)] = int(value);
  //    }
  //  }
    
    
    for (TableRow row : table.findRows("xTaka", "variable_name")) { if(xTaka.length > (PApplet.parseInt(row.getString("1D")))) {xTaka[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); } }
    for (TableRow row : table.findRows("yTaka", "variable_name")) { yTaka[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("rotX", "variable_name")) { rotX[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("fixZ", "variable_name")) { fixZ[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    
    for (TableRow row : table.findRows("memoryType", "variable_name")) { memoryType[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("soundToLightSteps", "variable_name")) { soundToLightSteps[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    
    for (TableRow row : table.findRows("red", "variable_name")) { red[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("green", "variable_name")) { green[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("blue", "variable_name")) { blue[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    
    for (TableRow row : table.findRows("rotTaka", "variable_name")) { rotTaka[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureType1", "variable_name")) { fixtureType1[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    
    int[] grouping = new int[4];
    for (TableRow row : table.findRows("grouping", "variable_name")) { grouping[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    controlP5place = grouping[0]; enttecDMXplace = grouping[1]; touchOSCplace = grouping[2];
          
    for (TableRow row : table.findRows("memory", "variable_name"))              { memory[PApplet.parseInt(row.getString("1D"))][PApplet.parseInt(row.getString("2D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("soundToLightPresets", "variable_name")) { soundToLightPresets[PApplet.parseInt(row.getString("1D"))][PApplet.parseInt(row.getString("2D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("preset", "variable_name"))              { preset[PApplet.parseInt(row.getString("1D"))][PApplet.parseInt(row.getString("2D"))] = PApplet.parseInt(row.getString("value")); }
    
    for (TableRow row : table.findRows("camX", "variable_name"))              { camX = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("camY", "variable_name"))              { camY = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("camZ", "variable_name"))              { camZ = PApplet.parseInt(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("rotX", "variable_name"))              { rotX[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("fixZ", "variable_name"))              { fixZ[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("fixParam", "variable_name"))              { fixParam[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    
    for (TableRow row : table.findRows("ansaZ", "variable_name"))         { if((PApplet.parseInt(row.getString("1D")) < ansaZ.length)) { ansaZ[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaX", "variable_name"))         { if((PApplet.parseInt(row.getString("1D")) < ansaX.length)) { ansaX[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaY", "variable_name"))         { if((PApplet.parseInt(row.getString("1D")) < ansaY.length)) { ansaY[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaParent", "variable_name"))    { if((PApplet.parseInt(row.getString("1D")) < ansaParent.length)) { ansaParent[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); } }
    for (TableRow row : table.findRows("ansaType", "variable_name"))    { if((PApplet.parseInt(row.getString("1D")) < ansaType.length)) { ansaType[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); } }
  
    
    for (TableRow row : table.findRows("channel", "variable_name"))              { channel[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureIdNow", "variable_name"))              { fixtureIdNow[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureIdOriginal", "variable_name"))              { fixtureIdOriginal[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("fixtureIdPlaceInArray", "variable_name"))              { fixtureIdOriginal[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    
    for (TableRow row : table.findRows("chaseModeByMemoryNumber", "variable_name"))              { chaseModeByMemoryNumber[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("chaseMode", "variable_name"))              { chaseMode = PApplet.parseInt(row.getString("value")); }
    
    
    for (TableRow row : table.findRows("valueOfMemory", "variable_name"))              { valueOfMemory[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("memoryValue", "variable_name"))              { memoryValue[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
    
    for (TableRow row : table.findRows("centerX", "variable_name"))              { centerX = PApplet.parseInt(row.getString("value")); }
    for (TableRow row : table.findRows("centerY", "variable_name"))              { centerY = PApplet.parseInt(row.getString("value")); }
    
    dataLoaded = true;
  
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 luetaan dmx-inputti, sek\u00e4 j\u00e4rjestet\u00e4\u00e4n my\u00f6s muut inputit oikeaan j\u00e4rjestykseen mm. dimInput[]-muuttujaan

int numberOfAllChannelsFirstDimensions = 5; // allChannels[numberOfAllChannelsFirstDimensions][];

public void dmxCheck() {
  if(useCOM == true && useEnttec == true) {
       while (myPort.available() > 0) {
          if (cycleStart == true) {
            if (counter <= 6+enttecDMXchannels) {
              int inBuffer = myPort.read();
              vals[counter] = inBuffer;
              counter++;
            }
            else {
              cycleStart = false;
            }
          }
          else {
            for(int i = 0; i <= 5; i++) {
              if(vals[i] == check[i]) {
                if(error == false) {
                  error = false;
                }
              }
            }
            if(error == false) {
              for(int i = 5; i < 6+enttecDMXchannels; i++) {
                ch[i - 5] = vals[i];
              }
              counter = 0;
              cycleStart = true;    
            }
           } 
      }
  }
}
public void dmxToDim() {
  for(int i = 1; i < 13; i++) {
      enttecDMXchannel[i] = ch[i];
  }
  channelsToDim();
}
public void channelsToDim() { 
  
  
  for(int i = 1; i <= controlP5channels; i++) {
    if(controlP5channelOld[i] != controlP5channel[i]) {
      allChannels[controlP5place][i] = controlP5channel[i];
    }
  }
  for(int i = 1; i <= enttecDMXchannels; i++) {
    if(enttecDMXchannelOld[i] != enttecDMXchannel[i]) {
      allChannels[enttecDMXplace][i] = enttecDMXchannel[i];
    }
  }
  for(int i = 1; i <= touchOSCchannels; i++) {
    if(touchOSCchannelOld[i] != touchOSCchannel[i]) {         
      for(int ii = 0; ii < numberOfAllChannelsFirstDimensions; ii++) {
        if(i > ii*12 && i < (ii+1)*12) {
          allChannels[touchOSCplace + ii][i-ii*12] = touchOSCchannel[i];
        }     
      }
    }   
  }
  
  
  for(int i = 1; i < 13; i++) {
    for(int ii = 0; ii < numberOfAllChannelsFirstDimensions; ii++) {
      if(allChannels[ii][i] < 2) {
        allChannels[ii][i] = 0;
      }
    }
  }

    
  for(int i = 1; i < 13; i++) {
    if(allChannelsOld[1][i] != allChannels[1][i]) {
      dimInput[i] = round(map(allChannels[1][i], 0, 255, 0, fixtureMasterValue));
    }
    if(allChannelsOld[2][i] != allChannels[2][i]) {
      dimInput[i+12] = round(map(allChannels[2][i], 0, 255, 0, fixtureMasterValue));
    }
    if(allChannelsOld[5][i] != allChannels[5][i]) {
      if(useMemories == true) {
        memory(i+memoryMenu, round(map(allChannels[5][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i+memoryMenu] = round(map(allChannels[5][i], 0, 255, 0, memoryMasterValue));

      }
    }
    if(allChannelsOld[3][i] != allChannels[3][i]) {
      if(useMemories == true) {
        memory(i, round(map(allChannels[3][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i] = round(map(allChannels[3][i], 0, 255, 0, memoryMasterValue));

      }
      else {
        dimInput[i+12+12] = allChannels[3][i];
      }
    }
    
    if(allChannelsOld[4][i] != allChannels[4][i]) {
      if(useMemories == true) {
        memory(i+12, round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i+12] = round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue));
      }
      else {
        dimInput[i+12+12] = allChannels[4][i];
      }
    }
  }
  for(int i = 1; i < 13; i++) {
    for(int ii = 1; ii < numberOfAllChannelsFirstDimensions; ii++) {
      allChannelsOld[ii][i] = allChannels[ii][i];
    }
  }
  
  for(int i = 1; i < 13; i++) {
      controlP5channelOld[i] = controlP5channel[i];
  }
  for(int i = 1; i < enttecDMXchannels; i++) {
      enttecDMXchannelOld[i] = enttecDMXchannel[i];
  }
  for(int i = 1; i < touchOSCchannels; i++) {
      touchOSCchannelOld[i] = touchOSCchannel[i];
  }
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 mm. luodaan presettej\u00e4
int[] oldMemoryValue = new int[numberOfMemories]; //Muuttuja, johon tallennetaan memoryn edellinen arvo
int[] oldPresetValue = new int[numberOfMemories]; //Muuttuja, johon tallennetaan memoryn edellinen arvo
public void makePreset(int memoryNumber) {
  rect(width/2-100, height/2-100, 100, 100);
  for(int i = 0; i < channels; i++) {
      preset[memoryNumber][i] = dim[i];
  }
  memoryType[memoryNumber] = 1;
}
public void preset(int memoryNumber, int value) {
  for(int i = 0; i < channels; i++) {
    int to = round(map(preset[memoryNumber][i], 0, 255, 0, value));
    if(memoryData[i] < to) {
      memoryData[i] = to;
    }
    
  }
  memoryValue[memoryNumber] = value;
  if(value != oldPresetValue[memoryNumber]) {
    sendMemoryToIpad(memoryNumber, value); //L\u00e4heteet\u00e4\u00e4n iPadille memorin arvo, jos se on muuttunut
  }
  oldPresetValue[memoryNumber] = value;
}

public void soundToLightFromPreset(int memoryNumber) {
  int a = 0;
  for(int i = 0; i < numberOfMemories; i++) {
    if(memoryValue[i] != 0) {
      a++;
      soundToLightPresets[memoryNumber][a] = i;
    }
}
soundToLightSteps[memoryNumber] = a;
memoryType[memoryNumber] = 2;
}
public void memory(int memoryNumber, int value) {
  if(value != oldMemoryValue[memoryNumber]) {
    sendMemoryToIpad(memoryNumber, value); //L\u00e4heteet\u00e4\u00e4n iPadille memorin arvo, jos se on muuttunut
  }
  valueOfMemory[memoryNumber] = value;
//  memoryValue[memoryNumber] = value;
  if(memoryType[memoryNumber] == 1) {
    preset(memoryNumber, value);
  }
  if(memoryType[memoryNumber] == 2) {
    beatDetectionDMX(memoryNumber, value);
  }
  if(memoryType[memoryNumber] == 3) {
    beatDetectionDMX(0, value);
  }
  if(memoryType[memoryNumber] == 4) {
    if(blackOut == false) { grandMaster = value; } else { grandMaster = 0; }
  }
  if(memoryType[memoryNumber] == 5) {
    chaseFade = value;
  }
  oldMemoryValue[memoryNumber] = value;
}
public void changeChaseModeByMemoryNumber(int memoryNumber) {
  fill(0, 0, 255);
  rect(width/2-200, height/2-200, 400, 400);
  fill(255, 255, 255);
  text("Change chaseModeByMemoryNumber", width/2-200+20, height/2-200+20);
  if(keyPressed == true) {
    if(keyCode == UP && keyReleased == true) {
      chaseModeByMemoryNumber[memoryNumber]++;
      keyReleased = false;
    }
    if(keyCode == DOWN && keyReleased == true) {
      chaseModeByMemoryNumber[memoryNumber]--;
      keyReleased = false;
    }
  }
  text("chaseModeByMemoryNumber:"+chaseModeByMemoryNumber[memoryNumber], width/2-200+20, height/2-200+50);
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 tallennetaan tietoja csv-taulukkotiedostoon

Table table;
public void saveAllData() {
    table = new Table();
  
  table.addColumn("id");
  table.addColumn("variable_name");
  table.addColumn("variable_dimensions");
  table.addColumn("value");
  table.addColumn("1D");
  table.addColumn("2D");

  
  for(int i = 0; i < xTaka.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "xTaka");
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(xTaka[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i < yTaka.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "yTaka"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(yTaka[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  for(int i = 0; i < rotX.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "rotX"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(rotX[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  for(int i = 0; i < fixZ.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixZ"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixZ[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaZ.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaZ"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaZ[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaX.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaX"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaX[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaY.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaY"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaY[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }


  for(int i = 0; i < ansaParent.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaParent"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaParent[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }
  
  for(int i = 0; i < ansaType.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "ansaType"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(ansaType[i]));   newRow.setString("1D", str(i));              newRow.setString("2D", "-");
  }

  
  for(int i = 0; i <  memoryType.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "memoryType"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(memoryType[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  soundToLightSteps.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "soundToLightSteps"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(soundToLightSteps[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  red.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "red"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(red[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  green.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "green"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(green[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  blue.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "blue"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(blue[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  rotTaka.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "rotTaka"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(rotTaka[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  rotX.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "rotX"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(rotX[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int i = 0; i <  fixZ.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixZ"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixZ[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixParam.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixParam"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixParam[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureType1.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureType1"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureType1[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  channel.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "channel"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(channel[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureIdNow.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureIdNow"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureIdNow[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureIdOriginal.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureIdOriginal"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureIdOriginal[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  fixtureIdPlaceInArray.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureIdPlaceInArray"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureIdPlaceInArray[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  
  
  
  
  
  
  for(int i = 0; i <  chaseModeByMemoryNumber.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "chaseModeByMemoryNumber"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(chaseModeByMemoryNumber[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  
  for(int i = 0; i <  valueOfMemory.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "valueOfMemory"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(valueOfMemory[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
 
 for(int i = 0; i <  memoryValue.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "memoryValue"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(memoryValue[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
 
  
  
  int[] grouping = new int[4];
        grouping[0] = controlP5place;
        grouping[1] = enttecDMXplace;
        grouping[2] = touchOSCplace;
        grouping[3] = PApplet.parseInt(useMovingHead);
  for(int i = 0; i <  grouping.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "grouping"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(grouping[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
  }
  for(int a = 0; a < numberOfMemories; a++) {
    for(int i = 0; i <  channels+5; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "memory"); 
      newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(memory[a][i]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  for(int a = 0; a < numberOfMemories; a++) {
    for(int i = 0; i <  channels*2; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "soundToLightPresets"); 
      newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(soundToLightPresets[a][i]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  for(int a = 0; a < numberOfMemories; a++) {
    for(int i = 0; i <  channels*2; i++) {
      TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "preset"); 
      newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(preset[a][i]));   newRow.setString("1D", str(a));               newRow.setString("2D", str(i));
    }
  }
  
  
  
 
  
  TableRow newRow = table.addRow();     
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "camX"); 
  newRow.setString("variable_dimensions", "1"); 
  newRow.setString("value", str(camX));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "camY"); 
  newRow.setString("variable_dimensions", "1"); 
  newRow.setString("value", str(camY));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "camZ"); 
  newRow.setString("variable_dimensions", "1"); 
  newRow.setString("value", str(camZ));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "chaseMode"); 
  newRow.setString("variable_dimensions", "0"); 
  newRow.setString("value", str(chaseMode));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "centerX"); 
  newRow.setString("variable_dimensions", "0"); 
  newRow.setString("value", str(centerX));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  newRow = table.addRow();
  
  newRow.setInt("id", table.lastRowIndex());  
  newRow.setString("variable_name", "centerY"); 
  newRow.setString("variable_dimensions", "0"); 
  newRow.setString("value", str(centerY));   
  newRow.setString("1D", "-");               
  newRow.setString("2D", "-");
  
  //Asetetaan oikeat tallennuspolut k\u00e4ytt\u00e4j\u00e4n mukaan

  if(userId == 1) { //Jos Elias k\u00e4ytt\u00e4\u00e4
    saveTable(table, "/Users/elias/Dropbox/DMX controller/main_modular/variables/pikkusten_disko.csv"); //Eliaksen polku
  }
  else { //Jos Roope k\u00e4ytt\u00e4\u00e4
    saveTable(table, "E:\\Dropbox\\DMX controller\\main_modular\\variables\\pikkusten_disko.csv"); //Roopen polku
  }
}

//T\u00e4h\u00e4n v\u00e4lilehteen voi laittaa setup-komentoja, jotta main ei tule turhan t\u00e4yteen

OscP5 oscP51;
NetAddress myRemoteLocation1;

OscP5 oscP52;
NetAddress myRemoteLocation2;




boolean loadAllDataInSetup = true;

public int leveys;
public int korkeus;
public void setuppi() {
  leveys = displayWidth;
  korkeus = displayHeight;
  loadSetupData();
  if(loadAllDataInSetup == true) {
    loadAllData();
  }
  setFixtureChannelsAtSoftwareBegin();
  if(userId == 1) { //Jos Elias k\u00e4ytt\u00e4\u00e4
    getPaths = false; //Ei oteta polkuja tiedostosta
  }
  else { //Jos Roope k\u00e4ytt\u00e4\u00e4
    getPaths = true; //Otetaan polut tiedostosta
  }



  oscP51 = new OscP5(this, 5001);
  oscP52 = new OscP5(this, 5000);
  myRemoteLocation1 = new NetAddress("192.168.0.17",5001);
  myRemoteLocation2 = new NetAddress("192.168.0.11",5000);
  
  
  if(dataLoaded) {
    ansaWidth = max(xTaka)+80;
  }

}
public void checkThemeMode() {
  fill(0, 0, 0);
  if(printMode == true) { //Tarkistetaan onko tulostusmode p\u00e4\u00e4ll\u00e4 - check if printmode is on 
    background(255, 255, 255); //Jos tulostusmode on p\u00e4\u00e4ll\u00e4 taustav\u00e4ri on valkoinen - if printmode is on then background is white
    stroke(0, 0, 0); //Jos tulostusmode on p\u00e4\u00e4ll\u00e4 kuvioiden reunat ovat mustia - if printmode is on then strokes are black
  }
  else { 
    background(0, 0, 0); //Jos tulostusmode on pois p\u00e4\u00e4lt\u00e4 taustav\u00e4ri on musta - if printmode is off then background is black
    stroke(255, 255, 255); //Jos tulostusmode on pois p\u00e4\u00e4lt\u00e4 kuvoiden reunat ovat valkoisia - if printmode is off then strokes are white
  }
}
//in this tab software sends data to other pc and ipad

boolean sendOscToAnotherPc = true;
boolean sendOscToIpad = true;
boolean sendMemoryToIpad = true;

int[] oldChannelValToPc = new int[channels];
int[] oldChannelValToIpad = new int[channels];
int[] oldMemoryValToIpad = new int[numberOfMemories];
int[] oldDataValToIpad = new int[100];


public void sendOscToAnotherPc(int ch, int val) {
  if(sendOscToAnotherPc == true) {
    if(val != oldChannelValToPc[ch]) {
      OscMessage myMessage1 = new OscMessage(str(ch));
      myMessage1.add(val); // add an int to the osc message
      oscP51.send(myMessage1, myRemoteLocation1); 
      oldChannelValToPc[ch] = val;
    }
  }
}

public void sendOscToIpad(int ch, int val) {
  if(sendOscToIpad == true) {
    if(val != oldChannelValToIpad[ch]) {
      OscMessage myMessage2 = new OscMessage("/1/fader" + str(ch));
      myMessage2.add(val); // add an int to the osc message
      oscP52.send(myMessage2, myRemoteLocation2); 
      oldChannelValToIpad[ch] = val;
    }
  }
}

public void sendMemoryToIpad(int ch, int val) {
  if(sendMemoryToIpad == true) {
    if(val != oldMemoryValToIpad[ch]) {
      OscMessage myMessage2 = new OscMessage("/5/fader" + str(ch));
      myMessage2.add(val); // add an int to the osc message
      oscP52.send(myMessage2, myRemoteLocation2); 
      oldMemoryValToIpad[ch] = val;
    }
  }
}

public void sendDataToIpad(String ch, int val) {
    OscMessage myMessage2 = new OscMessage(ch);
    myMessage2.add(val); // add an int to the osc message
    oscP52.send(myMessage2, myRemoteLocation2); 
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 on paljon lyhyit\u00e4 voideja

int ansaWidth;

public void arduinoSend() {
  
  for(int i = 0; i < channels; i++) {
    if((dim[i] < (dimOld[i] - (dimOld[i] / 20))) || (dim[i] > (dimOld[i] + (dimOld[i] / 20))) || dim[i] == 255 || dim[i] == 0) {
      if(useCOM == true) {
        setDmxChannel(i, dim[i]);
      }
      dimOld[i] = dim[i];
      
    }
    sendOscToAnotherPc(i, dim[i]);
    sendOscToIpad(i, dimInput[i]);
  }
}


public void ansat() {
    fill(0, 0, 0);
    for(int i = 0; i < ansaY.length; i++) {
      if(ansaType[i] == 1) {
        rect(ansaX[i], (ansaY[i]+25), ansaWidth, 5);
      }
    }
}
public void kalvo(int r, int g, int b) {
  fill(r, g, b);
}


//Gets dimensions of fixture #id
//0 = width, 1 = height, 2 = (0 or 1) render fixture?
public int[] getFixtureSize(int id) {
  //Default to this
  int[] toReturn = {30, 40, 1};
  
  switch(fixtureType1[id]) {
    case 1: toReturn[0] = 30; toReturn[1] = 50; toReturn[2] = 1; break;
    case 2: toReturn[0] = 25; toReturn[1] = 30; toReturn[2] = 1; break;
    case 3: toReturn[0] = 35; toReturn[1] = 40; toReturn[2] = 1; break;
    case 4: toReturn[0] = 40; toReturn[1] = 50; toReturn[2] = 1; break;
    case 5: toReturn[0] = 40; toReturn[1] = 20; toReturn[2] = 1; break;
    case 6: toReturn[0] = 20; toReturn[1] = 60; toReturn[2] = 1; break;
    case 7: toReturn[0] = 50; toReturn[1] = 50; toReturn[2] = 1; break;
    case 8: toReturn[2] = 0; break;
    case 9: toReturn[0] = 40; toReturn[1] = 30; toReturn[2] = 1; break;
    case 10: toReturn[2] = 0; break;
    case 11: toReturn[0] = 50; toReturn[1] = 70; toReturn[2] = 1; break;
    case 12: toReturn[0] = 5; toReturn[1] = 8; toReturn[2] = 1; break;
    case 13: toReturn[0] = 30; toReturn[1] = 50; toReturn[2] = 1; break;
  }
  return toReturn;
  
}

//Gets type description of fixture #id
public String getFixtureName(int id) {
  String toReturn = "unknown";
  switch(fixtureType1[id]) {
    case 1: toReturn = "par64"; break;
    case 2: toReturn = "p.fresu"; break;
    case 3: toReturn = "k.fresu"; break;
    case 4: toReturn = "i.fresu"; break;
    case 5: toReturn = "flood"; break;
    case 6: toReturn = "linssi"; break;
    case 7: toReturn = "haze"; break;
    case 8: toReturn = "fan"; break;
    case 9: toReturn = "strobe"; break;
    case 10: toReturn = "freq"; break;
    case 11: toReturn = "fog"; break;
    case 12: toReturn = "pinspot"; break;
    case 13: toReturn = "MHdim"; break;
    case 14: toReturn = "MHpan"; break;
    case 15: toReturn = "MHtilt"; break;
  }
  return toReturn;
}



public void drawFixture(int i) {
  boolean showFixture = true;
  int lampWidth = 30;
  int lampHeight = 40;
  String fixtuuriTyyppi = getFixtureName(i);
  
  if(fixtureType1[i] >= 1 && fixtureType1[i] <= 13) {
    int[] siz = getFixtureSize(i);
    lampWidth = siz[0];
    lampHeight = siz[1];
    showFixture = siz[2] == 1;
  }
  if(fixtureType1[i] == 14) { showFixture = false; movingHeadPan = dim[i]; rotTaka[i] = round(map(dim[channel[i]], 0, 255, -90, 90)); }
  if(fixtureType1[i] == 15) { showFixture = false; rotX[i-2] = round(map(dim[channel[i]], 0, 255, 180, 0)); }
  
  if(showFixture == true) {
    int x1 = 0; int y1 = 0;
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate(radians(map(movingHeadPan, 0, 255, 0, 180))); pushMatrix();}
    rect(x1, y1, lampWidth, lampHeight);
    if(fixtureType1[i] == 13) { rectMode(CENTER); popMatrix(); rectMode(CORNER); }
    if(zoom > 50) {
      if(printMode == false) {
        fill(255, 255, 255);
        text(dim[channel[i]], x1, y1 + lampHeight + 15);
      }
      else {
        fill(0, 0, 0);
        text(fixtuuriTyyppi, x1, y1 + lampHeight + 15);
      }
    
     text(channel[i], x1, y1 - 15);
    }
  }
}

public void mouseWheel(MouseEvent event) {
  if(mouseX < width-120) { //Jos hiiri ei ole sivuvalikon p\u00e4\u00e4ll\u00e4 sen skrollaus vaikuttaa visualisaation zoomaukseen
    float e = event.getCount();
    if(e < 0) { if(zoom < 110) { zoom--; } else { zoom = zoom - PApplet.parseInt(zoom/30); } }
    else if(e > 0) { if(zoom < 110) { zoom++; } else { zoom = zoom + PApplet.parseInt(zoom/30); }}
  }
  else {
    float e = event.getCount();
    if(e < 0) { if(memoryMenu > 0) { memoryMenu--; } }
    else if(e > 0) { if(memoryMenu < numberOfMemories) { memoryMenu++; } }
  }
}




//Is pointer hovering over a rectangle's bounding box?
public boolean isHover(int offsetX, int offsetY, int w, int h) {
  return isHoverAB(offsetX, offsetY, offsetX + w, offsetY + h);
}

public boolean isHoverAB(int obj1X, int obj1Y, int obj2X, int obj2Y){
  //The x and y coordinates of all the dots in the simulated rectangle
  int[] x = new int[4];
  int[] y = new int[4];
  
  x[0] = PApplet.parseInt(screenX(obj1X, obj1Y));
  y[0] = PApplet.parseInt(screenY(obj1X, obj1Y));
  x[1] = PApplet.parseInt(screenX(obj2X, obj1Y));
  y[1] = PApplet.parseInt(screenY(obj2X, obj1Y));
  x[2] = PApplet.parseInt(screenX(obj1X, obj2Y));
  y[2] = PApplet.parseInt(screenY(obj1X, obj2Y));
  x[3] = PApplet.parseInt(screenX(obj2X, obj2Y));
  y[3] = PApplet.parseInt(screenY(obj2X, obj2Y));
  
  return inBds2D(mouseX, mouseY, min(x), min(y), max(x), max(y));
}


//A simpler version of isHover. Doesn't make a bounding box, only regards the two corners and checks a rectangle between them. (Useful with non-rotated scenarios)
public boolean isHoverSimple(int offsetX, int offsetY, int w, int h){
  return inBds2D(mouseX, mouseY, PApplet.parseInt(screenX(offsetX, offsetY)), PApplet.parseInt(screenY(offsetX, offsetY)), PApplet.parseInt(screenX(offsetX + w, offsetY + h)), PApplet.parseInt(screenY(offsetX + w, offsetY + h)));
}


public boolean inBds2D(int pointerX, int pointerY, int x1, int y1, int x2, int y2){
  return inBds1D(pointerX, x1, x2) && inBds1D(pointerY, y1, y2);
}

public boolean inBds1D(int pointer, int x1, int x2){
  return pointer > x1 && pointer < x2;
}

public void movePage() {
  if(mouseReleased) {
    oldMouseX = mouseX;
    oldMouseY = mouseY;
    mouseReleased = false;
  }
  x_siirto = x_siirto - (oldMouseX - mouseX);
  y_siirto = y_siirto - (oldMouseY - mouseY);
  oldMouseX = mouseX;
  oldMouseY = mouseY;
}

public boolean isClicked(int x1, int y1, int x2, int y2) {
  if(mouseClicked) {
    if(mouseX > x1 && mouseX < x2+x1 && mouseY > y1 && mouseY < y2+y1) {
      return true;
    }
    else {
      return false;
    }
  }
  else {
    return false;
  }
}
//T\u00e4ss\u00e4 v\u00e4lilehdess\u00e4 muutetaan fixtuurien ID:t\u00e4. Voideja kutsutaan controlP5:st\u00e4

public void change_fixture_id(int originalFixtureId) {
  //Nollataan v\u00e4liaikaismuuttujat
  fixtureIdNowTemp = new int[numberOfAllFixtures];
  fixtureIdNewTemp = new int[numberOfAllFixtures];
  fixtureIdOldTemp = new int[numberOfAllFixtures];
  
  //Kirjoitetaan v\u00e4liaikaismuuttujiin nykyiset tiedot
  for(int i = 0; i < numberOfAllFixtures; i++) {
    fixtureIdNowTemp[i] = fixtureIdNow[i];
  }
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]+1];
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]+1] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]];

  fixtureIdPlaceInArray[originalFixtureId]++; 
}
public void change_fixture_id_down(int originalFixtureId) {
  //Nollataan v\u00e4liaikaismuuttujat
  fixtureIdNowTemp = new int[numberOfAllFixtures];
  fixtureIdNewTemp = new int[numberOfAllFixtures];
  fixtureIdOldTemp = new int[numberOfAllFixtures];
  
  //Kirjoitetaan v\u00e4liaikaismuuttujiin nykyiset tiedot
  for(int i = 0; i < numberOfAllFixtures; i++) {
    fixtureIdNowTemp[i] = fixtureIdNow[i];
  }
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]-1];
  fixtureIdNow[fixtureIdPlaceInArray[originalFixtureId]-1] = fixtureIdNowTemp[fixtureIdPlaceInArray[originalFixtureId]];

  fixtureIdPlaceInArray[originalFixtureId]--; 
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main_modular" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
