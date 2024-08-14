@echo off
cd /d %~dp0
set ESC=
set RD=%ESC%[31m
set GN=%ESC%[32m
set YW=%ESC%[33m
set BL=%ESC%[34m
set WT=%ESC%[37m
set RN=%ESC%[0m
echo %GN%[INFO] %WT%ª∂”≠ π”√MaaAssistant◊ ‘¥∏¸–¬π§æﬂ£°
:: ºÏ≤ÈMaa÷˜≥Ã–Ú «∑Ò¥Ê‘⁄
if not exist MAA.exe (
    echo %RD%[ERROR] %WT%Œ¥’“µΩMaaAssistant÷˜≥Ã–Ú£¨«Î»∑»œ¥Ê∑≈¬∑æ∂ «∑Ò’˝»∑£°
    goto :end
)
:: ºÏ≤È“¿¿µŒƒº˛ «∑Ò¥Ê‘⁄
    if not exist maaupdater\sleepx.exe (
        echo %RD%[ERROR] %WT%Œ¥’“µΩsleepx£¨«Î»∑»œ¥Ê∑≈¬∑æ∂ «∑Ò’˝»∑£°
        goto :end
    )
    if not exist maaupdater\aria2c.exe (
        echo %RD%[ERROR] %WT%Œ¥’“µΩaria2c£¨«Î»∑»œ¥Ê∑≈¬∑æ∂ «∑Ò’˝»∑£°
        goto :end
    )
    if not exist maaupdater\7z.exe (
        echo %RD%[ERROR] %WT%Œ¥’“µΩ7z£¨«Î»∑»œ¥Ê∑≈¬∑æ∂ «∑Ò’˝»∑£°
        goto :end
    )
    if not exist maaupdater\choice.exe (
        echo %RD%[ERROR] %WT%Œ¥’“µΩchoice£¨«Î»∑»œ¥Ê∑≈¬∑æ∂ «∑Ò’˝»∑£°
        goto :end
    )
:: ºÏ≤ÈMaa÷˜≥Ã–Ú «∑Ò’˝‘⁄‘À––
tasklist|find /i "MAA.exe" >nul
if not errorlevel 1 (
    echo %RD%[ERROR] %WT%ºÏ≤‚µΩMaaAssistant’˝‘⁄‘À––£¨«Îπÿ±’MaaAssistant∫Û‘Ÿ‘À––¥ÀΩ≈±æ£°
    goto :end
)
echo 1.¥ÀΩ≈±æ «Œ™¡À”¶∏∂MAA‘› ±»°œ˚◊‘∂Ø∏¸–¬µƒ«Èøˆ£¨À˘“‘ø…ƒ‹√ª”–Ãÿ±ÕÍ…∆°£
echo 2.«Î≤ª“™ø™∆Ùæ…∞Êøÿ÷∆Ã®£¨ª·ø®◊°£°£°£°
echo 3.∑¢œ÷”–Œ Ã‚«Î∑¢issues°£
echo 4.”§∂˘«Î≥ˆ√≈”“π’±¶±¶∞Õ ø°£
echo.
echo %YW%[∞¥»Œ“‚º¸»∑»œ“‘…œÃıøÓ≤¢ºÃ–¯∏¸–¬]
pause >nul

echo %GN%[INFO] %WT%ºÏ≤ÈÕ¯¬Á¡¨Ω”÷–£¨«Î…‘∫Û...
    ping -n 2 github.com>nul
    if errorlevel 0 (
        set source=https://github.com
        set server=github
    )
    ping -n 2 gitclone.com>nul
    if errorlevel 0 (
        set source=https://gitclone.com/github.com
        set server=gitclone
    )
    ping -n 2 mirror.ghproxy.com>nul
    if errorlevel 0 (
        set source=https://mirror.ghproxy.com/https://github.com
        set server=ghproxy
    )
    if not defined source (
        echo %RD%[ERROR] %WT%Œﬁ∑®¡¨Ω”µΩgithub.comªÚgitclone.comªÚmirror.ghproxy.com°£«ÎºÏ≤ÈÕ¯¬Á¡¨Ω”∫Û÷ÿ ‘...
        goto :end
    )
echo %GN%[INFO] %WT%◊‘∂Ø—°‘Ògit‘¥%server%
    maaupdater\sleepx.exe  -p "»Áπ˚“™ ÷∂Ø«–ªªgit‘¥£¨«Î‘⁄5√Îƒ⁄∞¥œ¬»Œ“‚º¸..." -k 5
    if errorlevel 1 goto :manualres

:getres
if exist maares.zip (
    if exist maares.zip.aria2 (
        echo %YW%[WARN] %WT%ºÏ≤‚µΩ¥Ê‘⁄¡Ÿ ±◊ ‘¥Œƒº˛£¨’˝‘⁄≥¢ ‘÷ÿ–¬œ¬‘ÿ...
        goto :regetres
    )
    del /s /q maares.zip
)
echo %GN%[INFO] %WT%ø™ ºªÒ»°maa◊Ó–¬◊ ‘¥Œƒº˛...
    ping -n 1 127.1>nul
maaupdater\aria2c.exe --max-connection-per-server=16 --min-split-size=1M --out maares.zip %source%/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip
if errorlevel 1 (
    echo %RD%[ERROR] %WT%‘⁄œ¬‘ÿ◊ ‘¥Œƒº˛—πÀı∞¸ ±∑¢…˙¥ÌŒÛ°£«ÎºÏ≤ÈÕ¯¬Á¡¨Ω”∫Û…‘∫Û÷ÿ ‘...
    goto :end
)

:unzipres
echo %GN%[INFO] %WT%◊ ‘¥Œƒº˛œ¬‘ÿÕÍ≥…£¨ø™ º–£—È...
    ping -n 1 127.1>nul
    maaupdater\7z.exe t maares.zip
    if errorlevel 1 (
        echo %RD%[ERROR] %WT%‘⁄–£—È◊ ‘¥Œƒº˛—πÀı∞¸ ±∑¢…˙¥ÌŒÛ°£
        goto :end
    )
echo %GN%[INFO] %WT%◊ ‘¥Œƒº˛–£—ÈÕ®π˝£¨ø™ ºΩ‚—π...
    ping -n 1 127.1>nul
    maaupdater\7z.exe x maares.zip
echo %GN%[INFO] %WT%◊ ‘¥Œƒº˛Ω‚—πÕÍ≥…£¨ø™ º∏¸–¬ª∫¥Ê∫Õ◊ ‘¥Œƒº˛...
    ping -n 1 127.1>nul
    xcopy .\MaaResource-main\cache .\cache /E /H /C /I /Y
    xcopy .\MaaResource-main\resource .\resource /E /H /C /I /Y
echo %GN%[INFO] %WT%ª∫¥Ê∫Õ◊ ‘¥Œƒº˛∏¸–¬ÕÍ≥…£¨ø™ º…æ≥˝¡Ÿ ±Œƒº˛...
    rd /s /q MaaResource-main
    del /s /q maares.zip
echo %GN%[INFO] %WT%∏¸–¬ÕÍ≥…£¨«Î÷ÿ∆ÙMaaAssistant°£

:end
echo ∞¥»Œ“‚º¸ÕÀ≥ˆ...
pause>nul
exit


:regetres
echo %GN%[INFO] %WT%ø™ º÷ÿ–¬œ¬‘ÿ◊ ‘¥Œƒº˛...
    ping -n 1 127.1>nul
    maaupdater\aria2c.exe --max-connection-per-server=16 --min-split-size=1M --out maares.zip -c %source%/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip
    if errorlevel 1 (
        echo %YW%[WARN] %WT%‘⁄÷ÿ–¬œ¬‘ÿ◊ ‘¥Œƒº˛—πÀı∞¸ ±∑¢…˙¥ÌŒÛ°£≥¢ ‘…æ≥˝∫Û÷ÿ–¬œ¬‘ÿ...
        del /s /q maares.zip
        del /s /q maares.zip.aria2
        goto :getres
    )
goto :unzipres

:manualres
echo %GN%[INFO] %WT%«Î ÷∂Ø—°‘Ògit‘¥£∫
    echo [A] github.com
    echo [B] gitclone.com
    echo [C] mirror.ghproxy.com
maaupdater\choice -n -c abc >nul
if errorlevel 3 (
    set server=ghproxy
    set source=https://mirror.ghproxy.com/https://github.com
    echo %GN%[INFO] %WT%—°‘Ò¡Àghproxy°£
    goto :getres
)
if errorlevel 2 (
    set server=gitclone
    set source=https://gitclone.com/github.com
    echo %GN%[INFO] %WT%—°‘Ò¡Àgitclone°£
    goto :getres
)
if errorlevel 1 (
    set server=github
    set source=https://github.com
    echo %GN%[INFO] %WT%—°‘Ò¡Àgithub°£
    goto :getres
)
echo %RD%[ERROR] %WT%Œ¥÷™¥ÌŒÛ£¨∏¸–¬ ß∞‹°£
goto :end