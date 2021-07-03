#NoEnv
#singleinstance off
SendMode input
SetTitleMatchMode, 1
SetBatchLines, -1
SetMouseDelay, -1

;_____________________________________________________________________________________________
;________ basic variables ____________________________________________________________________


cells =
loop, 9
{
	row = %a_index%
	loop, 9
	{
		column = %a_index%
		cells = %cells%-%row%%column%
		cell%row%%column% = 0
		highlight%row%%column% = 0
		loop, 9
			PencilMark%row%%column%%a_index% = 0
	}
}
cells := SubStr(cells, 2)

unit1 = 11-12-13-14-15-16-17-18-19	; rows
unit2 = 21-22-23-24-25-26-27-28-29
unit3 = 31-32-33-34-35-36-37-38-39
unit4 = 41-42-43-44-45-46-47-48-49
unit5 = 51-52-53-54-55-56-57-58-59
unit6 = 61-62-63-64-65-66-67-68-69
unit7 = 71-72-73-74-75-76-77-78-79
unit8 = 81-82-83-84-85-86-87-88-89
unit9 = 91-92-93-94-95-96-97-98-99
unit10 = 11-21-31-41-51-61-71-81-91	; columns
unit11 = 12-22-32-42-52-62-72-82-92
unit12 = 13-23-33-43-53-63-73-83-93
unit13 = 14-24-34-44-54-64-74-84-94
unit14 = 15-25-35-45-55-65-75-85-95
unit15 = 16-26-36-46-56-66-76-86-96
unit16 = 17-27-37-47-57-67-77-87-97
unit17 = 18-28-38-48-58-68-78-88-98
unit18 = 19-29-39-49-59-69-79-89-99
unit19 = 11-12-13-21-22-23-31-32-33	; blocks
unit20 = 14-15-16-24-25-26-34-35-36
unit21 = 17-18-19-27-28-29-37-38-39
unit22 = 41-42-43-51-52-53-61-62-63
unit23 = 44-45-46-54-55-56-64-65-66
unit24 = 47-48-49-57-58-59-67-68-69
unit25 = 71-72-73-81-82-83-91-92-93
unit26 = 74-75-76-84-85-86-94-95-96
unit27 = 77-78-79-87-88-89-97-98-99

loop, parse, cells, -
{
	rc = %a_loopfield%
	loop, 27
		if (a_index >= 19 and InStr(unit%a_index%, rc))
	{
		block%rc% = %a_index%
		break
	}
}

loop, parse, cells, -
{
	rc = %a_loopfield%
	CrossRoads%rc% =
	r := SubStr(rc, 1, 1)
	c := SubStr(rc, 2, 1)+9
	b := block%rc%
	RowColumn := unit%r% . "-" . unit%c%
	loop, parse, RowColumn, -
		if InStr(unit%b%, a_loopfield)
			CrossRoads%rc% := CrossRoads%rc% . "-" . a_loopfield
	CrossRoads%rc% := SubStr(CrossRoads%rc%, 2)
	CrossRoads%rc%r = %r%
	CrossRoads%rc%c = %c%
}

loop, parse, cells, -
{
	rc = %a_loopfield%
	string =
	loop, 27
		ifinstring, unit%a_index%, %rc%
			loop, parse, unit%a_index%, -
				if a_loopfield <> %rc%
				ifnotinstring, string, %a_loopfield%
					string = %string%%a_loopfield%-
	stringtrimright, ConnectedCells%rc%, string, 1
}

color1name = white
color1value = white
color2name = yellow
color2value = yellow
color3name = orange
color3value = ff8040
color4name = red
color4value = red
color5name = purple
color5value = purple
color6name = blue
color6value = blue
color7name = light blue
color7value = aqua
color8name = green
color8value = green
color9name = black
color9value = black

cBackground1 = FFFFFF  ; background color for numbers
cBackground2 = DDEEFF  ; background color for colors
cBackground = %cBackground1%

cNumber =
loop, 9
{
	row = %a_index%
	loop, 9
	{
		column = %a_index%
		cNumber%row%%column% =
	}
}


wCell1 = 80
sNumber1 = 50
sColor1 = 54
sHighlight1 = 60
wPencilMark1 = 22
sPencilNumber1 = 14
sPencilColor1 = 12
wCaption1 = 40
sCaption1 = 20

PlusMinus = 0
switch = numbers

HistoryIndex = 0
HistoryIndexMax = 0
string = numbers-FFFFFF-
history(string)

;_____________________________________________________________________________________________
;________ GUI ________________________________________________________________________________


gui, 1:-DPIScale
if (a_screendpi > 96)
{
	sNumber1 := sNumber1*96//a_screendpi
	sColor1 := sColor1*96//a_screendpi
	sHighlight1 := sHighlight1*96//a_screendpi
	sPencilNumber1 := sPencilNumber1*96//a_screendpi
	sPencilColor1 := sPencilColor1*96//a_screendpi
}
if (a_screenheight < 10*wCell1)
	PlusMinus -= 1

loop
{
	winTitle = Sudoku %A_Index%
	IfWinNotExist, %winTitle%
		break
}
GroupAdd, SudokuWindows, %winTitle%

menu, SudokuMenu, add, &Easy and symmetrical, easy
menu, SudokuMenu, add, &Difficult but not symmetrical, difficult
menu, SudokuMenu, add, &Open..., open
menu, SudokuMenu, add, &Fix/unfix, FixUnfix
menu, SudokuMenu, add, &Save as..., SaveAs
menu, SudokuMenu, add  ; separator line
menu, SudokuMenu, add, house
menu, SudokuMenu, add, tree, tree
menu, SudokuMenu, add, autumn tree, AutumnTree
menu, SudokuMenu, add, fir trees, FirTrees
menu, SudokuMenu, add, Christmas tree, ChristmasTree
menu, SudokuMenu, add, spiral
menu, SudokuMenu, add, crown
menu, SudokuMenu, add, sun
menu, SudokuMenu, add, smiley
menu, SudokuMenu, add, heart
menu, SudokuMenu, add  ; separator line
menu, SudokuMenu, add, &Create from image..., create

menu, ViewMenu, add, &Larger	+, larger
menu, ViewMenu, add, &Smaller	-, smaller
menu, ViewMenu, add, &Color numbers	Ctrl+C, ColorNumbers
menu, ViewMenu, add, S&witch between numbers and colors, switch

menu, SolveMenu, add, Find &one	Ctrl+page down, FindOne
menu, SolveMenu, add, Find &all, FindAll

menu, PlayMenu, add, &Back	page up, back
menu, PlayMenu, add, &Forward	page down, forward
menu, PlayMenu, add, &All pencil marks, AllPencilMarks
menu, PlayMenu, add, &Pencil marks only for singles and pairs, HintPencilMarks
menu, PlayMenu, add, &Remove pencil marks, RemovePencilMarks
menu, PlayMenu, add, &Clear board, ClearBoard

menu, MenuBar, add, &Sudoku, :SudokuMenu
menu, MenuBar, add, &View, :ViewMenu
menu, MenuBar, add, &Play, :PlayMenu
menu, MenuBar, add, S&olve, :SolveMenu
menu, MenuBar, add, &Help, help

gui, 1:menu, MenuBar

menu, LeftMouseMenu, add
menu, RightMouseMenu, add

loop, parse, cells, -
{
	gui, 1:add, text, vGridCell%a_loopfield% -background, g
	; G in Webdings makes the grid. Without Webdings, -background makes the grid.
	gui, 1:add, text, vhighlight%a_loopfield%
	gui, 1:add, text, vcell%a_loopfield% +center backgroundtrans
	loop, 9
		gui, 1:add, text, vPencilMark%a_loopfield%%a_index% +center backgroundtrans
}
caption123 = 1-2-3-4-5-6-7-8-9
loop, parse, caption123, -
	gui, 1:add, text, vcaption123%a_loopfield% +center
captionABC = A-B-C-D-E-F-G-H-I
loop, parse, captionABC, -
	gui, 1:add, text, vcaptionABC%a_loopfield% +center

gosub CellsSize
gui, 1:color, %cBackground%
gui, 1:show, w%wGui% h%wGui%, %winTitle%  ; GuiSize is launched

today = %A_MM%%A_DD%
if (today >= 1224 or today <= 0106)
	gosub ChristmasTree

return

;_____________________________________________________________________________________________
;________ gui events _________________________________________________________________________


GuiClose:
something = 0
loop, parse, cells, -
{
	if (cell%a_loopfield% <> 0)
		something += 1
	else loop, 9
		if (PencilMark%a_loopfield%%a_index% = 1)
			something += 1
}
if something > 3
{
	msgbox, 0x2003,, Do you want to save the current situation?
	IfMsgBox Yes
		gosub SaveAs
	IfMsgBox Cancel
		return
}
exitapp

;---------------------------------------------------------------------------------------------

GuiSize:
wingetpos,,,, winheight, %winTitle% ahk_class AutoHotkeyGUI
hTitleMenu := winheight-a_guiheight
return

;_____________________________________________________________________________________________
;________ keyboard hotkeys ___________________________________________________________________


; ---- get a color for numbers ---------------------------------------------------------------

^!lbutton::
mousegetpos, x, y
pixelgetcolor, cNumber, x, y, RGB
return

; --------------------------------------------------------------------------------------------

#ifwinactive ahk_group SudokuWindows ahk_class AutoHotkeyGUI

~Esc::
tooltip
if guitip = 1
{
	gui, 5:destroy
	guitip = 0
}
return

;---- move the mouse cursor ------------------------------------------------------------------

~left::
~right::
~up::
~down::
stringtrimleft, key, a_thishotkey, 1
if key = left
{
	hor = -1
	ver = 0
}
else if key = right
{
	hor = 1
	ver = 0
}
else if key = up
{
	hor = 0
	ver = -1
}
else if key = down
{
	hor = 0
	ver = 1
}
mousegetpos x0, y0
xm := x0 + hor*wCell
ym := y0 + ver*wCell
gosub xyGetNearestCell
if (x0 <> xcenter or y0 <> ycenter)
	click %xcenter%, %ycenter%, 0
return

;---- set numbers/colors ---------------------------------------------------------------------

1::
2::
3::
4::
5::
6::
7::
8::
9::
numpad1::
numpad2::
numpad3::
numpad4::
numpad5::
numpad6::
numpad7::
numpad8::
numpad9::
stringright, n, a_thislabel, 1
if CreateIndex = 4
	gosub swap
else ifnotinstring, fixed, %rm%%cm%
{
	gosub MouseGetNearestCell
	valid = 1
	loop, parse, ConnectedCells%rm%%cm%, -
		if (cell%a_loopfield% = n)
		{
			valid = 0
			break
		}
	if valid = 1
	{
		fill(rm . cm, n)
		loop, parse, ConnectedCells%rm%%cm%, -
			PencilMark(a_loopfield, n, 0)
		HintPencilMarks("refresh")
		history("gui")
	}
	else
	{
		fixed  = %fixed%-%rm%%cm%
		fill(rm . cm, n)
		history("gui")
		sleep 200
		back(0)
		del := HistoryIndex + 1
		history%del% =
		HistoryIndexMax = %HistoryIndex%
		stringtrimright, fixed, fixed, 3
	}
}
return

swap:
if swap1 =
	swap1 = %n%
else if (n = swap1)
{
	swap1 =
	tooltip
}
else
{
	swap2 = %n%
	tooltip
	loop, parse, cells, -
	{
		if (cell%a_loopfield% = swap1)
			fill(a_loopfield, swap2)
		else if (cell%a_loopfield% = swap2)
			fill(a_loopfield, swap1)
	}
	history("gui")
	swap1 =
	swap2 =
}
return

;---- color numbers --------------------------------------------------------------------------

^v::
if (switch = "numbers" and cNumber <> "")
{
	gosub MouseGetNearestCell
	if (cell%rm%%cm% <> 0)
	{
		gui, 1:font, c%cNumber% s%sNumber%
		gui, 1:font,, Ubuntu
		gui, 1:font,, Arial
		guicontrol, 1:font, cell%rm%%cm%
		cNumber%rm%%cm% = %cNumber%
	}
}
return

;---- set/delete pencil marks ----------------------------------------------------------------

+1::  ; set/delete a single pencil mark
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
+numpad1::
+numpad2::
+numpad3::
+numpad4::
+numpad5::
+numpad6::
+numpad7::
+numpad8::
+numpad9::
gosub MouseGetNearestCell
stringright, n, a_thislabel, 1
if cell%rm%%cm% = 0
{
	if PencilMark%rm%%cm%%n% = 0
	{
		valid = 1
		loop, parse, ConnectedCells%rm%%cm%, -
			if (cell%a_loopfield% = n)
			{
				valid = 0
				break
			}
		if valid = 1
		{
			PencilMark(rm . cm, n, 1)
			history("gui")
		}
		else
		{
			cell%rm%%cm% = x
			PencilMark(rm . cm, n, 1)
			history("gui")
			sleep 200
			back(0)
			del := HistoryIndex + 1
			history%del% =
			HistoryIndexMax = %HistoryIndex%
			cell%rm%%cm% = 0
		}
	}
	else
	{
		PencilMark(rm . cm, n, 0)
		history("gui")
	}
}
return

p::  ; set/delete all pencil marks from one cell
if CreateIndex = 1
{
	gosub MouseGetNearestCell
	fill(rm . cm, 0)
	loop, 9
	{
		i = %a_index%
		valid = 1
		loop, parse, ConnectedCells%rm%%cm%, -
			if (cell%a_loopfield% = i)
			{
				valid = 0
				break
			}
		if valid = 1
			PencilMark(rm . cm, i, 1)
	}
	history("gui")
}
return

del & 1::  ; delete one pencil mark from all cells
del & 2::
del & 3::
del & 4::
del & 5::
del & 6::
del & 7::
del & 8::
del & 9::
del & numpad1::
del & numpad2::
del & numpad3::
del & numpad4::
del & numpad5::
del & numpad6::
del & numpad7::
del & numpad8::
del & numpad9::
if CreateIndex = 1
{
	stringright, n, a_thislabel, 1
	loop, parse, cells, -
		PencilMark(a_loopfield, n, 0)
	history("gui")
}
return

;---- delete number/color/pencil marks from one cell -----------------------------------------

space::
gosub MouseGetNearestCell
if cell%rm%%cm% <> 0
ifinstring, fixed, %rm%%cm%
	return
fill(rm . cm, 0)
history("gui")
return

;_____________________________________________________________________________________________
;________ mouse hotkeys ______________________________________________________________________


;---- set and delete numbers and colors and pencil marks -------------------------------------

~lbutton::
gosub MouseGetNearestCell
wingetpos,,, width, height, %winTitle% ahk_class AutoHotkeyGUI
if (xm > 0 and xm < width and ym > hTitleMenu and ym < height)
{
	sleep 40  ; doesn't work without, don't know why
	empty = 1
	if cell%rm%%cm% <> 0
		empty = 0
	else loop, 9
		if PencilMark%rm%%cm%%a_index% = 1
			empty = 0
	if (CreateIndex = 1 and empty = 1)
	{
		loop, 9
		{
			i = %a_index%
			valid = 1
			loop, parse, ConnectedCells%rm%%cm%, -
				if (cell%a_loopfield% = i)
				{
					valid = 0
					break
				}
			if valid = 1
				PencilMark(rm . cm, i, 1)
		}
		history("gui")
	}
	else if CreateIndex = 4
	{
		if (cell%rm%%cm% <> 0 and swap1 = "")
		{
			swap1 := cell%rm%%cm%
			if switch = numbers
				text = %swap1%
			else
				text := color%swap1%name
			tooltip, Swap %text% and ...
		}
		else if (cell%rm%%cm% <> 0 and cell%rm%%cm% = swap1)
		{
			swap1 =
			tooltip
		}
		else if (cell%rm%%cm% <> 0 and swap1 <> "" and cell%rm%%cm% <> swap1)
		{
			swap2 := cell%rm%%cm%
			tooltip
			loop, parse, cells, -
			{
				if (cell%a_loopfield% = swap1)
					fill(a_loopfield, swap2)
				else if (cell%a_loopfield% = swap2)
					fill(a_loopfield, swap1)
			}
			history("gui")
			swap1 =
			swap2 =
		}
	}
	else ifnotinstring, fixed, %rm%%cm%
	{
		menu, LeftMouseMenu, deleteall
		loop, 9
		{
			n = %a_index%
			valid = 1
			loop, parse, ConnectedCells%rm%%cm%, -
				if cell%a_loopfield% = %n%
			{
				valid = 0
				break
			}
			if valid = 1
			{
				if switch = colors
					item := color%n%name
				else
					item = %n%
				menu, LeftMouseMenu, add, %item%, SetDeleteNumber
				if (cell%rm%%cm% = n)
					menu, LeftMouseMenu, check, %item%
			}
		}
		menu, LeftMouseMenu, show
	}
}
return

~rbutton::
gosub MouseGetNearestCell
wingetpos,,, width, height, %winTitle% ahk_class AutoHotkeyGUI
if (xm > 0 and xm < width and ym > hTitleMenu and ym < height)
{
	sleep 40
	menu, RightMouseMenu, deleteall
	if (cell%rm%%cm% = 0)  ; menu to set/delete pencil marks
	{
		loop, 9
		{
			n = %a_index%
			valid = 1
			loop, parse, ConnectedCells%rm%%cm%, -
				if cell%a_loopfield% = %n%
			{
				valid = 0
				break
			}
			if valid = 1
			{
				if switch = colors
					item := "pencil mark " . color%a_index%name
				else
					item := "pencil mark " . a_index
				menu, RightMouseMenu, add, %item%, SetDeletePencilMark
				if PencilMark%rm%%cm%%a_index% = 0
					menu, RightMouseMenu, uncheck, %item%
				else
					menu, RightMouseMenu, check, %item%
			}
		}
	}
	menu, RightMouseMenu, show
}
return

SetDeleteNumber:
loop, 9
	if (a_thismenuitem = a_index or a_thismenuitem = color%a_index%name)
{
	n = %a_index%
	if (cell%rm%%cm% <> n)
	{
		fill(rm . cm, n)
		loop, parse, ConnectedCells%rm%%cm%, -
			PencilMark(a_loopfield, n, 0)
	}
	else
		fill(rm . cm, 0)
	HintPencilMarks("refresh")
	history("gui")
	break
}
return

SetDeletePencilMark:
stringtrimleft, NumberOrColor, a_thismenuitem, 12  ; omit "pencil mark "
loop, 9
	if (NumberOrColor = a_index or NumberOrColor = color%a_index%name)
{
	if PencilMark%rm%%cm%%a_index% = 0
		PencilMark(rm . cm, a_index, 1)
	else
		PencilMark(rm . cm, a_index, 0)
	history("gui")
	break
}
return

;_____________________________________________________________________________________________
;________ gui subroutines and hotkeys ________________________________________________________


;---- generate an easy Sudoku ----------------------------------------------------------------

easy:
gosub PleaseWait
loop, parse, cells, -
	fill(a_loopfield, 0)
gosub FillRandom
loop, parse, cells, -
	full%a_loopfield% := cell%a_loopfield%
NotYetOmitted = %cells%-  ; The trailing - is needed for stringreplace. <----
;---- omit numbers ----
; Omit numbers found by FillRandom if there was no choice.
sort, NotYetOmitted, random d-
AlreadyLooped =
loop, parse, NotYetOmitted, -
	if a_loopfield <>
	ifnotinstring, AlreadyLooped, %a_loopfield%
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	sym1 := r . 10-c
	sym2 := 10-r . c
	sym3 := 10-r . 10-c
	sym4 := c . r
	sym5 := c . 10-r
	sym6 := 10-c . r
	sym7 := 10-c . 10-r
	AlreadyLooped = %AlreadyLooped%%sym1%-%sym2%-%sym3%-%sym4%-%sym5%-%sym6%-%sym7%-
	ifinstring, NoChoice, %a_loopfield%
	ifinstring, NoChoice, %sym1%
	ifinstring, NoChoice, %sym2%
	ifinstring, NoChoice, %sym3%
	ifinstring, NoChoice, %sym4%
	ifinstring, NoChoice, %sym5%
	ifinstring, NoChoice, %sym6%
	ifinstring, NoChoice, %sym7%
	{
		fill(a_loopfield, 0)
		fill(sym1, 0)
		fill(sym2, 0)
		fill(sym3, 0)
		fill(sym4, 0)
		fill(sym5, 0)
		fill(sym6, 0)
		fill(sym7, 0)
		stringreplace, NotYetOmitted, NotYetOmitted, %a_loopfield%-,  ; <----
		stringreplace, NotYetOmitted, NotYetOmitted, %sym1%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym2%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym3%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym4%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym5%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym6%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym7%-,
	}
}
; Omit numbers found by GetPossibleNumbers if there was no choice.
AlreadyLooped =
loop, parse, NotYetOmitted, -
	if a_loopfield <>
	ifnotinstring, AlreadyLooped, %a_loopfield%
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	sym1 := r . 10-c
	sym2 := 10-r . c
	sym3 := 10-r . 10-c
	sym4 := c . r
	sym5 := c . 10-r
	sym6 := 10-c . r
	sym7 := 10-c . 10-r
	AlreadyLooped = %AlreadyLooped%%sym1%-%sym2%-%sym3%-%sym4%-%sym5%-%sym6%-%sym7%-
	cell%a_loopfield% = 0
	cell%sym1% = 0
	cell%sym2% = 0
	cell%sym3% = 0
	cell%sym4% = 0
	cell%sym5% = 0
	cell%sym6% = 0
	cell%sym7% = 0
	GetAll = 1
	gosub GetPossibleNumbers
	GetAll = 0
	AllSym = 0
	ifinstring, WhatNext, 1%a_loopfield%
	ifinstring, WhatNext, 1%sym1%
	ifinstring, WhatNext, 1%sym2%
	ifinstring, WhatNext, 1%sym3%
	ifinstring, WhatNext, 1%sym4%
	ifinstring, WhatNext, 1%sym5%
	ifinstring, WhatNext, 1%sym6%
	ifinstring, WhatNext, 1%sym7%
		AllSym = 1
	if AllSym = 1
	{
		fill(a_loopfield, 0)
		fill(sym1, 0)
		fill(sym2, 0)
		fill(sym3, 0)
		fill(sym4, 0)
		fill(sym5, 0)
		fill(sym6, 0)
		fill(sym7, 0)
	}
	else
	{
		cell%a_loopfield% := full%a_loopfield%
		cell%sym1% := full%sym1%
		cell%sym2% := full%sym2%
		cell%sym3% := full%sym3%
		cell%sym4% := full%sym4%
		cell%sym5% := full%sym5%
		cell%sym6% := full%sym6%
		cell%sym7% := full%sym7%
	}
}
fix("green")
history("gui")
gui, 6:destroy
return

;---- generate a difficult Sudoku ------------------------------------------------------------

difficult:
gosub PleaseWait
loop, parse, cells, -
	fill(a_loopfield, 0)
gosub FillRandom
loop, parse, cells, -
	full%a_loopfield% := cell%a_loopfield%
;---- Try for each number if there is still only one solution when omitted. ----
RandomCells = %cells%
sort, RandomCells, random d-
loop, parse, RandomCells, -
{
	if a_index < 4
	{
		fill(a_loopfield, 0)
		continue
	}
	TryOmit = %a_loopfield%
	cell%TryOmit% = 0
	DontDisplay = 1
	StopAt = 1
	gosub FillMinimumFirst
	DontDisplay = 0
	StopAt = 0
	Still1Solution = 0
	if (filled = NoChoice)
		Still1Solution = 1
	else
	{
		FirstSolutionIdentical = 1
		loop, parse, cells, -
			if (FirstSolution%a_loopfield% <> full%a_loopfield%)
		{
			FirstSolutionIdentical = 0
			break
		}
		if FirstSolutionIdentical = 1
		{
			DontDisplay = 1
			gosub FillMaximumFirst
			DontDisplay = 0
			if SecondSolutionIdentical = 1
				Still1Solution = 1
		}
	}
	loop, parse, cells, -
	{
		if (a_loopfield = TryOmit)
		{
			if Still1Solution = 1
				fill(a_loopfield, 0)
			else
				cell%a_loopfield% := full%a_loopfield% 
		}
		else
			cell%a_loopfield% := FillMinimumFirst%a_loopfield%
	}
}
fix("green")
history("gui")
gui, 6:destroy
return

;---- open -----------------------------------------------------------------------------------

open:
ifnotexist, %a_desktop%\Sudoku
	FileCreateDir, %a_desktop%\Sudoku
FileSelectFile, Sudoku,, %a_desktop%\Sudoku,, *.txt
if errorlevel = 0
{
	if fixed <>
		unfix()
	fileread, string, %Sudoku%
	StringToGui(string)
	history(string)
}
return

;---- fix/unfix ------------------------------------------------------------------------------

FixUnfix:
if fixed =
	fix("green")
else
	unfix()
return

;---- save as --------------------------------------------------------------------------------

SaveAs:
ifnotexist, %a_desktop%\Sudoku
	FileCreateDir, %a_desktop%\Sudoku
FileSelectFile, Sudoku, S16, %a_desktop%\Sudoku,, *.txt
if errorlevel = 0
{
	string := GuiToString()
	stringright, extension, Sudoku, 4
	if (extension <> ".txt")
		Sudoku = %Sudoku%.txt
	ifexist, %Sudoku%
		filedelete, %Sudoku%
	fileappend, %string%, %Sudoku%
}
return

;---- house ----------------------------------------------------------------------------------

house:
string =
(Join
numbers-FFFFFF--152-244-261-334-371-424-481-528-567-579
-584-622-633-649-668-685-723-742-769-778
-786-825-846-883-929-943-982
)
StringToGui(string)
fix(777777)
history(string)
return

;---- tree ----------------------------------------------------------------------------------

tree:
string =
(Join
numbers-FFFFFF-
13green,14green,15green,16green,22green,27green,31green,38green,41green,48green,51green,
58green,62green,67green,73green,76green,
74804000,75804000,84804000,85804000,94804000,95804000
-134-149-157-166-223-276-318-385-415-481-511-584-628-677-736-743-754-767-842-855-941-956
)
StringToGui(string)
fix("")
history(string)
return

;---- autumn tree ---------------------------------------------------------------------------

AutumnTree:
string =
(Join
numbers-FFFFFF-
13FF6400,14FFB700,157D7327,16FFB700,22FF4000,27FF6400,31FF6400,38FF4000,41FFB700,48FF6400,
517D7327,58FFB700,62FFB700,677D7327,73FF6400,74654000,75654000,76FFB700,84654000,85654000,
94654000,95654000
-133-144-159-165-226-275-317-381-412-483-511-588-628-679-735-743-756-769-842-855-941-954
)
StringToGui(string)
fix("")
history(string)
return

;---- fir trees -----------------------------------------------------------------------------

FirTrees:
string =
(Join
numbers-FFFFFF-
13006000,23006000,2700A000,32006000,34006000,3700A000,42006000,44006000,4600A000,4800A000,
51006000,55006000,5600A000,5800A000,61006000,65006000,6900A000,76006000,7700A000,7800A000,
7900A000,81006000,82006000,83654000,84006000,85006000,86006000,87654000,93654000
-131-232-271-327-341-372-423-448-467-484-517-551-563-585-618-659-691-761-773-788-795-819-828
-833-846-855-862-874-934
)
StringToGui(string)
fix("")
history(string)
return

;---- Christmas tree -------------------------------------------------------------------------

ChristmasTree:
string =
(Join
colors-%cBackground2%--114-152-196-251-343-364-448-465-532-578
-637-673-721-788-828-835-842-857-863-871
-884-959
)
StringToGui(string)
fix("")
history(string)
return

;---- spiral ---------------------------------------------------------------------------------

spiral:
string =
(Join
numbers-FFFFFF-
54ffff00,45ffb700,56ff6e00,66ff2500,75ff0024,74ff006d,73ff00b6,
62ff00ff,52b700ff,426e00ff,332500ff,240024ff,25006dff,2600b6ff,
3700ffff,4800ffb7,5800ff6e,6800ff25,7824ff00,876dff00,96b6ff00
-248-257-262-331-379-425-456-483-528-541
-563-582-624-669-687-735-742-753-786-874
-961
)
StringToGui(string)
fix("")
history(string)
return

;---- crown ----------------------------------------------------------------------------------

crown:
string =
(Join
colors-DDEEFF--216-254-298-312-323-345-368-384-396-413
-432-476-495-514-592-618-651-694-717-791
-811-828-834-842-859-866-873-885-897
)
StringToGui(string)
fix("")
history(string)
return

;---- sun ------------------------------------------------------------------------------------

sun:
string =
(Join
colors-%cBackground2%--136-168-193-242-263-287-351-372-411-426
-435-443-482-498-552-571-644-661-683-734
-762-797-823-866-912-967
)
StringToGui(string)
fix("")
history(string)
return

;---- smiley ----------------------------------------------------------------------------------

smiley:
string =
(Join
numbers-ffff50-
-147-155-161-231-278-327-346-369-381-428-484-525-536-573-587-621-642-657-664-685-733-771-845
-853-862
)
StringToGui(string)
fix(777777)
history(string)
return

;---- heart ----------------------------------------------------------------------------------

heart:
string =
(Join
numbers-FFFFFF-
22cc0000,23cc0000,27cc0000,28cc0000,31cc0000,34cc0000,36cc0000,39cc0000,41cc0000,45cc0000,
49cc0000,51cc0000,59cc0000,62cc0000,68cc0000,73cc0000,77cc0000,84cc0000,86cc0000,95cc0000
-224-235-276-283-317-342-368-391-415-458-492-511-597-626-681-734-778-841-867-954
)
StringToGui(string)
fix("")
history(string)
return

;---- create ---------------------------------------------------------------------------------

create:
CreateIndex = 1
gui, 3:destroy
gui, 2:font, s12
gui, 2:add, text,,
(
Paint an image with pencil marks. You can preset some %switch%.
There must be pencil marks or preset %switch% in at least 17 cells.
The program will try to create a Sudoku from your image:
Empty cells will be left empty, preset %switch% will not be changed,
cells with pencil marks will be filled with one of the pencil mark %switch%.
The left mouse button and the P key are the main painting tools:
They set all possible pencil marks in a cell.
Preset %switch% with the left mouse button or the number keys.
Delete preset %switch% with the left mouse button or the spacebar.
Set and delete single pencil marks with the right mouse button or Shift+number key.
You can delete one pencil mark from all cells with Delete+number key.
)
gui, 2:add, text, xs, 1 = %color1name%
gui, 2:add, text, xp+120, 2 = %color2name%
gui, 2:add, text, xp+120, 3 = %color3name%
gui, 2:add, text, xp+120, 4 = %color4name%
gui, 2:add, text, xp+120, 5 = %color5name%
gui, 2:add, text, xs, 6 = %color6name%
gui, 2:add, text, xp+120, 7 = %color7name%
gui, 2:add, text, xp+120, 8 = %color8name%
gui, 2:add, text, xp+120, 9 = %color9name%

gui, 2:add, button, xs y+20, Create Sudoku
gui, 2:add, button, x+20, Cancel
if guiX =
	guiX = 10
if guiY =
	guiY = 10
gui, 2:show, x%guiX% y%guiY%, Paint an image ...
return

2GuiClose:
2ButtonCancel:
wingetpos, guiX, guiY,,, A
gui, 2:destroy
CreateIndex = 0
return

2ButtonCreateSudoku:
wingetpos, guiX, guiY,,, A
winactivate, %winTitle%
CreateIndex = 2
image =
loop, parse, cells, -
{
	if (cell%a_loopfield% <> 0)
		image = %image%%a_loopfield%-
	else loop, 9
		if (PencilMark%a_loopfield%%a_index% = 1)
	{
		image = %image%%a_loopfield%-
		break
	}
}
stringtrimright, image, image, 1
ImageLen = 0  ;---- less than 17 cells? ----
loop, parse, image, -
	ImageLen += 1
if (ImageLen < 17)
{
	msgbox There must be %switch% or pencil marks in at least 17 cells.
	CreateIndex = 1
	return
}
missing = 123456789  ;---- two numbers missing completely? ----
loop, parse, Image, -
{
	n := cell%a_loopfield%
	stringreplace, missing, missing, %n%,
	loop, 9
	{
		n := PencilMark%a_loopfield%%a_index% 
		if (n = 1)
			stringreplace, missing, missing, %a_index%,
	}
}
stringlen, missingLen, missing
if (missingLen >= 2)
{
	stringleft, missing1, missing, 1
	stringmid, missing2, missing, 2, 1
	if switch = colors
	{
		missing1 := color%missing1%name
		missing2 := color%missing2%name
	}
	msgbox, There can be no unique solution because %missing1% and %missing2% are missing completely and could be swapped.
	CreateIndex = 1
	return
}
loop, 6  ;---- two rows or columns in the same blocks completely empty? ----
{
	i1 := a_index * 3 - 3
	unitA =
	loop, 3
	{
		i2 := i1 + a_index
		empty = 1
		loop, parse, unit%i2%, -
			ifinstring, image, %a_loopfield%
		{
			empty = 0
			break
		}
		if empty = 1
		{
			if (i2 > 9)
				unitB := "column " . (i2 - 9)
			else
				unitB = row %i2%
			if unitA =
				unitA = %unitB%
			else
			{
				msgbox, There can be no unique solution because %unitA% and %unitB% are completely empty and could be swapped.
				CreateIndex = 1
				return
			}
		}
	}
}
loop, 27  ;---- more than n cells with only n possible numbers in one unit? ----
{
	u = %a_index%
	loop, 8
	{
		lenPencilCells := a_index+1
		PencilCells =
		loop, %lenPencilCells%
			PencilCells = %PencilCells%%a_index%
		loop
		{
			InImage = 1
			NotEmpty = 1
			PencilMarks =
			loop, parse, PencilCells
			{
				if (u <= 9)
				{
					row = %u%
					column := a_loopfield
				}
				else if (u <= 18)
				{
					row := a_loopfield
					column := u-9
				}
				else
				{
					block := u-18
					if (block <= 3)
						row = 1
					else if (block <= 6)
						row = 4
					else
						row = 7
					if (block = 1 or block = 4 or block = 7)
						column = 1
					else if (block = 2 or block = 5 or block = 8)
						column = 4
					else
						column = 7
					if (a_loopfield > 6)
						row += 2
					else if (a_loopfield > 3)
						row += 1
					if (a_loopfield = 2 or a_loopfield = 5 or a_loopfield = 8)
						column += 1
					else if (a_loopfield = 3 or a_loopfield = 6 or a_loopfield = 9)
						column += 2
				}
				ifnotinstring, image, %row%%column%
				{
					InImage = 0
					break
				}
				if cell%row%%column% <> 0
				{
					NotEmpty = 0
					break
				}
				loop, 9
					if PencilMark%row%%column%%a_index% = 1
					ifnotinstring, PencilMarks, %a_index%
						PencilMarks = %PencilMarks%%a_index%
			}
			if (InImage = 1 and NotEmpty = 1)
			{
				stringlen, lenPencilMarks, PencilMarks
				if (lenPencilMarks < lenPencilCells)
				{
					PencilCellsText = cells
					loop, parse, PencilCells
						PencilCellsText = %PencilCellsText% %a_loopfield% and
					stringtrimright, PencilCellsText, PencilCellsText, 4
					if (u <= 9)
						unit := "row " . u
					else if (u <= 18)
						unit := "column " . u-9
					else
						unit := "block " . u-18
					msgbox, In %PencilCellsText% in %unit% there are only %lenPencilMarks% possible %switch%, so one cell can't be filled.
					CreateIndex = 1
					return
				}
			}
			PencilCellsR =
			loop, parse, PencilCells
				PencilCellsR := a_loopfield . PencilCellsR
			FirstPossibleIncrease =
			loop, parse, PencilCellsR
				if (a_loopfield < 10-a_index)
				{
					FirstPossibleIncrease := lenPencilCells+1-a_index
					break
				}
			if FirstPossibleIncrease =
				break
			PencilCellsNew =
			loop, parse, PencilCells
			{
				if (a_index < FirstPossibleIncrease)
					PencilCellsNew := PencilCellsNew . a_loopfield
				else if (a_index = FirstPossibleIncrease)
				{
					increase := a_loopfield+1
					PencilCellsNew := PencilCellsNew . increase
				}
				else
				{
					increase += 1
					PencilCellsNew := PencilCellsNew . increase
				}
			}
			PencilCells = %PencilCellsNew%
		}
	}
}
PresetImage =
PencilImage =
loop, parse, image, -
	if (cell%a_loopfield% <> 0)
		PresetImage = %PresetImage%%a_loopfield%-
	else
		PencilImage = %PencilImage%%a_loopfield%-
stringtrimright, PresetImage, PresetImage, 1
stringtrimright, PencilImage, PencilImage, 1
if PencilImage =  ;---- no pencil marks? ----
{
	msgbox,
(
There are no pencil marks.
There have to be pencil marks so that the Sudoku creator can try different %switch%.
)
	CreateIndex = 1
	return
}
loop, parse, cells, -
	DeletedNumbers%a_loopfield% =
loop, parse, PencilImage, -
	loop, 9
		if (PencilMark%a_loopfield%%a_index% = 0)
			DeletedNumbers%a_loopfield% := DeletedNumbers%a_loopfield% . a_index
gosub FillRandom
if SolutionAtAll = 0
{
	msgbox, There is no solution.
	CreateIndex = 1
	return
}
gosub LeaveImage
gui, 2:destroy
CreateIndex = 3
interrupt = 0
examined = 0
NoSolution = 0
LastPossible = 0
DontRepeatList =
loop							;---- START CHANGING NUMBERS ----
{
	FirstIndex = %a_index%
	if (FirstIndex - LastPossible > 2)
	{
		CreateIndex = 4
		history("gui")
		back(0)
SoundBeep, 480, 240
sleep 80
SoundBeep, 480, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 768, 240
sleep 80
SoundBeep, 768, 240
sleep 80
SoundBeep, 720, 400
		guicontrol, 3:text, Gui3Text, Can't create a Sudoku with a unique solution.
		return
	}
	loop, parse, PencilImage, -
	{
		PencilImageLoopfield = %a_loopfield%
		PencilImageIndex = %a_index%
		stringleft, PencilImageLoopfieldL, PencilImageLoopfield, 1
		stringright, PencilImageLoopfieldR, PencilImageLoopfield, 1
		if (FirstIndex = 1 and PencilImageIndex = 1)
		{
			gui, 3:font, s12
			gui, 3:add, text, vGui3Text w500,
(
Loop 1, row %PencilImageLoopfieldL%, column %PencilImageLoopfieldR%
Examined positions:
Cells with no unique solution:

Please wait, this can take some time ...




)
			gui, 3:add, button,, Cancel
			gui, 3:show, x%guiX% y%guiY% w520, Create a Sudoku ...
		}
		else
			guicontrol, 3:text, Gui3Text,
(
Loop %FirstIndex%, row %PencilImageLoopfieldL%, column %PencilImageLoopfieldR%
Examined positions: %examined%
Cells with no unique solution: %DiffMin%

Please wait, this can take some time ...
)
		if interrupt = 1
		{
			gui, 3:destroy
			CreateIndex = 0
			history("gui")
			return
		}
		else if interrupt = 2
		{
			history("gui")
			back(0)
			gosub create
			return
		}
		DontRepeatString =
		loop, parse, PencilImage, -
			if (a_loopfield <> PencilImageLoopfield)
				DontRepeatString := DontRepeatString . cell%a_loopfield%
			else
				DontRepeatString = %DontRepeatString%X
		ifinstring, DontRepeatList, %DontRepeatString%
		{
			results := %DontRepeatString%  ; results is the value of the value of DontRepeatString!
			if (results <> "")
			{
				LastPossible := FirstIndex
				loop, parse, results, -
				{
					NextResult = %a_loopfield%
					break
				}
				loop, parse, NextResult, /
					if (a_index = 1)
						DiffMin = %a_loopfield%
					else
						PencilImageString = %a_loopfield%
				loop, parse, PencilImage, -
				{
					stringmid, n, PencilImageString, a_index, 1
					fill(a_loopfield, n)
				}
				stringlen, len, NextResult
				stringtrimleft, results, results, len+1
				%DontRepeatString% := results
			}
			continue
		}
		DontRepeatList = %DontRepeatList%%DontRepeatString%`n
		missing = 123456789
		loop, parse, Image, -
			if (a_loopfield <> PencilImageLoopfield)
			{
				n := cell%a_loopfield%
				stringreplace, missing, missing, %n%,
			}
		stringlen, missingLen, missing
		if (missingLen >= 2)
			possible = %missing%
		else
			possible = 123456789
		if (FirstIndex = 1 and PencilImageIndex = 1)
			results =
		else
		{
			if DiffMin <>
			{
				PencilImageString =
				loop, parse, PencilImage, -
					PencilImageString := PencilImageString . cell%a_loopfield%
				results := DiffMin . "/" . PencilImageString . "-"
			}
			else
				results =
			n := cell%PencilImageLoopfield%
			stringreplace, possible, possible, %n%,
		}
		if DeletedNumbers%PencilImageLoopfield% <>
			loop, parse, DeletedNumbers%PencilImageLoopfield%
				stringreplace, possible, possible, %a_loopfield%,
		loop, parse, PresetImage, -
			ifinstring, ConnectedCells%PencilImageLoopfield%, %a_loopfield%
			{
				n := cell%a_loopfield%
				stringreplace, possible, possible, %n%,
			}
		if possible <>
		{
			LastPossible := FirstIndex
			loop, parse, PencilImage, -
			{
				stringlen, possibleLen, possible
				if (possibleLen <= 2)
					break
				ifinstring, ConnectedCells%PencilImageLoopfield%, %a_loopfield%
				{
					n := cell%a_loopfield%
					stringreplace, possible, possible, %n%,
				}
			}
		}
		if possible <>
		{
			PencilImageString1 =
			loop, parse, PencilImage, -
				PencilImageString1 := PencilImageString1 . cell%a_loopfield%
			loop, parse, possible
			{
				if interrupt = 1
				{
					gui, 3:destroy
					CreateIndex = 0
					history("gui")
					return
				}
				else if interrupt = 2
				{
					history("gui")
					back(0)
					gosub create
					return
				}
				if SwitchAfterLoopIteration = 1
				{
					SwitchAfterLoopIteration = 0
					gosub switch2
				}
				PossLoopfield = %a_loopfield%
				fill(PencilImageLoopfield, PossLoopfield)
				ChangeConnectedCells = 0
				loop, parse, PencilImage, -
					ifinstring, ConnectedCells%PencilImageLoopfield%, %a_loopfield%
					if (cell%a_loopfield% = PossLoopfield)
					{
						fill(a_loopfield, 0)
						ChangeConnectedCells = 1
					}
				if ChangeConnectedCells = 1
				{
					gosub FillRandom
					gosub LeaveImage
				}
				examined += 1
				ChangePencilImage = 0
				gosub FillMinimumFirst
				if SolutionAtAll = 0
				{
					NoSolution += 1
					if (NoSolution/examined > 1/2)
						loop, parse, PencilImage, -
							if cell%a_loopfield% <> 0
							{
								fill(a_loopfield, 0)
								ChangePencilImage = 1
								gosub FillRandom
								if SolutionAtAll = 1
								{
									gosub LeaveImage
									gosub FillMinimumFirst
									break
								}
							}
				}
				if SolutionAtAll = 1
				{
					gosub FillMaximumFirst
					gosub LeaveImage
					if SecondSolutionIdentical = 1
					{
						CreateIndex = 4
						history("gui")
SoundBeep, 480, 240
sleep 80
SoundBeep, 480, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 800, 240
sleep 80
SoundBeep, 800, 240
sleep 80
SoundBeep, 720, 400
						guicontrol, 3:text, Gui3Text,
(
Loop %FirstIndex%, row %PencilImageLoopfieldL%, column %PencilImageLoopfieldR%
Examined positions: %examined%

Ready! You can improve the image in two ways:
1. Swap %switch%. Simply click on %switch% you want to swap, you can do that as long as this window is open.
2. Color numbers with "Color numbers" in the View menu. You can do that now or later.
)
						gui, 3:add, button, x+20, Save
						return
					}
					else
					{
						PencilImageString =
						loop, parse, PencilImage, -
							PencilImageString := PencilImageString . cell%a_loopfield%
						results := results . different . "/" . PencilImageString . "-"
					}
				}
				if (ChangeConnectedCells = 1 or ChangePencilImage = 1)
					loop, parse, PencilImage, -
					{
						stringmid, n, PencilImageString1, a_index, 1
						fill(a_loopfield, n)
					}
			}
			if results <>
			{
				sort, results, N D-
				loop, parse, results, -
				{
					NextResult = %a_loopfield%
					break
				}
				loop, parse, NextResult, /
					if (a_index = 1)
						DiffMin = %a_loopfield%
					else
						PencilImageString = %a_loopfield%
					loop, parse, PencilImage, -
					{
						stringmid, n, PencilImageString, a_index, 1
						fill(a_loopfield, n)
					}
				stringlen, len, NextResult
				stringtrimleft, results, results, len+1
				%DontRepeatString% := results
			}
		}
	}
}
return

3GuiClose:
wingetpos, guiX, guiY,,, A
if CreateIndex = 3
	interrupt = 1
else
{
	gui, 3:destroy
	CreateIndex = 0
}
return

3ButtonCancel:
wingetpos, guiX, guiY,,, A
if CreateIndex = 3
	interrupt = 2
else
{
	gui, 3:destroy
	CreateIndex = 0
}
return

3ButtonSave:
wingetpos, guiX, guiY,,, A
gui, 3:destroy
CreateIndex = 0
gosub SaveAs
return

LeaveImage:
loop, parse, cells, -
	ifnotinstring, image, %a_loopfield%
		fill(a_loopfield, 0)
return

;---- larger ---------------------------------------------------------------------------------

larger:
+::
NumpadAdd::
if PlusMinus < 6
{
	PlusMinus += 1
	gosub CellsSize
	gui, 1:show, w%wGui% h%wGui%
}
return

;---- smaller --------------------------------------------------------------------------------

smaller:
-::
NumpadSub::
if PlusMinus > -2
{
	PlusMinus -= 1
	gosub CellsSize
	gui, 1:show, w%wGui% h%wGui%
}
return

;---- color numbers --------------------------------------------------------------------------

ColorNumbers:
inputbox, cNumber,,
(
1. Enter a color.
You can input these color names:
black, silver, gray, maroon, brown, red, purple, fuchsia, green, lime, olive, yellow, navy, blue, teal, aqua
Or input a 6-digit hexadecimal RGB color value.
2. Or get a color anywhere on your computer with Ctrl+Alt+mouse click.
3. Assign the color to the number under the mouse cursor with Ctrl+V. (You don't have to click.)

- RGB means red-green-blue, the first two digits are the red part of the color, the third and fourth digit are the green part of the color and the last two digits are the blue part of the color. 
- Hexadecimal means there are 16 instead of 10 digits: 0 1 2 3 4 5 6 7 8 9 a b c d e f. Hexadecimal numbers all start with the prefix 0x (e.g. 0xCC0000 is the dark red of the heart Sudoku) but the prefix may be omitted.

You can get any color by increasing or reducing the red or green or blue value:

ffff00 to ff0000 = yellow to red
(In slow motion: ffff00, fffe00, fffd00, ..., ffa100, ffa000, ff9900, ff9800, ..., ff0200, ff0100, ff0000)
ff0000 to ff00ff = red to fuchsia
ff00ff to 0000ff = fuchsia to blue
0000ff to 00ffff = blue to aqua
00ffff to 00ff00 = aqua to lime
00ff00 to ffff00 = lime to yellow

ffffff to 000000 = white to black

Colored numbers are only for the looks of the Sudoku, the colors don't affect the solution! But you can switch from numbers to colors (also in the View menu), then 9 predefined colors REPLACE the numbers and every color must appear only once in every row and every column and every block.

The colors of numbers are not remembered, the numbers will turn black again the next time when their cells are filled. You have to save the Sudoku when you have colored it and want to keep it.
),, 800, 600,,,,, %cNumber%
if cNumber = white
	cNumber =
else if cNumber = brown
	cNumber = 654000
return

;---- switch between numbers and colors -------------------------------------------------------

switch:
if CreateIndex = 3
{
	SwitchAfterLoopIteration = 1
	return
}
switch2:
if switch = colors
{
	switch = numbers
	cBackground = %cBackground1%
	gui, 1:color, %cBackground1%
}
else
{
	switch = colors
	cBackground = %cBackground2%
	gui, 1:color, %cBackground2%
}
loop, parse, cells, -
{
	if cell%a_loopfield% <> 0
		fill(a_loopfield, cell%a_loopfield%)
	else loop, 9
		PencilMark(a_loopfield, a_index, PencilMark%a_loopfield%%a_index%)
}
history("gui")
return

;---- back -----------------------------------------------------------------------------------

back:
pgup::
back(1)
return

back(unfix)
{
	global
	if HistoryIndex > 1
	{
		if (fixed <> "" and HistoryIndex >= FixIndex and unfix = 1)
			unfix()
		HistoryIndex -= 1
		StringToGui(history%HistoryIndex%)
	}
}

;---- forward --------------------------------------------------------------------------------

forward:
pgdn::
if (HistoryIndex < HistoryIndexMax)
{
	HistoryIndex += 1
	StringToGui(history%HistoryIndex%)
}
return

;---- all pencil marks -----------------------------------------------------------------------

AllPencilMarks:
loop, parse, cells, -
	if cell%a_loopfield% = 0
{
	PencilMarks = 123456789
	loop, parse, ConnectedCells%a_loopfield%, -
		if cell%a_loopfield% <> 0
	{
		n := cell%a_loopfield%
		stringreplace, PencilMarks, PencilMarks, %n%,
	}
	loop, 9
	{
		ifinstring, PencilMarks, %a_index%
			PencilMark(a_loopfield, a_index, 1)
		else
			PencilMark(a_loopfield, a_index, 0)
	}
}
history("gui")
return

;---- pencil marks only for singles and pairs ------------------------------------------------

HintPencilMarks(mode)
{
	global
	local PencilMarks, u, rc, p, n
	if (mode = "refresh")
	{
		PencilMarks = 0
		loop, parse, cells, -
			loop, 9
				if PencilMark%a_loopfield%%a_index% = 1
		{
			PencilMarks = 1
			break
		}
		if (PencilMarks = 0)
			return
	
	}
	PencilMarks =
	loop, parse, cells, -
		if cell%a_loopfield% = 0
			PossibleNumbers%a_loopfield% = 123456789
	loop, parse, cells, -
		if cell%a_loopfield% = 0
	{
		rc = %a_loopfield%
		loop, parse, ConnectedCells%rc%, -
			if cell%a_loopfield% <> 0
		{
			n := cell%a_loopfield%
			DeletePossibleNumber(rc, n)
		}
		stringlen, PossibleNumbersLen, PossibleNumbers%rc%
		if (PossibleNumbersLen = 1)
		{
			p := PossibleNumbers%rc%
			PencilMark(rc, p, 1)
			PencilMarks = %PencilMarks%%rc%%p%-
		}
	}
	loop, 27  ; units
	{
		u = %a_index%
		loop, 9  ; numbers
		{
			n = %a_index%
			PossibleCells%u%%n% =
			loop, parse, unit%u%, -
			{
				if cell%a_loopfield% = %n%
					break
				else if cell%a_loopfield% = 0
					ifinstring, PossibleNumbers%a_loopfield%, %n%
						PossibleCells%u%%n% := PossibleCells%u%%n% . a_loopfield . "-"
			}
			stringlen, PossibleCellsLen, PossibleCells%u%%n%
			if (PossibleCellsLen = 3 or PossibleCellsLen = 6)
			{
				loop, parse, PossibleCells%u%%n%, -
					if a_loopfield <>
				{
					PencilMark(a_loopfield, n, 1)
					PencilMarks = %PencilMarks%%a_loopfield%%n%-
				}
			}
		}
	}
	if (mode <> "refresh")  ; if refresh, only find new ones, don't delete existing ones
	{
		loop, parse, cells, -
			loop, 9
				ifnotinstring, PencilMarks, %a_loopfield%%a_index%
					PencilMark(a_loopfield, a_index, 0)
		history("gui")
	}
}

;---- remove pencil marks --------------------------------------------------------------------

RemovePencilMarks:
loop, parse, cells, -
	loop, 9
		PencilMark(a_loopfield, a_index, 0)
history("gui")
return

;---- clear board ----------------------------------------------------------------------------

ClearBoard:
if fixed <>
	unfix()
loop, parse, cells, -
	fill(a_loopfield, 0)
if switch = numbers
{
	if (cBackground <> cBackground1)
	{
		cBackground = %cBackground1%
		gui, 1:color, %cBackground1%
	}
}
else
{
	if (cBackground <> cBackground2)
	{
		cBackground = %cBackground2%
		gui, 1:color, %cBackground2%
	}
}
history("gui")
return

;---- find one -------------------------------------------------------------------------------

^pgdn::
FindOne:
text =
explain = 1
gosub GetPossibleNumbers
explain = 0
stringleft, WhatNextLeft, WhatNext, 1
if WhatNextLeft = x  ; no possible cell
{
	stringtrimleft, WhatNext, WhatNext, 1
	stringright, n, WhatNext, 1
	stringtrimright, u, WhatNext, 1
	loop, parse, unit%u%, -
		if cell%a_loopfield% = 0
	{
		stringleft, r, a_loopfield, 1
		stringright, c, a_loopfield, 1
		xm := pos%c%+wCell/2
		ym := pos%r%+wCell/2+hTitleMenu
		click %xm%, %ym%, 0
		highlight(r . c, "red")
		sleep 400
	}
	text = Number %n%# can't be set anywhere in unit %u%.
	loop, parse, unit%u%, -
		text := ExplainAdd("text", a_loopfield . n)
}
else if WhatNextLeft = 0  ; no possible number
{
	stringmid, r, WhatNext, 2, 1
	stringmid, c, WhatNext, 3, 1
	xm := pos%c%+wCell/2
	ym := pos%r%+wCell/2+hTitleMenu
	click %xm%, %ym%, 0
	highlight(r . c, "red")
	text = This cell can't be filled.
	loop, 9
		text := ExplainAdd("text", r . c . a_index)
}
else if WhatNextLeft = 1  ; one possible number
{
	stringmid, r, WhatNext, 2, 1
	stringmid, c, WhatNext, 3, 1
	n := PossibleNumbers%r%%c%
	xm := pos%c%+wCell/2
	ym := pos%r%+wCell/2+hTitleMenu
	click %xm%, %ym%, 0
	fill(r . c, n)
	highlight(r . c, "green")
	loop, parse, ConnectedCells%r%%c%, -
		PencilMark(a_loopfield, n, 0)
	HintPencilMarks("refresh")
	history("gui")
	if explain%r%%c%%n% =
	{
		text = %n%# is the only possible number in this cell.
		loop, 9
			if (a_index <> n)
				text := ExplainAdd("text", r . c . a_index)
	}
	else
	{
		u := explain%r%%c%%n%
		text = This is the only possible cell for number %n%# in unit %u%.
		loop, parse, unit%u%, -
			if (a_loopfield <> r . c)
				text := ExplainAdd("text", a_loopfield . n)
	}
}
else if WhatNextLeft > 1  ; several possible numbers
{
	stringmid, r0, WhatNext, 2, 1  ; r and c are used by FillMinimumFirst. <---------
	stringmid, c0, WhatNext, 3, 1
	xm := pos%c0%+wCell/2
	ym := pos%r0%+wCell/2+hTitleMenu
	click %xm%, %ym%, 0
	ProvedNumbers =
	loop, parse, PossibleNumbers%r0%%c0%
	{
		fill(r0 . c0, a_loopfield)
		gosub FillMinimumFirst  ; <---------
		if SolutionAtAll = 1
			ProvedNumbers = %ProvedNumbers%%a_loopfield%
		history("gui")
		back(0)
	}
	stringlen, ProvedNumbersLen, ProvedNumbers
	if ProvedNumbersLen = 0
	{
		highlight(r0 . c0, "red")
		text := "This cell could be filled with"
		loop, parse, PossibleNumbersAll%r0%%c0%
			text = %text% %a_loopfield%# or
		stringtrimright, text, text, 3
		text := text . " but there is no solution with any of them."
	}
	else
	{
		if ProvedNumbersLen = 1
		{
			fill(r0 . c0, ProvedNumbers)
			highlight(r0 . c0, "green")
			loop, parse, ConnectedCells%r0%%c0%, -
				PencilMark(a_loopfield, ProvedNumbers, 0)
			HintPencilMarks("refresh")
			history("gui")
		}
		else
			highlight(r0 . c0, "blue")
		text := "Possible numbers:"
		loop, parse, PossibleNumbersAll%r0%%c0%
			text = %text% %a_loopfield%#,
		stringtrimright, text, text, 1
		text := text . ".There is a solution with:"
		loop, parse, ProvedNumbers
			text = %text% %a_loopfield%#,
		stringtrimright, text, text, 1
		text := text . "."
	}
}
if text <>
{
;---- omit multiple explanations ----
	text2 =
	loop, parse, text, .
		if a_loopfield <>
			if (InStr(text2, a_loopfield) = 0)
				text2 = %text2%%a_loopfield%.
	text = %text2%
;---- highlight cells ----
	loop, parse, cells, -
		if highlight%a_loopfield% <> green
			ifinstring, text, %a_loopfield%<blue>
				highlight(a_loopfield, "blue")
			else ifinstring, text, %a_loopfield%<red>
				highlight(a_loopfield, "red")
	stringreplace, text, text, <red>,, all
	stringreplace, text, text, <blue>,, all
;---- replace numbers with color names ----
	if switch = colors
	{
		loop, 9
		{
			color := color%a_index%name
			stringreplace, text, text, number %a_index%#, %color%, all
			stringreplace, text, text, %a_index%#, %color%, all
		}
		stringreplace, text, text, number, color, all
	}
	else
		stringreplace, text, text, #,, all
;---- replace row column 11 to 99 with coordinates A1 to I9 ----
	loop, parse, cells, -
		stringreplace, text, text, coord%a_loopfield%, % coord(a_loopfield), all
;---- replace unit 1 to 27 with row 1 to 9, column 1 to 9, block 1 to 9 ----
	loop, 9
	{
		u := a_index+9  ; columns and blocks first, otherwise unit 10 to 27 would become row 10 to 27
		C := letter(a_index)
		stringreplace, text, text, unit %u%, column %C%, all
		u := a_index+18
		stringreplace, text, text, unit %u%, block %a_index%, all
	}
	loop, 9
		stringreplace, text, text, unit %a_index%, row %a_index%, all
;---- uppercase at the beginning of sentences ----
	text2 =
	loop, parse, text, .
		if a_loopfield <>
	{
		x1 := SubStr(a_loopfield, 1, 1)
		x2 := SubStr(a_loopfield, 2, 1)
		if x1 is lower
			StringUpper, x1, x1
		else if x1 is not alpha
			if x2 is lower
				StringUpper, x2, x2
		text2 := text2 . x1 . x2 . SubStr(a_loopfield, 3) . "."
	}
	text = %text2%
;---- wrap text ----
	text2 =
	LineLenMax = 120
	loop, parse, text, `n`r
		if a_loopfield <>
	{
		line = %a_loopfield%
		if (StrLen(line) > LineLenMax)
		{
			line2 =
			Line2Len = 0
			x := " "
			loop, parse, line, %x%
				if a_loopfield <>
			{
				Line2Len += StrLen(a_loopfield)
				if (Line2Len > LineLenMax)
				{
					line2 := line2 . "`n" . a_loopfield
					Line2Len = 0
				}
				else
					line2 := line2 . " " . a_loopfield
			}
			line = %line2%
		}
		if (a_index = 1)
			text2 = %line%
		else
			text2 = %text2%`n%line%
	}
	text = %text2%
;---- tooltip or gui according to number and length of lines ----
	LineLenMax = 0
	loop, parse, text, `n`r
	{
		if (StrLen(a_loopfield) > LineLenMax)
			LineLenMax := StrLen(a_loopfield)
		LineIndex = %a_index%
	}
	if LineIndex <= 4
		tooltip %text%
	else
	{
		gui, 5:-caption +border
		gui, 5:color, FFFFE1
		gui, 5:font, s12
		gui, 5:add, text,, %text%
		k = 6
		l = 20
		if (a_screendpi > 96)
		{
			k := k*a_screendpi//96
			l := l*a_screendpi//96
		}
		overlap = 0
		loop, 10
		{
			wingetpos, winx, winy, winwidth, winheight, %winTitle% ahk_class AutoHotkeyGUI
			xRelGui := winx+winwidth+10-overlap
			yRelGui := winy+winheight+10-overlap
			xRelScreen := a_screenwidth-k*LineLenMax-180  ; got by testing
			if (xRelScreen < 0)
				xRelScreen = 0
			yRelScreen := a_screenheight-l*LineIndex-40  ; got by testing
			if (yRelScreen < 0)
				yRelScreen = 0
			if (yRelScreen >= yRelGui)
			{
				yText = %yRelGui%
				if (xRelScreen >= winx)
					xText = %winx%
				else
					xText = %xRelScreen%
				break
			}
			else if (xRelScreen >= xRelGui)
			{
				xText = %xRelGui%
				if (yRelScreen >= winy)
					yText = %winy%
				else
					yText = %yRelScreen%
				break
			}
			else
			{
				if (a_index = 1)
				{
					gui, 1:show, y10
					sleep 10
				}
				else if (a_index = 2)
				{
					gui, 1:show, x10
					sleep 10
				}
				else if (a_index = 3)
					overlap += 10
				else if (a_index = 4)
					overlap += wCaption
				else if (a_index = 5)
					overlap += wCell//2
				else if (a_index = 6)
				{
					gosub smaller
					overlap = 0
				}
				else if (a_index = 7)
					overlap += 10
				else if (a_index = 8)
					overlap += wCaption
				else if (a_index = 9)
					overlap += wCell//2
				else
				{
					xText = %xRelScreen%
					yText = %yRelScreen%
				}
			}
		}
		gui, 5:show, x%xText% y%yText% NoActivate
		guitip = 1
	}
	sleep 10
	gui, 1:show  ; for Linux
}
gui, 6:destroy
return

coord(rc)
{
	stringleft, r, rc, 1
	stringright, c, rc, 1
	return letter(c) . r
}

letter(c)
{
	if c = 1
		letter = A
	else if c = 2
		letter = B
	else if c = 3
		letter = C
	else if c = 4
		letter = D
	else if c = 5
		letter = E
	else if c = 6
		letter = F
	else if c = 7
		letter = G
	else if c = 8
		letter = H
	else if c = 9
		letter = I
	return letter
}

;---- find all -------------------------------------------------------------------------------

FindAll:
gosub FillMinimumFirst
if SolutionAtAll = 0
	msgbox, There is no solution!
else if SolutionAtAll = 1
{
	history("gui")
	sleep 1000
	gosub FillMaximumFirst
	if SecondSolutionIdentical = 1
		msgbox, There is only one solution!
	else
	{
		history("gui")
		msgbox, There is a second solution!
	}
}
return

;---- help -----------------------------------------------------------------------------------

help:
gui, 4:destroy
gui, 4:font, s12
gui, 4:add, text,, Set %switch% with the left mouse button or the number keys.
if switch = colors
{
	gui, 4:add, text, xs, 1 = %color1name%
	gui, 4:add, text, xp+120, 2 = %color2name%
	gui, 4:add, text, xp+120, 3 = %color3name%
	gui, 4:add, text, xp+120, 4 = %color4name%
	gui, 4:add, text, xp+120, 5 = %color5name%
	gui, 4:add, text, xs, 6 = %color6name%
	gui, 4:add, text, xp+120, 7 = %color7name%
	gui, 4:add, text, xp+120, 8 = %color8name%
	gui, 4:add, text, xp+120, 9 = %color9name%
	pos = m
}
else
	pos = 0
gui, 4:add, text, xs y+%pos%,
(
Delete %switch% with the left mouse button or the spacebar.
Set/delete pencil marks with the right mouse button or with Shift+number key.
The arrow keys also move the mouse cursor.

This program in its compiled form (that is, as exe file, not as ahk file) also works with Wine
in Linux but colors will probably appear as = or g.
To fix this, copy webdings.ttf from the Windows fonts folder (C:\Windows\Fonts)
to the Linux truetype folder (/usr/share/fonts/truetype - open as administrator!).
)
gui, 4:show, x10 y10, Help
return

4GuiClose:
gui, 4:destroy
return

;_____________________________________________________________________________________________
;________ hotkey variants for the swap gui ___________________________________________________


#ifwinactive Create ahk_class AutoHotkeyGUI
1::
2::
3::
4::
5::
6::
7::
8::
9::
numpad1::
numpad2::
numpad3::
numpad4::
numpad5::
numpad6::
numpad7::
numpad8::
numpad9::
stringright, n, a_thislabel, 1
gosub swap
return

;_____________________________________________________________________________________________
;________ other subroutines __________________________________________________________________


CellsSize:
parameters = wCell-sNumber-sColor-sHighlight-wPencilMark-sPencilNumber-sPencilColor-wCaption-sCaption
loop, parse, parameters, -
	%a_loopfield% := %a_loopfield%1 + (PlusMinus * %a_loopfield%1)//4
wLine := PlusMinus//2+2
loop, 9
{
	pos%a_index% := (a_index-1)*(wCell+wLine)  ; position of column/row
	if (a_index > 6)
		pos%a_index% += 2*wLine
	else if (a_index > 3)
		pos%a_index% += wLine
}
wGui := pos9+wCell+wCaption
loop, parse, cells, -
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	x := pos%c%
	y := pos%r%
	wGridCell := pos4-pos3
	sSquare := wGridCell*4//5
	gui, 1:font, s%sSquare% c888888, Webdings
	guicontrol, 1:font, GridCell%a_loopfield%
	guicontrol, 1:movedraw, GridCell%a_loopfield%, x%x% y%y% w%wGridCell% h%wGridCell%
	guicontrol, 1:movedraw, highlight%a_loopfield%, x%x% y%y% w%wCell% h%wCell%
	guicontrol, 1:movedraw, cell%a_loopfield%, x%x% y%y% w%wCell% h%wCell%
	loop, 3
		posP%a_index% := (wCell-3*wPencilMark)//2 + (a_index-1)*wPencilMark  ; position of pencil mark column/row
	x1 := x+posP1
	y1 := y+posP1
	x2 := x+posP2
	y2 := y+posP1
	x3 := x+posP3
	y3 := y+posP1
	x4 := x+posP1
	y4 := y+posP2
	x5 := x+posP2
	y5 := y+posP2
	x6 := x+posP3
	y6 := y+posP2
	x7 := x+posP1
	y7 := y+posP3
	x8 := x+posP2
	y8 := y+posP3
	x9 := x+posP3
	y9 := y+posP3
	loop, 9
	{
		x := x%a_index%
		y := y%a_index%
		guicontrol, 1:movedraw, PencilMark%a_loopfield%%a_index%, x%x% y%y% w%wPencilMark% h%wPencilMark%
	}
	if cell%a_loopfield% <> 0
		fill(a_loopfield, cell%a_loopfield%)
	else loop, 9
		PencilMark(a_loopfield, a_index, PencilMark%a_loopfield%%a_index%)
	if highlight%a_loopfield% <> 0
		highlight(a_loopfield, highlight%a_loopfield%)
}
x := pos9+wCell+2*wLine
i = 0
loop, parse, caption123, -
{
	i += 1
	y := pos%i%+wCell/4
	guicontrol, 1:movedraw, caption123%a_loopfield%, x%x% y%y% w%wCaption% h%wCell%
	gui, 1:font, c222222 s%sCaption%
	gui, 1:font,, Ubuntu
	gui, 1:font,, Arial
	guicontrol, 1:font, caption123%a_loopfield%
	guicontrol, 1:text, caption123%a_loopfield%, %a_loopfield%
}
y := pos9+wCell+2*wLine
i = 0
loop, parse, captionABC, -
{
	i += 1
	x := pos%i%
	guicontrol, 1:movedraw, captionABC%a_loopfield%, x%x% y%y% w%wCell% h%wCaption%
	gui, 1:font, c222222 s%sCaption%
	gui, 1:font,, Ubuntu
	gui, 1:font,, Arial
	guicontrol, 1:font, captionABC%a_loopfield%
	guicontrol, 1:text, captionABC%a_loopfield%, %a_loopfield%
}
return

;---------------------------------------------------------------------------------------------

MouseGetNearestCell:
mousegetpos, xm, ym
xyGetNearestCell:
rm = 1
cm = 1
loop, 9
	if a_index > 1
{
	if abs(xm-(pos%a_index%+wCell/2)) < abs(xm-(pos%cm%+wCell/2))
		cm = %a_index%
	if abs(ym-(pos%a_index%+wCell/2+hTitleMenu)) < abs(ym-(pos%rm%+wCell/2+hTitleMenu))
		rm = %a_index%
}
xcenter := pos%cm%+wCell/2
ycenter := pos%rm%+wCell/2+hTitleMenu
return

;---------------------------------------------------------------------------------------------

PleaseWait:
wingetpos, winx, winy, winwidth, winheight, %winTitle% ahk_class AutoHotkeyGUI
x := winx+winwidth//2-2*wCell
y := winy+winheight//2-wCell//2
s := sNumber*3//5
gui, 6:-caption +AlwaysOnTop +Disabled +Owner
gui, 6:font, s%s%
gui, 6:add, text,, Please wait ...
gui, 6:show, x%x% y%y% NoActivate
return

;---------------------------------------------------------------------------------------------

fill(rc, n)
{
	global
	if (cell%rc% <> n)
	{
		tooltip
		if guitip = 1
		{
			gui, 5:destroy
			guitip = 0
		}
	}
	if (JustHighlighted <> 1 and cell%rc% <> n)
		loop, parse, cells, -
			highlight(a_loopfield, 0)
	cell%rc% = %n%
	if CreateIndex = 3
	ifnotinstring, image, %rc%
		return
	if DontDisplay = 1
		return
	loop, 9
		PencilMark(rc, a_index, 0)
	if n = 0
	{
		if (LastFill%rc% <> 0)
		{
			guicontrol, 1:text, cell%rc%
			LastFill%rc% = 0
		}
	}
	else
	{
		if switch = colors
		{
			if (LastFill%rc% <> color%n%value . sColor . "Webdings" . "=" or JustHighlighted = 1)
			{
				color := color%n%value
				gui, 1:font, c%color% s%sColor%, Webdings
				guicontrol, 1:font, cell%rc%
				guicontrol, 1:text, cell%rc%, =
				LastFill%rc% := color%n%value . sColor . "Webdings" . "="
			}
		}
		else
		{
			if (LastFill%rc% <> sNumber . "Ubuntu Arial" . n 
			or JustHighlighted = 1
			or cNumber%rc% <> "" and MultipleChange > 1)
			{
				cNumber%rc% =
				if (a_thislabel = "CellsSize" and fixed <> "")
					gui, 1:font, cgreen s%sNumber%
				else
					gui, 1:font, c222222 s%sNumber%
				gui, 1:font,, Ubuntu
				gui, 1:font,, Arial
				guicontrol, 1:font, cell%rc%
				guicontrol, 1:text, cell%rc%, %n%
				LastFill%rc% := sNumber . "Ubuntu Arial" . n
			}
		}
	}
}

;---------------------------------------------------------------------------------------------

highlight(rc, color)
{
	global
	highlight%rc% = %color%
	if highlight%rc% = 0
	{
		if LastHighlight%rc% <> 0
		{
			guicontrol, 1:text, highlight%rc%
			LastHighlight%rc% = 0
			JustHighlighted = 1
			if cell%rc% <> 0
				fill(rc, cell%rc%)
			else loop, 9
				PencilMark(rc, a_index, PencilMark%rc%%a_index%)
			JustHighlighted = 0
		}
	}
	else
	{
		if (LastHighlight%rc% <> highlight%rc% . sHighlight)
		{
			if highlight%rc% = red
				RealColor = 0xFFCCCC
			else if highlight%rc% = green
				RealColor = 0xCCFFCC
			else if highlight%rc% = blue
				RealColor = 0xCCCCFF
			gui, 1:font, c%RealColor% s%sHighlight%, Webdings
			guicontrol, 1:font, highlight%rc%
			guicontrol, 1:text, highlight%rc%, g
			LastHighlight%rc% := highlight%rc% . sHighlight
			JustHighlighted = 1
			if cell%rc% <> 0
				fill(rc, cell%rc%)
			else loop, 9
				PencilMark(rc, a_index, PencilMark%rc%%a_index%)
			JustHighlighted = 0
		}
	}
}

;---------------------------------------------------------------------------------------------

PencilMark(rc, n, value)
{
	global
	PencilMark%rc%%n% = %value%
	if value = 0
	{
		if (LastPencilMark%rc%%n% <> 0)
		{
			guicontrol, 1:text, PencilMark%rc%%n%
			LastPencilMark%rc%%n% = 0
		}
	}
	else if value = 1
	{
		if switch = colors
		{
			if (LastPencilMark%rc%%n% <> color%n%value . sPencilColor . "Webdings" . "=" or JustHighlighted = 1)
			{
				color := color%n%value
				gui, 1:font, c%color% s%sPencilColor%, Webdings
				guicontrol, 1:font, PencilMark%rc%%n%
				guicontrol, 1:text, PencilMark%rc%%n%, =
				LastPencilMark%rc%%n% := color%n%value . sPencilColor . "Webdings" . "="
			}
		}
		else
		{
			if (LastPencilMark%rc%%n% <> sPencilNumber . "Ubuntu Arial" . n or JustHighlighted = 1)
			{
				gui, 1:font, c222222 s%sPencilNumber%
				gui, 1:font,, Ubuntu
				gui, 1:font,, Arial
				guicontrol, 1:font, PencilMark%rc%%n%
				guicontrol, 1:text, PencilMark%rc%%n%, %n%
				LastPencilMark%rc%%n% := sPencilNumber . "Ubuntu Arial" . n
			}
		}
	}
}

;---------------------------------------------------------------------------------------------

GuiToString()
{
	global
	string = %switch%-%cBackground%-
	if (switch = "numbers" and a_thislabel = "SaveAs") ; remember colored numbers only when you save them
	{
		loop, parse, cells, -
			if (cell%a_loopfield% <> 0 and cNumber%a_loopfield% <> "")
				string := string . a_loopfield . cNumber%a_loopfield% . ","
		stringright, x, string, 1
		if (x = ",")
			stringtrimright, string, string, 1
	}
	loop, parse, cells, -
		if (cell%a_loopfield% <> 0)
			string := string . "-" . a_loopfield . cell%a_loopfield%
	loop, parse, cells, -
		if (cell%a_loopfield% = 0)
			loop, 9
				if (PencilMark%a_loopfield%%a_index% = 1)
					string := string . "-" . a_loopfield . "p" . a_index
	return string
}

;---------------------------------------------------------------------------------------------

StringToGui(string)
{
	global
	loop, parse, cells, -
	{
		cell%a_loopfield%new = 0
		loop, 9
			PencilMark%a_loopfield%%a_index%new = 0
	}
	MultipleChange = 0
	loop, parse, string, -, `n`r
	{
		if a_index = 1
			switch = %a_loopfield%
		else if a_index = 2
		{
			if (a_loopfield <> cBackground)
				gui, 1:color, %a_loopfield%
			cBackground = %a_loopfield%
		}
		else if a_index = 3
			ColoredNumbers = %a_loopfield%
		else
		{
			stringleft, rc, a_loopfield, 2
			stringright, n, a_loopfield, 1
			ifnotinstring, a_loopfield, p
			{
				cell%rc%new = %n%
				if (cell%rc% <> n)
					MultipleChange += 1
			}
			else
				PencilMark%rc%%n%new = 1
		}
	}
	loop, parse, cells, -
	{
		if (cell%a_loopfield%new <> 0)
			fill(a_loopfield, cell%a_loopfield%new)
		else
		{
			if cell%a_loopfield% <> 0
				fill(a_loopfield, 0)
			loop, 9
				PencilMark(a_loopfield, a_index, PencilMark%a_loopfield%%a_index%new)
		}
	}
	MultipleChange = 0
	loop, parse, ColoredNumbers, `,
	{
		stringleft, rc, a_loopfield, 2
		stringtrimleft, color, a_loopfield, 2
		gui, 1:font, c%color% s%sNumber%
		gui, 1:font,, Ubuntu
		gui, 1:font,, Arial
		guicontrol, 1:font, cell%rc%
		cNumber%rc% = %color%
	}
}

;---------------------------------------------------------------------------------------------

fix(color)
{
	global
	fixed =
	loop, parse, cells, -
	if cell%a_loopfield% <> 0
	{
		fixed = %fixed%%a_loopfield%-
		if (switch = "numbers" and color <> "")
		{
			FixColor = %color%
			gui, 1:font, c%color% s%sNumber%
			gui, 1:font,, Ubuntu
			gui, 1:font,, Arial
			guicontrol, 1:font, cell%a_loopfield%
		}
	}
	FixIndex = %HistoryIndex%
}

unfix()
{
	global
	if (switch = "numbers" and FixColor <> "")
	loop, parse, fixed, -
	if a_loopfield <>
	{
		gui, 1:font, c222222 s%sNumber%
		gui, 1:font,, Ubuntu
		gui, 1:font,, Arial
		guicontrol, 1:font, cell%a_loopfield%
	}
	fixed =
	FixColor =
	FixIndex =
}

;---------------------------------------------------------------------------------------------

history(add)
{
	global
	if (HistoryIndexMax > HistoryIndex)
	{
		l := HistoryIndexMax - HistoryIndex
		loop, %l%
		{
			i := HistoryIndex + a_index
			history%i% =
		}
	}
	HistoryIndex += 1
	HistoryIndexMax = %HistoryIndex%
	if (add = "gui")
		add := GuiToString()
	history%HistoryIndex% = %add%
}

;---------------------------------------------------------------------------------------------

GetPossibleNumbers:

; contents:
; get possible numbers for every cell
; possible numbers are step by step excluded by the following loops:
; loop 4
; {
;	list cells with only two possible numbers
;	solving techniques using CellsWith2PossibleNumbers:
;	- two cells with the same two possible numbers (different from "two numbers with the same two possible cells"!)
;	- Y-wings/chains
;	loop units
;	loop numbers
;	{
;		list possible cells for every number in every unit
;		solving techniques using PossibleCells%u%%n%:
;		- two numbers with the same two possible cells (different from "two cells with the same two possible numbers"!)
;		- two or three possible cells with the same row or column and block
;		- empty rectangle
;		- X-wing
;		- Swordfish
;	}
; }

anything = 0
loop, parse, cells, -
	if cell%a_loopfield% = 0
{
	PossibleNumbers%a_loopfield% = 123456789
	anything = 1
}
if (anything = 0)
{
	WhatNext =
	return
}
loop, 27
{
	u = %a_index%
	loop, 9
		PossibleCells%u%%a_index% =
}
loop, parse, cells, -
	loop, 9
		explain%a_loopfield%%a_index% =
; explainxyz will be a text string, explaining why z can't be set in cell xy,
; or the index of a unit where z can only be set in cell xy.
;---- get possible numbers for every cell ----
loop, parse, cells, -
{
	rc = %a_loopfield%
	if cell%rc% = 0
	{
		loop, parse, ConnectedCells%rc%, -
			if cell%a_loopfield% <> 0
		{
			n := cell%a_loopfield%
			DeletePossibleNumber(rc, n)
		}
		if (CreateIndex = 2 or CreateIndex = 3)
		if DeletedNumbers%rc% <>
			loop, parse, DeletedNumbers%rc%
				DeletePossibleNumber(rc, a_loopfield)
		PossibleNumbersAll%rc% := PossibleNumbers%rc%
		stringlen, PossibleNumbersLen, PossibleNumbers%rc%
		if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
		{
			WhatNext = %PossibleNumbersLen%%rc%
			return
		}
	}
}
loop, 4
{
	main_index = %a_index%
	if (main_index = 2 and explain = 1)
		gosub PleaseWait
	CellsWith2PossibleNumbers =
	loop, parse, cells, -
		if (cell%a_loopfield% = 0)
	{
		stringlen, PossibleNumbersLen, PossibleNumbers%a_loopfield%
		if (PossibleNumbersLen = 2)
			CellsWith2PossibleNumbers = %CellsWith2PossibleNumbers%%a_loopfield%-
	}
	stringtrimright, CellsWith2PossibleNumbers, CellsWith2PossibleNumbers, 1
	;---- two cells with the same two possible numbers ---- (different from "two numbers with the same two possible cells"!)
	loop, parse, CellsWith2PossibleNumbers, -
	{
		rc1 = %a_loopfield%
		loop, parse, CellsWith2PossibleNumbers, -
			ifinstring, ConnectedCells%rc1%, %a_loopfield%
		{
			rc2 = %a_loopfield%
			if (PossibleNumbers%rc1% = PossibleNumbers%rc2%)
			{
				del1 := SubStr(PossibleNumbers%rc1%, 1, 1)
				del2 := SubStr(PossibleNumbers%rc1%, 2, 1)
				loop, parse, ConnectedCells%rc1%, -
					ifinstring, ConnectedCells%rc2%, %a_loopfield%
						if (cell%a_loopfield% = 0)
							if (InStr(PossibleNumbers%a_loopfield%, del1) or InStr(PossibleNumbers%a_loopfield%, del2))
				{
					rc3 = %a_loopfield%
					if explain = 1
					{
						text = can't be in coord%rc3%<red> because %del1%# and %del2%# are the only possible numbers in both coord%rc1%<blue> and coord%rc2%<blue>, so they will be there.
						loop, 9
							if (a_index <> del1 and a_index <> del2)
						{
							text := ExplainAdd("text", rc1 . a_index)  ; Have there been other possible numbers in rc1?
							text := ExplainAdd("text", rc2 . a_index)  ; Have there been other possible numbers in rc2?
						}
						if InStr(PossibleNumbers%rc3%, del1)
							explain%rc3%%del1% = %del1%# %text%
						if InStr(PossibleNumbers%rc3%, del2)
							explain%rc3%%del2% = %del2%# %text%
					}
					DeletePossibleNumber(rc3, del1)
					DeletePossibleNumber(rc3, del2)
					stringlen, PossibleNumbersLen, PossibleNumbers%rc3%
					if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
					{
						WhatNext = %PossibleNumbersLen%%rc3%
						return
					}
				}
			}
		}
	}
	if (main_index > 1)  ; try basic solving techniques first
		if (explain = 1 or GetAll = 1)
	{
		;---- Y-wings/chains ----
		loop, 9
		{
			ChainCell%a_index% =
			push%a_index% =
		}
		loop, parse, CellsWith2PossibleNumbers, -
		{
			ChainCell1 = %a_loopfield%
			loop, parse, PossibleNumbers%ChainCell1%
			{
				push1 = %a_loopfield%
				loop, parse, ConnectedCells%ChainCell1%, -
					if (PossiblePush(1,"","","","","","") = 1)
				{
					ChainCell2 = %a_loopfield%
					push2 := OtherNumber(PossibleNumbersNow, push1)
					loop, parse, ConnectedCells%ChainCell2%, -
						if (PossiblePush(2,1,"","","","","") = 1 and circle(1,"","","","","") <> 1)
					{
						ChainCell3 = %a_loopfield%
						push3 := OtherNumber(PossibleNumbersNow, push2)
						if chain(3) = 1
							return
						loop, parse, ConnectedCells%ChainCell3%, -
							if (PossiblePush(3,1,2,"","","","") = 1 and circle(1,2,"","","","") <> 1)
						{
							ChainCell4 = %a_loopfield%
							push4 := OtherNumber(PossibleNumbersNow, push3)
							if chain(4) = 1
								return
							loop, parse, ConnectedCells%ChainCell4%, -
								if (PossiblePush(4,1,2,3,"","","") = 1 and circle(1,2,3,"","","") <> 1)
							{
								ChainCell5 = %a_loopfield%
								push5 := OtherNumber(PossibleNumbersNow, push4)
								if chain(5) = 1
									return
								loop, parse, ConnectedCells%ChainCell5%, -
									if (PossiblePush(5,1,2,3,4,"","") = 1 and circle(1,2,3,4,"","") <> 1)
								{
									ChainCell6 = %a_loopfield%
									push6 := OtherNumber(PossibleNumbersNow, push5)
									if chain(6) = 1
										return
									loop, parse, ConnectedCells%ChainCell6%, -
										if (PossiblePush(6,1,2,3,4,5,"") = 1 and circle(1,2,3,4,5,"") <> 1)
									{
										ChainCell7 = %a_loopfield%
										push7 := OtherNumber(PossibleNumbersNow, push6)
										if chain(7) = 1
											return
										loop, parse, ConnectedCells%ChainCell7%, -
											if (PossiblePush(7,1,2,3,4,5,6) = 1 and circle(1,2,3,4,5,6) <> 1)
										{
											ChainCell8 = %a_loopfield%
											push8 := OtherNumber(PossibleNumbersNow, push7)
											if chain(8) = 1
												return
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	loop, 27  ; units
	{
		u = %a_index%
		loop, 9  ; numbers
		{
			n = %a_index%
			;---- list possible cells for every number in every unit ----
			nAlreadyInU = 0
			PossibleCells%u%%n% =
			loop, parse, unit%u%, -
			{
				if cell%a_loopfield% = %n%
				{
					nAlreadyInU = 1
					break
				}
				else if cell%a_loopfield% = 0
				{
					ifinstring, PossibleNumbers%a_loopfield%, %n%
						PossibleCells%u%%n% := PossibleCells%u%%n% . a_loopfield . "-"
				}
			}
			stringlen, PossibleCellsLen, PossibleCells%u%%n%
			if (nAlreadyInU = 0 and PossibleCellsLen = 0)  ; Number n is not and can not be set in unit u.
			{
				WhatNext = x%u%%n%
				return
			}
			else if PossibleCellsLen = 3  ; In unit u number n must be ...
			{
				stringleft, rc, PossibleCells%u%%n%, 2  ; ... in cell rc.
				PossibleNumbers%rc% = %n%
				if explain = 1
					explain%rc%%n% = %u%
				if GetAll <> 1
				{
					WhatNext = 1%rc%
					return
				}
			}
			else
			{
				;---- two numbers with the same two possible cells ---- (different from "two cells with the same two possible numbers"!)
				if PossibleCellsLen = 6
					loop, % n-1
						if (PossibleCells%u%%a_index% = PossibleCells%u%%n%)
				{
					n2 = %a_index%
					loop, parse, PossibleCells%u%%n%, -
						if a_loopfield <>
					{
						rc = %a_loopfield%
						if explain = 1
							loop, parse, PossibleNumbers%rc%
								if (a_loopfield <> n and a_loopfield <> n2)
						{
							n3 = %a_loopfield%
							stringleft, rc1, PossibleCells%u%%n%, 2
							stringmid, rc2, PossibleCells%u%%n%, 4, 2
							explain%rc%%n3% = %n3%# can't be in coord%rc%<red> because in unit %u% %n2%# and %n%# can be only in coord%rc1%<blue> and coord%rc2%<blue>, so they will be there.
							loop, parse, unit%u%, -
								if (a_loopfield <> rc1 and a_loopfield <> rc2)
							{
								explain%rc%%n3% := ExplainAdd(rc . n3, a_loopfield . n)
								explain%rc%%n3% := ExplainAdd(rc . n3, a_loopfield . n2)
							}
						}
						PossibleNumbers%rc% = %n2%%n%
					}
					break
				}
				;---- two or three possible cells with the same row or column and block ----
				if (PossibleCellsLen = 6 or PossibleCellsLen = 9)
				{
					stringleft, pc1, PossibleCells%u%%n%, 2
					if (u <= 18)  ; u = row or column => u2 must be a block
						BorRC := block%pc1%
					else
					{
						stringleft, r, pc1, 1
						stringright, c, pc1, 1
						c += 9
						BorRC = %r%-%c%
					}
					loop, parse, BorRC, -
					{
						u2 = %a_loopfield%
						AllInU2 = 1
						loop, parse, PossibleCells%u%%n%, -
							if a_loopfield <>
							ifnotinstring, unit%u2%, %a_loopfield%
						{
							AllInU2 = 0
							break
						}
						if AllInU2 = 1
						{
							loop, parse, unit%u2%, -
								if cell%a_loopfield% = 0
								ifnotinstring, PossibleCells%u%%n%, %a_loopfield%
								ifinstring, PossibleNumbers%a_loopfield%, %n%
							{
								rc = %a_loopfield%
								if explain = 1
								{
									string = %n%# can't be in coord%rc%<red> because in unit %u% it must be in
									loop, parse, PossibleCells%u%%n%, -
										if a_loopfield <>
											string = %string% coord%a_loopfield%<blue> or
									stringtrimright, string, string, 3
									explain%rc%%n% = %string%.
									loop, parse, unit%u%, -
										if (InStr(unit%u2%, a_loopfield) = 0)
											explain%rc%%n% := ExplainAdd(rc . n, a_loopfield . n)
								}
								DeletePossibleNumber(rc, n)
								stringlen, PossibleNumbersLen, PossibleNumbers%rc%
								if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
								{
									WhatNext = %PossibleNumbersLen%%rc%
									return
								}
							}
							break
						}
					}
				}
				if (main_index > 1)  ; try basic solving techniques first
					if (explain = 1 or GetAll = 1)
				{
					;---- empty rectangle ----
					if (PossibleCellsLen >= 6 and PossibleCellsLen <= 15)
					{
						loop, parse, unit%u%, -
						{
							rc = %a_loopfield%
							AllInCrossRoadsRC = 1
							loop, parse, PossibleCells%u%%n%, -
								if a_loopfield <>
									if (InStr(CrossRoads%rc%, a_loopfield) = 0)
							{
								AllInCrossRoadsRC = 0
								break
							}
							if (AllInCrossRoadsRC = 1)
							{
								rows =
								columns =
								loop, parse, PossibleCells%u%%n%, -
									if a_loopfield <>
								{
									if (InStr(rows, SubStr(a_loopfield, 1, 1)) = 0)
										rows .= SubStr(a_loopfield, 1, 1)
									if (InStr(columns, SubStr(a_loopfield, 2, 1)) = 0)
										columns .= SubStr(a_loopfield, 2, 1)
								}
								if (StrLen(rows) < 2 or StrLen(columns) < 2)	; all in one row or column
									AllInCrossRoadsRC = 0												; => no crossroads, only one road
							}
							if (AllInCrossRoadsRC = 1)
							{
								road1 := CrossRoads%rc%r
								road2 := CrossRoads%rc%c
								loop, 9
								{
									ChainCell%a_index% =
									push%a_index% =
								}
								loop, parse, unit%road1%, -																					; road1
									if (InStr(unit%u%, a_loopfield) = 0
									and InStr(CellsWith2PossibleNumbers, a_loopfield) <> 0
									and InStr(PossibleNumbers%a_loopfield%, n) <> 0)
								{
									ChainCell1 = %a_loopfield%
									push1 := OtherNumber(PossibleNumbers%ChainCell1%, n)
									loop, parse, unit%road2%, -																				; road2
										if (InStr(unit%u%, a_loopfield) = 0
										and InStr(CellsWith2PossibleNumbers, a_loopfield) <> 0
										and InStr(PossibleNumbers%a_loopfield%, n) <> 0)
									{
										ChainCell2 = %a_loopfield%
										push2 := OtherNumber(PossibleNumbers%ChainCell2%, n)
										if ChainEmptyRectangle(1, 2) = 1
											return
										loop, parse, ConnectedCells%ChainCell1%, -											; road1
											if (PossiblePush(1,"","","","","","") = 1 and circle(2,"","","","","") <> 1)
										{
											ChainCell3 = %a_loopfield%
											push3 := OtherNumber(PossibleNumbersNow, push1)
											if ChainEmptyRectangle(2, 3) = 1
												return
											loop, parse, ConnectedCells%ChainCell2%, -										; road2
												if (PossiblePush(2,"","","","","","") = 1 and circle(1,3,"","","","") <> 1)
											{
												ChainCell4 = %a_loopfield%
												push4 := OtherNumber(PossibleNumbersNow, push2)
												if ChainEmptyRectangle(3, 4) = 1
													return
												loop, parse, ConnectedCells%ChainCell3%, -									; road1
													if (PossiblePush(3,1,"","","","","") = 1 and circle(1,2,4,"","","") <> 1)
												{
													ChainCell5 = %a_loopfield%
													push5 := OtherNumber(PossibleNumbersNow, push3)
													if ChainEmptyRectangle(4, 5) = 1
														return
													loop, parse, ConnectedCells%ChainCell4%, -								; road2
														if (PossiblePush(4,2,"","","","","") = 1 and circle(1,2,3,5,"","") <> 1)
													{
														ChainCell6 = %a_loopfield%
														push6 := OtherNumber(PossibleNumbersNow, push4)
														if ChainEmptyRectangle(5, 6) = 1
															return
														loop, parse, ConnectedCells%ChainCell5%, -							; road1
															if (PossiblePush(5,1,3,"","","","") = 1 and circle(1,2,3,4,6,"") <> 1)
														{
															ChainCell7 = %a_loopfield%
															push7 := OtherNumber(PossibleNumbersNow, push5)
															if ChainEmptyRectangle(6, 7) = 1
																return
															loop, parse, ConnectedCells%ChainCell6%, -						; road2
																if (PossiblePush(6,2,4,"","","","") = 1 and circle(1,2,3,4,5,7) <> 1)
															{
																ChainCell8 = %a_loopfield%
																push8 := OtherNumber(PossibleNumbersNow, push6)
																if ChainEmptyRectangle(7, 8) = 1
																	return
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
					;---- X-wing ----
					if (PossibleCellsLen = 6)
					{
						stringleft, A, PossibleCells%u%%n%, 2
						stringmid, B, PossibleCells%u%%n%, 4, 2
						loop, % u-1  ; iterations u+1 to 27 would get earlier PossibleCells
						{
							u2 = %a_index%
							stringlen, p2, PossibleCells%u2%%n%
							stringleft, C, PossibleCells%u2%%n%, 2
							stringmid, D, PossibleCells%u2%%n%, 4, 2
							if (p2 = 6 and A <> C and A <> D and B <> C and B <> D)
							{
								positions = %A%%B%%C%%D%/%B%%A%%C%%D%/%A%%B%%D%%C%/%B%%A%%D%%C%
								loop, parse, positions, /
								{
									stringleft, uCell1, a_loopfield, 2
									stringmid, uCell2, a_loopfield, 3, 2
									stringmid, u2Cell1, a_loopfield, 5, 2
									stringright, u2Cell2, a_loopfield, 2
									ifinstring, ConnectedCells%uCell1%, %u2Cell1%
									ifnotinstring, ConnectedCells%uCell2%, %u2Cell1%
									ifnotinstring, ConnectedCells%u2Cell2%, %uCell1%
									{
										loop, parse, ConnectedCells%uCell2%, -
											if cell%a_loopfield% = 0
											ifinstring, ConnectedCells%u2Cell2%, %a_loopfield%
											ifinstring, PossibleNumbers%a_loopfield%, %n%
											{
												rc = %a_loopfield%
												explain%rc%%n% =
(
%n%# can't be in coord%rc%<red> because
- if in unit %u2% it is in coord%u2Cell1%<blue> then in unit %u% it must be in coord%uCell2%<blue>
- if in unit %u% it is in coord%uCell1%<blue> then in unit %u2% it must be in coord%u2Cell2%<blue>.
Either way %n%# can't be in coord%rc% because coord%rc% is connected with both coord%uCell2% and coord%u2Cell2%.
)
												loop, parse, unit%u%, -
													ifnotinstring, PossibleCells%u%%n%, %a_loopfield%
														explain%rc%%n% := ExplainAdd(rc . n, a_loopfield . n)
												loop, parse, unit%u2%, -
													ifnotinstring, PossibleCells%u2%%n%, %a_loopfield%
														explain%rc%%n% := ExplainAdd(rc . n, a_loopfield . n)
												DeletePossibleNumber(rc, n)
												stringlen, PossibleNumbersLen, PossibleNumbers%rc%
												if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
												{
													WhatNext = %PossibleNumbersLen%%rc%
													return
												}
											}
									}
								}
							}
						}
					}
					;---- Swordfish/Jellyfish ----
					if (main_index > 1)  ; don't catch too many fish
						if (u <= 18)
							if (PossibleCellsLen = 6 or PossibleCellsLen = 9 or PossibleCellsLen = 12)
					{
						loop, 18
							if water(2) = 1
								loop, 18
								{
									if water(3) = 2
										return
									else if water(3) = 1
									{
										loop, 18
											if water(4) = 2
												return
									}
								}
					}
				}
			}
		}
	}
}
WhatNext =
loop, parse, cells, -
	if cell%a_loopfield% = 0
	{
		stringlen, PossibleNumbersLen, PossibleNumbers%a_loopfield%
		WhatNext = %WhatNext%%PossibleNumbersLen%%a_loopfield%-
	}
sort, WhatNext, d-
return

;-------- subroutines A-Z for GetPossibleNumbers --------

chain(index)
{
	global
	LastChainCell := ChainCell%index%
	LastPush := push%index%
	if (LastPush = OtherNumber(PossibleNumbers%ChainCell1%, push1))
		loop, parse, cells, -
			if (cell%a_loopfield% = 0)
				ifinstring, ConnectedCells%ChainCell1%, %a_loopfield%
					ifinstring, ConnectedCells%LastChainCell%, %a_loopfield%
						ifinstring, PossibleNumbers%a_loopfield%, %LastPush%
	{
; Any other empty cell with LastPush as possible number (there may be more possible numbers) that "sees"
; both start and end of the chain. The chain prevents LastPush from being in this cell.
		SeeBoth = %a_loopfield%
		SeeWhat = %LastPush%
		3CellsWith3PossibleNumbers = 0
		if (index = 3)
		{
			stringleft, r1, SeeBoth, 1
			stringleft, r2, ChainCell1, 1
			stringleft, r3, ChainCell2, 1
			stringleft, r4, ChainCell3, 1
			stringright, c1, SeeBoth, 1
			stringright, c2, ChainCell1, 1
			stringright, c3, ChainCell2, 1
			stringright, c4, ChainCell3, 1
			if  (r1 = r2 and r1 = r3 and r1 = r4
			or c1 = c2 and c1 = c3 and c1 = c4
			or block%SeeBoth% = block%ChainCell1% and block%SeeBoth% = block%ChainCell2% and block%SeeBoth% = block%ChainCell3%)
				3CellsWith3PossibleNumbers = 1
		}
		if 3CellsWith3PossibleNumbers = 1
		{
			ThreeBlueCells = %ChainCell1%-%ChainCell2%-%ChainCell3%
			ThreePossibleNumbers = %SeeWhat%-%push1%-%push2%
			sort, ThreeBlueCells, D-
			sort, ThreePossibleNumbers, N D-
			loop, parse, ThreeBlueCells, -
				blue%a_index% = %a_loopfield%
			loop, parse, ThreePossibleNumbers, -
				blueN%a_index% = %a_loopfield%
			explain%SeeBoth%%blueN1% = Together, the three blue cells coord%blue1%<blue> and coord%blue2%<blue> and coord%blue3%<blue> have the three possible numbers %blueN1%# and %blueN2%# and %blueN3%#. So %blueN1%# and %blueN2%# and %blueN3%# will be somewhere in coord%blue1% and coord%blue2% and coord%blue3% and therefore can't be in coord%SeeBoth%<red>.
			explain%SeeBoth%%blueN2% := explain%SeeBoth%%blueN1%
			explain%SeeBoth%%blueN3% := explain%SeeBoth%%blueN1%
			text =
			loop, parse, ThreeBlueCells, -
				loop, 9
					if (InStr(ThreePossibleNumbers, a_index) = 0)  ; Have there been other possible numbers in the three blue cells?
						text := ExplainAdd("text", a_loopfield . a_index)
			explain%SeeBoth%%blueN1% := explain%SeeBoth%%blueN1% . text
			explain%SeeBoth%%blueN2% := explain%SeeBoth%%blueN2% . text
			explain%SeeBoth%%blueN3% := explain%SeeBoth%%blueN3% . text
			DeletePossibleNumber(SeeBoth, blueN1)
			DeletePossibleNumber(SeeBoth, blueN2)
			DeletePossibleNumber(SeeBoth, blueN3)
			stringlen, PossibleNumbersLen, PossibleNumbers%SeeBoth%
			if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
			{
				WhatNext = %PossibleNumbersLen%%SeeBoth%
				return 1
			}
		}
		else
		{
			chain =
			ChainText1 = %SeeWhat%# can't be in coord%SeeBoth%<red> because of the chain
			ChainText2 = If there is %SeeWhat%# in coord%ChainCell1%, then there can't be %SeeWhat%# in coord%SeeBoth%. Else, if
			loop, %index%
			{
				chain := chain . ChainCell%a_index% . "-"
				ChainText1 := ChainText1 . " coord" . ChainCell%a_index% . "<blue> -"
				ChainText2 := ChainText2 . " there is " . push%a_index% . "# in coord" . ChainCell%a_index% . ", then"
			}
			stringtrimright, chain, chain, 1		; trim "-"
			stringtrimright, ChainText1, ChainText1, 2	; trim " -"
			stringtrimright, ChainText2, ChainText2, 4	; trim "then"
			explain%SeeBoth%%SeeWhat% = %ChainText1%: %ChainText2% and again, there can't be %SeeWhat%# in coord%SeeBoth%.
			loop, parse, chain, -
				loop, 9
					if (InStr(PossibleNumbers%a_loopfield%, a_index) = 0)
						explain%SeeBoth%%SeeWhat% := ExplainAdd(SeeBoth . SeeWhat, a_loopfield . a_index)
			DeletePossibleNumber(SeeBoth, SeeWhat)
			stringlen, PossibleNumbersLen, PossibleNumbers%SeeBoth%
			if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
			{
				WhatNext = %PossibleNumbersLen%%SeeBoth%
				return 1
			}
		}
	}
}

ChainEmptyRectangle(index1, index2)
{
	global
	ChainCellindex1 := ChainCell%index1%
	pushindex1 := push%index1%
	ChainCellindex2 := ChainCell%index2%
	pushindex2 := push%index2%
	if (pushindex1 = pushindex2)
		loop, parse, cells, -
			if (cell%a_loopfield% = 0 
			and InStr(ConnectedCells%ChainCellindex1%, a_loopfield)
			and InStr(ConnectedCells%ChainCellindex2%, a_loopfield)
			and InStr(PossibleNumbers%a_loopfield%, pushindex1))
	{
									DeleteN = %pushindex1%
									FromRC = %a_loopfield%
									TextCrossRoads =
									TextRoad1 =
									TextRoad2 =
									loop, parse, PossibleCells%u%%n%, -
										if a_loopfield <>
									{
										TextCrossRoads = %TextCrossRoads% or coord%a_loopfield%<blue>
										stringleft, r, a_loopfield, 1
										if (r = road1)
											TextRoad1 = %TextRoad1% or coord%a_loopfield%
										stringright, c, a_loopfield, 1
										if (c = road2-9)
											TextRoad2 = %TextRoad2% or coord%a_loopfield%
									}
									stringtrimleft, TextCrossRoads, TextCrossRoads, 3	; AutoTrim already omitted the space from the beginning
									stringtrimleft, TextRoad1, TextRoad1, 3				;							"
									stringtrimleft, TextRoad2, TextRoad2, 3				;							"
									TextChain1 =
									TextChain2 =
									loop, %index2%
										if mod(a_index, 2) = 0  ; road2 leads to Chaincell2, Chaincell4, Chaincell6
											TextChain2 .= ", then in coord" . ChainCell%a_index% . "<blue> there must be " . push%a_index% . "#"
										else  ; road1 leads to Chaincell1, Chaincell3, Chaincell5
											TextChain1 .= ", then in coord" . ChainCell%a_index% . "<blue> there must be " . push%a_index% . "#"
									text = %DeleteN%# can't be in coord%FromRC%<red> because of %n%# in unit %u%: In unit %u%, %n%# must be in %TextCrossRoads%; if %n%# is in %TextRoad1%%TextChain1%, and %DeleteN%# can't be in coord%FromRC%. Else, if %n%# is in %TextRoad2%%TextChain2%, and again, %DeleteN%# can't be in coord%FromRC%.
									loop, parse, unit%u%, -
										if (InStr(unit%road1%, a_loopfield) = 0 and InStr(unit%road2%, a_loopfield) = 0)
											text := ExplainAdd("text", a_loopfield . n)
									loop, %index2%
									{
										ChainCella_index := ChainCell%a_index%
											loop, 9
												if (InStr(PossibleNumbers%ChainCella_index%, a_index) = 0)
													text := ExplainAdd("text", ChainCella_index . a_index)
									}
									explain%FromRC%%DeleteN% = %text%
									DeletePossibleNumber(FromRC, DeleteN)
									stringlen, PossibleNumbersLen, PossibleNumbers%FromRC%
									if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
									{
										WhatNext = %PossibleNumbersLen%%FromRC%
										return 1
									}
	}
}

circle(i1, i2, i3, i4, i5, i6)
{
	global
; i1 to i6 are the indices of all chain cells (empty rectangle: of both roads) except the "push" cell.
	NextChainCell = %a_loopfield%
	chain = %i1%%i2%%i3%%i4%%i5%%i6%
	loop, parse, chain
		if (NextChainCell = ChainCell%a_loopfield%)
			return 1
}

DeletePossibleNumber(cell, number)
{
	global
	if InStr(PossibleNumbers%cell%, number)
		stringreplace, PossibleNumbers%cell%, PossibleNumbers%cell%, %number%,
}

ExplainAdd(cell1n1, cell2n2)
{
	global
	if (cell1n1 = "text")
		explain1 = %text%
	else
		explain1 := explain%cell1n1%
	explain2 := explain%cell2n2%
	if (explain2 <> "" and InStr(explain1, explain2) = 0)
			explain1 .= "`n" . explain2
	return explain1
}

OtherNumber(PossibleNumbers, push)
{
	loop, parse, PossibleNumbers
		if (a_loopfield <> push)
	{
		return a_loopfield
		break
	}
}

PossiblePush(iPush, i1, i2, i3, i4, i5, i6)
{
	global
; iPush is the index of the "push" cell.
; i1 to i6 are the indices of chain cells before the "push" cell that might change the possible 
; numbers of the next chain cell = in normal chains all chain cells before the "push" cell,
; in empty rectangle chains the chain cells on the same road before the "push" cell.
	NextChainCell = %a_loopfield%
	if (cell%NextChainCell% <> 0)
		return 0
	PossibleNumbersNow := PossibleNumbers%NextChainCell%
	chain = %i1%%i2%%i3%%i4%%i5%%i6%
	loop, parse, chain
	{
		ChainCella_loopfield := ChainCell%a_loopfield%
		pusha_loopfield := push%a_loopfield%
		if (InStr(ConnectedCells%ChainCella_loopfield%, NextChainCell) and  InStr(PossibleNumbersNow, pusha_loopfield))
			PossibleNumbersNow := StrReplace(PossibleNumbersNow, pusha_loopfield)
	}
	if (StrLen(PossibleNumbersNow) = 2 and InStr(PossibleNumbersNow, push%iPush%))
		return 1
}

water(index)
{
	global
	u%index% = %a_index%
	if (u <= 9 and u%index% > 9 or u >= 10 and u%index% < 10)	; u and u%index% must be both rows or both columns
		return 0
	u1 = %u%
	loop, %index%
		if (a_index < index)
			if (u%a_index% = u%index%)							; u, u2, ..., uindex must be different
				return 0
	ui := u%index%
	if (PossibleCells%ui%%n% = "")
		return 0
	PossibleCellsLen := StrLen(PossibleCells%ui%%n%)
	if (PossibleCellsLen <> 6 and PossibleCellsLen <> 9 and PossibleCellsLen <> 12)
		return 0
	PossibleCells := PossibleCells%u%%n%  ; concatenate all possible cells of u, u2, ..., uindex
	loop, %index%
		if (a_index > 1)
	{
		ua_i := u%a_index%
		PossibleCells := PossibleCells . PossibleCells%ua_i%%n%
	}
	diagons =
	loop, parse, PossibleCells, -
		if a_loopfield <>
	{
		if (u <= 9)
			stringright, RorC, a_loopfield, 1
		else
			stringleft, RorC, a_loopfield, 1
		if (InStr(diagons, RorC) = 0)
			diagons = %diagons%%RorC%-
	}
	DiagonsLen := strlen(diagons)
	if (index = 3 and DiagonsLen = 6 or index = 4 and DiagonsLen = 8)
	{
		loop, parse, diagons, -
			if a_loopfield <>
		{
			d = %a_loopfield%
			if (u <= 9)	; if unit = row
				d += 9		; then diagon = column
			loop, parse, unit%d%, -
				if (InStr(PossibleCells, a_loopfield) = 0)
					if (cell%a_loopfield% = 0)
						if InStr(PossibleNumbers%a_loopfield%, n)
			{
				rc = %a_loopfield%
				;--------------------
				units = %u%-
				loop, %index%
					if (a_index > 1)
						units := units  . u%a_index% . "-"
				stringtrimright, units, units, 1
				sort, units, D-
				TextUnits =
				PossibleCells =  ; concatenate again to sort them according to the units
				loop, parse, units, -
				{
					TextUnits = %TextUnits% and unit %a_loopfield%
					PossibleCells := PossibleCells . PossibleCells%a_loopfield%%n%
				}
				stringtrimleft, TextUnits, TextUnits, 4
				;--------------------
				TextPossibleCells =
				loop, parse, PossibleCells, -
					if a_loopfield <>
						TextPossibleCells = %TextPossibleCells% or coord%a_loopfield%<blue>
				stringtrimleft, TextPossibleCells, TextPossibleCells, 3
				;--------------------
				sort, diagons, N D-
				TextDiagons =
				loop, parse, diagons, -
					if a_loopfield <>
				{
					d = %a_loopfield%
					if (u <= 9)	; if unit = row
						d += 9		; then diagon = column
					TextDiagons = %TextDiagons% or unit %d%
				}
				stringtrimleft, TextDiagons, TextDiagons, 3
				if (u <= 9)	; if unit = row
					DiagonsKind = column
				else
					DiagonsKind = row
				;--------------------
				explain%rc%%n% = %n%# can't be in coord%rc%<red> because in %TextUnits% %n%# must be in %TextPossibleCells%; that's all in %TextDiagons% and that's one %n%# for each %DiagonsKind%, so there can't be any more %n%#s in these %DiagonsKind%s.
				if (u <= 9)	; if unit = row
					d = 2	; the second digit of a cell could be in diagons
				else
					d = 1
				loop, %index%
				{
					if a_index = 1
						ua_i := u
					else
						ua_i := u%a_index%
					loop, parse, unit%ua_i%, -
						if (InStr(diagons, SubStr(a_loopfield, d, 1)) = 0)
							explain%rc%%n% := ExplainAdd(rc . n, a_loopfield . n)
				}
				DeletePossibleNumber(rc, n)
				stringlen, PossibleNumbersLen, PossibleNumbers%rc%
				if (PossibleNumbersLen = 0 or PossibleNumbersLen = 1 and GetAll <> 1)
				{
					WhatNext = %PossibleNumbersLen%%rc%
					return 2
				}
			}
		}
	}
	else if (index < 4 and DiagonsLen <= 8)  ; there might still be a Swordfish or Jellyfish
		return 1
}

;---------------------------------------------------------------------------------------------

FillMinimumFirst:
filled =
NoChoice =
loop, parse, cells, -
{
	FillMinimumFirst%a_loopfield% := cell%a_loopfield%
	minimum%a_loopfield% = 1
}
loop
{
	gosub GetPossibleNumbers
	if WhatNext =
	{
		SolutionAtAll = 1
		loop, parse, cells, -
			FirstSolution%a_loopfield% := cell%a_loopfield%
		return
	}
	stringleft, WhatNextLeft, WhatNext, 1
	if (WhatNextLeft = "x" or WhatNextLeft = 0)
	{
		if filled =
		{
			SolutionAtAll = 0
			return
		}
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		minimum%rc% := cell%rc%+1
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if WhatNextLeft = 1
	{
		stringmid, rc, WhatNext, 2, 2
		if (PossibleNumbers%rc% < minimum%rc%)
		{
			if filled =
			{
				SolutionAtAll = 0
				return
			}
			minimum%rc% = 1
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			minimum%rc% := cell%rc%+1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
			ifnotinstring, NoChoice, %rc%
				NoChoice = %NoChoice%%rc%-
			if (StopAt = 1 and rc = TryOmit and filled = NoChoice)
				return
		}
	}
	else if WhatNextLeft > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		loop, parse, PossibleNumbers%rc%
		{
			if (a_loopfield < minimum%rc%)
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			stringreplace, NoChoice, NoChoice, %rc%-,
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			if filled =
			{
				SolutionAtAll = 0
				return
			}
			minimum%rc% = 1
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			minimum%rc% := cell%rc%+1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return

;---------------------------------------------------------------------------------------------

FillMaximumFirst:
filled =
loop, parse, cells, -
{
	fill(a_loopfield, FillMinimumFirst%a_loopfield%)
	maximum%a_loopfield% = 9
}
loop
{
	gosub GetPossibleNumbers
	loop, parse, cells, -
	{
		rc = %a_loopfield%
		PossibleNumbersRev%rc% =
		loop, parse, PossibleNumbers%rc%
			PossibleNumbersRev%rc% := a_loopfield . PossibleNumbersRev%rc%
	}
	if WhatNext =
	{
		SecondSolutionIdentical = 1
		different = 0
		loop, parse, cells, -
			if (cell%a_loopfield% <> FirstSolution%a_loopfield%)
		{
			SecondSolutionIdentical = 0
			different += 1
		}
		return
	}
	stringleft, WhatNextLeft, WhatNext, 1
	if (WhatNextLeft = "x" or WhatNextLeft = 0)
	{
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		maximum%rc% := cell%rc%-1
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if WhatNextLeft = 1
	{
		stringmid, rc, WhatNext, 2, 2
		if (PossibleNumbers%rc% > maximum%rc%)
		{
			maximum%rc% = 9
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			maximum%rc% := cell%rc%-1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
		}
	}
	else if WhatNextLeft > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		loop, parse, PossibleNumbersRev%rc%
		{
			if (a_loopfield > maximum%rc%)
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			maximum%rc% = 9
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			maximum%rc% := cell%rc%-1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return

;---------------------------------------------------------------------------------------------

FillRandom:
filled =
NoChoice =
loop, parse, cells, -
	remaining%a_loopfield% = 123456789
loop
{
	gosub GetPossibleNumbers
	if WhatNext =
	{
		SolutionAtAll = 1
		return
	}
	stringleft, WhatNextLeft, WhatNext, 1
	if (WhatNextLeft = "x" or WhatNextLeft = 0)
	{
		if filled =
		{
			SolutionAtAll = 0
			return
		}
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		cellRC := cell%rc%
		stringreplace, remaining%rc%, remaining%rc%, %cellRC%,
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if WhatNextLeft = 1
	{
		stringmid, rc, WhatNext, 2, 2
		PossibleNumbersRC := PossibleNumbers%rc%
		ifnotinstring, remaining%rc%, %PossibleNumbersRC%
		{
			if filled =
			{
				SolutionAtAll = 0
				return
			}
			remaining%rc% = 123456789
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			cellRC := cell%rc%
			stringreplace, remaining%rc%, remaining%rc%, %cellRC%,
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
			ifnotinstring, NoChoice, %rc%
				NoChoice = %NoChoice%%rc%-
		}
	}
	else if WhatNextLeft > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		PossibleNumbersRC =
		loop, parse, PossibleNumbers%rc%
			PossibleNumbersRC = %PossibleNumbersRC%%a_loopfield%-
		stringtrimright, PossibleNumbersRC, PossibleNumbersRC, 1
		sort, PossibleNumbersRC, random d-
		loop, parse, PossibleNumbersRC, -
		{
			ifnotinstring, remaining%rc%, %a_loopfield%
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			stringreplace, NoChoice, NoChoice, %rc%-,
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			if filled =
			{
				SolutionAtAll = 0
				return
			}
			remaining%rc% = 123456789
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			cellRC := cell%rc%
			stringreplace, remaining%rc%, remaining%rc%, %cellRC%,
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return