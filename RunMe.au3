#RequireAdmin
#Region
#AutoIt3Wrapper_Icon=Resources\ICONS\Skull.ico
#EndRegion
$SCMDLINE = @ScriptDir & "\Resources\NSudo.exe  -U:E -P:E -ShowWindowMode:Hide" & " " & _
            @ScriptDir & "\Resources\Adobe-GenP-3.0"
Run($SCMDLINE)
; DeTokenise by myAut2Exe >The Open Source AutoIT/AutoHotKey script decompiler< 2.16 build(215)
