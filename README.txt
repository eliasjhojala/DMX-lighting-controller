This project is made to control DMX ligting systems from computer.
It's designed to use with Enttec DMX usb pro as input and Arduino with DMX shield as output,
but of course you can use any devices you want to.
There is also iPad input allowed in this program.
Original I made this program for only myself, so for the begin it would be really difficult
to use and change settings in it.

Also the most of the comments in the software is in finnish, so it would
make it also more difficult to use.

Here is the main hieracrhy of the software:

main tab:
  - the place where most of the variables are created
  - void setup()

draw tab:
  - void draw()
  
DMX_input tab:
  - reading input from Enttec Dmx Usb Pro
  - putting all inputs to dim variable
  
OSC tab:
  - reading input from iPad
  
  
  
Variables:

  dim[channel]: out going data
  dimInput[channel]: out going data before master
  allChannels[input][channel]: in coming data from all inputs
