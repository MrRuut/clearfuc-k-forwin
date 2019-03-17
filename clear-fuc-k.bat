@echo off
goto nodebug
echo By Mr.Ruut_Unix
title ClearFuck_Win
:: @@@@@ Below Block is for Debugging Purposes Only @@@@@
@echo on
echo ERROR TEST LOG FLAG
IF NOT %1!==/go! %0 /go 1>C:\state\%~n0.log 2>&1
SHIFT

ECHO %1 %2 %3 %4 %5

:: @@@@@ Above Block is for Debugging Purposes Only @@@@@@
:nodebug
:: :::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:: :::::::::::::::::::::::::::::::::::::::
:: http://stackoverflow.com/questions/...
echo Hello Computer Name: %computername%
echo.
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

echo Current path is %cd%
echo Changing directory to the path of the current script
cd %~dp0
echo Current path is %cd%

:gotPrivileges
::::::::::::::::::::::::::::
::START
:: @@@@@@@@@@@@ DEEP OR QUICK MODE SELECTION BELOW @@@@@@@@@@@@
@For /F "tokens=1,2,3,4 delims=/ " %%A in ('Date /t') do @(
Set Day=%%A
Set Month=%%B
Set Year=%%C
)

echo -------------------------------------------------
echo %Year%-%Month%-%Day%
echo.
set choice=n
echo -------------------------------------------------
echo Do you want to RUN Manual Deep Scans ALSO ? Press: y : then : ENTER.
echo.
echo NOTE: Some of these deep scans can take a long time to complete ...
echo You should only run the DEEP scans about once a month to save time...
echo OR If you KNOW their is a problem with your computer and it needs fixing.
echo.
echo If you Want FULL Automation and DO NOT want to
echo be bothered with DEEP Manual Scans JUST Press Enter.
echo -------------------------------------------------
set /P choice=: [y] or [n] ^>
echo.
echo You Pressed The: %choice% Key
:: Check and MAKE SURE an Invalid Key was not pressed if so set n
if not %choice%==y if not %choice%==n set choice=n
echo.
:: @@@@@@@@@@@@ DEEP OR QUICK MODE SELECTION ABOVE @@@@@@@@@@@@
:: The User Selection Options y or n are taken into consideration
:: further down the script in various selected regions.
:: ------------------------------------------------------------
:: This Sets a TIME SLOT of FULL scan mode on EMSISOFT if ALL true
if %choice%==y (set scanmode=deep) else (set scanmode=smart)
echo -----------------------------------------------------------
echo This AUTOMATED batch cleaning tool was written by Chelley
echo It can ONLY work if you have several programs Installed
echo Including SPYBOT SEARCH AND DESTROY. Including the Following !
echo Malwarebytes : Emsisoft : Defraggler : CCleaner :
echo IF some or ALL of these programs are missing or not Installed
echo in their USUAL C:\Program Files Location then this Batch
echo file MAY not be effective in AUTOCLEANING your system,
echo if you have any problems please contact Chelley
echo.
echo THIS BATCH MUST BE STARTED VIA RUNNING: RUNME.bat AS an ADMINISTRATOR
echo -----------------------------------------------------------
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
if not exist "%SystemRoot%\System32\Contig.exe" if exist "Contig.exe" xcopy /y Contig.exe "%SystemRoot%\System32\Contig.exe"
cls
:: ###########################################################
> cleaning.tmp echo Running
set state="C:\state\clnstate.txt"
if not exist C:\state\ md C:\state\
>> %state% echo.
>> %state% echo STARTING NEW SCAN ON Time: %time% Date: %date%
>> %state% echo ----------------------------------------
:: http://www.makeuseof.com/tag/xx-way...
:: ###########################################################
:: https://helpdesk.malwarebytes.org/h...
if exist "C:\Program Files\Malwarebytes Anti-Malware\mbam.exe" (set mbytes=11) else (set mbytes=10)
if exist "C:\Program Files\Malwarebytes Anti-Malware\mbam.exe" (set mbaU="C:\Program Files\Malwarebytes Anti-Malware\mbam.exe" /runupdate) else (set mbaU=>> %state% echo Malware Bytes is Not Installed or path LOCATION ERROR on %date%)
if exist "C:\Program Files\Malwarebytes Anti-Malware\mbam.exe" (set mbaS="C:\Program Files\Malwarebytes Anti-Malware\mbam.exe" /fullauto) else (set mbaS=echo none)
if exist "C:\Program Files\Defraggler\df.exe" (set def="C:\Program Files\Defraggler\df") else (set def=%SystemRoot%\system32\Defrag)
if exist "C:\Program Files\CCleaner\CCleaner.exe" (set cc=1) else (set cc=10)
if exist "C:\Program Files\CCleaner\CCleaner.exe" (set ccscf="C:\Program Files\CCleaner\CCleaner.exe" /AUTO) else (set ccscf=>> %state% echo CCleaner is Not Installed or path LOCATION ERROR on %date%)
if exist "C:\Program Files\CCleaner\CCleaner.exe" (set ccscr="C:\Program Files\CCleaner\CCleaner.exe" /REGISTRY /AUTO) else (set ccscr=echo none)
if exist "C:\Program Files\Spybot - Search & Destroy\SpybotSD.exe" (set spb=1) else (set spb=10)
if exist "C:\Program Files\Spybot - Search & Destroy\SpybotSD.exe" (set spybot1="C:\Program Files\Spybot - Search & Destroy\SpybotSD.exe" /autoupdate /autoimmunize /autocheck /autofix /autoclose) else (set spybot1=>> %state% echo Spybot Search and Destroy is Not Installed or path LOCATION ERROR on %date%)
if exist "C:\Program Files\Emsisoft Anti-Malware\a2cmd.exe" (set a2c=1) else (set a2c=10)
if exist "C:\Program Files\Emsisoft Anti-Malware\a2cmd.exe" (set amalu="C:\Program Files\Emsisoft Anti-Malware\a2cmd.exe" /s /update &&echo UPDATED Emsisoft &&if exist sleep.com sleep 5) else (set amalu=>> %state% echo Emsisoft Antimalware is Not Installed or path LOCATION ERROR on %date%)
if exist "C:\Program Files\Emsisoft Anti-Malware\a2cmd.exe" (set amals="C:\Program Files\Emsisoft Anti-Malware\a2cmd.exe" /s /%scanmode% /h /m /t /r /d /whitelist="C:\Program Files\Emsisoft Anti-Malware\a2whitelist.ini" /quarantine="C:\Program Files\Emsisoft Anti-Malware\Quarantine" /delete) else (set amals=echo none)
if %mbytes%==11 echo Updating MalwareBytes &&%mbaU%
:: http://www.safer-networking.org/faq...
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:: SPYBOT SEARCH AND DESTROY LOG SNOOPING LOOKING FOR SPYWARE START
:: ---------------------------------------------------
if exist "%ALLUSERSPROFILE%\Application Data\Spybot - Search & Destroy\Logs" set splogs="%ALLUSERSPROFILE%\Application Data\Spybot - Search & Destroy\Logs\Checks.*%Month%%Day%-*.log"
set spiesfound=0
if exist %splogs% (goto check1a) else (goto nochk1a)
:check1a
>nul find "found:" %splogs% && (
echo Spybot has found Spyware on %computername%.
set spiesfound=1
goto :notice2
) || (
echo Spybot has found no Spyware on %computername%.
goto :nofix2
)

if %spiesfound%==1 echo SPYWARE WAS FOUND BY SPYBOT SEARCH AND DESTROY.
if %spiesfound%==1 >> %state% echo SPYWARE WAS FOUND BY SPYBOT SEARCH AND DESTROY T:%time D:%date%
:nochk1a
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:: SPYBOT SEARCH AND DESTROY LOG SNOOPING LOOKING FOR SPYWARE END
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
>> %state% echo Operating System = Windows %os%
>> %state% echo --------------------------------------------------------------------------------
>> %state% echo.
>> %state% echo NEW SCAN INITIALIZED FOR CLEANING AND DEFRAG AT %time% on %date%
if %a2c%==10 >> %state% echo Emsisoft Antimalware Is Missing Please Instal http://tinyurl.com/knd5aod
if %mbytes%==10 >> %state% echo MalwareBytes is Not Installed Will try Portable Version OR Please Install from https://www.malwarebytes.org/
if %cc%==10 >> %state% echo Ccleaner is Missing Please Install http://www.piriform.com/
if %spb%==10 >> %state% echo Spybot Search and Destroy is Missing Please Install http://www.safer-networking.org/
if %Day%==8 Cleanmgr /sagerun:1
if %Day%==22 Cleanmgr /sagerun:1
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
cls
:: ------------------------------------------------------
>> %state% echo CLEANING YOUR SYSTEM T: %time% D: %date%
if %a2c%==1 echo Updating Emsisoft &&%amalu%
echo.&&cls
echo DONE Emsisoft Update
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cls
:: ------------------------------------------------------
if %cc%==1 echo Running Ccleaner File Clean &&%ccscf%
echo.&&cls
if %cc%==1 echo DONE Ccleaner File Clean
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cls
:: ------------------------------------------------------
if %cc%==1 echo Running Ccleaner Reg Clean &&%ccscr%
echo.&&cls
if %cc%==1 echo DONE Ccleaner Registry Clean
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cls
if %choice%==n goto donesbsd
if %spb%==10 goto donesbsd
:: ---------- Prevents Repeat Checks Same Month ---------
set noloop2=0
if exist Month2.tmp set /p noloop2=<Month2.tmp
if %noloop2% NEQ %Month% goto spsdr
if %noloop2% EQU %Month% echo SPYBOT Search 8 Destroy HAS ALREADY RUN ONCE THIS Month
if %noloop2% EQU %Month% >> %state% echo SPYBOT Search 8 Destroy HAS ALREADY RUN ONCE THIS Month %Month%
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
if %noloop2%==%Month% goto donesbsd
:: ------------------------------------------------------
:spsdr
> Month2.tmp echo %Month%
if %choice%==y echo Running Spybot Search and Destroy Please Wait ... &&%spybot1%
echo.&&cls
if %choice%==y echo DONE Spybot Search and Destroy Scan &&goto donesbsd
cls
:: ------------------------------------------------------
if %Day%==21 echo Running Spybot Search and Destroy &&%spybot1%
if %Day%==21 echo DONE Spybot Search and Destroy Scan
:donesbsd
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cls
:: ------------------------------------------------------
if %mbytes%==11 if %choice%==y echo Running MalwareBytes Antimalware &&%mbaS%
echo.&&cls
if %mbytes%==11 if %choice%==y echo Done MalwareBytes Antimalware
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cls
:: ------------------------------------------------------
if %a2c%==1 echo Emsisoft Antimalware Scanning &&%amals%
echo.&&cls
if %a2c%==1 echo Completed Emsisoft Antimalware Scan.
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cls
set malfound=0
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:: @@@@@@@@@@@@@@@@@@@@ OPTIONAL @@@@@@@@@@@@@@@@@@@@@@@@
:: ------------------------------------------------------
:: If in "mbar-log-*.txt" a "Removal queue found" or "Cleaning up" or "Infected" then run fixdamage
if exist Mbar\mbar.exe (goto mbar1) else (goto nofix)
:mbar1
:: ----------------------------------------------------------------
echo.
echo.
:: If all the scanners did a DEEP scan all at once it could take 24 Hours
:: to complete so these Variables below check to ensure only one scanner at
:: a time gets to run in deep scan mode to save time.
:: also if Malwarebytes is already installed skip portable MBAR version.
:: ----------------------------------------------------------------
if %mbytes%==11 goto nocheck1
if %scanmode%==deep goto nocheck1
if %choice%==n goto nocheck1
echo -------------------------------------------------
echo PLEASE LEAVE THIS WINDOW OPEN or BEHIND an Active Scan Window
echo as you may have to read further scan results or Input [y] or [n]
echo.
echo STARTING PORTABLE VERSION OF MALWAREBYTES MBAR
echo Starting Mbar Scanner Please Wait ....
echo.
if exist Mbar\mbar.exe call Mbar\mbar.exe
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cd %1
cls
if exist "Mbar\Plugins\fixdamage.exe" (goto fixdamage) else (goto nofix)

echo --------------------------------------------------------------
:fixdamage
echo PRESS PAUSE BREAK KEY TO READ TEXT BELOW : PRESS SPACE BAR TO CONTINUE
echo.
echo --------------------------------------------------------------
if exist Mbar\mbar-log-%year%-%Month%-%Day%*.txt (goto :check1) else (goto :nocheck1)
:check1
>nul find "Infected" Mbar\mbar-log-%year%-%Month%-%Day%*.txt && (
echo MBAR has found A Virus on %computername%.
set malfound=1
goto :notice
) || (
echo Mbar has found no Infection on %computername%.
goto :nofix
)

:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:notice
echo.
echo Selecting fixdamage will open another console window and request
echo confirmation to apply any fixes to %computername%. Input: Y
echo to begin the fix.
echo.
:nocheck1
echo IMPORTANT If MBAR should ever find an Infection on %computername%
echo You MUST Run the FIX DAMAGE application to repair any Damage
echo A Virus / Trojan Horse / or other Malware may have caused.
echo.
echo However PLEASE NOTE that Running FIXDAMAGE.EXE Unnecesarily
echo may result in losing some user settings, these are not critical but
echo will mean you may have to reconfigure some user preferences again.
echo.
echo.
:nofix
pathping 127.0.0.1 -n -q 1 -p 15000 >nul 2>&1
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo.
if %spiesfound%==1 if %malfound%==1 echo Multiple Problems were found on your computer Virus's and Spyware
echo.
:: ---------------------------------------------------
>> %state% echo.
if %spiesfound%==1 if %malfound%==1 >> %state% echo Multiple Problems were found on your computer Virus's and Spyware
>> %state% echo.
:: @@@@@@@@@@@@@@@@@@@@ OPTIONAL @@@@@@@@@@@@@@@@@@@@@@@@
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo Now Defragmenting YOUR HARD DRIVE
>> %state% echo DEFRAGMENTING YOUR SYSTEM T: %time% D: %date%
%def% C:
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if exist "D:\"* (set drvexist01=1) else (set drvexist01=0)
if exist "E:\"* (set drvexist02=1) else (set drvexist02=0)
if exist "F:\"* (set drvexist03=1) else (set drvexist03=0)
if exist "G:\"* (set drvexist04=1) else (set drvexist04=0)
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:: -----------------------
if "%drvexist01%"=="0" goto noD
echo.
echo Now Checking Defrag Schedule for D: Drive
echo.
if %Day%==2 %def% D:
if %Day%==5 %def% D:
if %Day%==10 %def% D:
if %Day%==28 %def% D:
:: -----------------------
:noD
if "%drvexist02%"=="0" goto noE
echo.
echo Now Checking Defrag Schedule for E: Drive
echo.
if %Day%==3 %def% E:
if %Day%==12 %def% E:
:: -----------------------
:noE
if "%drvexist03%"=="0" goto noF
echo.
echo Now Checking Defrag Schedule for F: Drive
echo.
if %Day%==4 %def% F:
if %Day%==26 %def% F:
:: -----------------------
:noF
if "%drvexist03%"=="0" goto noG
echo.
echo Now Checking Defrag Schedule for G: Drive
echo.
if %Day%==25 %def% G:
:: -----------------------
:noG
:: @@@@@@@@@@@@@@@@@
:: CHECK DISK FOR ERRORS chkdsk
if %Day% GTR 25 if %Day% LSS 27 goto chk
if %Day% GTR 10 if %Day% LSS 14 goto chk
if %Day% LSS 03 goto chk
goto nochk
:chk
set noloop1=0
if exist today1.tmp set /p noloop1=<today1.tmp
if %noloop1%==%Day% echo HARD DISKS HAVE ALREADY BEEN CHECKED ONCE TODAY
>> %state% echo HARD DISKS HAVE ALREADY BEEN CHECKED ONCE TODAY %date%
if %noloop1%==%Day% goto nochk
> today1.tmp echo %Day%
>> %state% echo Now CHECKING YOUR HARD DRIVE
echo Now CHECKING YOUR HARD DRIVE
echo y > confirm.txt
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
:: -----------------------
if "%drvexist01%"=="0" goto noD1
echo Checking Drive D: For Errors
echo.
cls
>> %state% echo Checking Drive D: For Errors
>> %state% echo.
chkdsk D: /F < confirm.txt
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
:noD1

if "%drvexist02%"=="0" goto noE1
echo Checking Drive E: For Errors
echo.
cls
>> %state% echo Checking Drive E: For Errors
>> %state% echo.
chkdsk E: /F < confirm.txt
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
:noE1

:: -----------------------
if "%drvexist03%"=="0" goto noF1
echo Checking Drive F: For Errors
echo.
cls
>> %state% echo Checking Drive F: For Errors
>> %state% echo.
chkdsk F: /F < confirm.txt
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
:noF1

:: -----------------------
if "%drvexist04%"=="0" goto noG1
echo Checking Drive G: For Errors
echo.
cls
>> %state% echo Checking Drive G: For Errors
>> %state% echo.
chkdsk G: /F < confirm.txt
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
:noG1

:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo Checking Drive C: For Errors
echo.
>> %state% echo Checking Drive C: For Errors
>> %state% echo.
chkdsk C: /F < confirm.txt
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
:nochk
if %malfound%==0 goto nomrt
echo BECAUSE A VIRUS WAS DETECTED A FULL MICROSOFT
echo M.R.T. MUST BE RUN this Can take some time,
echo IT SHOULD BE ALLOWED TO BE COMPLETED.
:nomrt
if %spiesfound%==1 if %malfound%==1 goto malrem
if %choice%==n goto nomalrem
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if exist "malremove.exe" goto malrem
goto nomalrem
:malrem
echo Running Microsoft Malacious Software Removal Tool Time: %time%
>> %state% echo PLEASE Un-Check The Check Box to ASK for Permission Time: %time% Date: %date%
>> %state% echo should it be displayed.
echo.
echo Please WAIT This can Take quite a long time this Scan is Only run
echo If other virus Detections have been confirmed during earlier scans.
echo.
echo ----------------------------------------
if %spiesfound%==1 if %malfound%==1 goto mrtcln
echo skipping M.R.T. On this occasion I'm feeling lazy
>> %state% echo ----------------------------------------
>> %state% echo skipping M.R.T. On this occasion
>> %state% echo as no virus to cleanup
>> %state% echo ----------------------------------------
goto skipmrt
:mrtcln
echo PLEASE select CONTINUE and DE-SELECT The Check Box
echo for "M.S. Malacious Software Removal Tool"
echo IF it should ask for your permission to run ....
echo should it be displayed..
echo.
malremove.exe /Q /F:Y
:skipmrt
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
cls
:nomalrem
:: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if not exist "%SystemRoot%\System32\Contig.exe" goto nocontig
>> %state% echo Starting CONTIG this program defragments system files
>> %state% echo including the paging file and Multi Fat Table etc.
>> %state% echo.

echo Starting CONTIG this program defragments system files
echo including the paging file and Multi Fat Table.
echo.

>> %state% echo ----------------------------------------

contig $Mft
contig $LogFile
contig $Volume
contig $AttrDef
contig $Bitmap
contig $Boot
contig $BadClus
contig $Secure
contig $UpCase
contig $Extend

>> %state% echo ----------------------------------------
>> %state% echo.
pathping 127.0.0.1 -n -q 1 -p 19000 >nul 2>&1
cls
:: ::::::::::::::::::::::::::
:nocontig
echo Please Scroll Down for any Software errors
echo When NOTEPAD opens the LOG FILE to read batch log
echo and send to chelley if their are errors listed.
echo.
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
notepad %state%
del cleaning.tmp

if %malfound%==0 goto nowarn
>> %state% echo MALWARE OR A VIRUS WAS FOUND
>> %state% echo YOU MAY WISH TO DO FURTHER
>> %state% echo DEEP SCANS ON YOUR COMPUTER.
:nowarn
>> %state% echo.
>> %state% echo Clean5.bat Completed Successfully Date: %date% Time: %time%
echo Clean5.bat Completed Successfully %time%
:: ------------------------------------------
:: --------- BELOW COMMAND DISABLED ---------
:: echo COMPUTER WILL SHUTDOWN IN 10 MINUTES TIME
:: shutdown -i -s -t 600
:: ------------------------------------------
:: ::::::::::::::::::::::::::
setlocal & pushd .

echo Current path is %cd%
echo Changing directory to the path of the current script
cd %~dp0
echo Current path is %cd%

REM Run shell as admin (example) - put here code as you like
>> %state% echo %choice% Key
>> %state% echo You Pressed The: %choice% Key y = full n = quick
>> %state% echo Completed
>> %state% echo.
>> %state% echo ----------------------------------------
pathping 127.0.0.1 -n -q 1 -p 5000 >nul 2>&1
:: cmd /k
endlocal


