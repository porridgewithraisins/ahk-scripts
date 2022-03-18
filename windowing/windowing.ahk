#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
ListLines Off
SetBatchLines -1
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
#KeyHistory 0
#WinActivateForce

Process, Priority,, H

SetWinDelay -1
SetControlDelay -1

#Include, VD.ahk

VD.createUntil(9, false)

prevDesktop := VD.getCurrentDesktopNum()

statefulGoToDesktopNum(num){
    global
    if(num != VD.getCurrentDesktopNum()){
        prevDesktop := VD.getCurrentDesktopNum()
        VD.goToDesktopNum(num)
    }
}

goToPreviousDesktop(){
    global
    statefulGoToDesktopNum(prevDesktop)
}

statefulGoToLeftDesktop(){
    global
    local n := VD.getCount()
    local num := VD.getCurrentDesktopNum()
    if(num > 1){
        statefulGoToDesktopNum(num - 1)
    } else {
        statefulGoToDesktopNum(n)
    }
}

statefulGoToRightDesktop(){
    global
    local n := VD.getCount()
    local num := VD.getCurrentDesktopNum()
    if(num < n){
        statefulGoToDesktopNum(num + 1)
    } else {
        statefulGoToDesktopNum(1)
    }
}

#1::statefulGoToDesktopNum(1)
#2::statefulGoToDesktopNum(2)
#3::statefulGoToDesktopNum(3)
#4::statefulGoToDesktopNum(4)
#5::statefulGoToDesktopNum(5)
#6::statefulGoToDesktopNum(6)
#7::statefulGoToDesktopNum(7)
#8::statefulGoToDesktopNum(8)
#9::statefulGoToDesktopNum(9)

#+1::VD.MoveWindowToDesktopNum("A", 1), statefulGoToDesktopNum(1)
#+2::VD.MoveWindowToDesktopNum("A", 2), statefulGoToDesktopNum(2)
#+3::VD.MoveWindowToDesktopNum("A", 3), statefulGoToDesktopNum(3)
#+4::VD.MoveWindowToDesktopNum("A", 4), statefulGoToDesktopNum(4)
#+5::VD.MoveWindowToDesktopNum("A", 5), statefulGoToDesktopNum(5)
#+6::VD.MoveWindowToDesktopNum("A", 6), statefulGoToDesktopNum(6)
#+7::VD.MoveWindowToDesktopNum("A", 7), statefulGoToDesktopNum(7)
#+8::VD.MoveWindowToDesktopNum("A", 8), statefulGoToDesktopNum(8)
#+9::VD.MoveWindowToDesktopNum("A", 9), statefulGoToDesktopNum(9)

^#+1::VD.MoveWindowToDesktopNum("A", 1)
^#+2::VD.MoveWindowToDesktopNum("A", 2)
^#+3::VD.MoveWindowToDesktopNum("A", 3)
^#+4::VD.MoveWindowToDesktopNum("A", 4)
^#+5::VD.MoveWindowToDesktopNum("A", 5)
^#+6::VD.MoveWindowToDesktopNum("A", 6)
^#+7::VD.MoveWindowToDesktopNum("A", 7)
^#+8::VD.MoveWindowToDesktopNum("A", 8)
^#+9::VD.MoveWindowToDesktopNum("A", 9)

^#Left::statefulGoToLeftDesktop()
^#Right::statefulGoToRightDesktop()

#q::goToPreviousDesktop()

#c::WinClose, A

