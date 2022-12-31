#RequireAdmin
#Region
#AutoIt3Wrapper_Icon=ICONS\Skull.ico
#AutoIt3Wrapper_Res_Comment=2.0.0
#AutoIt3Wrapper_Res_Description=Adobe-GenP-3.0
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_ProductName=2.0.0
#AutoIt3Wrapper_Res_ProductVersion=2.0.0
#AutoIt3Wrapper_Res_CompanyName=2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=2.0.0
#AutoIt3Wrapper_Res_LegalTradeMarks=2.0.0
#EndRegion
Opt( "TrayAutoPause"	 , 0  )
Opt( "TrayIconHide"	 , 1  )
Opt( "GUICloseOnESC"	 , 0  )
Opt( "MustDeclareVars", 1  )

HotKeySet("{ESC}", "ShowEscMessage")

Global $Patch_BannerS                 =  "72656C6174696F6E7368697050726F66696C65"
Global $Patch_BannerR[1]              = ["78656C6174696F6E7368697050726F66696C65"]
;                                         ^^

; 72 65                   jb     0x67
; 78 65                   js     0x67
; 6c                      ins    BYTE PTR es:[edi],dx
; 61                      popa
; 74 69                   je     0x6f
; 6f                      outs   dx,DWORD PTR ds:[esi]
; 6e                      outs   dx,BYTE PTR ds:[esi]
; 73 68                   jae    0x72
; 69 70 50 72 6f 66 69    imul   esi,DWORD PTR [eax+0x50],0x69666f72
; 6c                      ins    BYTE PTR es:[edi],dx
; 65                      gs

Global $Patch_Profile_ExpiredS        =  "85C075(.{10})"        +"75(..)"   +"B892010000E9"
Global $Patch_Profile_ExpiredR[5]     = ["31C075", "004883FF0F", "75", "00", "B800000000E9"]
; 85 c0                   test   eax,eax
; 75                      jne    0x

; 00 48 83                add    BYTE PTR [eax-0x7d],cl
; ff 0f                   dec    DWORD PTR [edi]

; b8 92 01 00 00          mov    eax,0x192
; e9                      jmp    0x


; 31 c0                   xor    eax,eax


Global $Patch_CmpEax61S               =  "8B(..)" +"85C074(..)" +"83F80674(....)"   +"83(....)"   +"007D"
Global $Patch_CmpEax61R[9]            = ["C7", "??", "030000", "00", "83F80674", "00??", "83", "????", "00EB"]

Global $Patch_CmpEax62S               =  "8B(..)85C074(..)83F80674(....)83(.{6})007D"
Global $Patch_CmpEax62R[9]            = ["C7", "??", "030000", "00", "83F80674", "00??", "83", "??????", "00EB"]

Global $Patch_CmpEax63S               =  "8B(....)85C074(..)83F80674(....)83(....)007D"
Global $Patch_CmpEax63R[9]            = ["C7", "????", "030000", "00", "83F80674", "00??", "83", "????", "00EB"]

Global $Patch_CmpEax64S               =  "8B(....)85C074(..)83F80674(....)83(.{6})007D"
Global $Patch_CmpEax64R[9]            = ["C7", "????", "030000", "00", "83F80674", "00??", "83", "??????", "00EB"]
; 8b ??                   mov    edx,DWORD PTR [ecx]
; ?? 85 c0 74 11 22       ???    al,BYTE PTR [ebp+0x221174c0]
; 83 f8 06                cmp    eax,0x6
; 74 11                   je     0x
; ?? ??                   ?? ??
; ??                      ??
; 83 11 ??                adc    DWORD PTR [ecx],??
; ?? ?? 00 7d             ???


Global $Patch_ProcessV2Profile1AS     =  "00007504488D4850"
Global $Patch_ProcessV2Profile1AR[1]  = ["00007500488D4850"]
;                                                ^^
Global $Patch_ProcessV2Profile1A1S    =  "00007504488D5050"
Global $Patch_ProcessV2Profile1A1R[1] = ["00007500488D5050"]
;                                                ^^
; 00 00                   add    BYTE PTR [eax],al
; 75 04                   jne    0x8   =>0x48
; 48                      dec    eax
; 8d 48 50                lea    ecx,[eax+0x50]
; 8d 50 50                lea    edx,[eax+0x50]


Global $Patch_ValidateLicenseS        =  "83F80175(..)"   +"BA94010000"
Global $Patch_ValidateLicenseR[3]     = ["83F80175", "??", "BA00000000"]
; 83 f8 01                cmp    eax,0x1
; 75 xx                   jne    0x
; ba 94 01 00 00          mov    edx,0x194

Global $Patch_ValidateLicense_edx_S   =  "83F8040F95C281C293010000"
Global $Patch_ValidateLicense_edx_R[1]= ["83F8040F95C2BA0000000090"]
;                                                         ^^^^^^^^^^^^
Global $Patch_ValidateLicense_ecx_S   =  "83F8040F95C181C193010000"
Global $Patch_ValidateLicense_ecx_R[1]= ["83F8040F95C1B90000000090"]
; 83 f8 04                cmp    eax,0x4
; 0f 95 c1                setne  cl
; 81 c1 93 01 00 00       add    ecx,0x193
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
; b9 00 00 00 00          mov    ecx,0x0
; 90                      nop


Global $Patch_BridgeCamRaw1S          =  "84C074(..)8B(..)83(..)0174(..)83(..)0174(..)83(..)01"
Global $Patch_BridgeCamRaw1R[15]      = ["84C074", "??", "8B", "??", "83", "??", "01EB", "??", "83", "??", "0174", "??", "83", "??", "01"]

Global $Patch_BridgeCamRaw2S          =  "4084F60F85(.{8})"       +"4084ED0F84"
Global $Patch_BridgeCamRaw2R[3]       = ["4084F60F85", "????????", "40FEC60F85"]
;~ 40                      inc    eax
;~ 84 f6                   test   dh,dh
;~ 0f 85 11 22 33 44       jne    0x4433221a
;~ 40                      inc    eax
;~ 84 ed                   test   ch,ch
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;~ fe c6                   inc    dh

;~ 0f 84                   je    0x
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;~ 0f 85                   jne   0x


; SweetPeaSupport.dll
Global $Patch_HevcMpegEnabler1S       =  "8B(..)FF50100FB6"
Global $Patch_HevcMpegEnabler1R[3]    = ["8B", "??", "FFC0900FB6"]
;~ 8b 11                   mov    edx,DWORD PTR [ecx]
;~ ff 50 10                call   DWORD PTR [eax+0x10]
;~ 0f                      .byte 0xf
;~ b6                      .byte 0xb6

Global $Patch_HevcMpegEnabler2S       =  "8B(..)FF50280FB6"
Global $Patch_HevcMpegEnabler2R[3]    = ["8B", "??", "FFC0900FB6"]

Global $Patch_HevcMpegEnabler3S       =  "8B(..)FF50300FB6"
Global $Patch_HevcMpegEnabler3R[3]    = ["8B", "??", "FFC0900FB6"]

Global $Patch_HevcMpegEnabler4S       =  "8B(..)FF50380FB6"
Global $Patch_HevcMpegEnabler4R[3]    = ["8B", "??", "FFC0900FB6"]

Global $Patch_HevcMpegEnabler5S       =  "8B(..)FF5010(..)0FB6"
Global $Patch_HevcMpegEnabler5R[5]    = ["8B", "??", "FFC090", "??", "0FB6"]

Global $Patch_HevcMpegEnabler6S       =  "8B(..)FF5028(..)0FB6"
Global $Patch_HevcMpegEnabler6R[5]    = ["8B", "??", "FFC090", "??", "0FB6"]

Global $Patch_HevcMpegEnabler7S       =  "8B(..)FF5030(..)0FB6"
Global $Patch_HevcMpegEnabler7R[5]    = ["8B", "??", "FFC090", "??", "0FB6"]

Global $Patch_HevcMpegEnabler8S       =  "8B(..)FF5038(..)0FB6"
Global $Patch_HevcMpegEnabler8R[5]    = ["8B", "??", "FFC090", "??", "0FB6"]

; dvaappsupport.dll
Global $Patch_TeamProjectEnablerAS    =  "488379(....)740A488379(....)7403B001C332C0C3"
Global $Patch_TeamProjectEnablerAR[5] = ["488379", "????", "740A488379", "????", "7403B001C3B001C3"]

#include <Misc.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>


#include <GuiListView.au3>
#include <GuiEdit.au3>
#include <GuiButton.au3>

Global Const $g_AppWndTitle = "Adobe-GenP-3.0"

If _Singleton( $g_AppWndTitle , 1) = 0 Then
	Exit
EndIf

Global $FilesToPatch[0][1], $FilesToPatchNULL[0][1]
Global $FilesToRestore[0][1]
Global $MYHGUI, $IDMSG, $IDLISTVIEW, $IDBUTTON_SEARCH, $IDBUTTONCUSTOMFOLDER, $IDBTNCURE, $TIMESTAMP
Global $MYDEFPATH = "C:\Program Files\Adobe"
Global $RegExp_SearchCOUNT = 0, $COUNT = 0, $MYOWNIDPROGRESS
Global $aOutTheGlobalArray[0], $ANULLARRAY[0], $AINHEXARRAY[0]
Global $Data = "", $MYFILETOPARSSWEATPEA = "", $DataEACLIENT = ""
MAINGUI()
WinWait( $g_AppWndTitle , "", 5)
dim $HWNDPARENTWINDOW = WinGetHandle( $g_AppWndTitle )
dim $HWND_PROGRESS = ControlGetHandle($HWNDPARENTWINDOW, "", "msctls_progress321")
While 1
	$IDMSG = GUIGetMsg()
	Switch $IDMSG

		Case $GUI_EVENT_CLOSE
			Local $SPIDHANDLE = ProcessExists("GenPPP-3.0.exe")
			ProcessClose($SPIDHANDLE)
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($IDLISTVIEW))
			GUIDelete()
			Exit

		Case $IDBUTTON_SEARCH
			GUICtrlSetState($IDLISTVIEW, $GUI_DISABLE)
			GUICtrlSetState($IDBUTTON_SEARCH, $GUI_DISABLE)
			GUICtrlSetState($IDBTNCURE, $GUI_DISABLE)
			GUICtrlSetState($IDBUTTONCUSTOMFOLDER, $GUI_DISABLE)
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($IDLISTVIEW))
			_GUICtrlListView_AddItem($IDLISTVIEW, "", 0)
			_GUICtrlListView_AddItem($IDLISTVIEW, "", 1)
			_GUICtrlListView_AddSubItem($IDLISTVIEW, 0, "Searching for files. Be patient, please", 1)
			_GUICtrlListView_AddSubItem($IDLISTVIEW, 1, "Press 'Esc' to terminate GenP if you want", 1)

			; Clear previous results
			$FilesToPatch   = $FilesToPatchNULL
			$FilesToRestore = $FilesToPatchNULL

			$TIMESTAMP = TimerInit()
			Local $ASIZE = DirGetSize($MYDEFPATH, $DIR_EXTENDED)
			local $FileCount= $ASIZE[1]


			Global $ProgressFileCountScale = 100 / $FileCount
			Global $FileSearchedCount = 0

			ProgressWrite(0)
			RecursiveFileSearch($MYDEFPATH, 0, $ASIZE[1])

			Sleep(100)
			ProgressWrite(0)

			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($IDLISTVIEW))

			FillListViewWithFiles()
			For $II = 0 To _GUICtrlListView_GetItemCount($IDLISTVIEW) - 1
				_GUICtrlListView_SetItemChecked($IDLISTVIEW, $II)
			Next

			GUICtrlSetState($IDLISTVIEW, $GUI_ENABLE)
			GUICtrlSetState($IDBUTTON_SEARCH, $GUI_ENABLE)
			GUICtrlSetState($IDBTNCURE, $GUI_ENABLE)
			GUICtrlSetState($IDBUTTONCUSTOMFOLDER, $GUI_ENABLE)
			GUICtrlSetState($IDBTNCURE, 256)

		Case $IDBUTTONCUSTOMFOLDER
			MYFILEOPENDIALOG()
			GUICtrlSetState($IDBUTTON_SEARCH, 256)

		Case $IDBTNCURE
			GUICtrlSetState($IDLISTVIEW, $GUI_DISABLE)
			GUICtrlSetState($IDBUTTON_SEARCH, $GUI_DISABLE)
			GUICtrlSetState($IDBTNCURE, $GUI_DISABLE)
			GUICtrlSetState($IDBUTTONCUSTOMFOLDER, $GUI_DISABLE)
			For $II = 0 To _GUICtrlListView_GetItemCount($IDLISTVIEW) - 1
				If _GUICtrlListView_GetItemChecked($IDLISTVIEW, $II) = True Then
					_GUICtrlListView_SetItemSelected($IDLISTVIEW, $II)
					Local $ITEMFROMLIST = _GUICtrlListView_GetItemText($IDLISTVIEW, $II, 1)
					MYGLOBALPATTERNSEARCH($ITEMFROMLIST)
					ProgressWrite(0)
					Sleep(100)
					MEMOWRITE("Current path" & @CRLF & "---" & @CRLF & $ITEMFROMLIST & @CRLF & "---" & @CRLF & "medication :)")
					Sleep(100)
					_GUICtrlListView_Scroll($IDLISTVIEW, 0, -10000)
					MyGlobalPatternPatch(_GUICtrlListView_GetItemText($IDLISTVIEW, $II, 1), $aOutTheGlobalArray)

					_GUICtrlListView_Scroll($IDLISTVIEW, 0, 10)
					Sleep(100)
				EndIf
				_GUICtrlListView_SetItemChecked($IDLISTVIEW, $II, False)
			Next
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($IDLISTVIEW))
			$MYDEFPATH = "C:\Program Files\Adobe"
			MEMOWRITE("Current path" & @CRLF & "---" & @CRLF & $MYDEFPATH & @CRLF & "---" & @CRLF & "waiting for user action")
			GUICtrlSetState($IDLISTVIEW, $GUI_ENABLE)
			GUICtrlSetState($IDBUTTON_SEARCH, $GUI_ENABLE)
			GUICtrlSetState($IDBUTTONCUSTOMFOLDER, $GUI_ENABLE)
			GUICtrlSetState($IDBTNCURE, $GUI_DISABLE)
			GUICtrlSetState($IDBUTTON_SEARCH, 256)
			FillListViewWithInfo()
	EndSwitch
	Sleep(10)
WEnd

Func MAINGUI()

	Const $Dlg_Width  =	900 ; <->
	Const $Dlg_Height = 800 ;    ^v
	Const $Dlg_Margin = 20

	Const $BT_Width  =	80 ; <->
	Const $BT_Height =  30;    ^v

	Const $BT_WH_Cure =  56;

	Const $Dlg_WidthHalf  =	$Dlg_Width / 2 ; <->


	$MYHGUI = GUICreate( $g_AppWndTitle , _
		$Dlg_Width + $Dlg_Margin*2, 			$Dlg_Height + $Dlg_Margin * 2 )

	$IDLISTVIEW = GUICtrlCreateListView("", _
		$Dlg_Margin,							$Dlg_Margin,						$Dlg_Width , 	$Dlg_Height / 1.4, _
		-1, $LVS_EX_FULLROWSELECT + $LVS_EX_CHECKBOXES )
	_GUICtrlListView_SetItemCount(				-1, UBound($FilesToPatch))
	_GUICtrlListView_AddColumn(					-1, "Id", 50)
	_GUICtrlListView_AddColumn(					-1, "These files we will try to patch", 600)

	FillListViewWithInfo()

	$IDBUTTONCUSTOMFOLDER = GUICtrlCreateButton("Custom Path", _
		$Dlg_Margin, 					        60 + $Dlg_Height / 1.4 ,	$BT_Width, 		$BT_Height )
		GUICtrlSetTip(	-1, "Select Path that You want -> press Search -> press Pill button")

	$IDBUTTON_SEARCH = GUICtrlCreateButton("Search Files", _
		($Dlg_Width + $Dlg_Margin*2)-$Dlg_Margin-$BT_Width  , 	60 + $Dlg_Height / 1.4, 	$BT_Width, 		$BT_Height )
		GUICtrlSetTip(	-1, "Let GenP find Apps automatically in current path")

	$MYOWNIDPROGRESS = GUICtrlCreateProgress( _
		$Dlg_Margin, 										40 + $Dlg_Height / 1.4,  		$Dlg_Width , 	$BT_Height / 3,	 _
			$PBS_SMOOTHREVERSE)

	Global $G_IDMEMO = GUICtrlCreateEdit("", _
		$Dlg_Margin, 										100 + $Dlg_Height / 1.4, 			$Dlg_Width, 	90, _
			$ES_READONLY + $ES_CENTER + $WS_DISABLED )

	MEMOWRITE("Current path" & @CRLF & "---" & @CRLF & $MYDEFPATH & @CRLF & "---" & @CRLF & "waiting for user action")

	$IDBTNCURE = GUICtrlCreateButton("", _
			$Dlg_Width / 2, 		$Dlg_Height / 1.04, 				$BT_WH_Cure, 		$BT_WH_Cure, _
			$BS_BITMAP)
			GUICtrlSetTip(		-1, "Cure")
	_GUICtrlButton_SetImage(-1, @ScriptDir & "\ICONS\Cure.bmp")
	GUICtrlSetState(	-1, $GUI_DISABLE)


	GUICtrlSetState($IDBUTTON_SEARCH, $GUI_FOCUS )
	GUISetState(@SW_SHOW)
EndFunc   ;==>MAINGUI



Func RecursiveFileSearch($INSTARTDIR, $DEPTH, $FILECOUNT)
	;_FileListToArrayEx


	Dim $RecursiveFileSearch_MaxDeep = 1
	Dim $RecursiveFileSearch_WhenFoundRaiseToLevel = 0  ;0 to disable raising
	if $DEPTH > $RecursiveFileSearch_MaxDeep then return

	Local $TargetFileList_Adobe = [ _
	 "AppsPanelBL.dll",		 _
	 "Acrobat.dll",		 _
	 "acrodistdll.dll",		 _
	 "acrotray.exe",		 _
	 "Aero.exe",		 _
	 "AfterFXLib.dll",		 _
	 "Animate.exe",		 _
	 "auui.dll",		 _
	 "bridge.exe",		 _
	 "animator.exe",		 _
	 "dreamweaver.exe",		 _
	 "illustrator.exe",		 _
	 "public.dll",		 _
	 "lightroomcc.exe",		 _
	 "lightroom.exe",		 _
	 "Encoder.exe",		 _
	 "photoshop.exe",		 _
	 "registration.dll",		 _
	 "euclid-core",		 _
	 "XD.exe",		 _
	 "gemini_uwp_bridge.dll",		 _
	 "ngl-lib.dll",		 _
	 "Designer.exe",		 _
	 "Modeler.exe",		 _
	 "Painter.exe",		 _
	 "Sampler.exe",		 _
	 "Stager.exe",		 _
	 "SweetPeaSupport.dll",		 _
	 "dvaappsupport.dll"		 _
	]


	Local $STARTDIR = $INSTARTDIR & "\"
	$FileSearchedCount +=1

	dim $HSEARCH = FileFindFirstFile($STARTDIR & "*.*")
	If @error Then Return

	While 1
		Local $NEXT = FileFindNextFile($HSEARCH)
		$FileSearchedCount +=1

		If @error Then ExitLoop
		local $isDir = StringInStr(FileGetAttrib($STARTDIR & $NEXT), "D")

		If $isDir Then
			local $targetDepth
			$targetDepth = RecursiveFileSearch($STARTDIR & $NEXT, $DEPTH + 1, $FILECOUNT)
			; raise up in recursion to wanted level
;~ 			if ( $targetDepth > 0 ) and _
;~ 			   ( $targetDepth < $DEPTH ) Then _
;~ 				Return $targetDepth
		Else
			Local $IPATH = $STARTDIR & $NEXT

			For $AdobeFileTarget In $TargetFileList_Adobe
				local $FileNameCropped = StringSplit ( _
					StringLower( $IPATH ),  _
					StringLower( $AdobeFileTarget ),  _
					$STR_ENTIRESPLIT   _
				)
				If  @error <> 1 then
					if not StringInStr($IPATH, ".bak"        ) Then
						;_ArrayAdd( $FilesToPatch, $DEPTH & " - " & $IPATH )
						_ArrayAdd( $FilesToPatch, $IPATH )
					Else
						_ArrayAdd( $FilesToRestore, $IPATH )
					EndIf

				  ; File Found and stored - Quit search in current dir
;~ 					return $RecursiveFileSearch_WhenFoundRaiseToLevel
				EndIf
			Next

		EndIf
	WEnd

	;Lazy screenupdates
	If 1 = Random ( 0, 10, 1) then
		MEMOWRITE(	"Searching in " & $FILECOUNT & " files" & @TAB & @TAB & "Found : " & UBound( $FilesToPatch ) & @CRLF & _
					"---" 			& @CRLF & _
					"Level: " & $DEPTH & "  Time elapsed : " & Round(TimerDiff($TIMESTAMP) / 1000, 0) & " second(s)" & @TAB & @TAB & "Excluded because of *.bak: " & UBound( $FilesToRestore ) &  @CRLF & _
					"---" 			& @CRLF & _
					$INSTARTDIR _
					)
		ProgressWrite( $ProgressFileCountScale * $FileSearchedCount )
	EndIf

	FileClose($HSEARCH)
EndFunc   ;==>RecursiveFileSearch


Func FillListViewWithInfo()
	For $I = 0 To 25
		_GUICtrlListView_AddItem($IDLISTVIEW, "", $I)
	Next
	_GUICtrlListView_AddSubItem( -1,  0, "How to use GenP", 1)
	_GUICtrlListView_AddSubItem( -1,  1, "If you want to patch all Adobe apps in default location:", 1)
	_GUICtrlListView_AddSubItem( -1,  2, "Press 'Search Files' - wait until GenP finds all files", 1)
	_GUICtrlListView_AddSubItem( -1,  3, "Press 'Pill Button' - wait until GenP will do it's job", 1)
	_GUICtrlListView_AddSubItem( -1,  4, "-------------------------------------------------------------", 1)
	_GUICtrlListView_AddSubItem( -1,  5, "One Adobe app at a time", 1)
	_GUICtrlListView_AddSubItem( -1,  6, "Press 'Custom path' - Select folder that you want for ex:", 1)
	_GUICtrlListView_AddSubItem( -1,  7, "C:\Program Files\WindowsApps\Adobe.Fresco_* or", 1)
	_GUICtrlListView_AddSubItem( -1,  8, "C:\Program Files\WindowsApps\Adobe.XD_* or", 1)
	_GUICtrlListView_AddSubItem( -1,  9, "C:\Program Files\Adobe\Adobe Photoshop *", 1)
	_GUICtrlListView_AddSubItem( -1, 10, "Press 'Search Files' - wait until GenP finds all files", 1)
	_GUICtrlListView_AddSubItem( -1, 11, "Press 'Pill Button' - wait until GenP will do it's job", 1)
	_GUICtrlListView_AddSubItem( -1, 12, "-------------------------------------------------------------", 1)
	_GUICtrlListView_AddSubItem( -1, 13, "What's new in GenP", 1)
	_GUICtrlListView_AddSubItem( -1, 14, "Can patch apps from 2019 version to current and future releases", 1)
	_GUICtrlListView_AddSubItem( -1, 15, "Automatic search in selected folder", 1)
	_GUICtrlListView_AddSubItem( -1, 16, "New patching logic", 1)
	_GUICtrlListView_AddSubItem( -1, 17, "Support for all Substance products", 1)
	_GUICtrlListView_AddSubItem( -1, 18, "-------------------------------------------------------------", 1)
	_GUICtrlListView_AddSubItem( -1, 19, "Known issues:", 1)
	_GUICtrlListView_AddSubItem( -1, 20, "1. InDesign and InCopy will have high Cpu usage", 1)
	_GUICtrlListView_AddSubItem( -1, 21, "2. Animate will have some problems with home screen if Signed Out", 1)
	_GUICtrlListView_AddSubItem( -1, 22, "3. Lightroom Classic will partially work if Signed Out", 1)
	_GUICtrlListView_AddSubItem( -1, 23, "4. Acrobat,Rush,Lightroom Online,Photosop Express,Creative Cloud App", 1)
	_GUICtrlListView_AddSubItem( -1, 24, "   won't be patched or fully unlocked", 1)
	_GUICtrlListView_AddSubItem( -1, 25, "   Maybe in next release i'll find solution for them", 1)

   ;Hide Checkbox column
	_GUICtrlListView_SetColumnWidth($IDLISTVIEW, 0 ,0)
EndFunc   ;==>FillListViewWithInfo

Func FillListViewWithFiles()
	If UBound($FilesToPatch) > 0 Then
		Global $AITEMS[UBound($FilesToPatch)][2]
		For $II = 0 To UBound($AITEMS) - 1
			$AITEMS[$II][0] = $II
			$AITEMS[$II][1] = $FilesToPatch[$II][0]
		Next

		_GUICtrlListView_AddArray($IDLISTVIEW, $AITEMS)

		MEMOWRITE( 	UBound($FilesToPatch) & " File(s) were found in " & _
					Round(TimerDiff($TIMESTAMP) / 1000, 0) & " second(s) at:" & @CRLF & _
					"---" 		& @CRLF & _
					$MYDEFPATH 	& @CRLF & _
					"---" 		& @CRLF & _
					"Press the Pill button" _
					)
	   ; show Checkbox column
		_GUICtrlListView_SetColumnWidth($IDLISTVIEW, 0 ,23)

	Else
		MEMOWRITE("Nothing was found in" & @CRLF & "---" & @CRLF & $MYDEFPATH & @CRLF & "---" & @CRLF & "waiting for user action")
	EndIf
EndFunc   ;==>FillListViewWithFiles

Func MEMOWRITE($SMESSAGE)
	GUICtrlSetData($G_IDMEMO, $SMESSAGE)
EndFunc   ;==>MEMOWRITE

Func ProgressWrite($MSG_PROGRESS)
	_SendMessage($HWND_PROGRESS, $PBM_SETPOS, $MSG_PROGRESS)
EndFunc   ;==>ProgressWrite

Func MYFILEOPENDIALOG()
	Local Const $SMESSAGE = "Select a Path"
	Local $MYTEMPPATH = FileSelectFolder($SMESSAGE, $MYDEFPATH, 0, $MYDEFPATH, $MYHGUI)
	If @error Then
		MEMOWRITE("Current path" & @CRLF & "---" & @CRLF & $MYDEFPATH & @CRLF & "---" & @CRLF & "waiting for user action")
	Else
		GUICtrlSetState($IDBTNCURE, $GUI_DISABLE)
		$MYDEFPATH = $MYTEMPPATH
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($IDLISTVIEW))
		_GUICtrlListView_AddItem($IDLISTVIEW, "", 0)
		_GUICtrlListView_AddItem($IDLISTVIEW, "", 1)
		_GUICtrlListView_AddItem($IDLISTVIEW, "", 2)
		_GUICtrlListView_AddSubItem($IDLISTVIEW, 0, $MYDEFPATH, 1)
		_GUICtrlListView_AddSubItem($IDLISTVIEW, 1, "Press 'Search Files' - wait until GenP finds all files", 1)
		_GUICtrlListView_AddSubItem($IDLISTVIEW, 2, "Press 'Pill Button' - wait until GenP will do it's job", 1)
		MEMOWRITE("Current path" & @CRLF & "---" & @CRLF & $MYDEFPATH & @CRLF & "---" & @CRLF & "Press the Search button")
	EndIf
EndFunc   ;==>MYFILEOPENDIALOG

Func _PROCESSCLOSEEX($SPIDHANDLE)
	If IsString($SPIDHANDLE) Then $SPIDHANDLE = ProcessExists($SPIDHANDLE)
	If Not $SPIDHANDLE Then Return SetError(1, 0, 0)
	Return Run(@ComSpec & " /c taskkill /F /PID " & $SPIDHANDLE & " /T", @SystemDir, @SW_HIDE)
EndFunc   ;==>_PROCESSCLOSEEX

Func ShowEscMessage()
	If ( WinGetState($MYHGUI) = _
	        $WIN_STATE_EXISTS  + _
			$WIN_STATE_VISIBLE + _
			$WIN_STATE_ENABLED ) _
	And _
	($IDYES  = MsgBox( $MB_YESNO + $MB_ICONERROR , $g_AppWndTitle, "Do you want to terminate ?") ) Then	_
		Exit

EndFunc   ;==>ShowEscMessage

Func MYGLOBALPATTERNSEARCH($Data)
	Sleep(100)

	ConsoleWrite($Data & @CRLF)

	$AINHEXARRAY = $ANULLARRAY
	$aOutTheGlobalArray = $ANULLARRAY
	ProgressWrite(0)

	$RegExp_SearchCOUNT = 0
	$COUNT = 15
	MEMOWRITE( $Data & @CRLF & _
				"---" & @CRLF & _
				"Preparing to Analyze" & @CRLF & _
				"---" & @CRLF & _
				"*****" _
	)
	If  StringInStr($Data, "AppsPanelBL.dll"  		) > 0 Or _
		StringInStr($Data, "SweetPeaSupport.dll"	) > 0 Or _
		StringInStr($Data, "dvaappsupport.dll"		) > 0 Or _
		StringInStr($Data, "bridge.exe"			) > 0 Then

		If StringInStr($Data, "AppsPanelBL.dll") > 0 Then
			MsgBox($MB_SYSTEMMODAL, "Ups...", "Not Implemented")
		EndIf

		If StringInStr($Data, "SweetPeaSupport.dll") > 0 Then
			RegExp_Search($Data, $Patch_HevcMpegEnabler1S, $Patch_HevcMpegEnabler1R, "$Patch_HevcMpegEnabler1S")
			RegExp_Search($Data, $Patch_HevcMpegEnabler2S, $Patch_HevcMpegEnabler2R, "$Patch_HevcMpegEnabler2S")
			RegExp_Search($Data, $Patch_HevcMpegEnabler3S, $Patch_HevcMpegEnabler3R, "$Patch_HevcMpegEnabler3S")
			RegExp_Search($Data, $Patch_HevcMpegEnabler4S, $Patch_HevcMpegEnabler4R, "$Patch_HevcMpegEnabler4S")
			RegExp_Search($Data, $Patch_HevcMpegEnabler5S, $Patch_HevcMpegEnabler5R, "$Patch_HevcMpegEnabler5S")
			RegExp_Search($Data, $Patch_HevcMpegEnabler6S, $Patch_HevcMpegEnabler6R, "$Patch_HevcMpegEnabler6S")
			RegExp_Search($Data, $Patch_HevcMpegEnabler7S, $Patch_HevcMpegEnabler7R, "$Patch_HevcMpegEnabler7S")
			RegExp_Search($Data, $Patch_HevcMpegEnabler8S, $Patch_HevcMpegEnabler8R, "$Patch_HevcMpegEnabler8S")
		EndIf

		If StringInStr($Data, "dvaappsupport.dll") > 0 Then
			RegExp_Search($Data, $Patch_TeamProjectEnablerAS, $Patch_TeamProjectEnablerAR, "$Patch_TeamProjectEnablerAS")
		EndIf

		If StringInStr($Data, "bridge.exe") > 0 Then

			RegExp_Search($Data, $Patch_Profile_ExpiredS, $Patch_Profile_ExpiredR, "$Patch_Profile_ExpiredS")

			If UBound($aOutTheGlobalArray) > 0 Then
				RegExp_Search($Data, $Patch_ValidateLicenseS, $Patch_ValidateLicenseR, "$Patch_ValidateLicenseS")
				RegExp_Search($Data, $Patch_ValidateLicense_edx_S, $Patch_ValidateLicense_edx_R, "$Patch_ValidateLicense_edx_S")
				RegExp_Search($Data, $Patch_ValidateLicense_ecx_S, $Patch_ValidateLicense_ecx_R, "$Patch_ValidateLicense_ecx_S")
				RegExp_Search($Data, $Patch_CmpEax61S, $Patch_CmpEax61R, "$Patch_CmpEax61S")
				RegExp_Search($Data, $Patch_CmpEax62S, $Patch_CmpEax62R, "$Patch_CmpEax62S")
				RegExp_Search($Data, $Patch_CmpEax63S, $Patch_CmpEax63R, "$Patch_CmpEax63S")
				RegExp_Search($Data, $Patch_CmpEax64S, $Patch_CmpEax64R, "$Patch_CmpEax64S")
				RegExp_Search($Data, $Patch_ProcessV2Profile1AS, $Patch_ProcessV2Profile1AR, "$Patch_ProcessV2Profile1aS")
				RegExp_Search($Data, $Patch_ProcessV2Profile1A1S, $Patch_ProcessV2Profile1A1R, "$Patch_ProcessV2Profile1a1S")
				RegExp_Search($Data, $Patch_BannerS, $Patch_BannerR, "$Patch_BannerS")
				RegExp_Search($Data, $Patch_BridgeCamRaw1S, $Patch_BridgeCamRaw1R, "$Patch_BridgeCamRaw1S")
				RegExp_Search($Data, $Patch_BridgeCamRaw2S, $Patch_BridgeCamRaw2R, "$Patch_BridgeCamRaw2S")
;~ 				_ArrayDisplay($aOutTheGlobalArray, "Global Search Check")
				$RegExp_SearchCOUNT = 0
				$COUNT = 0
				ProgressWrite(0)
			Else
				MEMOWRITE(	$Data & @CRLF & _
							"---" & @CRLF & _
							"File was already patched?. Aborting..." & @CRLF & _
							"---" _
				)
				Sleep(100)

				$RegExp_SearchCOUNT = 0
				$COUNT = 0
				ProgressWrite(0)
			EndIf

		EndIf
	Else

		RegExp_Search($Data, $Patch_Profile_ExpiredS, $Patch_Profile_ExpiredR, "$Patch_Profile_ExpiredS")

		If UBound($aOutTheGlobalArray) > 0 Then
			RegExp_Search($Data, $Patch_ValidateLicenseS, $Patch_ValidateLicenseR, "$Patch_ValidateLicenseS")
			RegExp_Search($Data, $Patch_ValidateLicense_edx_S, $Patch_ValidateLicense_edx_R, "$Patch_ValidateLicense_edx_S")
			RegExp_Search($Data, $Patch_ValidateLicense_ecx_S, $Patch_ValidateLicense_ecx_R, "$Patch_ValidateLicense_ecx_S")
			RegExp_Search($Data, $Patch_CmpEax61S, $Patch_CmpEax61R, "$Patch_CmpEax61S")
			RegExp_Search($Data, $Patch_CmpEax62S, $Patch_CmpEax62R, "$Patch_CmpEax62S")
			RegExp_Search($Data, $Patch_CmpEax63S, $Patch_CmpEax63R, "$Patch_CmpEax63S")
			RegExp_Search($Data, $Patch_CmpEax64S, $Patch_CmpEax64R, "$Patch_CmpEax64S")
			RegExp_Search($Data, $Patch_ProcessV2Profile1AS, $Patch_ProcessV2Profile1AR, "$Patch_ProcessV2Profile1aS")
			RegExp_Search($Data, $Patch_ProcessV2Profile1A1S, $Patch_ProcessV2Profile1A1R, "$Patch_ProcessV2Profile1a1S")
			RegExp_Search($Data, $Patch_BannerS, $Patch_BannerR, "$Patch_BannerS")
			$RegExp_SearchCOUNT = 0
			$COUNT = 0
			ProgressWrite(0)
		Else
			MEMOWRITE(	$Data & @CRLF & _
						"---" & @CRLF & _
						"File was already patched?. Aborting..." & @CRLF & _
						"---" _
			)
			Sleep(100)
			$RegExp_SearchCOUNT = 0
			$COUNT = 0
			ProgressWrite(0)
		EndIf
	EndIf
EndFunc   ;==>MYGLOBALPATTERNSEARCH

Func RegExp_Search($FILETOPARSE, $PATTERNTOSEARCH, $PATTERNTOREPLACE, $PATTERNNAME)
	Local $hFile = FileOpen($FILETOPARSE, $FO_READ + $FO_BINARY)
	Local $FileData = FileRead($hFile)

	Local $ISEARCHPATTERN  = $PATTERNTOSEARCH
	Local $IREPLACEPATTERN = $PATTERNTOREPLACE
	Local $INEWSEARCHCONSTRUCT = "", $INEWREPLACECONSTRUCT = "", $INEWREPLACECONSTRUCT1 = ""
	$AINHEXARRAY = StringRegExp($FileData, $ISEARCHPATTERN, $STR_REGEXPARRAYFULLMATCH, 1)
	If @error = 0 Then
		$INEWSEARCHCONSTRUCT = $AINHEXARRAY[0]
		For $I = 0 To UBound($IREPLACEPATTERN) - 1
			$INEWREPLACECONSTRUCT &= $IREPLACEPATTERN[$I]
		Next
		If StringInStr($INEWREPLACECONSTRUCT, "?") Then
			For $I = 1 To StringLen($INEWREPLACECONSTRUCT) + 1
				Local $SSTRING1 = StringMid($INEWSEARCHCONSTRUCT, $I, 1)
				Local $SSTRING2 = StringMid($INEWREPLACECONSTRUCT, $I, 1)
				If $SSTRING2 <> "?" Then
					$INEWREPLACECONSTRUCT1 &= $SSTRING2
				Else
					$INEWREPLACECONSTRUCT1 &= $SSTRING1
				EndIf
			Next
		Else
			$INEWREPLACECONSTRUCT1 = $INEWREPLACECONSTRUCT
		EndIf
		_ArrayAdd($aOutTheGlobalArray, $INEWSEARCHCONSTRUCT)
		_ArrayAdd($aOutTheGlobalArray, $INEWREPLACECONSTRUCT1)

		ConsoleWrite($PATTERNNAME &      "---" & @TAB & $INEWSEARCHCONSTRUCT & "	" & @CRLF)
		ConsoleWrite($PATTERNNAME & "R" & "--" & @TAB & $INEWREPLACECONSTRUCT1 & "	" & @CRLF)
		MEMOWRITE(   $FILETOPARSE & @CRLF & "---" & @CRLF & $PATTERNNAME & @CRLF & "---" & @CRLF & $INEWSEARCHCONSTRUCT & @CRLF & $INEWREPLACECONSTRUCT1)
	Else
		ConsoleWrite($PATTERNNAME & "---" & @TAB & "No" & "	" & @CRLF)
		MEMOWRITE(   $FILETOPARSE & @CRLF & "---" & @CRLF & $PATTERNNAME & "---" & "No")
	EndIf

	$RegExp_SearchCOUNT += 1
	FileClose($hFile)

	$FileData = ""
	ProgressWrite( Round($RegExp_SearchCOUNT / $COUNT * 100) )
	Sleep(100)
EndFunc   ;==>RegExp_Search

Func MyGlobalPatternPatch( $FileToPatch , $MYARRAYTOPATCH)
	ProgressWrite(0)

	MEMOWRITE("Current path" & @CRLF & "---" & @CRLF &  $FileToPatch  & @CRLF & "---" & @CRLF & "medication :)")

	Local $IROWS1 = 0
	$IROWS1 = UBound($MYARRAYTOPATCH)

	If $IROWS1 > 0 Then
		; Read in File
		Local $hFile 	 = 	FileOpen( $FileToPatch , $FO_READ + $FO_BINARY)
		Local $FileData = FileRead($hFile)

		; Apply Patches in Memory
		For $I = 0 To $IROWS1 - 1 Step 2
			Local $SSTRINGOUT = StringReplace( $FileData, _
				$MYARRAYTOPATCH[$I], _
				$MYARRAYTOPATCH[$I + 1], _
				0, $STR_CASESENSE )

			$FileData = $SSTRINGOUT
			$SSTRINGOUT = $FileData
			ProgressWrite( Round ($I / $IROWS1 * 100) )
		Next
		FileClose($hFile)

		;Make Backup
		FileMove( $FileToPatch ,  $FileToPatch  & ".bak", 1)

		; Write Patches to File
		$hFile = FileOpen( $FileToPatch , $FO_OVERWRITE + $FO_BINARY)
		FileWrite($hFile, Binary($SSTRINGOUT))
		FileClose($hFile)

		ProgressWrite(0)
		Sleep(100)
	Else
	EndIf
EndFunc   ;==>MyGlobalPatternPatch

; DeTokenise by myAut2Exe >The Open Source AutoIT/AutoHotKey script decompiler< 2.16 build(215)
