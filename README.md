#DMX Controller
_An open source DMX control suite made in Processing._
_- The furthest Processing has ever been taken (according to me, @ollpu)_


###What it can do
 - This program works well with 'dumb' one-channeled fixtures, but it is also great for controlling RGB LEDs and moving heads.
 - In the near future, you will be able to make your own profiles for different, unique types of fixtures, but this feature is still under developement.
 - Robust memory system
    - Quickly make chases with automaticlly assigned steps, or create a custom chase that cycles through presets.
    - Presets can control all DMX values, including dimming, color, moving head rotation and other fixture specific data-types.
    - Master dimmer and master fade are implemented as memories so that any controlling input can easily adjust them.
 - Color wash -functionality
 - Pleasing graphical interface 

###For developers
Here are a few important things to know about:
 - The fixture -class
    - (FixtureDMX) in and out
      - If you want to control the fixture, change the in object and remember to change fixture.DMXChanged to true.
      - If you want to get display-ready data from a fixture, you can use the out object. 
 - The fixture ArrayList wrapper (yes, we made our own wrapper to properly preserve IDs)
    - fixtures.get(id), returns a fixture object. This is your friend.
    - fixtures.add(fixture), adds a fixture to the managed ArrayList.
 - The SubwidnowHandler and SubwindowContainer classes and Mouse class
    - Yes, we made our own internal window handler. It's quite cool.
    - Yes, we made our own internal mouse capture handler. It is very cool. (Refer to CODER MANUAL/Mouse_class.md)
    - Can support any window class that fits certain requirements (uses reflection).
    - Please refer to the code of this (in GUI.pde), as it is farely complicated.
 - The memory class
    - Everything memories. (memory.pde)
 - **There are loads of things to find and mess around with, go ahead and explore the whole software.**
 - We've tried to make many of the elements as standardized as possible, so that you can use them in any Processing sketch.
