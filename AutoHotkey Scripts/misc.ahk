; Minimize a window to taskbar while maintaing win + down for tiling
#+down:: WinMinimize, A
; Maximize a window to taskbar while maintaining win + up for tiling
#+up:: WinMaximize, A
;Mouse Alt-Tab functionality
;MButton::AltTabMenu
;WheelDown::AltTab
;WheelUp::ShiftAltTab

::my favorite person in the world::puj


;Run in background desktop
^F3::
InputBox, UserInput, Open in background desktop,Enter a command to run in a new desktop,,400,100
If ErrorLevel
	{}
Else
	Run, %COMSPEC% /c ""C:\Program Files (x86)\VDesk\VDesk.exe" "run:%UserInput%"",,hide
return

#Space:: Return

;Toggle the taskbar
#t::
   WinGet,var,Style,ahk_class Shell_TrayWnd

   if (var & 0x10000000){
      
      WinHide, ahk_class Shell_TrayWnd
      ;Run,tbset win hide class Shell_TrayWnd
   }
   else {
      WinShow, ahk_class Shell_TrayWnd
      ;Run,tbset win show class Shell_TrayWnd
      WinActivate, ahk_class Shell_TrayWnd
   }
;    Run tbset win togglehide class Shell_TrayWnd
;    WinActivate, ahk_class Shell_TrayWnd
Return

;Restart Explorer.exe
^!#F1::Run,exploreAgain.bat

;Mapping LWin to Fluent Search, but leaving lwin modified
;shortcuts as is. i.e win + L still locks the PC.




