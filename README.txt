1. Make sure you have AutoHotKey installed:
https://www.autohotkey.com/

2. Download timelineClick() function from my GitHub:
https://github.com/UnBOlievable/MyAHKScripts/tree/master/TimelineClick

3. Copy the function into a new AHK script (or use one of the example scripts).

4. If using on a new program, acquire reference images for the function to look for, must be a graphic that moves with the timeline.  Save this image next to or in a folder next to the script.  I already have the images for Resolve and FL Studio in the examples.

5. Fill in the function parameters. 
	- First is the pointer to the reference image, refer to the example.
	- Next is the size of the image
	- Then the yOffset of the timeline from the top-left corner of the reference image
	- Last is an optional parameter for whether the function should click and hold while the hotkey is pressed (True/False)

Parameters can be listed as arrays if one program has more than one timeline to be interfaced with like Resolve.

Just open up the .ahk scripts in a text editor and you should be able to follow what's happening and adapt it to your needs.








