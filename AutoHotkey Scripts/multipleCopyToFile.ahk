#NoEnv
#Persistent
OnClipboardChange("ClipChanged")			; place in script's auto-execute section 
return

    ClipChanged(Type) {
        If (type = 1)	; is (new) text in the clipboard?
			FileAppend, %Clipboard%`n, C:\Users\sandy-pc\Documents\multiplePasteFile.txt
    }