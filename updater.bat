@echo off
cd /d %~dp0
set ESC=
set RD=%ESC%[31m
set GN=%ESC%[32m
set YW=%ESC%[33m
set BL=%ESC%[34m
set WT=%ESC%[37m
set RN=%ESC%[0m
echo %GN%[INFO] %WT%欢迎使用MaaAssistant资源更新工具！
:: 检查Maa主程序是否存在
if not exist MAA.exe (
    echo %RD%[ERROR] %WT%未找到MaaAssistant主程序，请确认存放路径是否正确！
    goto :end
)
:: 检查依赖文件是否存在
    if not exist maaupdater\sleepx.exe (
        echo %RD%[ERROR] %WT%未找到sleepx，请确认存放路径是否正确！
        goto :end
    )
    if not exist maaupdater\aria2c.exe (
        echo %RD%[ERROR] %WT%未找到aria2c，请确认存放路径是否正确！
        goto :end
    )
    if not exist maaupdater\7z.exe (
        echo %RD%[ERROR] %WT%未找到7z，请确认存放路径是否正确！
        goto :end
    )
    if not exist maaupdater\choice.exe (
        echo %RD%[ERROR] %WT%未找到choice，请确认存放路径是否正确！
        goto :end
    )
:: 检查Maa主程序是否正在运行
tasklist|find /i "MAA.exe" >nul
if not errorlevel 1 (
    echo %RD%[ERROR] %WT%检测到MaaAssistant正在运行，请关闭MaaAssistant后再运行此脚本！
    goto :end
)
echo 1.此脚本是为了应付MAA暂时取消自动更新的情况，所以可能没有特别完善。
echo 2.请不要开启旧版控制台，会卡住！！！
echo 3.发现有问题请发issues。
echo 4.婴儿请出门右拐宝宝巴士。
echo.
echo %YW%[按任意键确认以上条款并继续更新]
pause >nul

echo %GN%[INFO] %WT%检查网络连接中，请稍后...
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
        echo %RD%[ERROR] %WT%无法连接到github.com或gitclone.com或mirror.ghproxy.com。请检查网络连接后重试...
        goto :end
    )
echo %GN%[INFO] %WT%自动选择git源%server%
    maaupdater\sleepx.exe  -p "如果要手动切换git源，请在5秒内按下任意键..." -k 5
    if errorlevel 1 goto :manualres

:getres
if exist maares.zip (
    if exist maares.zip.aria2 (
        echo %YW%[WARN] %WT%检测到存在临时资源文件，正在尝试重新下载...
        goto :regetres
    )
    del /s /q maares.zip
)
echo %GN%[INFO] %WT%开始获取maa最新资源文件...
    ping -n 1 127.1>nul
maaupdater\aria2c.exe --max-connection-per-server=16 --min-split-size=1M --out maares.zip %source%/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip
if errorlevel 1 (
    echo %RD%[ERROR] %WT%在下载资源文件压缩包时发生错误。请检查网络连接后稍后重试...
    goto :end
)

:unzipres
echo %GN%[INFO] %WT%资源文件下载完成，开始校验...
    ping -n 1 127.1>nul
    maaupdater\7z.exe t maares.zip
    if errorlevel 1 (
        echo %RD%[ERROR] %WT%在校验资源文件压缩包时发生错误。
        goto :end
    )
echo %GN%[INFO] %WT%资源文件校验通过，开始解压...
    ping -n 1 127.1>nul
    maaupdater\7z.exe x maares.zip
echo %GN%[INFO] %WT%资源文件解压完成，开始更新缓存和资源文件...
    ping -n 1 127.1>nul
    xcopy .\MaaResource-main\cache .\cache /E /H /C /I /Y
    xcopy .\MaaResource-main\resource .\resource /E /H /C /I /Y
echo %GN%[INFO] %WT%缓存和资源文件更新完成，开始删除临时文件...
    rd /s /q MaaResource-main
    del /s /q maares.zip
echo %GN%[INFO] %WT%更新完成，请重启MaaAssistant。

:end
echo 按任意键退出...
pause>nul
exit


:regetres
echo %GN%[INFO] %WT%开始重新下载资源文件...
    ping -n 1 127.1>nul
    maaupdater\aria2c.exe --max-connection-per-server=16 --min-split-size=1M --out maares.zip -c %source%/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip
    if errorlevel 1 (
        echo %YW%[WARN] %WT%在重新下载资源文件压缩包时发生错误。尝试删除后重新下载...
        del /s /q maares.zip
        del /s /q maares.zip.aria2
        goto :getres
    )
goto :unzipres

:manualres
echo %GN%[INFO] %WT%请手动选择git源：
    echo [A] github.com
    echo [B] gitclone.com
    echo [C] mirror.ghproxy.com
maaupdater\choice -n -c abc >nul
if errorlevel 3 (
    set server=ghproxy
    set source=https://mirror.ghproxy.com/https://github.com
    echo %GN%[INFO] %WT%选择了ghproxy。
    goto :getres
)
if errorlevel 2 (
    set server=gitclone
    set source=https://gitclone.com/github.com
    echo %GN%[INFO] %WT%选择了gitclone。
    goto :getres
)
if errorlevel 1 (
    set server=github
    set source=https://github.com
    echo %GN%[INFO] %WT%选择了github。
    goto :getres
)
echo %RD%[ERROR] %WT%未知错误，更新失败。
goto :end