#t::
   WinGet,var,Style,ahk_class Shell_TrayWnd

   if (var & 0x10000000){
      
      WinHide, ahk_class Shell_TrayWnd
   }
   else {
      WinShow, ahk_class Shell_TrayWnd
      WinActivate, ahk_class Shell_TrayWnd
   }
Return