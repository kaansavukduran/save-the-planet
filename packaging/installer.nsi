Unicode True
!ifndef VERSION
 !define VERSION "0.3.0"
!endif
Name "Save the Planet"
OutFile "../dist/SaveThePlanet-Setup.exe"
InstallDir "$LOCALAPPDATA\Fragaria Interactive\Save the Planet"
RequestExecutionLevel user
SetCompressor /SOLID lzma
!include "MUI2.nsh"
!define MUI_ABORTWARNING
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "../LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\SaveThePlanet.exe"
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Turkish"
Section "Game"
 SetOutPath "$INSTDIR"
 File "../build/windows/SaveThePlanet.exe"
 File "../build/windows/BUILD.json"
 File "../LICENSE"
 File "../THIRD_PARTY_NOTICES.md"
 File "../assets/fonts/LICENSE.txt"
 WriteUninstaller "$INSTDIR\Uninstall.exe"
 CreateDirectory "$SMPROGRAMS\Fragaria Interactive"
 CreateShortcut "$SMPROGRAMS\Fragaria Interactive\Save the Planet.lnk" "$INSTDIR\SaveThePlanet.exe"
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\SaveThePlanet" "DisplayName" "Save the Planet"
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\SaveThePlanet" "UninstallString" '"$INSTDIR\Uninstall.exe"'
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\SaveThePlanet" "DisplayVersion" "${VERSION}"
 WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\SaveThePlanet" "Publisher" "Fragaria Interactive"
SectionEnd
Section "Uninstall"
 Delete "$INSTDIR\SaveThePlanet.exe"
 Delete "$INSTDIR\BUILD.json"
 Delete "$INSTDIR\LICENSE"
 Delete "$INSTDIR\LICENSE.txt"
 Delete "$INSTDIR\THIRD_PARTY_NOTICES.md"
 Delete "$INSTDIR\Uninstall.exe"
 Delete "$SMPROGRAMS\Fragaria Interactive\Save the Planet.lnk"
 RMDir "$SMPROGRAMS\Fragaria Interactive"
 RMDir "$INSTDIR"
 DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\SaveThePlanet"
 ; Godot user:// saves intentionally survive uninstall.
SectionEnd
