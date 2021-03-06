#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_OutFile=..\APK-Info.exe
#AutoIt3Wrapper_icon=APK-Info.ico
#AutoIt3Wrapper_UseAnsi=n
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Shows info about Android Package Files (APK)
#AutoIt3Wrapper_Res_Description=APK-Info
#AutoIt3Wrapper_Res_Fileversion=1.15.0.0
#AutoIt3Wrapper_Res_LegalCopyright=zoster
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#pragma compile(AutoItExecuteAllowed True)
#include <Constants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <WinAPIShPath.au3>
#include <Array.au3>
#include <String.au3>
Opt("TrayMenuMode",1)
Opt("TrayIconHide",1)


; Adding the directives below, will cause your program be compiled with the indexing
; of the original lines shown in SciTE:
#AutoIt3Wrapper_Run_Before=ShowOriginalLine.exe %in%
#AutoIt3Wrapper_Run_After=ShowOriginalLine.exe %in%


Global $apk_Label, $apk_IconPath, $apk_IconName, $apk_PkgName, $apk_VersionCode, $apk_VersionName
Global $apk_Permissions, $apk_Features, $hGraphic, $hImage, $hImage_original, $apk_MinSDK, $apk_MinSDKVer, $apk_MinSDKName
Global $apk_TargetSDK, $apk_TargetSDKVer, $apk_TargetSDKName, $apk_Screens, $apk_Densities, $apk_ABIs, $apk_Signature
Global $tempPath = @TempDir & "\APK-Info\" & @AutoItPID
Global $Inidir, $ProgramVersion, $ProgramReleaseDate, $ForceGUILanguage
Global $IniProgramSettings, $IniLogReport, $IniLastFolderSettings
Global $tmpArrBadge, $tmp_Filename, $dirAPK, $fileAPK,$fullPathAPK
Global $sNewFilenameAPK

$IniProgramSettings="APK-Info.ini"
$IniLastFolderSettings="APK-Info.LastFolder.ini"
$IniLogReport="APK-Info.log.txt"

; $aCmdLine[0] = number of parametrs passed to exe file
; $aCmdLine[1] = first parameter (optional) passed to exe file (apk file name)


; https://www.autoitscript.com/autoit3/docs/intro/running.htm
; An alternative to the limitation of $CmdLine[] only being able to return a maximum of 63 parameters.
Local $aCmdLine = _WinAPI_CommandLineToArgv($CmdLineRaw)
; Uncomment it to Show all cmdline parameters
;_ArrayDisplay($aCmdLine)

$Inidir= @ScriptDir & "\"

;$ProgramVersion=Iniread ($Inidir & $IniProgramSettings, "Settings", "ProgramVersion", "0.7Q");
;$ProgramReleaseDate=Iniread ($Inidir & $IniProgramSettings, "Settings", "ProgramReleaseDate", "01.06.2017");

$ProgramVersion="1.15";
$ProgramReleaseDate="14.06.2018";

$ForcedGUILanguage=Iniread ($Inidir & $IniProgramSettings, "Settings", "ForcedGUILanguage", "auto");


; Check OS language
$OS_language=@OSLang

; more info on country code
; https://www.autoitscript.com/autoit3/docs/appendix/OSLangCodes.htm

$ForcedGUILanguage=Iniread ($Inidir & $IniProgramSettings, "Settings", "ForcedGUILanguage", "auto");
$OSLanguageCode=@OSLang
IF $ForcedGUILanguage = "auto" then
	$Language_code=Iniread ($Inidir & $IniProgramSettings, "OSLanguage", @OSLang, "en");
Else
	$Language_code=$ForcedGUILanguage
EndIf

$CheckSignature=Iniread ($Inidir & $IniProgramSettings, "Settings", "CheckSignature", "1");

$ShowLog=Iniread ($Inidir & $IniProgramSettings, "Settings", "ShowLog", "0");
$ShowLangCode=Iniread ($Inidir & $IniProgramSettings, "Settings", "ShowLangCode", "1");
; $ShowCmdLine=Iniread($Inidir & $IniProgramSettings,"Settings","ShowCmdLine","1");
$FileNamePrefix=Iniread ($Inidir & $IniProgramSettings, "Settings", "FileNamePrefix", "");
If $FileNamePrefix="" Then $FileNamePrefix=" "
$FileNameSuffix=Iniread ($Inidir & $IniProgramSettings, "Settings", "FileNameSuffix", "");
If $FileNameSuffix="" Then $FileNameSuffix="."
$FileNameSpace=Iniread ($Inidir & $IniProgramSettings, "Settings", "FileNameSpace", "");
If $FileNameSpace="" Then $FileNameSpace=" "
$Lastfolder=Iniread($Inidir & $IniLastFolderSettings,"Settings","LastFolder",@WorkingDir);

$String01=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String01", "Application")
$String02=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String02", "Version")
$String03=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String03", "Version Code")
$String04=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String04", "Package")
$String05=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String05", "Min. SDK")
$String06=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String06", "Traget SDK")
$String07=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String07", "Screen Size")
$String08=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String08", "Resolution")
$String09=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String09", "Permission")
$String10=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String10", "Feature")
$String11=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String11", "Current name")
$String12=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String12", "New name")
$String13=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String13", "Play Store")
$String14=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String14", "Rename File")
$String15=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String15", "Exit")
$String16=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String16", "Rename APK File")
$String17=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String17", "New APK Filename")
$String18=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String18", "Error!")
$String19=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String19", "APK File could not be renamed.")
$String20=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String20", "Select APK file")
$String21=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String21", "Cur_Dev")
$String22=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String22", "Current Dev. Build")
$String23=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String23", "Unknown")
$String24=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String24", "Unknown")
$String25=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String25", "Browse")
$String26=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String26", "OS Lang Code")
$String27=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String27", "Lang Name")
$String28=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String28", "ABIs")
$String29=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String29", "Signature")
$String30=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String30", "Debug")
$String31=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String31", "Icon")
$String32=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "String32", "Loading")

$URLPlayStore=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "URLPlaystore", "https://play.google.com/store/apps/details?id=")

$PlayStoreLanguage=Iniread ($Inidir & $IniProgramSettings, "Strings-" & $Language_code, "PlayStoreLanguage", "en")

Dim $sMinAndroidString, $sTgtAndroidString

Global $apk_Build = ''

;================== GUI ===========================

$ProgramTitle="APK-Info " & $ProgramVersion & " (" & $ProgramReleaseDate & ")"
; iF $ShowLangCode="1" then
; $ProgramTitle=$ProgramTitle & "- OSLangCode = " & $OSLanguageCode & " - Lang = " & $Language_code
; Endif
If $ShowLog="1" then
	IniWrite($Inidir & $IniLogReport, "APK_Info Version", "Program version", $ProgramVersion);
	IniWrite($Inidir & $IniLogReport, "APK_Info Version", "Program release date", $ProgramReleaseDate);
	IniWrite($Inidir & $IniLogReport, "Language", "OSLanguage", @OSLang);
	IniWrite($Inidir & $IniLogReport, "Language", "OSLanguage", @OSLang);
	IniWrite($Inidir & $IniLogReport, "Language", "OSLanguage", @OSLang);
	IniWrite($Inidir & $IniLogReport, "Language", "ForcedLanguage", $ForcedGUILanguage);
	IniWrite($Inidir & $IniLogReport, "IniFile", "IniFileFolderPath", $Inidir);
	IniWrite($Inidir & $IniLogReport, "IniFile", "IniFileProgramSettings", $IniProgramSettings);
	IniWrite($Inidir & $IniLogReport, "IniFile", "IniFileGuiSettings", $IniProgramSettings);
	IniDelete($Inidir & $IniLogReport, "IniFile", "FileNamePrefix");
	IniWrite($Inidir & $IniLogReport, "IniFile", "FileNamePrefix", $FileNamePrefix);
	IniDelete($Inidir & $IniLogReport, "IniFile", "FileNameSuffix");
	IniWrite($Inidir & $IniLogReport, "IniFile", "FileNameSuffix", $FileNameSuffix);
; Cleanup not defined variables
	IniWrite($Inidir & $IniLogReport, "Icon", "TempFilePath", "");
	IniWrite($Inidir & $IniLogReport, "Icon", "ApkIconeName", "");
	IniWrite($Inidir & $IniLogReport, "NewFile", "NewFilenameAPK", "");
	IniWrite($Inidir & $IniLogReport, "NewFile", "NewNameInput", "");
	IniWrite($Inidir & $IniLogReport, "OpenNewFile", "LastFileName", "");
	IniWrite($Inidir & $IniLogReport, "OpenNewFile", "TempFileName", "");
Endif
iF $aCmdLine[0]=0 And $ShowLog="1" then
	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter1", $aCmdLine[0]);
	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter2", "");
; Else
;	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter1", $aCmdLine[0]);
;	IniWrite($Inidir & $IniLogReport, "CommandLine", "Parameter2", $aCmdLine[1]);
Endif

$fieldHeight = 24;
$bigFieldHeight = 93;

$labelStart = 8;
$labelWidth = 100;
$labelHeight = 20;
$labelTop = 3;

$inputStart = 125;
$inputWidth = 300;
$inputHeight = 20;
$inputFlags = BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY);

$editHeight = 85;
$editFlags = BitOR($ES_READONLY,$ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$WS_VSCROLL,$ES_WANTRETURN);

$offsetHeight = 9;

$rightColumnWidth = 100;
$rightColumnStart = $inputStart + $inputWidth + 10;

$fullWidth = $rightColumnStart + $rightColumnWidth + 10;
$fullHeight = $offsetHeight + $fieldHeight*11 + $bigFieldHeight*3 + 50;

$btnWidth = $fullWidth/3  - 20;

$hGUI =	GUICreate($ProgramTitle, $fullWidth, $fullHeight, -1, -1, -1, $WS_EX_ACCEPTFILES)

GUICtrlCreateLabel("", 0, 0, $fullWidth, $fullHeight, $WS_CLIPSIBLINGS); // for accept drag & drop
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
;GUICtrlSetBkColor(-1, $COLOR_RED)

$globalStyle = $GUI_DROPACCEPTED + $GUI_ONTOP
$globalInputStyle = $GUI_ONTOP

$Input1 = _makeField($String01, $apk_Label, False, 0)
$Input2 = _makeField($String02, $apk_VersionName, False, 0)
$Input3 = _makeField($String03, $apk_VersionCode & $apk_Build, False, 0)
$Input4 = _makeField($String04, $apk_PkgName, False, 0)

$Input6 = GUICtrlCreateInput($sMinAndroidString,	150, $offsetHeight, 275,  $inputHeight, $inputFlags)
GUICtrlSetState(-1, $globalInputStyle)
$Input5 = _makeField($String05, $apk_MinSDK, False, 20)

$Input8 = GUICtrlCreateInput($sTgtAndroidString,	150, $offsetHeight, 275,  $inputHeight, $inputFlags)
GUICtrlSetState(-1, $globalInputStyle)
$Input7 = _makeField($String06, $apk_TargetSDK, False, 20)

$Input9 = _makeField($String07, $apk_Screens, False, 0)
$Input10 = _makeField($String08, $apk_Densities, False, 0)
$Input13 = _makeField($String28, $apk_ABIs, False, 0)

$Edit1 = _makeField($String09, $apk_Permissions, True, 0)
$Edit2 = _makeField($String10, $apk_Features, True, 0)
$Edit3 = _makeField($String29, $apk_Signature, True, 0)

$Input11 = _makeField($String11, $fileAPK, False, 0)
$Input12 = _makeField($String12, $sNewFilenameAPK, False, 0)

; Show OS language and language code
IF $ShowLangCode="1" Then
   GUICtrlCreateLabel($String26,			 $rightColumnStart, 84,  $rightColumnWidth,  $labelHeight, $SS_CENTER)
   GUICtrlSetState(-1, $globalStyle)
   GUICtrlCreateLabel($OSLanguageCode,		 $rightColumnStart, 108, $rightColumnWidth,  $labelHeight, $SS_CENTER)
   GUICtrlSetState(-1, $globalStyle)
   GUICtrlCreateLabel($String27,			 $rightColumnStart, 156, $rightColumnWidth,  $labelHeight, $SS_CENTER)
   GUICtrlSetState(-1, $globalStyle)
   GUICtrlCreateLabel($Language_code,		 $rightColumnStart, 180, $rightColumnWidth,  $labelHeight, $SS_CENTER)
   GUICtrlSetState(-1, $globalStyle)
   ;GUICtrlCreateLabel($sPadSpace,		 455, 228, 100,  20)
   ;GUICtrlSetState(-1, $globalStyle)
Endif

$offsetHeight += 11; // buttons row gap

; Button Play / Rename / Exit
$offsetWidth = 10;
$gBtn_Play =	_makeButton($String13)
$gBtn_Rename =	_makeButton($String14)
$gBtn_Exit =	_makeButton($String15)

_GDIPlus_StartUp()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

$defBkColor = 0

If $aCmdLine[0] > 0 Then
	$tmp_Filename = $aCmdLine[1]
Else
	$tmp_Filename = ""
EndIf

_OpenNewFile($tmp_Filename)

GUIRegisterMsg($WM_PAINT, "MY_WM_PAINT")

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $gBtn_Play
			_openPlay()

		Case $GUI_EVENT_DROPPED
			_OpenNewFile(@GUI_DragFile)
			MY_WM_PAINT(0, 0, 0, 0)

		Case $gBtn_Rename
			$sNewNameInput = InputBox($String16,$String17, $sNewFilenameAPK, "", 300, 130)
			If $ShowLog = "1" then
				IniWrite($Inidir & $IniLogReport, "NewFile", "NewFilenameAPK", $sNewFilenameAPK);
				IniWrite($Inidir & $IniLogReport, "NewFile", "NewNameInput", $sNewNameInput);
			Endif
			If $sNewNameInput <> "" Then _renameAPK($sNewNameInput)
		Case $gBtn_Exit
			_cleanUp()
			Exit
		Case $GUI_EVENT_CLOSE
			_cleanUp()
			Exit
	EndSwitch
WEnd

;==================== End GUI =====================================

Func _makeButton($value)
	$ret = GUICtrlCreateButton($value,		$offsetWidth,  $offsetHeight, $btnWidth)
	GUICtrlSetState(-1, $globalStyle)
	$offsetWidth += $btnWidth + 20;
	Return $ret
EndFunc

Func _makeField($label, $value, $isEdit, $width)
	  If $width == 0 Then
		 $width = $inputWidth
	  EndIf
	  GUICtrlCreateLabel($label,			 $labelStart,  $offsetHeight + $labelTop, $labelWidth,  $labelHeight)
	  GUICtrlSetState(-1, $globalStyle)
	  If $isEdit Then
		 $ret = GUICtrlCreateEdit($value,		$inputStart, $offsetHeight, $inputWidth + 10 + $rightColumnWidth,  $editHeight, $editFlags)
		 GUICtrlSetState(-1, $globalInputStyle)
		 $offsetHeight += $bigFieldHeight;
	  Else
		 $ret = GUICtrlCreateInput($value,		$inputStart, $offsetHeight, $width,  $inputHeight, $inputFlags)
		 GUICtrlSetState(-1, $globalInputStyle)
		 $offsetHeight += $fieldHeight;
	  EndIf
	  Return $ret
EndFunc

; Draw PNG image
Func MY_WM_PAINT($hWnd, $Msg, $wParam, $lParam)
	_WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_UPDATENOW)
	$s = 48
	$x = $rightColumnStart + $rightColumnWidth/2 - $s/2
	$y = 10
	If $defBkColor == 0 Then
		$hDC = _WinAPI_GetDC($hGUI)
		$defBkColor = _WinAPI_GetPixel($hDC, $x + $s/2, $y + $s /2)
		_WinAPI_ReleaseDC($hGUI, $hDC)
		;$defBkColor = $COLOR_RED
		$defBkColor = BitOR($defBkColor, 0xFF000000)
	EndIf
	$hBrush = _GDIPlus_BrushCreateSolid($defBkColor)
	_GDIPlus_GraphicsFillRect($hGraphic, $x, $y, $s, $s, $hBrush)
	_GDIPlus_BrushDispose($hBrush)
    _GDIPlus_GraphicsDrawImage($hGraphic, $hImage, $x, $y)
    _WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_VALIDATE)
    Return $GUI_RUNDEFMSG
EndFunc

Func _renameAPK($prmNewFilenameAPK)
	$result = FileMove($fullPathAPK, $dirAPK & "\" & $prmNewFilenameAPK)
	; if result<> = error
	If $result <> 1 Then MsgBox(0,$String18, $String19)
EndFunc

Func _SplitPath($prmFullPath, $prmReturnDir = false)
	$posSlash = StringInStr($prmFullPath, "\", 0, -1)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $posSlash = ' & $posSlash & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
	Switch $prmReturnDir
		Case False
			Return StringMid($prmFullPath, $posSlash + 1)
		Case True
			Return StringLeft($prmFullPath, $posSlash - 1)
	EndSwitch
EndFunc

Func _checkFileParameter($prmFilename)
	If FileExists($prmFilename) Then
		Return $prmFilename
	Else
		$f_Sel = FileOpenDialog($String20, $Lastfolder, "(*.apk)", 1, "")
		If @error Then Exit
		$Lastfolder = _SplitPath($f_Sel, true)
		IniWrite($Inidir & $IniLastFolderSettings, "Settings", "Lastfolder", $Lastfolder);
;		IniWrite($Inidir & $IniProgramSettings, "Settings", "Lastfile", $f_sel);
		Return $f_Sel
	EndIf
EndFunc

Func _OpenNewFile($apk)
	$fullPathAPK = _checkFileParameter($apk)
	$dirAPK      = _SplitPath($fullPathAPK,true)
	$fileAPK     = _SplitPath($fullPathAPK,false)
	$apk_Build = ''

	ProgressOn($String32 & "...", $fileAPK)

	ProgressSet(0, $String04 & '...')

	$tmpArrBadge = _getBadge($fullPathAPK)
	_parseLines($tmpArrBadge)

	ProgressSet(25, $String31 & '...')

	_extractIcon()

	ProgressSet(75, $String29 & '...')

	_getSignature($fullPathAPK)

	If $apk_MinSDKVer <> "" Then $sMinAndroidString = 'Android ' & $apk_MinSDKVer  & ' (' & $apk_MinSDKName & ')'
	If $apk_TargetSDKVer <> "" Then $sTgtAndroidString = 'Android ' & $apk_TargetSDKVer  & ' (' & $apk_TargetSDKName & ')'

	$sNewFilenameAPK = StringReplace ($apk_Label, " ", $FileNameSpace) & $FileNamePrefix & StringReplace ($apk_VersionName, " ", $FileNameSpace) & $FileNameSuffix & StringReplace($apk_VersionCode, " ", $FileNameSpace) & ".apk"

	GUICtrlSetData ($Input1 , $apk_Label)
	GUICtrlSetData ($Input2 , $apk_VersionName)
	GUICtrlSetData ($Input3 , $apk_VersionCode)
	GUICtrlSetData ($Input4 , $apk_PkgName)
	GUICtrlSetData ($Input5 , $apk_MinSDK	)
	GUICtrlSetData ($Input6 , $sMinAndroidString)
	GUICtrlSetData ($Input7 , $apk_TargetSDK)
	GUICtrlSetData ($Input8 , $sTgtAndroidString)
	GUICtrlSetData ($Input9 , $apk_Screens)
	GUICtrlSetData ($Input10, $apk_Densities)
	GUICtrlSetData ($Input13, $apk_ABIs)
	GUICtrlSetData ($Edit1  , $apk_Permissions)
	GUICtrlSetData ($Edit2  , $apk_Features)
	GUICtrlSetData ($Edit3  , $apk_Signature)
	GUICtrlSetData ($Input11, $fileAPK)
	GUICtrlSetData ($Input12, $sNewFilenameAPK)

	_drawPNG()

	ProgressOff()
EndFunc

Func _getSignature($prmAPK)
	$output = ''
	If $CheckSignature == 1 Then
		$foo = Run('java -jar apksigner.jar verify --v --print-certs ' & '"' & $prmAPK & '"', @ScriptDir,  @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		While 1
			$output &= StderrRead($foo)
			If @error Then ExitLoop
		Wend
		While 1
			$output &= StdoutRead($foo)
			If @error Then ExitLoop
		Wend
	EndIf
	$apk_Signature = $output
EndFunc

Func _getBadge($prmAPK)
	Local $foo = Run('aapt.exe d badging ' & '"' & $prmAPK & '"', @ScriptDir,  @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $output
	While 1
		$output &= StdoutRead($foo)
		If @error Then ExitLoop
	Wend
	$arrayLines = _StringExplode($output, @CRLF)
	Return $arrayLines
EndFunc

Func _parseLines($prmArrayLines)
	For $line in $prmArrayLines
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $line = ' & $line & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

		If $line == 'application-debuggable' Then
			$apk_Build = ' ' & $String30
		EndIf

		$arraySplit = _StringExplode($line, ":", 1)
		If Ubound($arraySplit) > 1 Then
			$key = $arraySplit[0]
			$value = $arraySplit[1]
		Else
			ContinueLoop
		EndIf

		Switch $key
			Case 'application'
				$tmp_arr =  _StringBetween($value, "label='", "'")
				$apk_Label = $tmp_arr[0]
				$tmp_arr =  _StringBetween($value, "icon='", "'")
				$apk_IconPath = $tmp_arr[0]
				$tmp_arr = _StringExplode($apk_IconPath, "/")
				$apk_IconName = $tmp_arr[UBound($tmp_arr)-1]

			Case 'package'
				$tmp_arr =  _StringBetween($value, "name='", "'")
				$apk_PkgName = $tmp_arr[0]
				$tmp_arr =  _StringBetween($value, "versionCode='", "'")
				$apk_VersionCode = $tmp_arr[0]
				$tmp_arr =  _StringBetween($value, "versionName='", "'")
				$apk_VersionName = $tmp_arr[0]

			Case 'uses-permission'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_Permissions &= StringLower(StringReplace($tmp_arr[0], "android.permission.", "")  & @CRLF)

			Case 'uses-feature'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_Features &= StringLower(StringReplace($tmp_arr[0], "android.hardware.", "")  & @CRLF)

			Case 'sdkVersion'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_MinSDK = $tmp_arr[0]
				$apk_MinSDKVer = _translateSDKLevel($apk_MinSDK)
				$apk_MinSDKName = _translateSDKLevel($apk_MinSDK, true)

			Case 'targetSdkVersion'
				$tmp_arr =  _StringBetween($value, "'", "'")
				$apk_TargetSDK = $tmp_arr[0]
				$apk_TargetSDKVer = _translateSDKLevel($apk_TargetSDK)
				$apk_TargetSDKName = _translateSDKLevel($apk_TargetSDK, true)

			Case 'supports-screens'
				$apk_Screens = StringStripWS(StringReplace($value, "'", ""),3)

			Case 'densities'
				$apk_Densities = StringStripWS(StringReplace($value, "'", ""),3)

			Case 'native-code'
				$apk_ABIs = StringStripWS(StringReplace($value, "'", ""),3)

			EndSwitch
	Next
EndFunc

Func _extractIcon()
	; find png
	;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _extractIcon = ' & $apk_IconPath & '; ' & $apk_IconName & @crlf)
	If StringRight($apk_IconPath, 4) == '.xml' Then
		$foo = Run('unzip.exe -l ' & '"' & $fullPathAPK & '"', @ScriptDir,  @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		$output = ''
		While 1
			$output &= StdoutRead($foo)
			If @error Then ExitLoop
		Wend
		$arrayLines = _StringExplode($output, @CRLF)

		$start = StringLeft($apk_IconPath, 10) ; 'res/mipmap' or 'res/drawab'
		$end = '/' & StringReplace($apk_IconName, '.xml', '.png')
		$bestSize = 0
		For $line in $arrayLines
			$check = _StringBetween($line, $start, $end)
			;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $arrayLines = ' & $line & '; ' & $check & @crlf)
			If $check <> 0 Then
				$size = Int(StringStripWS($line, 3))
				;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $arrayLines = ' & $line & '; ' & $check[0] & '; ' & $size & '; ' & $bestSize & @crlf)
				If $size > $bestSize Then
					$bestSize = $size
					$apk_IconPath = $start & $check[0] & $end
					$tmp_arr = _StringExplode($apk_IconPath, "/")
					$apk_IconName = $tmp_arr[UBound($tmp_arr)-1]

					;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $line = ' & $line & @crlf & $bestSize & ': ' & $apk_IconPath & @crlf)
				EndIf
			EndIf
		Next
	EndIf

	ProgressSet(50, $String31 & '...')

	; extract icon
	DirCreate($tempPath)
	$runCmd = "unzip.exe -o -j " & '"' & $fullPathAPK & '" ' & $apk_IconPath & " -d " & '"' & $tempPath & '"'
	RunWait($runCmd, @ScriptDir, @SW_HIDE)
EndFunc

Func _cleanUp()
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()

	DirRemove($tempPath, 1); // clean own dir
	DirRemove(@TempDir & "\APK-Info", 1); // clean files from previous runs
EndFunc

Func _openPlay()
	$url = $URLPlayStore & $apk_PkgName & '&hl=' & $PlayStoreLanguage
	ShellExecute($url)
EndFunc

Func _translateSDKLevel($prmSDKLevel, $prmReturnCodeName = false)
	if $prmSDKLevel="1000" then
		$sVersion=$String21
		$sCodeName=$String22
	Else
		$sVersion=Iniread ($Inidir & $IniProgramSettings, "AndroidName", "SDK" & $prmSDKLevel & "-Version", $String23)
		$sCodeName=Iniread ($Inidir & $IniProgramSettings, "AndroidName", "SDK" & $prmSDKLevel & "-CodeName", $String24)
	Endif
	Switch $prmReturnCodeName
		Case true
			Return $sCodeName
		Case Else
			Return $sVersion
	EndSwitch
EndFunc

Func _drawPNG()
	; Png Workaround
	; Load PNG image
	$filename = $tempPath & "\" & $apk_IconName;
	$hImage_original   = _GDIPlus_ImageLoadFromFile($filename)
	If $ShowLog= "1" then
		IniWrite($Inidir & $IniLogReport, "Icon", "TempFilePath", $tempPath);
		IniWrite($Inidir & $IniLogReport, "Icon", "ApkIconeName", $apk_IconName);
	Endif
		; resize always the bigger icon to 48x48 pixels
	If $hImage Then
		_GDIPlus_ImageDispose($hImage)
	EndIf
	$hImage   = _GDIPlus_ImageResize ($hImage_original, 48, 48)
	_GDIPlus_ImageDispose($hImage_original)
	FileDelete($filename); // no need - try delete
	$type = VarGetType($hImage)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $type = ' & $type & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
EndFunc
