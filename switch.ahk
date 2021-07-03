#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


Global tClass:="SysShadow,Alternate Owner,tooltips_class32,DummyDWMListenerWindow,EdgeUiInputTopWndClass,ApplicationFrameWindow,TaskManagerWindow,Qt5QWindowIcon,Windows.UI.Core.CoreWindow,WorkerW,Progman,Internet Explorer_Hidden,Shell_TrayWnd" ; HH Parent


RWin Up::
    Loop
        Send,{LAlt down}{Esc}{LAlt up}
    Until WindowIsVisible()
Return

Control::
    loop
        Send,{LAlt down}{RShift Down}{Esc}{RShift Up}{LAlt up}
    Until WindowIsVisible()
Return

WindowIsVisible() {
    WinGet, hwnd, id, A
    WinGetClass, cClass, ahk_id %hwnd%
    if !DllCall("IsWindowVisible", UPtr,hwnd) || IsWindowCloaked(hwnd) || InStr(tClass, cClass, 1)
        Return 0
    WinActivate, ahk_id %hwnd%
    Return 1
}

IsWindowCloaked(hwnd) {
    return DllCall("dwmapi\DwmGetWindowAttribute", "ptr",hwnd, "int",14, "int*",cloaked, "int",4) >= 0
        && cloaked
}

LWin & F1::ExitApp