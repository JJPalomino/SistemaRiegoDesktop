; Instalador de Windows para el Sistema de Riego (Tlatlauquitepec).
;
; Compilar (desde la raiz del proyecto Flutter):
;   "C:\Users\<usuario>\AppData\Local\Programs\Inno Setup 6\ISCC.exe" installer\sistema_riego.iss
;
; Genera: dist\SistemaRiego-Setup-<version>.exe
; Antes de compilar hay que generar la build de Release:
;   flutter build windows

#define MyAppName "Sistema de Riego"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Sistema de Riego - Tlatlauquitepec"
#define MyAppExeName "sistema_riego_desktop.exe"

[Setup]
; Identificador unico de la aplicacion (no cambiar entre versiones).
AppId={{7C1E4B52-3A9D-4E6B-8F21-5D0A6C3B9E18}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
; Sin pagina de seleccion de grupo del menu inicio (se crea automaticamente).
DisableProgramGroupPage=yes
OutputDir=..\dist
OutputBaseFilename=SistemaRiego-Setup-{#MyAppVersion}
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
; Instalacion por usuario: no requiere permisos de administrador.
PrivilegesRequired=lowest
; Windows de 64 bits (la build de Flutter es x64).
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
; Cierra la app automaticamente si esta abierta al instalar/actualizar.
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
; Se empaqueta todo el contenido de la build de Release (exe, DLLs y carpeta data).
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Desinstalar {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Limpia cualquier archivo generado dentro de la carpeta de instalacion.
Type: filesandordirs; Name: "{app}"
