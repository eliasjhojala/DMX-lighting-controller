#FixturesArray

The FixturesArray -class is an originally ArrayList, but now TreeMap wrapper for the Fixture class. It provides a nice interface (no, not Java Interface :smile:) for the TreeView -class tailored to the needs of this software.

##Functions
####Collection< fixture > iterate()
Returns an iterable collection of all the fixtures contained in this instance.

####Set< Map.Entry< Integer, fixture > > iterateIDs()
Returns an iterable Set of Map.Entries, which provide both the id of the fixture, and the fixture itself.
You can retrieve the ID, or the fixture with Entry.getKey() and Entry.getValue() respectively.
**Notice: There is a bug in Processing (atleast 2.x), where using the diamond symbol (_<Classes here..._>) doesn't work with indirectly referenced classes, ie Map.Entry, so I have imported java.util.Map.Entry as well.**

####void add(fixture newFix)
Adds a fixture to the map with an automatically generated ID.

####void set(int id, fixture newFix)
Adds or replaces a fixture with the specified ID. _Will replace existing!_

####void remove(int id)
Removes a fixture with the specified ID.

####fixture get(int id)
Gets a fixture at this position. If none found, will return dummyFixture, which is a plain fixture with its isDrawn set to false.

####int size()
Returns the size of the map according to its highest ID.

####int mapSize()
Returns the actual size of the map.

####void clear()
Clears the map. **Removes _ALL_ fixtures!**


##How to iterate (specific to [this](https://github.com/eliasjhojala/DMX-lighting-controller) project)
Since FixturesArray implements Iterable, the simplest way of iterating through it is:
```processing
for(fixture fix : FixtureArray) {
  //code here...
}
```
Where the iterated is usually `fixtures`.

You can also use `FixtureArray.iterate()`, but this is deprecated, and is technically exactly the same as just `FixtureArray`.

However, the methods above don't provide access to the ID of the fixture. In order to accomplish that, you can use:
```processing
for(Entry<Integer, fixture> entry : FixtureArray.iterateIDs()) {
  int i = entry.getKey();
  fixture fix = entry.getValue();
  
  //code here...
}
```
Now, the ID of the fixture is contained in the variable `i` and the fixture is contained in the variable `fix`.

_Please note that I have specifically imported java.util.Map.Entry to circumvent a bug in Processing (as mentioned above), while the normal procedure is to use Map.Entry._
