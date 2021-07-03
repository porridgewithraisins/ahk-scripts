;#persistent
;SetCapsLockState, AlwaysOff

SendMode Input

!^t::
    Run terminal  
    return
!^b::
    Run brave 
    return
!^d::
    Run discord
    return
!^w::
    Run whatsapp
    return
!^s::
    Send,^lC:/Users/sandy-pc/Documents/ShareX/Screenshots/%A_YYYY%-%A_MM%{Enter}
    return

Appskey::!^v
RControl::#!d