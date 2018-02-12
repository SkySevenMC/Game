@echo off
setlocal enabledelayedexpansion
color 0E
mode 40,18
title DEV

:Load

set MAXX=10
set MAXY=32
set score=0
set X=0
set Y=0
set /a IA_X=%MAXX%
set /a IA_Y=%MAXY%
set t=1
set "WALL="

for /l %%X in (0,1,%MAXY%) do set WALL=!WALL!-
set WALL=-%WALL%-
for /l %%A in (0,1,%MAXX%) do (
	for /l %%B in (0,1,%MAXY%) do (
		set X%%AY%%B= 
	)
)


:Menu
cls
set "c%t%=^>"
cls
echo.
echo.  %c1% PLAY
echo.  %c2% HELP
echo.  %c3% QUIT

choice.exe /c:SZV /n
set "c%t%="

if %errorlevel%==3 (
	if %t% == 1 goto :Game
	if %t% == 2 goto :Help
	if %t% == 3 goto :Quit
)
if %errorlevel%==2 (
	if not %t%==1 (
		set /a t-=1
	) else (
		set t=3
	)
)
if %errorlevel%==1 (
	if not %t%==3 (
		set /a t+=1
	) else (
		set t=1
	)
)
goto :Menu

:Help
cls
echo HELP :
echo.   Z : UP
echo.   S : DOWN
echo.   Q : LEFT
echo.   D : RIGHT

pause>nul
goto :Menu

:Quit
cls
echo.
echo.
echo. DO YOU REALLY WANT TO LEAVE ?(Y/N)
choice.exe /c:YN /N

if %errorlevel% == 2 goto :Menu
if %errorlevel% == 1 exit
goto :Quit

:Game
cls
call :IA
call :update
echo. %WALL%
for /l %%E in (0,1,%MAXX%) do echo. ^|!line_%%E!^|
echo. %WALL%
echo.  score : %score%

if %X%%Y% == %IA_X%%IA_Y% goto :Loose

choice.exe /c:ZQSD /n

set /a score+=1
set "X%X%Y%Y%= "
set "X%IA_X%Y%IA_Y%= "

if %errorlevel% == 4 (
	if not %Y% == %MAXY% set /a Y+=1
	goto :Game
) else (

	if %errorlevel% == 3 (
		if not %X% == %MAXX% set /a X+=1
		goto :Game
	) else (

		if %errorlevel% == 2 (
			if not %Y% == 0 set /a Y-=1
			goto :Game
		) else (

			if %errorlevel% == 1 (
				if not %X% == 0 set /a X-=1
				goto :Game
			)
		)
	)
)

:update
cls

set X%IA_X%Y%IA_Y%=@
set X%X%Y%Y%=O

for /l %%G in (0,1,%MAXX%) do set line_%%G=

for /l %%C in (0,1,%MAXX%) do (
	for /l %%D in (0,1,%MAXY%) do (
		set line_%%C=!line_%%C!!X%%CY%%D!
	)
)
goto :eof

:IA

set /a RAN=%RANDOM%%%2
set /a "c=%RANDOM%%%3" 
if %c% == 0 set c=1
if %RAN% == 0 (
	if %IA_X% GTR %X% (
		set /a IA_X-=%c%
		goto :eof
	)
	if %IA_X% LSS %X% (
		set /a IA_X+=%c%
		goto :eof
	)

)

if %RAN% == 1 (
	if %IA_Y% GTR %Y% (
		set /a IA_Y-=%c%
		goto :eof
	)
	if %IA_Y% lss %Y% (
		set /a IA_Y+=%c%
		goto :eof
	)
)

goto :eof
:Again
cls
echo.
echo. PLAY AGAIN ?(Y/N)
choice.exe /c:YN /N

if %errorlevel% == 2 exit
if %errorlevel% == 1 goto :Load
goto :Again

:Loose
cls 
echo.
echo YOU HAVE BEEN KILLED ^^!
echo YOUR SCORE WAS %score% ^^!

timeout -t 3 -nobreak > nul
goto :Again

