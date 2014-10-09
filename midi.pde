



//Maschine Mikro MK2 Interfacing
void maschineNoteOn(int pitch, int velocity) {
  println("Maschine noteOn PITCH|" + pitch + "/VEL|" + velocity);
}

void maschineNoteOff(int pitch, int velocity) {
  println("Maschine noteOff PITCH|" + pitch + "/VEL|" + velocity);
}

void maschineControllerChange(int number, int value) {
  println("Maschine CC NUMBER|" + number + "/VALUE|" + value);
}
