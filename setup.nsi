; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "HaxeBuilder"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "AS3Boyan"
!define PRODUCT_WEB_SITE "http://haxebuilder.blogspot.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\HaxeBuilder.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "EnvVarUpdate.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "COPYING"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
;!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\README.md"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

!include "winmessages.nsh"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "HaxeBuilder.exe"
InstallDir "$PROGRAMFILES\HaxeBuilder"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  ;SetShellVarContext all
  !define INSTDIR_DATA "$APPDATA\Macromedia\Flash Player\#Security\FlashPlayerTrust\" ;
  SetOutPath "${INSTDIR_DATA}"
  FileOpen $0 'HaxeBuilder.cfg' w
  FileWrite $0 "$INSTDIR\bin"
  FileClose $9

  SetOutPath "$INSTDIR\bin"
  SetOverwrite try
  File "bin\HaxeBuilder.exe"
  CreateDirectory "$SMPROGRAMS\HaxeBuilder"
  CreateShortCut "$SMPROGRAMS\HaxeBuilder\HaxeBuilder.lnk" "$INSTDIR\bin\HaxeBuilder.exe"
  CreateShortCut "$DESKTOP\HaxeBuilder.lnk" "$INSTDIR\bin\HaxeBuilder.exe"
  File "bin\HaxeBuilder.n"
  File "bin\LaunchSWF.exe"
  File "bin\LaunchSWF.n"
  File "bin\Stopper.exe"
  File "bin\Stopper.n"
  File "bin\SWFLoaderhaxe.swf"
  SetOutPath "$INSTDIR"
  File "changelog.txt"
  File "COPYING"
  File "HaxeBuilder.hxproj"
  File "README.md"
  File "Run.bat"
  SetOutPath "$INSTDIR\src"
  File "src\LaunchSWF.hx"
  File "src\Main.hx"
  File "src\Stopper.hx"
  File "src\SWFLoader.hx"
  SetOutPath "$INSTDIR\templates"
  File "templates\Haxe_AS3_Live_Reloading_Template.fdz"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\HaxeBuilder\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\HaxeBuilder\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
   ; include for some of the windows messages defines
   ; HKLM (all users) vs HKCU (current user) defines
   !define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
   !define env_hkcu 'HKCU "Environment"'
   ; set variable
   WriteRegExpandStr ${env_hkcu} HAXE_BUILDER "$INSTDIR\bin\"
   ; make sure windows knows about the change
   SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
   
   ${EnvVarUpdate} $0 "PATH" "A" "HKCU" "%HAXE_BUILDER%;"

  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\bin\HaxeBuilder.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  
  ExecCmd::exec /TIMEOUT=2000 '"start" $INSTDIR\templates\Haxe_AS3_Live_Reloading_Template.fdz'
  Pop $0
  
  ExecWait '"$WINDIR\notepad.exe" $INSTDIR\README.md'
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  SetOutPath "${INSTDIR_DATA}"
  Delete "HaxeBuilder.cfg"
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\templates\Haxe AS3 Live Reloading Template.fdz"
  Delete "$INSTDIR\src\SWFLoader.hx"
  Delete "$INSTDIR\src\Stopper.hx"
  Delete "$INSTDIR\src\Main.hx"
  Delete "$INSTDIR\src\LaunchSWF.hx"
  Delete "$INSTDIR\Run.bat"
  Delete "$INSTDIR\README.md"
  Delete "$INSTDIR\HaxeBuilder.hxproj"
  Delete "$INSTDIR\COPYING"
  Delete "$INSTDIR\changelog.txt"
  Delete "$INSTDIR\bin\SWFLoaderhaxe.swf"
  Delete "$INSTDIR\bin\Stopper.n"
  Delete "$INSTDIR\bin\Stopper.exe"
  Delete "$INSTDIR\bin\LaunchSWF.n"
  Delete "$INSTDIR\bin\LaunchSWF.exe"
  Delete "$INSTDIR\bin\HaxeBuilder.n"
  Delete "$INSTDIR\bin\HaxeBuilder.exe"
  Delete "$INSTDIR\bin\swfpath.txt"

  Delete "$SMPROGRAMS\HaxeBuilder\Uninstall.lnk"
  Delete "$SMPROGRAMS\HaxeBuilder\Website.lnk"
  Delete "$DESKTOP\HaxeBuilder.lnk"
  Delete "$SMPROGRAMS\HaxeBuilder\HaxeBuilder.lnk"

  RMDir "$SMPROGRAMS\HaxeBuilder"
  RMDir "$INSTDIR\templates"
  RMDir "$INSTDIR\src"
  RMDir "$INSTDIR\bin"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  
   ; delete variable
   DeleteRegValue ${env_hkcu} HAXE_BUILDER
   ; make sure windows knows about the change
   SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
    ${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "%HAXE_BUILDER%"
  
  SetAutoClose true
SectionEnd