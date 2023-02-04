#NoEnv ;Script performance: https://www.autohotkey.com/docs/v1/misc/Performance.htm
SetBatchLines -1
ListLines Off
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr") ;This makes screen coordinates work across monitors with different system scal.
#Requires AutoHotKey v1.1 ;Sorry I'd make it work for v2 but I'm lazy.
;###############################################################################
; FUNCTION				TimelineClick
; DESCRIPTION			Move a playhead in any timeline to the cursor's position.  
;
; PARAMETERS:
; images				Filepath to the image to search the screen for, can be local or absolute.
;						This image should move vertically with the timeline bar.
; yOffests				The vertical distance between the top-left corner of the located image and the vertical clickable region of the timeline.
; hold					OPTIONAL PARAMETER: If true, stop moving the playhead (release LMB) when the hotkey is released.  This is the default value.
;						If false, playhead will only be brought to the cursor position and LMB will be released immediately.				
;###############################################################################

TimelineClick(images, yOffsets, hold=True){

	bareKey := TC_StripModifierCharacters(A_ThisHotkey)	

	hotkeyContainsModifiers := (bareKey != A_ThisHotkey) ? true : false
	if (hotkeyContainsModifiers){
		; Msgbox, % bareKey
		Hotkey, If 
		HotKey, % bareKey, TC_Block, On
	}
	static g_MonitorManager
	if !g_MonitorManager
		g_MonitorManager := New TC_MonitorManager
	CoordMode, Pixel, Screen
	CoordMode, Mouse, Screen	
	
	static s_lastImage, s_TagX, s_TagY, s_ImageSize, s_MonIndex	

	;convert single properties to array just for funsies
	If !IsObject(images)
		images := [images]
	If !IsObject(yOffsets)
		yOffsets := [yOffsets]	


	for image in images {
		thisImage := images[image]		
		if (SubStr(thisImage, 1, 1) == "\"){			
			images[image] := A_WorkingDir . thisImage	
		}
	}	
	imageSizes := []
    for image in images
    {		
        thisImage := images[image]			
        dimensions := TC_FGP_Value(thisImage, TC_FGP_Num("Dimensions"))
		dimensions := StrSplit(dimensions, " ")
		dimensions := [RegExReplace(dimensions[1], "\D"), RegExReplace(dimensions[3], "\D")]		
        imageSizes.push(dimensions)
    }

	monDimensions := TC_GetActiveMonitorDimensions(g_MonitorManager) ;This allows this to work properly with multiple displays	
	; msgbox, % monDimensions.scaleX

	BlockInput, MouseMove
	MouseGetPos, MouseX, MouseY 	
	Try ;Check for image in last position
	{
		if monDimensions.index != s_MonIndex
		{			
			s_MonIndex := monDimensions.index		
			throw
		}		
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
			ImageSearch, s_TagX, s_TagY, monDimensions.left, monDimensions.top, monDimensions.right, monDimensions.bottom, %searchImage%
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
		KeyWait, % bareKey
	if (hotkeyContainsModifiers){
		Hotkey, If 
		HotKey, % bareKey, Off
	}	

	Click, up
	Return
}

;Helper Functions for timeline click
TC_Block(){
	return
}
TC_StripModifierCharacters(var, chars="+^!#")
	{
	   stringreplace,var,var,%A_space%,_,a
	   loop, parse, chars,
	      stringreplace,var,var,%A_loopfield%,,a
	   return var
	}

TC_GetActiveMonitorDimensions(monitorManagerObj)
	{	
	if (substr(a_osversion, 1, 2) = "10")
	{	
	;detemine what monitor the mouse is in and scale factor
	; pieDPIScale := 1
	
	MouseGetPos, mouseX, mouseY
	; getActiveMonitorDPI([mouseX, mouseY])
	; bottomRight := [A_ScreenWidth,A_ScreenHeight]
	for monIndex in monitorManagerObj.monitors
		{		
		if (mouseX >= monitorManagerObj.monitors[monIndex].left and mouseX <= monitorManagerObj.monitors[monIndex].right)
			{			
			; msgbox, % PieOpenLocX " is apparently between " monitorManagerObj.monitors[monIndex].left " and " monitorManagerObj.monitors[monIndex].right
			if (mouseY >= monitorManagerObj.monitors[monIndex].top and mouseY <= monitorManagerObj.monitors[monIndex].bottom)
				{
				; monitorDimensions := [monitorManagerObj.monitors[monIndex].left, monitorManagerObj.monitors[monIndex].right, monitorManagerObj.monitors[monIndex].top, monitorManagerObj.monitors[monIndex].bottom, monIndex]
				monitorDimensions := monitorManagerObj.monitors[monIndex]
				monitorDimensions.index := monIndex
				; bottomRight := [monitorManagerObj.monitors[monIndex].right,monitorManagerObj.monitors[monIndex].bottom]				
				break			
				}
			}
		}
	}
	; return bottomRight
	return monitorDimensions
	}


TC_FGP_Init() {
	
	static PropTable
	if (!PropTable) {
		PropTable := {Name: {}, Num: {}}, Gap := 0
		oShell := ComObjCreate("Shell.Application")
		oFolder := oShell.NameSpace(0)
		while (Gap < 11)
			if (PropName := oFolder.GetDetailsOf(0, A_Index - 1)) {
				PropTable.Name[PropName] := A_Index - 1
				PropTable.Num[A_Index - 1] := PropName
				Gap := 0
			}
			else
				Gap++
	}
	return PropTable
}
TC_FGP_Value(FilePath, Property) {
	static PropTable := TC_FGP_Init()
	if ((PropNum := PropTable.Name[Property] != "" ? PropTable.Name[Property]
	: PropTable.Num[Property] ? Property : "") != "") {
		SplitPath, FilePath, FileName, DirPath
		oShell := ComObjCreate("Shell.Application")
		oFolder := oShell.NameSpace(DirPath)
		oFolderItem := oFolder.ParseName(FileName)
		if (PropVal := oFolder.GetDetailsOf(oFolderItem, PropNum))
			return PropVal
		return 0
	}
	return -1
}
TC_FGP_Num(PropName) {
	static PropTable := TC_FGP_Init()
	if (PropTable.Name[PropName] != "")
		return PropTable.Name[PropName]
	return -1
}

class TC_MonitorManager {
  __New() {
    ;; enum _PROCESS_DPI_AWARENESS    
	PROCESS_DPI_UNAWARE := 0
    PROCESS_SYSTEM_DPI_AWARE := 1
    PROCESS_PER_MONITOR_DPI_AWARE := 2
    ; DllCall("SHcore\SetProcessDpiAwareness", "UInt", PROCESS_PER_MONITOR_DPI_AWARE)
    ;; InnI: Get per-monitor DPI scaling factor (https://www.autoitscript.com/forum/topic/189341-get-per-monitor-dpi-scaling-factor/?tab=comments#comment-1359832)
    DPI_AWARENESS_CONTEXT_UNAWARE := -1
    DPI_AWARENESS_CONTEXT_SYSTEM_AWARE := -2
    DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE := -3
    DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 := -4
    DllCall("User32\SetProcessDpiAwarenessContext", "UInt" , DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE)
    ;; pneumatic: -DPIScale not working properly (https://www.autohotkey.com/boards/viewtopic.php?p=241869&sid=abb2db983d2b3966bc040c3614c0971e#p241869)
    
    ptr := A_PtrSize ? "Ptr" : "UInt"
    this.monitors := []
    DllCall("EnumDisplayMonitors", ptr, 0, ptr, 0, ptr, RegisterCallback("TC_MonitorEnumProc", "", 4, &this), "UInt", 0)
    ;; Solar: SysGet incorrectly identifies monitors (https://autohotkey.com/board/topic/66536-sysget-incorrectly-identifies-monitors/)
  }
}
TC_MonitorEnumProc(hMonitor, hdcMonitor, lprcMonitor, dwData) {
  l := NumGet(lprcMonitor + 0,  0, "Int")
  t := NumGet(lprcMonitor + 0,  4, "Int")
  r := NumGet(lprcMonitor + 0,  8, "Int")
  b := NumGet(lprcMonitor + 0, 12, "Int")
  
  this := Object(A_EventInfo)
  ;; Helgef: Allow RegisterCallback with BoundFunc objects (https://www.autohotkey.com/boards/viewtopic.php?p=235243#p235243)
  this.monitors.push(New TC_Monitor(hMonitor, l, t, r, b))
  
	Return, 1
}
class TC_Monitor {
  __New(handle, left, top, right, bottom) {
    ;When compiled with true/pm these values are based on real pixel coordinates without scaling.
	this.handle := handle
    this.left   := left
    this.top    := top
    this.right  := right
    this.bottom := bottom
    
    this.x      := left
    this.y      := top
    this.width  := right - left
    this.height := bottom - top
	this.center := [this.x + (this.width/2),this.y + (this.height/2)]

	; dpi := this.getDpiForMonitor()	
	; this.dpiX := dpi.x
    ; this.dpiY := dpi.y
    ; this.scaleX := this.dpiX / 96
   	; this.scaleY := this.dpiY / 96	
  }
;   getDpiForMonitor() {
; 	;; enum _MONITOR_DPI_TYPE
; 	MDT_EFFECTIVE_DPI := 0
; 	MDT_ANGULAR_DPI := 1
; 	MDT_RAW_DPI := 2
; 	MDT_DEFAULT := MDT_EFFECTIVE_DPI
; 	ptr := A_PtrSize ? "Ptr" : "UInt"
; 	dpiX := dpiY := 0
; 	DllCall("SHcore\GetDpiForMonitor", ptr, this.handle, "Int", MDT_DEFAULT, "UInt*", dpiX, "UInt*", dpiY)	
; 	Return, {x: dpiX, y: dpiY}
; 	}

}