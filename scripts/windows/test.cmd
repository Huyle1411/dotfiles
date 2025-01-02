@echo off
set SRC_FILE=%1
set LANG=%2
set DEBUG=%3
if "%LANG%"=="" (
    echo Wrong format
    echo Usage: build.bat ^<problem_name^> ^<lang^>
    exit /b 1
)
py "D:\Personal\Global_config\test_solution.py" %SRC_FILE% %LANG% %DEBUG%