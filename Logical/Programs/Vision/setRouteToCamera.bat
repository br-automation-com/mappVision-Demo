:Run this batch file with administrator rights 

@echo off
@prompt -$G
chcp 1252 >nul
echo.

:--------------------------------------
: Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
 
: If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
Echo Request admin rights...
goto UACPrompt
) else (goto gotAdmin)
 
: UACPrompt
Echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
Echo UAC.ShellExecute %0, "", "", "runas", 1 >> "%temp%\getadmin.vbs"
 
"%temp%\getadmin.vbs"
call: Exit /b
 
: gotAdmin
if exist "%temp%\getadmin.vbs" (Del "%temp%\getadmin.vbs")
Pushd "%CD%"
CD /D "%~dp0"
:--------------------------------------


: Create routing
:=================================

route delete 192.168.200.0
route add 192.168.200.0 mask 255.255.255.0 192.168.1.100


