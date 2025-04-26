!include "MUI2.nsh"

Name "Flutter Theme Changer"
OutFile "flutter_theme_changer_installer.exe"
InstallDir $PROGRAMFILES\FlutterThemeChanger

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

Section "Install"
    SetOutPath $INSTDIR
    File /r "build\windows\runner\Release\*.*"
    
    CreateDirectory "$SMPROGRAMS\Flutter Theme Changer"
    CreateShortcut "$SMPROGRAMS\Flutter Theme Changer\Flutter Theme Changer.lnk" "$INSTDIR\flutter_theme_changer_erfan.exe"
    
    WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

Section "Uninstall"
    RMDir /r "$INSTDIR"
    RMDir /r "$SMPROGRAMS\Flutter Theme Changer"
SectionEnd