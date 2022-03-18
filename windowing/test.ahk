#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

n := 5 > 4 ? 3 : 2

msgbox % n
