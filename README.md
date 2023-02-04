## Requirements
1. Install AutoHotKey V1.1:
https://www.autohotkey.com/<br/>

2. Download this codebase:
    - For `TimelineClick()` with example scripts, download this codebase:<br/>
    https://github.com/dumbeau/TimeLineClick
    - For includable `TimelineClick()` function for your own script from the releases section.<br/>
    https://github.com/dumbeau/TimeLineClick/releases/download/v2.0.0/TimelineClick.ahk

## Setup

Video setup:
UPDATE THIS!!!

There are example scripts included for Davinci Resolve, Adobe After Effects, FL Studio and Cavalry.

1. Include `TimelineClick.ahk` into your ahk script<br/>

```autohotkey
#Include, %A_ScriptDir%\TimelineClick.ahk
```  

2. Add an `#IfWinActive` block to limit your function to an application.  Then add your hotkey block with the `TimelineClick()` function inside.<br/>

```autohotkey
;Example using FL Studio
#IfWinActive ahk_exe FL64.exe
{
    w:: ;Change hotkey to desired hotkey
    TimelineClick("\ImageSearch\FL Studio\LeftScroll.png", 30)
    return
}
```


<br/>
3. Enter the parameters for the `TimelineClick()` function.  This takes 2 or 3 parameters.<br/>

#### TimelineClick( images, yOffsets, hold:=false ) <br/>

1. `images` : The image/images filepaths to search the screen for.  Filepath can be local or absolute.  The sourced images should move with the timeline bar when it's resized.<br/>
        - Sourcing images: Find a section of your application's UI that moves with the timeline bar when resized.  Screenshot this section with `Win + Shift + S` and save it where it can be referenced by your script.<br/>
2. `yOffsets` : The vertical distance between the top-left corner of the located image and the vertical clickable region of the timeline.
3. `hold` : OPTIONAL: If true, stop moving the playhead (release LMB) when the hotkey is released.  This is the default value.  If false (default), playhead will only be brought to the cursor position and LMB will be released immediately.<br/>

Here is an example for FL Studio:
```autohotkey    
;Example using FL Studio
#IfWinActive ahk_exe FL64.exe
{
    w::
    TimelineClick("\ImageSearch\FL Studio\LeftScroll.png", 30)
    return
}
```

4. If your application has multiple timelines where you need to check for multiple images, the `images` and `yOffsets` parameters need to be given an array of values.  Here's an example for resolve, which needs to check for 3 different images with 3 corresponding Y-offsets:

```autohotkey
#IfWinActive, ahk_exe Resolve.exe
{
    w::
    TimelineClick(["EditPageTimeline.png", "FairlightClock.png",  "CutPageSplitClip.png"], [45,30,45])
    return
}
```

## Notes
#### Notable features:
- Only the screen the mouse is in will be searched for the images (not just the screen with the active window)
- The function will remember the last position and image searched and check there before looking elsewhere.

## Questions
Post an issue if you've found a bug. Otherwise I made a setup video, written documentation and commented example scripts.  You should look at these.  Chances are nobody will read this and they'll just post a comment on the YouTube video, which is fine.
