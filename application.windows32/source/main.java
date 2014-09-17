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

public class main extends PApplet {

//KOKEILE magic cue
/*
KORJATTAVAA/TEHT\u00c4V\u00c4\u00c4 22.4.2014
 - beat detection step vaihto
 - mouse lock kaikille alueille
 - kommentit kaikkiin komentoihin
 - memorien tallennus muutamaan tiedostoon muutaman tuhannen sijasta
 - sound to light taajuuksien mukaan kanavat s\u00e4\u00e4dett\u00e4viksi
 - osc-yhteys toiseen tietokoneeseen --> visualisaatio
 - memorit my\u00f6s moving headille
 - valmiita valotyyppej\u00e4, joiden kanavat ja muoto on m\u00e4\u00e4ritelty etuk\u00e4teen (par64, fresu, strobo, moving head, led par64, jne)
 - dmx kanavien m\u00e4\u00e4r\u00e4n automaattinen tunnistus
 
 
KORJATTAVAA/TEHT\u00c4V\u00c4\u00c4 23.4.2014
 - k\u00e4yr\u00e4npiirto
 - help/readme 
 - noin tuhat presetti\u00e4, joita voi vaihtaa scrollaamalla OK
 - wave efekti osaksi ohjelmaa OK
 
SELVIT\u00c4
 - Stairvillen valop\u00f6yd\u00e4n ykk\u00f6skanavassa jotain vikaa? Ei tahdo pysy\u00e4 nollassa kovin helposti
*/


/*
This software reads data from Enttec DMX Usb pro, sends it to arduino DMX shield
and visualize it.
It will work only if your DMX Usb pro is plugged into first serial port
and you have drivers for it. You also have to plug in arduino with DMX shield
to second COM port.
*/


int userId = 1; //1 = Elias, 2 = Roope

//triggerWave

boolean nextStepPressed = false;
boolean revStepPressed = false;
int lastStepDirection;

int soloMemory = 10; //Memorypaikka, joka on solo
boolean soloWasHere = false; //Oliko Solo \u00e4sken k\u00e4yt\u00f6ss\u00e4
boolean useSolo = true; //K\u00e4ytet\u00e4\u00e4nk\u00f6 soloa


PFrame f1 = new PFrame();;
secondApplet1 s1;

PFrame1 f = new PFrame1();;
secondApplet s;

boolean biitti = false;

int pageRotation = 0;

int memoryMenu = 0;

int numberOfMemories = 100; //Presettien m\u00e4\u00e4r\u00e4

int memoryMasterValue = 255;
int fixtureMasterValue = 255;

//int[] waveStep = new int[1000];
//boolean[] waveHasGone = new boolean[1000];
//boolean[] waveHasGoneOld = new boolean[1000];
//int activeWaves = 3;

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

boolean useCOM = false; //Onko tietokoneeseen kytketty arduino ja enttec DMX usb pro

boolean mouseLocked = false; //Onko hiiri lukittu jollekin tietylle alueelle
String mouseLocker; //Mille alueelle hiiri on lukittu

int[] valueOfMemory = new int[1000];
int[] valueOfMemoryBeforeSolo = new int[1000];

int[] memoryType = new int[1000]; //Memoryn tyyppi (1 = preset, 2 = sound to light)
int[] chaseModeByMemoryNumber = new int[1000];

long[] millisNow = new long[100]; //Nykyinen aika   --> K\u00e4ytet\u00e4\u00e4n delayta sijaistavissa komennoissa
long[] millisOld = new long[100]; //Edellinen aika  --> K\u00e4ytet\u00e4\u00e4n delayta sijaistavissa komennoissa

boolean keyReleased = false; //Onko n\u00e4pp\u00e4in vapautettu

boolean presetMenu = false; //Onko presetmenu n\u00e4kyviss\u00e4


int arduinoIndex = 1; //Arduinon COM-portin j\u00e4rjestysnumero
int enttecIndex = 0; // Enttecin USB DMX palikan COM-portin j\u00e4rjestysnumero




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

int[] soundToLightValues = { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 11, 11, 11, 12, 12, 12, 13, 13, 13, 14, 14, 14, 15, 15, 16, 17, 18, 19, 20, 21, 22, 24, 26, 28, 30, 34, 38, 42, 46, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 120, 125, 130, 135, 140, 145, 150, 155, 160, 165, 170, 174, 178, 182, 184, 186, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 215, 216, 217, 218, 219, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 250, 240, 230, 220, 210, 200, 190, 180, 170, 160, 150, 140, 130, 120, 110, 100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
 
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

int enttecDMXchannels = 24; //DMX kanavien m\u00e4\u00e4r\u00e4
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
String remoteIP = "192.168.0.12";

//sound to light asetuksia 
Minim minim;
AudioPlayer song;
AudioInput in;
BeatDetect beat;

FFT fft;

float[] lastY;
float[] lastVal;

int buffer_size = 1024;  // also sets FFT size (frequency resolution)
float sample_rate = 44100;


Serial arduinoPort;

public void setDmxChannel(int channel, int value) {
  if(useCOM == true) {
    // Convert the parameters into a message of the form: 123c45w where 123 is the channel and 45 is the value
    // then send to the Arduino
    arduinoPort.write( str(channel) + "c" + str(value) + "w" );
  }
}

// 1 = par64; 2 = pieni fresu; 3 = keskikokoinen fresu; 4 = iso fresu; 5 = floodi; 6 = linssi; 7 = haze; 8 = haze fan; 9 = strobe; 10 = strobe freq; 11 = fog; 12 = pinspot; 13 = moving head  dim; 14 = moving head pan; 15 = moving head tilt;
int[] fixtureType1 = { 3, 4, 4, 1, 1, 1, 1, 4, 4, 3, 6, 6, 5, 5, 5, 5, 1, 1, 1, 7, 71, 8, 81, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };

//visualisaation fixtuurien sijainnit
//int[] xEtu = { 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600 }; //etuansan fixtuurien sijainnit sivusuunnassa
int[] xTaka = { 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 50, 100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000 }; //taka-ansan fixtuurien sijainnit sivusuunnassa
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
int[] ch = new int[512];


int[] vals = new int[31];
boolean cycleStart = false;
int counter;
boolean error = false;
int[] check = { 126, 5, 14, 0, 0, 0 };

int[] dmxChannel = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 13, 14, 14, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40 };
int[] channel = new int[channels];

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

//Chase muuttujat
int chaseStep1 = 1;
int chaseStep2;
int[] chaseBright1 = new int[numberOfMemories];
int[] chaseBright2 = new int[numberOfMemories];
int chaseLamp1;
int chaseLamp2;

boolean chaseFirstTime = true;

boolean chase;
boolean dmxSoundToLight = false;
Serial myPort;  // The serial port

public void setup() {
  memoryIsZero = new boolean[channels];
  if(getPaths == true) {
  String lines100[] = loadStrings("C:\\DMXcontrolsettings\\savePath.txt");
  savePath = lines100[0];
  
  String lines101[] = loadStrings("C:\\DMXcontrolsettings\\loadPath.txt");
  loadPath = lines101[0];
  }
  
  cp5 = new ControlP5(this);
  
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("Control", 500,500);
    size(1024, 768);
    background(0, 0, 0);
    stroke(255, 255, 255);
    ansat(); 
    for(int i = 1; i < 512; i++) {
      dim[i] = 0;
    }
    for(int i = 0; i < channels; i++) {
      channel[i] = dmxChannel[i];
    }
    
    if(useCOM == true) {
    myPort = new Serial(this, Serial.list()[enttecIndex], 115000);
    arduinoPort = new Serial(this, Serial.list()[arduinoIndex], 9600);
    }
    
    minim = new Minim(this);

    //in = minim.getLineIn(Minim.STEREO, int(1024));
    in = minim.getLineIn(Minim.MONO,buffer_size,sample_rate);
    beat = new BeatDetect(in.bufferSize(), in.sampleRate());
    
    oscP5 = new OscP5(this, 8000); 
    frame.setResizable(true);
    Remote = new NetAddress(remoteIP,portOutgoing);
    
     setuppi();
     
    fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(16, 2);
  fft.window(FFT.HAMMING);
}


public void dmxCheck() {
  if(useCOM == true) {
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
        else {
        }
      }
      
      
      if(error == false) {
            for(int i = 6; i < 12; i++) {
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
    if(chase == true || play == true) {
    if(ch[i] == 0) { } else {
      enttecDMXchannel[i] = ch[i];
    }
    }
    else {
      enttecDMXchannel[i] = ch[i];
    }
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
     if(i > 48) {
       allChannels[touchOSCplace+4][i-48] = touchOSCchannel[i];
     }     
     else if(i > 36) {
          allChannels[touchOSCplace+3][i-36] = touchOSCchannel[i];
      }
      else if(i > 24) {
          allChannels[touchOSCplace+2][i-24] = touchOSCchannel[i];
      }
      else if(i > 12) {
          allChannels[touchOSCplace+1][i-12] = touchOSCchannel[i];
      }
      else {
        allChannels[touchOSCplace][i] = touchOSCchannel[i];
      }
    }
  }
  
  
   for(int i = 1; i < 13; i++) {
    if(allChannels[1][i] < 5) {
      allChannels[1][i] = 0;
    }
    if(allChannels[2][i] < 5) {
      allChannels[2][i] = 0;
    }
    if(allChannels[3][i] < 5) {
      allChannels[3][i] = 0;
    }
    if(allChannels[4][i] < 5) {
      allChannels[4][i] = 0;
    }
    if(allChannels[5][i] < 5) {
      allChannels[5][i] = 0;
    }
  }

    
  for(int i = 1; i < 13; i++) {
    if(allChannelsOld[1][i] != allChannels[1][i]) {
      dim[i] = round(map(allChannels[1][i], 0, 255, 0, fixtureMasterValue));
    }
    if(allChannelsOld[2][i] != allChannels[2][i]) {
      dim[i+12] = round(map(allChannels[2][i], 0, 255, 0, fixtureMasterValue));
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
        dim[i+12+12] = allChannels[3][i];
      }
    }
    
    if(allChannelsOld[4][i] != allChannels[4][i]) {
      if(useMemories == true) {
        memory(i+12, round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue)));
        memoryValue[i+12] = round(map(allChannels[4][i], 0, 255, 0, memoryMasterValue));
      }
      else {
        dim[i+12+12] = allChannels[4][i];
      }
    }
  }
  for(int i = 1; i < 13; i++) {
    allChannelsOld[1][i] = allChannels[1][i];
    allChannelsOld[2][i] = allChannels[2][i];
    allChannelsOld[3][i] = allChannels[3][i];
    allChannelsOld[4][i] = allChannels[4][i];
    allChannelsOld[5][i] = allChannels[5][i];
  }
  
  for(int i = 1; i < 13; i++) {
      controlP5channelOld[i] = controlP5channel[i];
  }
  for(int i = 1; i < 24; i++) {
      enttecDMXchannelOld[i] = enttecDMXchannel[i];
  }
  for(int i = 1; i < touchOSCchannels; i++) {
      touchOSCchannelOld[i] = touchOSCchannel[i];
  }
}


public void dmxEmulator() {
  
for(int i = 1; i < 10; i++) {
  for(int br = 1; br < 255; br++) {
    ch[i] = br;
    ch[i - 1] = 255 - br;
  }
}
}
public void oscEvent(OscMessage theOscMessage){
  String addr = theOscMessage.addrPattern();
  float val = theOscMessage.get(0).floatValue();

  int digitalValue = PApplet.parseInt(val);


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

}
public void alavalikko() {
  translate(0, height-100);
  for(int i = 0; i <= channels/2; i++) {
    translate(65, 0);
    fixture(i, dim[i+1], fixtureType1[i]);
  }
  for(int i = 0; i <= channels/2; i++) {
    translate(-65, 0);
  }
  translate(0, 65);
  for(int i = channels/2+1; i <= channels; i++) {
    translate(65, 0);
    fixture(i, dim[i+1], fixtureType1[i]);
  }
  translate(0, -55);
  for(int i = channels/2+1; i <= channels; i++) {
    translate(-65, 0);
  }
  translate(0, (height-100)*(-1));
}
public void fixture(int numero, int dimmi, int fixtuuriTyyppi1) {
  String fixtuuriTyyppi = "";

    
  if(fixtuuriTyyppi1 == 1) { fixtuuriTyyppi = "par64"; }
  if(fixtuuriTyyppi1 == 2) { fixtuuriTyyppi = "p.fresu"; }
  if(fixtuuriTyyppi1 == 3) { fixtuuriTyyppi = "k.fresu"; }
  if(fixtuuriTyyppi1 == 4) { fixtuuriTyyppi = "i.fresu"; }
  if(fixtuuriTyyppi1 == 5) { fixtuuriTyyppi = "flood"; }
  if(fixtuuriTyyppi1 == 6) { fixtuuriTyyppi = "linssi"; }
  if(fixtuuriTyyppi1 == 7) { fixtuuriTyyppi = "haze"; }
  if(fixtuuriTyyppi1 == 8) { fixtuuriTyyppi = "fan"; }
  if(fixtuuriTyyppi1 == 9) { fixtuuriTyyppi = "strobe"; }
  if(fixtuuriTyyppi1 == 10) { fixtuuriTyyppi = "freq"; }
  if(fixtuuriTyyppi1 == 11) { fixtuuriTyyppi = "fog"; }
  if(fixtuuriTyyppi1 == 12) { fixtuuriTyyppi = "pinspot"; }
  if(fixtuuriTyyppi1 == 13) { fixtuuriTyyppi = "MHdim"; }
  if(fixtuuriTyyppi1 == 14) { fixtuuriTyyppi = "MHpan"; }
  if(fixtuuriTyyppi1 == 15) { fixtuuriTyyppi = "MHtilt"; }
  fill(255, 255, 255);
  stroke(255, 255, 0);
  rect(0, 0, 60, -51);
  stroke(0, 0, 0);
  fill(0, 255, 0);
  rect(0, -40, 60, -15);
  fill(0, 0, 0);
  text(str(numero+1)+":"+fixtuuriTyyppi, 2, -44);
  fill(0, 0, 255);
  rect(0, 0, 10, (map(dimmi, 0, 255, 0, 30))*(-1));
  fill(255, 255, 255);
  rect(10, 0, 49, -15);
  fill(0, 0, 0);
  text("Go", 12, -3);
  fill(255, 255, 255);
  rect(10, -15, 49, -15);
  fill(0, 0, 0);
  text("Toggle", 12, -18);
  fill(255, 255, 255);
  
  if(numero <= channels/2) {
  if(mouseX > 65*numero+10 && mouseX < 65*(numero+1)) {
    
    if(mouseY > height-(200+15) && mouseY < height-110) {
          if(mousePressed == true && mouseButton == RIGHT) {
            toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = numero-1;
          }
    }
      if(mouseY > height-(100+15) && mouseY < height-100) {
        if(mouseClicked == true) {
            dim[numero] = 255;       
        }
        else if(mouseReleased == true){
          mouseReleased = false;
          dim[numero] = 0;
        }
      }
    }
  }
  else {
    
    if((mouseX > 65*(numero-(channels/2))+10) && (mouseX < 65*(numero+1-(channels/2)))) {
      if(mouseY > height-(100+15) && mouseY < height-10) {
          if(mousePressed == true && mouseButton == RIGHT) {
            toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = numero;
          }
    }
      if(mouseY > height-(100+15-65) && mouseY < height-110) {
      }
          if(mouseY > height-(100+15-65) && mouseY < height-(100-65)) {
            if(mouseClicked == true) {
                dim[numero+1] = 255;
            }
            else if(mouseReleased == true){
              mouseReleased = false;
              dim[numero+1] = 0;
            }
          }
        }
      }
      
      if(numero <= channels/2) {
  if(mouseX > 65*numero+10 && mouseX < 65*(numero+1)) {
      if(mouseY > height-(100+30) && mouseY < height-(100+15)) {
        if(mouseClicked == true) {
          if(mouseReleased == true) {
          if(dim[numero] == 255) {
                dim[numero] = 0;
              }
              else {
                dim[numero] = 255;
              }
              mouseReleased = false;
          }
        }
      }
    }
  }
  else {
    if((mouseX > 65*(numero-(channels/2))+10) && (mouseX < 65*(numero+1-(channels/2)))) {
          if(mouseY > height-(100+30-65) && mouseY < height-(100-65+15)) {
            if(mouseClicked == true) {
              if(mouseReleased == true) {
              if(dim[numero+1] == 255) {
                dim[numero+1] = 0;
              }
              else {
                dim[numero+1] = 255;
              }
              mouseReleased = false;
              }
            }
          }
        }
      }
      
      
      if(numero <= channels/2) {
  if(mouseX > 65*numero && mouseX < 65*(numero)+10) {
      if(mouseY > height-(100+30) && mouseY < height-100) {
        if(mouseClicked == true) {
          dim[numero] = round(map(mouseY, height-100, height-(100+30), 0, 255));
          
        }
        else if(mouseReleased == true) {
          mouseReleased = false;
        }
      }
    }
  }
  else {
    if((mouseX > 65*(numero-(channels/2))) && (mouseX < 65*(numero-(channels/2))+10)) {
          if(mouseY > height-(100+30-65) && mouseY < height-(100-65)) {
            if(mouseClicked == true) {
              dim[numero+1] = round(map(mouseY, height-(100-65), height-(100+30-65), 0, 255));
            }
            else if(mouseReleased == true) {
              mouseReleased = false;
            }
          }
        }
      }
}

public void chanelConfig() {
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
/* IDEA JOLLA T\u00c4M\u00c4N SAA TOIMIMAAN:

ENSIN LASKETAAN AKTIIVISET MEMORYT JA SEN J\u00c4LKEEN JOKA ISKULLA FOR LOOPPI

*/
public void detectBeat() {
      beat.detect(in.mix); //minim-kirjaston beatintunnistuskomentoihin tarvittava komento
      millisNow[10] = millis();
      if (((beat.isKick() && beat.isSnare()) || (beat.isKick() && beat.isHat()) || (beat.isHat() && beat.isSnare()))) {
        biitti = true;
        millisOld[10] = millis();
      }
      else {
        if(millisNow[10] - millisOld[10] > 50) {
          biitti = false;
          millisOld[10] = millis();
        }
      }
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
      if(keyPressed == true && key == ' ' && keyReleased == true || (chaseStepChanging[memoryNumber] == true && chaseFade > 0) || nextStepPressed == true) {
        nextStepPressed = false;
        lastStepDirection = 1;
        chaseStepChangingRev[memoryNumber] = false;
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
      else if(lastStepDirection == 1) {
        stepChange(i, value, true, false); //stepChange(memoryn numero, memoryn arvo, onko crossFade k\u00e4yt\u00f6ss\u00e4, halutaanko steppi\u00e4 vaihtaa)
      }
      if(revStepPressed == true || (chaseStepChangingRev[memoryNumber] == true && chaseFade > 0)) {
        chaseStepChanging[memoryNumber] = false;
        lastStepDirection = 2;
        revStepPressed = false;
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
            preset(soundToLightPresets[i][1], 255);
      }
      else { //Jos ei ole biitti\u00e4 presetti sammutetaan
            preset(soundToLightPresets[i][1], 0);
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
  //memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = chaseBright2[memoryNumber];
  //memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 255 - chaseBright2[memoryNumber];
  
  
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
  //  memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = 255;
  //  memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 0;
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
    print("chaseBright1: ");
    print(chaseBright1[memoryNumber]);
    print("               chaseBright2: ");
    print(chaseBright2[memoryNumber]);
    println(); println();
  }
preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], round(map(chaseBright2[memoryNumber], 0, 255, 0, value)));
preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], round(map(255 - chaseBright2[memoryNumber], 0, 255, 0, value)));
//memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = chaseBright2[memoryNumber];
//memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 255 - chaseBright2[memoryNumber];


}
else {
//  if(changeStep == true) {
//    steppi[memoryNumber]++;
//    steppi1[memoryNumber] = steppi[memoryNumber] - 1;
//    if(steppi[memoryNumber] > soundToLightSteps[memoryNumber]) {
//      steppi[memoryNumber] = 1;
//      steppi1[memoryNumber] = soundToLightSteps[memoryNumber];
//    }
//  }
//  preset(soundToLightPresets[memoryNumber][steppi1[memoryNumber]], round(map(255, 0, 255, 0, value)));
//  preset(soundToLightPresets[memoryNumber][steppi[memoryNumber]], 0);
////  memoryValue[soundToLightPresets[memoryNumber][steppi[memoryNumber]]] = 255;
////  memoryValue[soundToLightPresets[memoryNumber][steppi1[memoryNumber]]] = 0;
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
          if(iii*20/(soundToLightSteps[memoryNumber]+1) > 10) {
            preset(soundToLightPresets[memoryNumber][iii], soundToLightValues[round(map(200*val11, 0, 300, 0, value))]);
          }
          else {
            preset(soundToLightPresets[memoryNumber][iii], soundToLightValues[round(map(100*val11, 0, 300, 0, value))]);
          }
          
        }
        
    }
    
    millisOld[1] = millisNow[1];
      }
}
 
public void stop()
{
  // always close Minim audio classes when you are finished with them
  //song.close();
  in.close();
  // alway s stop Minim before exiting
  minim.stop();
 
  super.stop();
} 
public void dmx_channel_list() {
  
}

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
     println(checkedPresets);
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
  public void setup() {
    
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
    .setRange(1, 3)
    .setPosition(10, 40)
    .setLabel("ControlP5")
    .moveTo("settings")
    ;
    cp5.addNumberbox("grouping2")
    .setSize(40, 10)
    .setRange(1, 3)
    .setPosition(60, 40)
    .setLabel("enttec DMX")
    .moveTo("settings")
    ;
    cp5.addNumberbox("grouping3")
    .setSize(40, 10)
    .setRange(1, 3)
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
  
  //The controlEvent void triggers also when the elements are created, so we have to make sure it doesn't execute the trigger at the first catch of a specific element. (asvPre and adelPre should not be fired at program launch)
  boolean deleteAll = false;
  boolean createNew = false;
  boolean Trigwave = false;
  
  public void controlEvent(ControlEvent theEvent) {
    //ListBoxes don't like .getName(), so we'll check that there is no error
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
        cp5.controller("fixtParam").setValue(fixParam[changeColorFixtureId]);
        lb.setIndex(fixtureType1[changeColorFixtureId] - 1);
        //Make the color tab visible and activate it
        cp5.tab("fixtSettings").setVisible(true).setLabel("Fixture ID: " + str(changeColorFixtureId + 1));
        cp5.window(this).activateTab("fixtSettings");
        
        toChangeFixtureColor = false;
      }
      
      //Make the color tab invisible again when the user goes out of it
      if(cp5.tab("fixtSettings").isActive() == false) {cp5.tab("fixtSettings").setVisible(false);}
      
      //Set RGB values for selected fixture
      if (fixtureColorChangeHasHappened) {
        red[changeColorFixtureId] = PApplet.parseInt(cp5.controller("colorRed").getValue());
        green[changeColorFixtureId] = PApplet.parseInt(cp5.controller("colorGreen").getValue());
        blue[changeColorFixtureId] = PApplet.parseInt(cp5.controller("colorBlue").getValue());
        rotTaka[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtRotation").getValue());
        rotX[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtRotationX").getValue());
        fixZ[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtZ").getValue());
        fixParam[changeColorFixtureId] = PApplet.parseInt(cp5.controller("fixtParam").getValue());
        fixtureType1[changeColorFixtureId] = PApplet.parseInt(lb.getValue());
      }
      
      //Set ansa Z values according to NBoxes
      for (int i = 0; i < createdAnsaZBoxes; i++) {
        ansaZ[i] = PApplet.parseInt(cp5.controller("ansaZ" + str(i)).getValue());
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

public void draw() {
  memoryType[1] = 4;
  memoryType[2] = 5;
  memoryType[3] = 6;
  fill(0, 0, 0);
  background(0, 0, 0);
  stroke(255, 255, 255);
   
   translate(x_siirto, y_siirto);
   rotate(radians(pageRotation));
  ansat();
  dmxCheck();
  dmxToDim();
  memoryData = new int[channels];
  for(int i = 0; i < numberOfMemories; i++) {
    if(useSolo == true) {
      if(valueOfMemory[soloMemory] < 10) {
        if(soloWasHere == true) {
          memory(i, valueOfMemoryBeforeSolo[i]);
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
            if(valueOfMemory[i] != 0) {
              valueOfMemoryBeforeSolo[i] = valueOfMemory[i];
            }
            memory(i, 0);
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
      dim[i] = memoryData[i];
      if (memoryData[i] == 0) {memoryIsZero[i] = true;} else {memoryIsZero[i] = false;}
    }
  }
  
  if(play == false) {
    if(chase == false) {
      if(dmxSoundToLight == false) {
        
      }
      else {
       // beatDetectionDMX(1, 3, 2);
      }
    }
    else {
//      chaser(1);
    }
  }
  else {
    toista();
  }
  arduinoSend();
  if(rec == true) {
    tallennus();
  }
  delay(10);
  translate(0, 0);
  
 
  
  for(int i = 0; i < ansaTaka; i++) {
    if(move == true && (mouseLocked == false || mouseLocker == "main")) {
    if(mouseClicked == true) {
        if(mouseX > (xTaka[i])*zoom/100 + x_siirto && mouseX < (xTaka[i])*zoom/100 + 30 + x_siirto && mouseY > (yTaka[i])*zoom/100 + y_siirto && mouseY < (yTaka[i])*zoom/100 + 50 + y_siirto) {
          if(mouseButton == RIGHT) { toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = i; }
          else {
            lampToMove = i;
            moveLamp = true;
          }
        }
      }
      else {
      if(moveLamp == true) {
       if(lampToMove < ansaTaka) {
        xTaka[lampToMove] = mouseX;
        yTaka[lampToMove] = mouseY;
      }
//      else {
//        xEtu[lampToMove-ansaTaka] = mouseX;
//        yEtu[lampToMove-ansaTaka] = mouseY;
//      }
      moveLamp = false;
      }
      }
    if(moveLamp == true) {
    if(i == lampToMove) {
      translate(mouseX, mouseY);
    }
    else {
      translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100);
    }
    }
    else {
      translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100);
    }
    }
    else {
      translate((xTaka[i])*zoom/100, (yTaka[i])*zoom/100);
    }
      rotate(radians(rotTaka[i]));
      kalvo(round(map(red[i], 0, 255, 0, dim[channel[i]])), round(map(green[i], 0, 255, 0, dim[channel[i]])), round(map(blue[i], 0, 255, 0, dim[channel[i]])));
      drawFixture(i);
      rotate(radians(rotTaka[i] * (-1)));
     if(moveLamp == true) {
    if(i == lampToMove) {
      translate(0-mouseX, 0-mouseY);
    }
    else {
      translate((0-xTaka[i])*zoom/100, (0-yTaka[i])*zoom/100);
    }
    }
    else {
      translate((0-xTaka[i])*zoom/100, (0-yTaka[i])*zoom/100);
    }
  }
  
//Valoja ei en\u00e4\u00e4 lajitella erikseen ansoille, joten alla oleva koodi on turha
  
//  for(int i = 0; i < ansaEtu; i++) {
//    if(move == true && (mouseLocked == false || mouseLocker == "main")) {
//    if(mouseClicked == true) {
//        if(mouseX > xEtu[i] && mouseX < xEtu[i] + 30 && mouseY > yEtu[i] && mouseY < yEtu[i] + 50) {
//          if(mouseButton == RIGHT) { toChangeFixtureColor = true; toRotateFixture = true; changeColorFixtureId = i+ansaTaka; }
//          else {
//            lampToMove = i+ansaTaka;
//            moveLamp = true;
//          }
//        }
//    }
//    else {
//      if(moveLamp == true) {
//      if(lampToMove <= ansaTaka) {
//        xTaka[lampToMove] = mouseX;
//        yTaka[lampToMove] = mouseY;
//      }
//      else {
//      xEtu[lampToMove-ansaTaka] = mouseX;
//      yEtu[lampToMove-ansaTaka] = mouseY;
//    }
//    moveLamp = false;
//      }
//    }
//    if(moveLamp == true) {
//    if(i+ansaTaka == lampToMove) {
//      translate(mouseX, mouseY);
//    }
//    else {
//      translate((xEtu[i])*zoom/100, (yEtu[i])*zoom/100);
//    }
//    }
//    else {
//      translate((xEtu[i])*zoom/100, (yEtu[i])*zoom/100);
//    }
//    }
//    else {
//      translate((xEtu[i])*zoom/100, (yEtu[i])*zoom/100);
//    }
//    rotate(0);
//   
//    kalvo(round(map(red[i], 0, 255, 0, dim[channel[i+ansaTaka]])), round(map(green[i], 0, 255, 0, dim[channel[i+ansaTaka]])), round(map(blue[i], 0, 255, 0, dim[channel[i+ansaTaka]])));
//    par64(0, 0, dim[channel[i+ansaTaka]], channel[i+ansaTaka]);
//    if(moveLamp == true) {
//    if(i+ansaTaka == lampToMove) {
//      translate(0-mouseX, 0-mouseY);
//    }
//    else {
//      translate((0-xEtu[i])*zoom/100, (0-yEtu[i])*zoom/100);
//    }
//    }
//    else {
//      translate((0-xEtu[i])*zoom/100, (0-yEtu[i])*zoom/100);
//    }
//  }
  
   if(useMovingHead == true) {
     rectMode(CENTER);
    translate(width/2, height/2);
    rotate(radians(90-movingHeadPan));
    kalvo(round(map(movingHeadRed, 0, 255, 0, movingHeadDim)), round(map(movingHeadGreen, 0, 255, 0, movingHeadDim)), round(map(movingHeadBlue, 0, 255, 0, movingHeadDim)));
    par64(movingHeadDimChannel);
    rotate(radians((90-movingHeadPan) * (-1)));
    translate(-200, -200);
    rectMode(CORNER);
  }
  rotate(radians(pageRotation*(-1)));
  translate((x_siirto)*(-1), (y_siirto)*(-1));
  ylavalikko();
  alavalikko();
  sivuValikko();
  translate(x_siirto, y_siirto);

}
public class secondApplet extends PApplet {

  public void setup() {
    size(600, 900);
  }
  public void draw() {
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
  /*
   * TODO: something like on Close set f to null, this is important if you need to 
   * open more secondapplet when click on button, and none secondapplet is open.
   */
}



/*
 This part of the program has mainly been made by Roope Salmi, rpsalmi@gmail.com
 */



String assetPath;
int[] rotX = { 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135 };
int[] fixZ = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

//0 = None, 1 = ansa 0, 2 = ansa 1
int[] ansaParent = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
int[] ansaZ = { 0, 0 };

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

int lavaX = 0, lavaY = 0, lavaSizX = 400, lavaSizY = 300, lavaH = 200;
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
  
  if(userId == 1) {frameRate(15);} else {frameRate(30);} 
  //frameRate(15);
  
}

int[] valoY = {100 + 70, 100 +140, 100 + 210, 100 + 280, 100 + 350, 100 + 420};
int valoScale = 20;



public void draw() {
 
  background(0);
  lights();
  
  //Camera
  camera(camX, camY, camZ, width/2.0f, height/2.0f + 1500, -1000, 0, 0, -1);
  
  
  
  //Draw floor
  pushMatrix();
  translate(width/2, height/2, -1000);
  noStroke();
  rotateX(radians(90));
  fill(50);
  scale(400, 400, 400);
  shape(base);
  
  popMatrix();
  
  //Draw ansas
  for(int i = 0; i < y.length; i++) {
    pushMatrix();
    translate(0, y[i] * 5, ansaZ[i] + 82);
    box(10000, 10, 10);
    popMatrix();
  }
  
  //Draw stage (lava)
  if(lava) {
    pushMatrix();
    translate(lavaX * 5, lavaY * 5, -1000 + lavaH);
    fill(237, 205, 97);
    box(lavaSizX * 5, lavaSizY * 5, lavaH);
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



public void drawLight(int posX, int posY, int posZ, int rotZ, int rotX, int scale, float coneDiam, int coneR, int coneG, int coneB, int conedim, int coneZOffset, int parentAnsa, PShape lightModel) {
      //If light is parented to an ansa, offset Z height by ansas height
      if (parentAnsa > 0) {
        posZ += ansaZ[parentAnsa - 1];
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
      if (parentAnsa > 0) {
        posZ += ansaZ[parentAnsa - 1];
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
      if (parentAnsa > 0) {
        posZ += ansaZ[parentAnsa - 1];
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
    
    camX -= (mouseX - pmouseX) * 5;
    camY -= (mouseY - pmouseY) * 10;
}
 

 
public void keyPressed()
{
  if (keyCode == UP) {
    camZ += 100;
  } else if (keyCode == DOWN) {
    camZ -= 100;
  }
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
public void keyReleased() {
  keyReleased = true;
}
public void keyPressed() {
  if(key == 'm') {
    if(move == true) {
      move = false;
      moveLamp = false;
      delay(10);
    }
    else {
      zoom = 100;
      x_siirto = 0;
      y_siirto = 0;
      move = true;
      delay(10);
    }
  }
  if(key == '1') {
    lampToMove = 1;
  }
  if(key == 's') {
    
    saveAllData();
    

    
  }
  if(key == 'l') {
    
    loadAllData();
    

  }
  
  if(key == 'r') {
    if(rec == true) {
      rec = false;

    }
    else {
      rec = true;
    }
  }
  if(key == 'p') {
    if(play == true) {
      play = false;
    }
    else {
      play = true;
    }
  }
  if(key == 'c') {
    if(chase == true) {
      chase = false;
    }
    else {
      chase = true;
    }
  }
//  if(key == 'b') {
//    if(dmxSoundToLight == true) {
//      dmxSoundToLight = false;
//    }
//    else {
//      dmxSoundToLight = true;
//    }
//  }
 if(key == 'u') {
    if(upper == true) {
      enttecDMXplace = enttecDMXplace - 1;
      upper = false;
    }
    else {
      enttecDMXplace = enttecDMXplace + 1;
      upper = true;
    }
  } 
  
}
public void mousePressed() {
  mouseClicked = true;
}
public void mouseReleased() {
  mouseClicked = false;
  mouseReleased = true;
}

public void loadAllData() {
  
  if(userId == 1) {
   table = loadTable("/Users/elias/Dropbox/DMX controller/main/variables/new.csv", "header"); //Eliaksen polku
  }
  else {
   table = loadTable("E:\\Dropbox\\DMX controller\\main\\variables\\new.csv", "header"); //Roopen polku
  }

  println(table.getRowCount() + " total rows in table1"); 

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
  
  
  for (TableRow row : table.findRows("xTaka", "variable_name")) { xTaka[PApplet.parseInt(row.getString("1D"))] = PApplet.parseInt(row.getString("value")); }
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
  
}
public void loadAllDataWithOldMethod() {
    String lines[] = loadStrings(loadPath + "variables/xTaka.txt");
    for (int i = 0; i < lines.length; i++) {
      xTaka[i] = PApplet.parseInt(lines[i]);
    }
    String lines1[] = loadStrings(loadPath + "variables/yTaka.txt");
    for (int i = 0; i < lines1.length; i++) {
      yTaka[i] = PApplet.parseInt(lines1[i]);
    }
//    String lines2[] = loadStrings(loadPath + "variables/xEtu.txt");
//    for (int i = 0; i < lines2.length; i++) {
//      xEtu[i] = int(lines2[i]);
//    }
//    String lines3[] = loadStrings(loadPath + "variables/yEtu.txt");
//    for (int i = 0; i < lines3.length; i++) {
//      yEtu[i] = int(lines3[i]);
//    }
    String lines4[] = loadStrings(loadPath + "variables/chGroup.txt");
    controlP5place = PApplet.parseInt(lines4[0]);
    enttecDMXplace = PApplet.parseInt(lines4[1]);
    touchOSCplace = PApplet.parseInt(lines4[2]);
    
    
    for (int i = 0; i < 100; i++) {
      memory[i] = PApplet.parseInt(loadStrings(loadPath + "variables/memories/memory"+str(i)+".txt"));
    }
    for(int i = 0; i < 100; i++) {
      soundToLightPresets[i] = PApplet.parseInt(loadStrings(loadPath + "variables/s2l_presets/preset"+str(i)+".txt"));
    }
    for(int i = 0; i < 100; i++) {
      preset[i] = PApplet.parseInt(loadStrings(loadPath + "variables/presets/preset"+str(i)+".txt"));
    }
    
    String lines5[] = loadStrings(loadPath + "variables/memoryType.txt");
    for (int i = 0; i < lines5.length; i++) {
      memoryType[i] = PApplet.parseInt(lines5[i]);
    }
    
    String lines6[] = loadStrings(loadPath + "variables/soundToLightSteps.txt");
    for (int i = 0; i < lines6.length; i++) {
      soundToLightSteps[i] = PApplet.parseInt(lines6[i]);
    }
    
    String lines7[] = loadStrings(loadPath + "variables/kalvot/red.txt");
    for (int i = 0; i < lines7.length; i++) {
      red[i] = PApplet.parseInt(lines7[i]);
    }
    
    String lines8[] = loadStrings(loadPath + "variables/kalvot/green.txt");
    for (int i = 0; i < lines8.length; i++) {
      green[i] = PApplet.parseInt(lines8[i]);
    }
    
    String lines9[] = loadStrings(loadPath + "variables/kalvot/blue.txt");
    for (int i = 0; i < lines9.length; i++) {
      blue[i] = PApplet.parseInt(lines9[i]);
    }
    
    String lines10[] = loadStrings(loadPath + "variables/rotTaka.txt");
    for (int i = 0; i < lines10.length; i++) {
      rotTaka[i] = PApplet.parseInt(lines10[i]);
    }
    String lines11[] = loadStrings(loadPath + "variables/fixtureType.txt");
    for (int i = 0; i < lines11.length; i++) {
      fixtureType1[i] = PApplet.parseInt(lines11[i]);
    }
 
}
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
    chaseSpeed = round(map(value, 0, 255, 0, 5000));
  }
  if(memoryType[memoryNumber] == 5) {
    chaseFade = value;
  }
  
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
  for(int i = 0; i <  fixtureType1.length; i++) {
    TableRow newRow = table.addRow();             newRow.setInt("id", table.lastRowIndex());  newRow.setString("variable_name", "fixtureType1"); 
    newRow.setString("variable_dimensions", "1"); newRow.setString("value", str(fixtureType1[i]));   newRow.setString("1D", str(i));               newRow.setString("2D", "-");
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
  
  //Asetetaan oikeat tallennuspolut k\u00e4ytt\u00e4j\u00e4n mukaan

  if(userId == 1) { //Jos Elias k\u00e4ytt\u00e4\u00e4
    saveTable(table, "/Users/elias/Dropbox/DMX controller/main/variables/new.csv"); //Eliaksen polku
  }
  else { //Jos Roope k\u00e4ytt\u00e4\u00e4
    saveTable(table, "E:\\Dropbox\\DMX controller\\main\\variables\\new.csv"); //Roopen polku
  }
}
public void saveAllDataWithOldMethod() {
      saveStrings(savePath + "variables/xTaka.txt", str(xTaka));
    saveStrings(savePath + "variables/yTaka.txt", str(yTaka));
    saveStrings(savePath + "variables/memoryType.txt", str(memoryType));
    saveStrings(savePath + "variables/soundToLightSteps.txt", str(soundToLightSteps));
    saveStrings(savePath + "variables/kalvot/red.txt", str(red));
    saveStrings(savePath + "variables/kalvot/green.txt", str(green));
    saveStrings(savePath + "variables/kalvot/blue.txt", str(blue));
    saveStrings(savePath + "variables/rotTaka.txt", str(rotTaka));
    saveStrings(savePath + "variables/fixtureType.txt", str(fixtureType1));
    int[] grouping = new int[4];
        grouping[0] = controlP5place;
        grouping[1] = enttecDMXplace;
        grouping[2] = touchOSCplace;
        grouping[3] = PApplet.parseInt(useMovingHead);
        saveStrings(savePath + "variables/chGroup.txt", str(grouping));
        
    for(int i = 0; i < numberOfMemories; i++) {
      saveStrings(savePath + "variables/memories/memory"+str(i)+".txt", str(memory[i]));
    }
    for(int i = 0; i < numberOfMemories; i++) {
      saveStrings(savePath + "variables/s2l_presets/preset"+str(i)+".txt", str(soundToLightPresets[i]));
    }
    for(int i = 0; i < numberOfMemories; i++) {
      saveStrings(savePath + "variables/presets/preset"+str(i)+".txt", str(preset[i]));
    }
}


public void setuppi() {

  if(userId == 1) { //Jos Elias k\u00e4ytt\u00e4\u00e4
    getPaths = false; //Ei oteta polkuja tiedostosta
  }
  else { //Jos Roope k\u00e4ytt\u00e4\u00e4
    getPaths = true; //Otetaan polut tiedostosta
  }

}
public void sivuValikko() {
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
      print((mouseY-30)/15);
      println(str(mouseX-width+60));
    }
    else {
      mouseLocked = false;
      mouseLocker = "";
    }
  }
  
  translate(width-60, 30);
  for(int i = 1; i <= height/15-5; i++) {
    if(memoryMenu < numberOfMemories+40) {
    translate(0, 15);
    memoryy(i+memoryMenu, memoryValue[i+memoryMenu]);
  }
  }
  for(int i = 0; i < 40; i++) {
    translate(0, -15);
  }
  translate((width-100)*(-1), 0);
 
}
public void memoryy(int numero, int dimmi) {
  String nimi = "";
  if(memoryType[numero] == 1) { nimi = "prst"; }
  if(memoryType[numero] == 2) { nimi = "s2l"; }
  if(memoryType[numero] == 4) { nimi = "spd"; }
  if(memoryType[numero] == 5) { nimi = "fade"; }
  if(memoryType[numero] == 6) { nimi = "wave"; }
  fill(255, 255, 255);
  stroke(255, 255, 0);
  rect(0, -5, 60, 15);
  fill(0, 255, 0);
  rect(-60, -5, 60, 15);
  fill(0, 0, 0);
  text(str(numero)+":"+nimi, -47, 7);
  fill(0, 0, 255);
  rect(0, -5, (map(dimmi, 0, 255, 0, 60))*(1), 15);
  fill(0, 0, 0);
  text(str(dimmi), 0, 7);
}


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
public void arduinoSend() {
  if(useCOM == true) {
  for(int i = 0; i < channels; i++) {
    if(dim[i] != dimOld[i]) {
      setDmxChannel(i, dim[i]);
      dimOld[i] = dim[i];
    }
  }
  }
}

public void tallennus() {
  countteri++;
  for(int i = 0; i < 12; i++) {
    recVal[countteri][i] = dim[i];
  }
  delay(10);
}

public void toista() {
    if(playStep < 1000) { playStep++; }
    for(int i = 0; i < 12; i++) {
      dim[i] = recVal[playStep][i];
    }
    delay(10);
}

//void chase() {
//  
//  
//  chaseBright1[memoryNumber]++;
//  if(chaseBright1 > ch[1]) {
//    chaseStep1++;
//    chaseBright1 = 0;
//    delay(ch[2]*10);
//  }
//  if(chaseStep1 > 12) {
//    chaseStep1 = 1;
//  }
//  dim[chaseStep1] = round(map(chaseBright1, 0, ch[1], 0, 255));
//  dim[chaseStep1-1] = 255 - round(map(chaseBright1, 0, ch[1], 0, 255));
//}



public void ansat() {
  fill(0, 0, 0);
  rect(0, (y[0]+25)*zoom/100, width*zoom/150, 5);
  rect(0, (y[1]+25)*zoom/100, width*zoom/150, 5);
}
public void kalvo(int r, int g, int b) {
  fill(r, g, b);
}
public void par64(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 30*zoom/100;
  int lampHeight = 50*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void linssi(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 20*zoom/100;
  int lampHeight = 60*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void iso_fresu(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 40*zoom/100;
  int lampHeight = 50*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void keski_fresu(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 35*zoom/100;
  int lampHeight = 40*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void pieni_fresu(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 25*zoom/100;
  int lampHeight = 30*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void flood(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 40*zoom/100;
  int lampHeight = 20*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void strobe(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 40*zoom/100;
  int lampHeight = 30*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void haze(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 50*zoom/100;
  int lampHeight = 50*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}
public void fog(int i) {
  int x1 = 0;
  int y1 = 0;
  int lampWidth = 50*zoom/100;
  int lampHeight = 70*zoom/100;
  rect(x1, y1, lampWidth, lampHeight);
  if(zoom > 50) {
  fill(255, 255, 255);
  text(dim[channel[i]], x1, y1 + lampHeight + 15);
  text(channel[i], x1, y1 - 15);
  }
}

public void drawFixture(int i) {
  boolean showFixture = true;
  int lampWidth = 30;
  int lampHeight = 40;
  if(fixtureType1[i] == 1) { lampWidth = 30*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 2) { lampWidth = 25*zoom/100; lampHeight = 30*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 3) { lampWidth = 35*zoom/100; lampHeight = 40*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 4) { lampWidth = 40*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 5) { lampWidth = 40*zoom/100; lampHeight = 20*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 6) { lampWidth = 20*zoom/100; lampHeight = 60*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 7) { lampWidth = 50*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 8) { showFixture = false; }
  if(fixtureType1[i] == 9) { lampWidth = 40*zoom/100; lampHeight = 30*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 10) { showFixture = false; }
  if(fixtureType1[i] == 11) { lampWidth = 50*zoom/100; lampHeight = 70*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 12) { lampWidth = 5*zoom/100; lampHeight = 8*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 13) { lampWidth = 30*zoom/100; lampHeight = 50*zoom/100; showFixture = true; }
  if(fixtureType1[i] == 14) { showFixture = false; movingHeadPan = dim[channel[i]]; rotTaka[i-1] = round(map(dim[channel[i]], 0, 255, -90, 90)); }
  if(fixtureType1[i] == 15) { showFixture = false; rotX[i-2] = round(map(dim[channel[i]], 0, 255, 180, 0)); }
  
  if(showFixture == true) {
    int x1 = 0; int y1 = 0;
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate(radians(map(movingHeadPan, 0, 255, 0, 180))); }
    rect(x1, y1, lampWidth, lampHeight);
    if(fixtureType1[i] == 13) { rectMode(CENTER); rotate((radians(map(movingHeadPan, 0, 255, 0, 180))) * (-1)); rectMode(CORNER); }
    if(zoom > 50) {
    fill(255, 255, 255);
    text(dim[channel[i]], x1, y1 + lampHeight + 15);
    text(channel[i], x1, y1 - 15);
    }
  }
}

public void mouseWheel(MouseEvent event) {
  if(mouseX < width-120) {
  float e = event.getCount();
  if(e < 0) {
    zoom--;
  }
  else if(e > 0) {
    zoom++;
  }
  }
  else {
    float e = event.getCount();
  if(e < 0) {
    if(memoryMenu > 0) {
      memoryMenu--;
    }
  }
  else if(e > 0) {
    if(memoryMenu < numberOfMemories) {
      memoryMenu++;
    }
  }
  }
}
public void ylavalikko() {
  if(move == false && mouseY < height - 200 && mouseY > 100 && (mouseLocked == false || mouseLocker == "main")) { //Tarkistetaan mm. ettei hiiri ole lukittuna jollekin muulle alueelle
    if(mouseClicked == true) {
      x_siirto = x_siirto - (oldMouseX - mouseX);
      y_siirto = y_siirto - (oldMouseY - mouseY);
      oldMouseX = mouseX;
      oldMouseY = mouseY;
    }
  }
  if(move == true) {
    zoom = 100;
    x_siirto = 0;
    y_siirto = 0;
    
  }
  else {
    oldMouseX = mouseX;
    oldMouseY = mouseY;
  }
  stroke(255, 255, 255); 
  if(mouseX > 0 && mouseX < width/4 && mouseY < 50 && mouseClicked == true) {
    fill(0, 0, 255);
    if(move == true) {
      move = false;
      delay(100);
    }
    else {
      zoom = 100;
      x_siirto = 0;
      y_siirto = 0;
      move = true;
      delay(100);
    }
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
  
  if(mouseX > width/4 && mouseX < width/4*2 && mouseY < 50 && mouseClicked == true) {
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
  if(mouseX > width/4*2 && mouseX < width/4*3 && mouseY < 50 && mouseClicked == true) {
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
  if(mouseX > width/4*3 && mouseX < width/4*4 && mouseY < 50 && mouseClicked == true && mouseReleased == true) {
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
