#NoEnv ;Script performance: https://www.autohotkey.com/docs/v1/misc/Performance.htm
SetBatchLines -1
ListLines Off
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;Import the TimelineClick function into this script.
#Include, %A_ScriptDir%\lib\TimelineClick.ahk

;TimelineClick for Adobe After Effects
#IfWinActive, ahk_exe AfterFX.exe
{
    w:: ;Change hotkey to desired hotkey: https://www.autohotkey.com/docs/v1/Hotkeys.htm
    TimelineClick("\ImageSearch\After Effects\Flowchart-100pct.png", 8)    
    return
}

;TimelineClick for Davinci Resolve
#IfWinActive, ahk_exe Resolve.exe ;Limit declared hotkeys in this block to this executable.
{
    w:: ;Change hotkey to desired hotkey
        ; Resolve v18
    ; TimelineClick(["\ImageSearch\Resolve\18\EditPageTimelineSettings.png", "\ImageSearch\Resolve\18\FairlightClock.png",  "\ImageSearch\Resolve\18\CutPageSplitClip.png"], [65,30,45])
    ;Resolve v19
    TimelineClick(["\ImageSearch\Resolve\19\EditPageTimelineSettings.png", "\ImageSearch\Resolve\19\CutPageHamburger.png"], [65, 45])
    return
}

;TimelineClick for FL Studio
#IfWinActive ahk_exe FL64.exe
{
    w:: ;Change hotkey to desired hotkey
    TimelineClick("\ImageSearch\FL Studio\LeftScroll.png", 30)
    return
}

;TimelineClick for Cavalry (really cool After Effects alternative)
#IfWinActive, ahk_exe Cavalry.exe
{
    w::  ;Change hotkey to desired hotkey
    TimelineClick(["\ImageSearch\Cavalry\100pct-F-Timeline.png","\ImageSearch\Cavalry\150pct-F-Timeline.png"], [8,8])
    return
}
