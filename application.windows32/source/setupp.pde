void setuppi() {

  if(userId == 1) { //Jos Elias käyttää
    getPaths = false; //Ei oteta polkuja tiedostosta
  }
  else { //Jos Roope käyttää
    getPaths = true; //Otetaan polut tiedostosta
  }

}
