Mouse Class
-----------

How to use:
To declare an element you can use:
mouse.declareElement(String name, int priority, int x1, int y1, int x2, int y2);
or
mouse.declareElement(String name, String ontopof, int x1, int y1, int x2, int y2);
where ontopof is the name of the element you want to place this element on top.

To update an elements location you can use:
mouse.updateElement(String name, int x1, int y1, int x2, int y2);
The name has to be the same as what it was when you created it

You can change other preferences directly by getting the desired element like this:
mouse.getElementByName(String name).autoCapture = false;
where autocapture can be anything in the HoverableElement class.
autoCapture determines whether the object is automatically catpured or will
the owner do it when it's "ready".

More advanced solutions:

mouse.declareUpdateElement(String name, int priority, int x1, int y1, int x2, int y2);
and
mouse.declareUpdateElement(String name, String ontopof, int x1, int y1, int x2, int y2);
These methods sort-of passively create an element if it doesn't exist and updates otherwise. This is useful if your element moves a lot. --and you're lazy.

mouse.setElementExpire(String name, int expire);
if you want the element to expire after $expire frames. Useful if you don't get any chance to know when a window is closed for example.

Finally, the important things:

mouse.removeElement(String name); for deleting your element.

mouse.isCaptured(String name); for checking if your element gets the capture.

mouse.elmIsHover(String name); for checking if your element is hovered over.
