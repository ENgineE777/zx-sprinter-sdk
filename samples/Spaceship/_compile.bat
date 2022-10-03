
if "%ZXSDK%"=="" (
    echo "ZXSDK enviroment wan't set. Please execute registerSDK.bat in SDK folder"
    pause
    exit
)

set output=Spaceship
set runZXMak=Yes
call %ZXSDK%compileExe.bat
