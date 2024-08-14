@echo off
cd /d %~dp0
set ESC=
set RD=%ESC%[31m
set GN=%ESC%[32m
set YW=%ESC%[33m
set BL=%ESC%[34m
set WT=%ESC%[37m
set RN=%ESC%[0m
echo %GN%[INFO] %WT%��ӭʹ��MaaAssistant��Դ���¹��ߣ�
:: ���Maa�������Ƿ����
if not exist MAA.exe (
    echo %RD%[ERROR] %WT%δ�ҵ�MaaAssistant��������ȷ�ϴ��·���Ƿ���ȷ��
    goto :end
)
:: ��������ļ��Ƿ����
    if not exist maaupdater\sleepx.exe (
        echo %RD%[ERROR] %WT%δ�ҵ�sleepx����ȷ�ϴ��·���Ƿ���ȷ��
        goto :end
    )
    if not exist maaupdater\aria2c.exe (
        echo %RD%[ERROR] %WT%δ�ҵ�aria2c����ȷ�ϴ��·���Ƿ���ȷ��
        goto :end
    )
    if not exist maaupdater\7z.exe (
        echo %RD%[ERROR] %WT%δ�ҵ�7z����ȷ�ϴ��·���Ƿ���ȷ��
        goto :end
    )
    if not exist maaupdater\choice.exe (
        echo %RD%[ERROR] %WT%δ�ҵ�choice����ȷ�ϴ��·���Ƿ���ȷ��
        goto :end
    )
:: ���Maa�������Ƿ���������
tasklist|find /i "MAA.exe" >nul
if not errorlevel 1 (
    echo %RD%[ERROR] %WT%��⵽MaaAssistant�������У���ر�MaaAssistant�������д˽ű���
    goto :end
)
echo 1.�˽ű���Ϊ��Ӧ��MAA��ʱȡ���Զ����µ���������Կ���û���ر����ơ�
echo 2.�벻Ҫ�����ɰ����̨���Ῠס������
echo 3.�����������뷢issues��
echo 4.Ӥ��������ҹձ�����ʿ��
echo.
echo %YW%[�������ȷ�����������������]
pause >nul

echo %GN%[INFO] %WT%������������У����Ժ�...
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
        echo %RD%[ERROR] %WT%�޷����ӵ�github.com��gitclone.com��mirror.ghproxy.com�������������Ӻ�����...
        goto :end
    )
echo %GN%[INFO] %WT%�Զ�ѡ��gitԴ%server%
    maaupdater\sleepx.exe  -p "���Ҫ�ֶ��л�gitԴ������5���ڰ��������..." -k 5
    if errorlevel 1 goto :manualres

:getres
if exist maares.zip (
    if exist maares.zip.aria2 (
        echo %YW%[WARN] %WT%��⵽������ʱ��Դ�ļ������ڳ�����������...
        goto :regetres
    )
    del /s /q maares.zip
)
echo %GN%[INFO] %WT%��ʼ��ȡmaa������Դ�ļ�...
    ping -n 1 127.1>nul
maaupdater\aria2c.exe --max-connection-per-server=16 --min-split-size=1M --out maares.zip %source%/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip
if errorlevel 1 (
    echo %RD%[ERROR] %WT%��������Դ�ļ�ѹ����ʱ�������������������Ӻ��Ժ�����...
    goto :end
)

:unzipres
echo %GN%[INFO] %WT%��Դ�ļ�������ɣ���ʼУ��...
    ping -n 1 127.1>nul
    maaupdater\7z.exe t maares.zip
    if errorlevel 1 (
        echo %RD%[ERROR] %WT%��У����Դ�ļ�ѹ����ʱ��������
        goto :end
    )
echo %GN%[INFO] %WT%��Դ�ļ�У��ͨ������ʼ��ѹ...
    ping -n 1 127.1>nul
    maaupdater\7z.exe x maares.zip
echo %GN%[INFO] %WT%��Դ�ļ���ѹ��ɣ���ʼ���»������Դ�ļ�...
    ping -n 1 127.1>nul
    xcopy .\MaaResource-main\cache .\cache /E /H /C /I /Y
    xcopy .\MaaResource-main\resource .\resource /E /H /C /I /Y
echo %GN%[INFO] %WT%�������Դ�ļ�������ɣ���ʼɾ����ʱ�ļ�...
    rd /s /q MaaResource-main
    del /s /q maares.zip
echo %GN%[INFO] %WT%������ɣ�������MaaAssistant��

:end
echo ��������˳�...
pause>nul
exit


:regetres
echo %GN%[INFO] %WT%��ʼ����������Դ�ļ�...
    ping -n 1 127.1>nul
    maaupdater\aria2c.exe --max-connection-per-server=16 --min-split-size=1M --out maares.zip -c %source%/MaaAssistantArknights/MaaResource/archive/refs/heads/main.zip
    if errorlevel 1 (
        echo %YW%[WARN] %WT%������������Դ�ļ�ѹ����ʱ�������󡣳���ɾ������������...
        del /s /q maares.zip
        del /s /q maares.zip.aria2
        goto :getres
    )
goto :unzipres

:manualres
echo %GN%[INFO] %WT%���ֶ�ѡ��gitԴ��
    echo [A] github.com
    echo [B] gitclone.com
    echo [C] mirror.ghproxy.com
maaupdater\choice -n -c abc >nul
if errorlevel 3 (
    set server=ghproxy
    set source=https://mirror.ghproxy.com/https://github.com
    echo %GN%[INFO] %WT%ѡ����%server%��
    goto :getres
)
if errorlevel 2 (
    set server=gitclone
    set source=https://gitclone.com/github.com
    echo %GN%[INFO] %WT%ѡ����%server%��
    goto :getres
)
if errorlevel 1 (
    set server=github
    set source=https://github.com
    echo %GN%[INFO] %WT%ѡ����%server%��
    goto :getres
)
echo %RD%[ERROR] %WT%δ֪���󣬸���ʧ�ܡ�
goto :end