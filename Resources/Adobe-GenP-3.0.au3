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

Global $FilesToPatch     [0][1]
Global $FilesToPatchNULL [0][1]
Global $FilesToRestore   [0][1]
Global $MYHGUI, $IDMSG, $IDLISTVIEW, $IDBUTTON_Search, $IDBUTTONCUSTOMFOLDER, $IDBTNCURE, $TimeStamp

Global $ProgramFilesDir = EnvGet('ProgramW6432') ; for 64bit Win it will return a valid path.
if not $ProgramFilesDir then $ProgramFilesDir = @ProgramFilesDir ; for 32bit Win this will "repair" the broken return from above.

Global $Path_Default          =  $ProgramFilesDir & "\Adobe"

Global $RegExp_SearchCOUNT = 0, $COUNT = 0, $GUI_Progressbar
Global $aOutTheGlobalArray[0], $ANullArray[0], $aInHexArray[0]
Global $Data               = "", $MYFILETOPARSSWEATPEA = "", $DataEACLIENT = ""
Global $ProgressFileCountScale = 1

Global $RecursiveFileSearch_MaxDeep = 7

Func App_Quit()
	ConsoleWrite('@@ (190) :(' & @MIN & ':' & @SEC & ') App_Quit()' & @CR) ;### Trace Function

;~ 	Local $SPIDHANDLE = ProcessExists("GenPPP-3.0.exe")
;~ 	ProcessClose($SPIDHANDLE)

;~ 	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($IDLISTVIEW))
;~ 	GUIDelete()

	Exit

EndFunc


Gui_Main_Create()
	ConsoleWrite('@@ (201) :(' & @MIN & ':' & @SEC & ') Gui_Main_Create()' & @CR) ;### Trace Function

Gui_Main_Init()

WinWait( $g_AppWndTitle , "", 5)

dim $HWNDPARENTWINDOW = WinGetHandle( $g_AppWndTitle )
dim $HWND_PROGRESS = ControlGetHandle($HWNDPARENTWINDOW, "", "msctls_progress321")
While 1

    $IDMSG = GUIGetMsg()

	Switch $IDMSG

		Case $GUI_EVENT_CLOSE

			App_Quit()


		Case $IDBUTTONCUSTOMFOLDER
			myFileOpenDialog()
			GUICtrlSetState($IDBUTTON_Search, $GUI_FOCUS)


		Case $IDBUTTON_Search

            Gui_State( $GUI_DISABLE )

			Local $tmp[2] = [ _
			"定位文件中，请耐心等待~", _
			"按'Esc'关闭GenP" _
			]
			ListView_Text( $tmp )

			; Clear previous results
			$FilesToPatch   = $FilesToPatchNULL
			$FilesToRestore = $FilesToPatchNULL

			$TimeStamp          = TimerInit()

			MemoWrite ("计算文件数量 ...")
			local $FileCount         = DirGetSize( $Path_Default, $DIR_EXTENDED ) [1]
															;[0] = Size;   [1] = Files count ;[2] = Dirs Count
			Global $FileSearchedCount = 0

			ProgressInit( 100 / $FileCount )
			RecursiveFileSearch( $Path_Default, 0, $FileCount )

			ProgressDone( )


			FillListViewWithFiles()

            Gui_State( $GUI_ENABLE )

			GUICtrlSetState( $IDBTNCURE, $GUI_FOCUS)


		Case $IDBTNCURE

            Gui_State( $GUI_DISABLE )

			For $II = 0 To _GUICtrlListView_GetItemCount($IDLISTVIEW) - 1

				;Is Item checked
				If _GUICtrlListView_GetItemChecked($IDLISTVIEW, $II) = True Then

					; Focus item
					_GUICtrlListView_SetItemSelected($IDLISTVIEW, $II)

					Local $ItemToPatch = _GUICtrlListView_GetItemText($IDLISTVIEW, $II, 1)

					DoSearch( $ItemToPatch )

;~ 					ProgressWrite(0)

					MemoWrite(	"当前目录" & @CRLF & _
								"---" & @CRLF & _
								$ItemToPatch & @CRLF & _
								"---" & @CRLF & "medication :)")

;~ 					_GUICtrlListView_Scroll($IDLISTVIEW, 0, -10000)

					DoPatch( $ItemToPatch , $aOutTheGlobalArray)

;~ 					_GUICtrlListView_Scroll($IDLISTVIEW, 0, 10)

				EndIf

				; DeSelect item
				_GUICtrlListView_SetItemChecked($IDLISTVIEW, $II, False)

			Next

			Gui_Main_Init()

	EndSwitch

	Sleep(10)
WEnd

Func Gui_State( $state )
	ConsoleWrite('@@ (306) :(' & @MIN & ':' & @SEC & ') Gui_State()' & @CR) ;### Trace Function

    GUICtrlSetState(    $IDLISTVIEW,            $state )
    GUICtrlSetState(    $IDBUTTON_Search,       $state )
    GUICtrlSetState(    $IDBTNCURE,             $state )
    GUICtrlSetState(    $IDBUTTONCUSTOMFOLDER,  $state )

EndFunc

Func Gui_Main_Create()

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
;~ 	_GUICtrlListView_SetItemCount(				-1, UBound($FilesToPatch))
	_GUICtrlListView_AddColumn(					-1, "Id", 50)
	_GUICtrlListView_AddColumn(					-1, "将破解以下文件", 600)

	$IDBUTTONCUSTOMFOLDER = GUICtrlCreateButton("选择目录", _
		$Dlg_Margin, 					        60 + $Dlg_Height / 1.4 ,	$BT_Width, 		$BT_Height )
		GUICtrlSetTip(	-1, "选择一个目录 -> 点击搜索按钮 -> 点击Pill按钮")

	$IDBUTTON_Search = GUICtrlCreateButton("搜索", _
		($Dlg_Width + $Dlg_Margin*2)-$Dlg_Margin-$BT_Width  , 	60 + $Dlg_Height / 1.4, 	$BT_Width, 		$BT_Height )
		GUICtrlSetTip(	-1, "GenP会自动寻找当前目录中的Adobe软件")

	$GUI_Progressbar = GUICtrlCreateProgress( _
		$Dlg_Margin, 										40 + $Dlg_Height / 1.4,  		$Dlg_Width , 	$BT_Height / 3,	 _
			$PBS_SMOOTHREVERSE)

	Global $G_IDMEMO = GUICtrlCreateEdit("", _
		$Dlg_Margin, 										100 + $Dlg_Height / 1.4, 			$Dlg_Width, 	90, _
			$ES_READONLY + $ES_CENTER + $WS_DISABLED )

	$IDBTNCURE = GUICtrlCreateButton("", _
			$Dlg_Width / 2, 		$Dlg_Height / 1.04, 				$BT_WH_Cure, 		$BT_WH_Cure, _
			$BS_BITMAP)
			GUICtrlSetTip(		-1, "Cure")
	_GUICtrlButton_SetImage(-1, @ScriptDir & "\ICONS\Cure.bmp")
	GUISetState(@SW_SHOW)

EndFunc   ;==>Gui_Main_Create


Func Gui_Main_Init()
	ConsoleWrite('@@ (367) :(' & @MIN & ':' & @SEC & ') Gui_Main_Init()' & @CR) ;### Trace Function


	GUICtrlSetState($IDLISTVIEW, $GUI_DISABLE)

	FillListViewWithInfo()

	$Path_Default          =  $ProgramFilesDir & "\Adobe"
	MemoWrite(	"当前目录" & @CRLF & _
				"---" & @CRLF & _
				$Path_Default & @CRLF & _
				"---" & @CRLF &  _
				"等待用户操作")


	Gui_State( $GUI_ENABLE )

	GUICtrlSetState( $IDBUTTON_Search, $GUI_FOCUS )

	FillListViewWithInfo()


	GUICtrlSetState($IDBUTTON_Search, $GUI_FOCUS )
EndFunc


Func RecursiveFileSearch($INSTARTDIR, $DEPTH, $FILECOUNT)
	;_FileListToArrayEx

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

	dim $HSearch = FileFindFirstFile($STARTDIR & "*.*")
	If @error Then Return

	While 1
		Local $NEXT = FileFindNextFile($HSearch)
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
			Local $IPATH = StringLower(  $STARTDIR & $NEXT )
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IPATH = ' & $IPATH & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

			For $AdobeFileTarget In $TargetFileList_Adobe
				local $FileNameCropped = StringSplit ( _
					$IPATH ,  _
					StringLower( $AdobeFileTarget ),  _
					$STR_ENTIRESPLIT   _
				)
				If  @error <> 1 then
					Local $BackupFile = $IPATH & ".bak"

					if  StringInStr($FileNameCropped[2], ".bak" )         Then
						_ArrayAdd( $FilesToRestore, $IPATH )
					Else

						if FileExists ( $BackupFile ) <> 1 then
							;_ArrayAdd( $FilesToPatch, $DEPTH & " - " & $IPATH )
							_ArrayAdd( $FilesToPatch, $IPATH )
						EndIf
					EndIf

				  ; File Found and stored - Quit Search in current dir
;~ 					return $RecursiveFileSearch_WhenFoundRaiseToLevel
				EndIf
			Next

		EndIf
	WEnd

	;Lazy screenupdates
	If 1 = Random ( 0, 10, 1) then
		MemoWrite(	"共计" & $FILECOUNT & "文件 " & @TAB & @TAB & "找到 : " & UBound( $FilesToPatch ) & @CRLF & _
					"---" 			& @CRLF & _
					"目录深度: " & $DEPTH & "  时间 : " & Round(TimerDiff($TimeStamp) / 1000, 0) & "秒" & @TAB & @TAB & "由于*.bak排除: " & UBound( $FilesToRestore ) &  @CRLF & _
					"---" 			& @CRLF & _
					$INSTARTDIR _
					)
		ProgressWrite( $ProgressFileCountScale * $FileSearchedCount )
	EndIf

	FileClose($HSearch)
EndFunc   ;==>RecursiveFileSearch


Func ListView_Text( $TextArray )
	ConsoleWrite('@@ (494) :(' & @MIN & ':' & @SEC & ') ListView_Text()' & @CR) ;### Trace Function
	_GUICtrlListView_DeleteAllItems( GUICtrlGetHandle($IDLISTVIEW) )

	Local $SubItemIndex=0
	For $I In  $TextArray
		_GUICtrlListView_AddItem	(	$IDLISTVIEW,           "" )
		_GUICtrlListView_AddSubItem	( -1, $SubItemIndex ,  $I  , 1)
		$SubItemIndex += 1
	Next
EndFunc

Func FillListViewWithInfo()
	ConsoleWrite('@@ (506) :(' & @MIN & ':' & @SEC & ') FillListViewWithInfo()' & @CR) ;### Trace Function
	Local $tmp[23] = [ _
		"How to use GenP", _
		"If you want to patch all Adobe apps in default location:", _
		"Press 'Search Files' - wait until GenP finds all files", _
		"Press 'Pill Button' - wait until GenP will do it's job", _
		"-------------------------------------------------------------", _
		"One Adobe app at a time", _
		"Press 'Custom path' - Select folder that you want for ex:", _
		"C:\Program Files\Adobe\Adobe Photoshop *", _
		"Press 'Search Files' - wait until GenP finds all files", _
		"Press 'Pill Button' - wait until GenP will do it's job", _
		"-------------------------------------------------------------", _
		"What's new in GenP", _
		"Can patch apps from 2019 version to current and future releases", _
		"Automatic Search in selected folder", _
		"New patching logic", _
		"Support for all Substance products", _
		"-------------------------------------------------------------", _
		"Known issues:", _
		"1. InDesign and InCopy will have high Cpu usage", _
		"2. Animate will have some problems with home screen if Signed Out", _
		"3. Lightroom Classic will partially work if Signed Out", _
		"4. Acrobat,Rush,Lightroom Online,Photosop Express,Creative Cloud App", _
		"   won't be patched or fully unlocked" _
		]

	ListView_Text( $tmp )

   ;Hide Checkbox column
	_GUICtrlListView_SetColumnWidth($IDLISTVIEW, 0 ,0)
EndFunc   ;==>FillListViewWithInfo

Func FillListViewWithFiles()
	ConsoleWrite('@@ (540) :(' & @MIN & ':' & @SEC & ') FillListViewWithFiles()' & @CR) ;### Trace Function
	_GUICtrlListView_DeleteAllItems( GUICtrlGetHandle($IDLISTVIEW) )

	If UBound($FilesToPatch) > 0 Then

		; Make Listview columns ID and filename
		Global $aItems[UBound($FilesToPatch)][2]
		For $II = 0 To UBound($aItems) - 1
			$aItems[$II][0] = $II
			$aItems[$II][1] = $FilesToPatch[$II][0]
		Next

		_GUICtrlListView_AddArray( $IDLISTVIEW, $aItems)

		MemoWrite( "找到" & UBound($FilesToPatch) & " 个符合要求的文件，耗时 " & _
					Round(TimerDiff($TimeStamp) / 1000, 0) & "秒 目录：" & @CRLF & _
					"---" 		& @CRLF & _
					$Path_Default 	& @CRLF & _
					"---" 		& @CRLF & _
					"请点击下方Pill按钮" _
					)
	   ; show Checkbox column
		_GUICtrlListView_SetColumnWidth( $IDLISTVIEW, 0 ,23)

	  ;	Select all
		For $II = 0 To _GUICtrlListView_GetItemCount($IDLISTVIEW) - 1
				_GUICtrlListView_SetItemChecked($IDLISTVIEW, $II)
		Next


	Else
		MemoWrite(	"在此目录中没有相应的文件" & @CRLF & _
					"---" & @CRLF & _
					$Path_Default & @CRLF & _
					"---" & @CRLF & _
					"请检查并更换文件夹再次操作")
	EndIf
EndFunc

Func MemoWrite($sMessage)
	GUICtrlSetData($G_IDMEMO, $sMessage)
EndFunc

Func ProgressInit( $Scale )
    Global $ProgressFileCountScale = $Scale
	_SendMessage( $HWND_PROGRESS, $PBM_SETPOS, 0 )
EndFunc

Func ProgressWrite($MSG_PROGRESS)
	_SendMessage($HWND_PROGRESS, $PBM_SETPOS, $MSG_PROGRESS)
EndFunc   ;==>ProgressWrite

Func ProgressDone( )
    ProgressInit( 1 )
EndFunc


Func myFileOpenDialog()
	ConsoleWrite('@@ (602) :(' & @MIN & ':' & @SEC & ') myFileOpenDialog()' & @CR) ;### Trace Function

	Local $StatusText= "请点击搜索按钮"

	Local $MYTEMPPATH = FileSelectFolder( _
							"请选择一个目录",  _
							$Path_Default, 0, $Path_Default,  _
							$MYHGUI )
	If @error Then

		$StatusText= "等待用户操作"

	Else

		GUICtrlSetState( $IDBTNCURE, $GUI_DISABLE)

		$Path_Default = $MYTEMPPATH

		Local $tmp[3] = [ _
			$Path_Default, _
			"点击搜索，等待GenP定位所有文件。", _
			"点击Pill按钮，等待GenP完成破解。" _
		]
		ListView_Text( $tmp )

	EndIf

	MemoWrite(	"当前目录" & @CRLF & _
			"---" & @CRLF & _
			$Path_Default & @CRLF & _
			"---" & @CRLF & _
			$StatusText )
EndFunc   ;==>myFileOpenDialog

Func _PROCESSCLOSEEX($SPIDHANDLE)
	ConsoleWrite('@@ (637) :(' & @MIN & ':' & @SEC & ') _PROCESSCLOSEEX()' & @CR) ;### Trace Function
	If IsString($SPIDHANDLE) Then $SPIDHANDLE = ProcessExists($SPIDHANDLE)
	If Not $SPIDHANDLE Then Return SetError(1, 0, 0)
	Return Run(@ComSpec & " /c taskkill /F /PID " & $SPIDHANDLE & " /T", @SystemDir, @SW_HIDE)
EndFunc   ;==>_PROCESSCLOSEEX

Func ShowEscMessage()
	ConsoleWrite('@@ (644) :(' & @MIN & ':' & @SEC & ') ShowEscMessage()' & @CR) ;### Trace Function
	If ( WinGetState($MYHGUI) = _
	        $WIN_STATE_EXISTS  + _
			$WIN_STATE_VISIBLE + _
			$WIN_STATE_ENABLED ) _
	And _
	($IDYES  = MsgBox( $MB_YESNO + $MB_ICONERROR , $g_AppWndTitle, "是否结束 ?") ) Then	_
		Exit

EndFunc   ;==>ShowEscMessage

Func DoSearch($Data)
	ConsoleWrite('@@ (656) :(' & @MIN & ':' & @SEC & ') DoSearch()' & @CR) ;### Trace Function
	Sleep(100)

	ConsoleWrite($Data & @CRLF)

	$aInHexArray 		= $ANullArray
	$aOutTheGlobalArray = $ANullArray

	ProgressWrite(0)

	$RegExp_SearchCOUNT = 0
	$COUNT = 15

	MemoWrite( $Data & @CRLF & _
				"---" & @CRLF & _
				"准备分析目录" & @CRLF & _
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
				MemoWrite(	$Data & @CRLF & _
							"---" & @CRLF & _
							"文件已经破解成完成？ 停止本次操作 ..." & @CRLF & _
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
			MemoWrite(	$Data & @CRLF & _
						"---" & @CRLF & _
						"文件已经破解成完成？ 停止本次操作 ..." & @CRLF & _
						"---" _
			)
			Sleep(100)
			$RegExp_SearchCOUNT = 0
			$COUNT = 0
			ProgressWrite(0)
		EndIf
	EndIf
EndFunc   ;==>DoSearch

Func RegExp_Search($FILETOPARSE, $PatternTOSearch, $PatternTOReplace, $PatternName)
	ConsoleWrite('@@ (767) :(' & @MIN & ':' & @SEC & ') RegExp_Search()' & @CR) ;### Trace Function

	Local $hFile    = FileOpen($FILETOPARSE, $FO_READ + $FO_BINARY)
	Local $FileData = FileRead($hFile)

	Local $INEWSearchConstruct = "", $INEWReplaceConstruct = "", $INEWReplaceConstruct1 = ""

	$aInHexArray = StringRegExp( $FileData, $PatternTOSearch, $STR_REGEXPARRAYFULLMATCH)
	If @error = 0 Then

		$INEWSearchConstruct  = $aInHexArray[0]

        $INEWReplaceConstruct = _ArrayToString( $PatternTOReplace , "")

        ; Replace all '?' in ReplaceString with Data from SearchString
		If StringInStr($INEWReplaceConstruct, "?") Then
			For $I = 1 To StringLen($INEWReplaceConstruct) + 1
				Local $SSTRING1 = StringMid( $INEWSearchConstruct , $I, 1)
				Local $SSTRING2 = StringMid( $INEWReplaceConstruct, $I, 1)
				If $SSTRING2 <> "?" Then
					$INEWReplaceConstruct1 &= $SSTRING2
				Else
					$INEWReplaceConstruct1 &= $SSTRING1
				EndIf

			Next
		Else
			$INEWReplaceConstruct1 = $INEWReplaceConstruct
		EndIf

		_ArrayAdd( $aOutTheGlobalArray, $INEWSearchConstruct   )
		_ArrayAdd( $aOutTheGlobalArray, $INEWReplaceConstruct1 )

		ConsoleWrite($PatternName &      "---" & @TAB & $INEWSearchConstruct & "	" & @CRLF)
		ConsoleWrite($PatternName & "R" & "--" & @TAB & $INEWReplaceConstruct1 & "	" & @CRLF)
		MemoWrite(  $FILETOPARSE & @CRLF & _
                    "---" & @CRLF &  _
                    $PatternName & @CRLF &  _
                    "---" & @CRLF &  _
                    $INEWSearchConstruct & @CRLF &  _
                    $INEWReplaceConstruct1 _
                    )
	Else
		ConsoleWrite($PatternName & "---" & @TAB & "No" & "	" & @CRLF)
		MemoWrite(   $FILETOPARSE & @CRLF &  _
                     "---" & @CRLF &  _
                     $PatternName & "---" & "No")
	EndIf

	$RegExp_SearchCOUNT += 1
	FileClose($hFile)

	$FileData = ""
	ProgressWrite( Round($RegExp_SearchCOUNT / $COUNT * 100) )
	Sleep(100)
EndFunc   ;==>RegExp_Search

Func DoPatch( $FileName_Patch , $MyArrayToPatch)
	ConsoleWrite('@@ (825) :(' & @MIN & ':' & @SEC & ') DoPatch()' & @CR) ;### Trace Function

	local $FileName_Backup = $FileName_Patch  & ".bak"
	if FileExists (	$FileName_Backup ) Then
		MemoWrite   ("错误！无法完成破解，请删除软件的备份文件！'" & $FileName_Backup & "'!" )
		ConsoleWrite("错误！无法完成破解，请删除软件的备份文件！ '" & $FileName_Backup & "'!" )
		Return
	EndIf

	ProgressInit ( 100 / UBound($MyArrayToPatch)  )

	MemoWrite( _
		"当前目录" & @CRLF & _
		"---" & @CRLF &  _
		$FileName_Patch  & @CRLF & _
		"---" & @CRLF & _
		"medication :)" _
		)


	If UBound($MyArrayToPatch) > 0 Then
		; Read in File
		Local $hFile    = FileOpen( $FileName_Patch , $FO_READ + $FO_BINARY)
		Local $FileData = FileRead($hFile)

		; Apply Patches in Memory
		For $I = 0 To UBound($MyArrayToPatch) - 1 Step 2
			Local $SSTRINGOUT = StringReplace( $FileData, _
				$MyArrayToPatch[$I], _
				$MyArrayToPatch[$I + 1], _
				0, $STR_CASESENSE )

;~ 			$FileData = $SSTRINGOUT
;~ 			$SSTRINGOUT = $FileData
			ProgressWrite( $I  )
		Next
		FileClose($hFile)

		;Make Backup
		FileMove( $FileName_Patch , $FileName_Backup  , 1)

		; Write Patches to File
		$hFile = FileOpen( $FileName_Patch , $FO_OVERWRITE + $FO_BINARY)
		FileWrite($hFile, Binary($SSTRINGOUT))
		FileClose($hFile)

		ProgressWrite(0)
		Sleep(100)
	Else
	EndIf
EndFunc   ;==>DoPatch
