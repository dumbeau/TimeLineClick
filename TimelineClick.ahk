#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;Example for Davinci Resolve
#IfWinActive ahk_exe Resolve.exe
{
k::
timelineClick([A_ScriptDir . "\Resolve\ImageSearch\EditPageTimelineSettings.png", A_ScriptDir . "\Resolve\ImageSearch\FairlightClock.png",  A_ScriptDir . "\Resolve\ImageSearch\CutPageSplitClip.png"], [[27,17],[14,15],[17,25]], [45,30,45])
Return
}

;Example for FL Studio
#IfWinActive ahk_exe FL64.exe
{
k::
timeLineClick([A_ScriptDir . "\FL Studio\ImageSearch\LeftScroll.png"], [[19,19]], [30])
Return
}



timelineClick(images,imageSizes, yOffsets, hold=True)
{	
	static s_lastImage, s_TagX, s_TagY	
	;convert single properties to array just for funsies
	If !IsObject(images)
		images := [images]
	If !IsObject(imageSizes[1])
		imageSizes := [imageSizes]
	If !IsObject(yOffsets)
		yOffsets := [yOffsets]
		
	
	BlockInput, MouseMove
	MouseGetPos, MouseX, MouseY 
	;Check for image in last position	
	Try
	{
		searchImage := images[s_lastImage]
		Imagesearch, , , s_TagX, s_TagY, (s_TagX+imageSizes[s_lastImage][1]), (s_TagY+imageSizes[s_lastImage][2]), %searchImage%		
		if ErrorLevel > 0
			throw
	}
	catch e 
	{
		;look everywhere for all the images        
		for image in images
			{
			searchImage := images[image]
			ImageSearch, s_TagX, s_TagY, 0, 15, %A_ScreenWidth%, %A_ScreenHeight%, %searchImage%
			if ErrorLevel > 0
				continue
			else
				{
				;Success
				s_lastImage := image
				break
				}
		If ErrorLevel > 0
			{
			msgbox, Couldn't find reference image.
			Return
			}
			}
	}
	MouseClick, Left, MouseX, s_TagY + yOffsets[s_lastImage], ,0, D
	MouseMove, MouseX, MouseY, 0
	BlockInput, MouseMoveOff
	if (hold == True)
		keywait, %A_ThisHotkey%
	Click, up
Return
}