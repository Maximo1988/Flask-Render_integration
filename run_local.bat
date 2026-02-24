@echo off
setlocal

cd /d "%~dp0"
set "PORT=5000"

where python >nul 2>nul
if %errorlevel%==0 (
    set "PY_CMD=python"
    set "PY_ARGS="
) else (
    where py >nul 2>nul
    if %errorlevel%==0 (
        set "PY_CMD=py"
        set "PY_ARGS=-3"
    ) else (
        echo No se encontro Python en PATH.
        pause
        exit /b 1
    )
)

netstat -ano | findstr /R /C:":%PORT% .*LISTENING" >nul
if %errorlevel%==0 (
    echo Ya hay un proceso escuchando en el puerto %PORT%.
) else (
    if defined PY_ARGS (
        start "waitress" %PY_CMD% %PY_ARGS% -m waitress --host=0.0.0.0 --port=%PORT% src.app:app
    ) else (
        start "waitress" %PY_CMD% -m waitress --host=0.0.0.0 --port=%PORT% src.app:app
    )
    timeout /t 2 >nul
    echo Servidor iniciado con Waitress en http://127.0.0.1:%PORT%
)

where chrome >nul 2>nul
if %errorlevel%==0 (
    start "" chrome "http://127.0.0.1:%PORT%"
) else (
    start "" "http://127.0.0.1:%PORT%"
)

endlocal
