/*CHANNELS

1 0…255 Rotation (pan) (0° to max. value of the Pan range: 180°, 270° or 540°)
2 0…255 Inclination (tilt) (0° to max. value of the Tilt range: 90°, 180° or 270°)
3 0…255 Fine adjustment for rotation (pan)
4 0…255 Fine adjustment for inclination (tilt)
5 0…255 Response speed (normal to slow)
6 Colour wheel
    0…6 White
    7…13 Yellow
    14…20 Pink
    21…27 Green
    28…34 Peachblow
    35…41 Blue
    42…48 Kelly-green
    49…55 Red
    56…63 Dark blue
    64…70 White + yellow
    71…77 Yellow + pink
    78…84 Pink + green
    85…91 Green + peachblow
    92…98 Peachblow + blue
    99…105 Blue + kelly-green
    106…112 Kelly-green + red
    113…119 Red + dark blue
    120…127 Dark blue + white
    128…191 Rainbow effect in positive rotation direction, increasing speed
    192…255 Rainbow effect in negative rotation direction, increasing speed
7 Shutter
    0…3 Closed (blackout)
    4…7 Open
    8…215 Strobe effect, increasing speed
    216…255 Open
8 0…255 Mechanical dimmer (0 to 100 %)
9 Gobo wheel
    0…7 Open
    8…15 Gobo 2
    16…23 Gobo 3
    24…31 Gobo 4
    32…39 Gobo 5
    40…47 Gobo 6
    48…55 Gobo 7
    56…63 Gobo 8
    64…71 Gobo 8 shake, increasing speed
    72…79 Gobo 7 shake, increasing speed
    80…87 Gobo 6 shake, increasing speed
    88…95 Gobo 5 shake, increasing speed
    96…103 Gobo 4 shake, increasing speed
    104…111 Gobo 3 shake, increasing speed
    112…119 Gobo 2 shake, increasing speed
    120…127 Open
    128…191 Rainbow effect in positive rotation direction, increasing speed
    192…255 Rainbow effect in negative rotation direction, increasing speed
10 Gobo rotation
    0…63 Gobo fixed
    64…147 Positive rotation direction, increasing speed
    148…231 Negative rotation direction, increasing speed
    232…255 Gobo bouncing
11 Special functions
    0…7 Unused
    8…15 Blackout during pan or tilt movement
    16…23 No blackout during pan or tilt movement
    24…31 Blackout during colour wheel movement
    32…39 No blackout during colour wheel movement
    40…47 Blackout during gobo wheel movement
    48…55 No blackout during gobo wheel movement
    56…87 Unused
    88…95 Blackout during movement
    96…103 Reset pan
    104…111 Reset tilt
    112…119 Reset colour wheel
    120…127 Reset gobo wheel
    128…135 Reset gobo rotation
    136…143 Reset prism
    144…151 Reset focus
    152…159 Reset all channels
    160…255 Unused
12 Built-in programmes
    0…7 Unused
    8…23 Program 1
    24…39 Program 2
    40…55 Program 3
    56…71 Program 4
    72…87 Program 5
    88…103 Program 6
    104…119 Program 7
    120…135 Program 8
    136…151 Sound control 1
    152…167 Sound control 2
    168…183 Sound control 3
    184…199 Sound control 4
    200…215 Sound control 5
    216…231 Sound control 6
    232…247 Sound control 7
    248…255 Sound control 8
13 Prism
    0…7 Unused
    8…247 Rotating prism, increasing speed
    248…255 Prism fixed
14 0…255 Focus

*/


int[] mh-x50_color_values = { };
