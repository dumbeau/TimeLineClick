#NoEnv ;Script performance: https://www.autohotkey.com/docs/v1/misc/Performance.htm
SetBatchLines -1
ListLines Off
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%

;Import the TimelineClick function into this script.
#Include, %A_ScriptDir%\lib\TimelineClick.ahk

;Set modifier key to enable macros.  This example is the "Back" or 4th mouse button.
InputMod := 0
*XButton1::
	InputMod := 1
Return
*XButton1 up::
	InputMod := 0
Return

;TimelineClick for Adobe After Effects
#If InputMod == 1 && WinActive("ahk_exe AfterFX.exe")
{
    LButton:: ;Change hotkey to desired hotkey: https://www.autohotkey.com/docs/v1/Hotkeys.htm
    TimelineClick("\ImageSearch\After Effects\Flowchart-100pct.png", 8)
    return
}

;TimelineClick for Davinci Resolve
#If InputMod == 1 && WinActive("ahk_exe Resolve.exe") ;Limit declared hotkeys in this block to this executable when InputMod == 1
{
    LButton:: ;Change hotkey to desired hotkey, this means you will have to hold the "Back" button down and press LMB
    TimelineClick(["\ImageSearch\Resolve\EditPageTimelineSettings.png", "\ImageSearch\Resolve\FairlightClock.png",  "\ImageSearch\Resolve\CutPageSplitClip.png"], [45,30,45])
    return
}

;TimelineClick for FL Studio
#If InputMod == 1 && WinActive("ahk_exe FL64.exe")
{
    LButton:: ;Change hotkey to desired hotkey
    TimelineClick("\ImageSearch\FL Studio\LeftScroll.png", 30)
    return
}

;TimelineClick for Cavalry (really cool After Effects alternative)
#If InputMod == 1 && WinActive("ahk_exe Cavalry.exe")
{
    LButton::  ;Change hotkey to desired hotkey
    TimelineClick(["\ImageSearch\Cavalry\100pct-F-Timeline.png","\ImageSearch\Cavalry\150pct-F-Timeline.png"], [8,8])
    return
}