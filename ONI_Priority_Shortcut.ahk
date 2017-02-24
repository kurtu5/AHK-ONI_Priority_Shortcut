;
;   Oxygen Not Included Priority Shortcut
;
;   Name: ONI_Priority_Shortcut.ahk 
;   Description:  Tired of hitting P then hunting for a priority to click?  Well just hit Q and type a number.
;
;   Version: 1.0 Author: kurtu5 Date: 2/24/2017
;   Site: http://www.autohotkey.com/
;   License: We don't need no stinking licenses.  Do what you will with it.  
;
;   Todo:  Try and figure a simple way to use the P key.  Also add an option to invert the priority keys so 1=9 and 9=1 as thats closer to Q.
;
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#IfWinActive, Oxygen Not Included
#InstallMouseHook

;;;
;;; Launch training screen at start/reload and define then define the priority button locations
;;;
GoSub !P

!p::
startString = 
( 
This AHK script lets you use P and a number to set a priority without having to click
the numbers in the lower right hand corner.  

Alt-P    - You will need to tell the script where the 1 and 9 priority buttons are, this
           will start that process.
           
Q+Number - This will open the priority screen and let you type a number to set that as a priority.
           
                    Click To Continue
)

selectOne = "Please click in the middle of the 1 box."

selectTwo = "Now please click in the middle of the 9 box."

finishedString = 
(
Now just type Q and a number to set a priority

                    Click To Continue
)

    ;Log("`n`nStart Log`n")
    ButtonLocations := []
  

    UserPopupTip(startString)
    KeyWait, LButton, D
    Sleep 200

    UserPopupTip(selectOne)
    Send P
    KeyWait, LButton, D
    Sleep 200
    MouseGetPos, X, Y
    ButtonLocations[1] := {x: X, y: Y}


    UserPopupTip(selectTwo)
    KeyWait, LButton, D
    Sleep 200
    MouseGetPos, X, Y
    ButtonLocations[9] := {x: X, y: Y}

    UserPopupTip(finishedString)
    KeyWait, LButton, D
    Sleep 200

    UserPopupTip("")
    Send Esc
    ;Log("ButtonLocations[1]=" ButtonLocations[1]["x"] "," ButtonLocations[1]["y"] "`n")
    ;Log("ButtonLocations[9]=" ButtonLocations[9]["x"] "," ButtonLocations[9]["y"] "`n")

    xDelta := ButtonLocations[9]["x"] - ButtonLocations[1]["x"]
    yDelta := ButtonLocations[9]["y"] - ButtonLocations[1]["y"]
    ;Log("xDelta,yDelta=" xDelta "," yDelta "`n")

    newY := ButtonLocations[1]["y"] + yDelta/2  ; Average out the Y centers
    Loop, 9
    {   
        newX := ButtonLocations[1]["x"] + (xDelta/(8))* (a_index-1)  ; Average out the X centers and calc the new locations between 1-9
        ButtonLocations[a_index] := {x: newX, y: newY}
        ;Log("ButtonLocations[" a_index "]=" ButtonLocations[a_index]["x"] "," ButtonLocations[a_index]["y"] "`n")
    }
    Return
  

;;;
;;;  The hotkey binding for P and a number.  You have to hit a number or wait for it to timeout(1.0 seconds) as AHK doesn't have any decent builtins for waiting for a mouse click or a key click.
;;;

q::
    MouseGetPos, oldX, oldY

    ; Wait for number or ignore after 10 seconds
    Input, NumberKey, L1 T10
    ;Log("Number Key pressed = " NumberKey)
   /* If !( (NumberKey >= 1) or (NumberKey <=9) ) 
    {
        UserPopupTip("Invalid Priority Chosen. Please Try Again.")
        Sleep 2000
        UserPopupTip("Invalid Priority Chosen. Please Try Again.")
    }
    */
    Send p
    Sleep 200
    MouseClick Left, ButtonLocations[NumberKey]["x"], ButtonLocations[NumberKey]["y"]

    Sleep 200
    MouseMove, oldX, oldY

Return


;;;
;;;  Debug Log in the same directory as the script.  Uncomment Log lines to get output.
;;;
Log(text) {
   FileAppend, %text%, ONI_Priority_ShortCut_Debuglog.txt
}
    
;;;
;;; User Prompt
;;;
UserPopupTip(text) {
    if (text != "")
        Progress, B2 FS9 ZX10 ZY10 X50 Y100 W500 CTwhite CWgrey, %text%, , , Arial Bold
    else
        Progress, Off
}
UserPopupTipTimeOut:
    SetTimer UserPopupTipTimeOut, Off
    UserPopupTip("")
    Return
    
;;;
;;; Force Script Reload
;;;
!r::
    Reload
#IfWinActive