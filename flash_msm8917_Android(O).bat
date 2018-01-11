
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo ʹ�÷�����
@echo      1. ֱ��˫���ű�,���� imagePath ָ��·���еİ汾��Ĭ��Ϊ��ǰ·��
@echo.
@echo      2. ֱ���Ϸŵ��ű�������
@echo      3. ���������ؾ������Ҽ���ѡ�� flash_msm8917_Android(O) 
@echo             2/3 ��Ϊ��
@echo              1^> apk ��׺����ѡ��װ���ѹ(�������ͷž���)
@echo              2^> ������׺����������
@echo.
@echo ��֧��ƽ̨��8917/8937
@echo.
:: 
:: ���¼�¼��(�������,���뷨�ɽ������� ( ^_^ ) wangjun
::      ��� fsg ������������ǰ��������                               --20171120
::      ��ӵ��Ҽ����/ȡ�� reg          
::      ��� asusfw.img/logo.bin                                      --20171204
::      ��� ����ʱ����ģʽѡ��Ĭ��Ϊ����׿������ f ���� fastboot   --20171221
::      ��� ͨ�� adb ���� fastboot ��������                          --20171223
::      ��� APK ͨ�� adb ��װ                                        --20180103
::      ��� user �汾���� fastboot ����                              --20180104
::      ��ӷ������ͷŵ� apk �Ҽ���ѹ����                             --20180107
::      ��� vendor.img                                               --20180108
:: ���� Bug: ���н��
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: ����·��������裺(�� asusfw.img Ϊ��)
::      1. �ڸ���ѡ��ˢ����������һ��
::          IF {%~n1}=={asusfw} (goto asusfw) 
::      2. �� flash_all ��ǩ�����һ��
::          fastboot flash asusfw asusfw.img
::      3. ˢ�벿�־���λ�ã�����±�ţ�
::              :asusfw
::              @echo on
::              fastboot flash asusfw asusfw.img
::              goto ChoiceBootMode
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off

:: ��װĿ¼����
Set installPath=C:\C_FastBoot_Flash8917\

:::::::::::::::::::::::::::::::::
:: ʹ�õ�����ɫ����

Set ADBPATH=%installPath%ADB\adb.exe
Set FASTBOOTPATH=%installPath%ADB\fastboot.exe
Set UZIPPATH=%installPath%7-Zip\App\ProgramFiles64\7z.exe

:::::::::::::::::::::::::::::::::


@echo off
::CHOICE /T 10 /C:yn  /D n /M "�Ƿ�ͨ�� adb ���� fastboot?"
::If ErrorLevel 2 goto main
::If ErrorLevel 1 goto adbfastboot

:: ƥ���׺Ϊ APK �����
::  1. ͨ�� adb ��װ 
::  2. Ϊ�������ͷŵ��ļ������ж��ν�ѹ 
IF {%~x1}=={.apk} (goto handleApk) 



:: ƥ��������׺����������ͨ�� adb/fastboot ����
:handleOthers
set /p bootChoice="ֱ�ӻس����� ������ a ͨ�� adb ���� fastboot ����: "
if /I "%bootChoice%" EQU "F" goto adbfastboot 
if "%bootChoice%"=="" goto main
:adbfastboot
@echo on
%ADBPATH% reboot bootloader
goto main


:: ���� apk ��װ�����
:handleApk
set /p bootChoice="ֱ�ӻس���װ ������ x ��ѹ�ͷž���: "
if /I "%bootChoice%" EQU "X" goto unzipApk 
if "%bootChoice%"=="" goto adbinstall

:adbinstall
@echo on
%ADBPATH% wait-for-device
%ADBPATH% install %1 
pause
goto end

:: ���� apk �������ͷŵľ���
:unzipApk
:: ��������ļ�������׺
Set argOneFileName=%~nx1


:: �л��� apk ����Ŀ¼
cd /d  %~dp1

:: ��ѹ *.apk ��Ŀ¼��
%UZIPPATH% x %argOneFileName% -aoa -o%argOneFileName:~0,-11%
cd /d %argOneFileName:~0,-11%
:: ���� *.gz ��ǰ·�� 
%UZIPPATH% x %argOneFileName:~0,-4% -aoa
:: ���� *.tar ��ǰ·�� 
%UZIPPATH% x %argOneFileName:~0,-7% -aoa

pause
goto end

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:main

:: ��� user �汾���� fastboot ����
::fastboot oem enable-unlock-once

::::::::::::::::::::::::::::::::::::::::::
:: ����֮ǰ�ű�ˢ�����з���
::::::::::::::::::::::::::::::::::::::::::
:: ֱ�ӵ�� 
@echo off
IF {%~n1}=={} (goto flash_all) 

::::::::::::::::::::::::::::::::::::::::::
:: ���ݴ��뾵������ȥ��׺��ѡ��ˢ�����
::::::::::::::::::::::::::::::::::::::::::
@echo off
IF {%~n1}=={cmnlib_30} (goto cmnlib_30) 
IF {%~n1}=={cmnlib64_30} (goto cmnlib64_30) 
IF {%~n1}=={keymaster64} (goto keymaster64) 
IF {%~n1}=={dsp2} (goto dsp2) 
IF {%~n1}=={adspso} (goto adspso) 
IF {%~n1}=={NON-HLOS} (goto NON-HLOS) 
IF {%~n1}=={sbl1} (goto sbl1) 
IF {%~n1}=={rpm} (goto rpm) 
IF {%~n1}=={tz} (goto tz) 
IF {%~n1}=={devcfg} (goto devcfg) 
IF {%~n1}=={sec} (goto sec) 
IF {%~n1}=={emmc_appsboot} (goto emmc_appsboot) 
IF {%~n1}=={boot} (goto boot) 
IF {%~n1}=={system} (goto system) 
IF {%~n1}=={userdata} (goto userdata) 
IF {%~n1}=={persist} (goto persist) 
IF {%~n1}=={recovery} (goto recovery) 
IF {%~n1}=={cache} (goto cache) 
IF {%~n1}=={mdtp} (goto mdtp) 
IF {%~n1}=={APD} (goto APD) 
IF {%~n1}=={splash} (goto splash) 

:: %~n1 ���� 1 �ļ����޺�׺
echo %~n1|findstr "^fs_image.tar" >nul
if %errorlevel% equ 0 (
goto fs_image.tar.gz.mbn
) 

IF {%~n1}=={asusfw} (goto asusfw) 
IF {%~n1}=={logo} (goto logo) 
IF {%~n1}=={vendor} (goto vendor) 
IF {%~n1}=={dp_AP_signed} (goto apdp) 
IF {%~n1}=={dp_MSA_signed} (goto msadp) 


goto ChoiceBootMode
::::::::::::::::::::::::::::::::::::::::::
:: ���� fastboot ˢ�뾵��
::::::::::::::::::::::::::::::::::::::::::

:flash_all
::::::::::::::::::::::::::::::::
::�޸�Ϊ�汾ͨ��ӳ��ķ���
:: imgePath ȥ������ע��ָ���汾ͨ��
Set imagePath=.\
cd /d %imagePath%
::::::::::::::::::::::::::::::::
@echo on

%FASTBOOTPATH% flash cmnlib cmnlib_30.mbn
%FASTBOOTPATH% flash cmnlibbak cmnlib_30.mbn
%FASTBOOTPATH% flash cmnlib64 cmnlib64_30.mbn
%FASTBOOTPATH% flash cmnlib64bak cmnlib64_30.mbn

%FASTBOOTPATH% flash keymaster keymaster64.mbn
%FASTBOOTPATH% flash keymasterbak keymaster64.mbn

::
%FASTBOOTPATH% flash adsp dsp2.mbn
%FASTBOOTPATH% flash dsp adspso.bin

%FASTBOOTPATH% flash modem NON-HLOS.bin
%FASTBOOTPATH% flash sbl1 sbl1.mbn
%FASTBOOTPATH% flash sbl1bak sbl1.mbn
%FASTBOOTPATH% flash rpm rpm.mbn
%FASTBOOTPATH% flash rpmbak rpm.mbn
%FASTBOOTPATH% flash tz tz.mbn
%FASTBOOTPATH% flash tzbak tz.mbn

%FASTBOOTPATH% flash devcfg devcfg.mbn
%FASTBOOTPATH% flash devcfgbak devcfg.mbn
%FASTBOOTPATH% flash sec sec.dat
%FASTBOOTPATH% flash aboot emmc_appsboot.mbn
%FASTBOOTPATH% flash abootbak emmc_appsboot.mbn

:: AP
%FASTBOOTPATH% flash boot boot.img
%FASTBOOTPATH% flash system system.img
%FASTBOOTPATH% flash userdata userdata.img
%FASTBOOTPATH% flash persist persist.img
%FASTBOOTPATH% flash recovery recovery.img
%FASTBOOTPATH% flash cache cache.img
%FASTBOOTPATH% flash mdtp mdtp.img
%FASTBOOTPATH% flash APD APD.img

%FASTBOOTPATH% flash splash splash.img
%FASTBOOTPATH% erase modemst1
%FASTBOOTPATH% erase modemst2
%FASTBOOTPATH% erase fsg
%FASTBOOTPATH% flash fsg fs_image.tar.gz.mbn.8917.full.band.img
%FASTBOOTPATH% erase misc

%FASTBOOTPATH% flash asusfw asusfw.img
%FASTBOOTPATH% flash logo logo.bin
%FASTBOOTPATH% flash vendor vendor.img
goto ChoiceBootMode

:::::::::::::::::::::::
::: ˢ�벿�־���
:::::::::::::::::::::::
:apdp
@echo on
%FASTBOOTPATH% flash apdp dp_AP_signed.mbn
goto ChoiceBootMode

:msadp
@echo on
%FASTBOOTPATH% flash msadp dp_MSA_signed.mbn
goto ChoiceBootMode

:vendor
@echo on
%FASTBOOTPATH% flash vendor vendor.img
goto ChoiceBootMode

:logo
@echo on
%FASTBOOTPATH% flash logo logo.bin
goto ChoiceBootMode

:asusfw
@echo on
%FASTBOOTPATH% flash asusfw asusfw.img
goto ChoiceBootMode

:fs_image.tar.gz.mbn
@echo on
%FASTBOOTPATH% erase modemst1
%FASTBOOTPATH% erase modemst2
%FASTBOOTPATH% erase fsg
%FASTBOOTPATH% flash fsg %~f1
goto ChoiceBootMode

:cmnlib_30
@echo on
%FASTBOOTPATH% flash cmnlib %~f1
%FASTBOOTPATH% flash cmnlibbak %~f1
goto ChoiceBootMode

:cmnlib64_30
@echo on
%FASTBOOTPATH% flash cmnlib64 %~f1
%FASTBOOTPATH% flash cmnlib64bak %~f1
goto ChoiceBootMode

:keymaster64
@echo on
%FASTBOOTPATH% flash keymaster %~f1
%FASTBOOTPATH% flash keymasterbak %~f1
goto ChoiceBootMode

::::::::::::::::::::::::::::::::::::::::::
:dsp2
@echo on
%FASTBOOTPATH% flash adsp %~f1
goto ChoiceBootMode

:adspso
@echo on
%FASTBOOTPATH% flash dsp %~f1
goto ChoiceBootMode

:NON-HLOS
@echo on
%FASTBOOTPATH% flash modem %~f1
goto ChoiceBootMode

:sbl1
@echo on
%FASTBOOTPATH% flash sbl1 %~f1
%FASTBOOTPATH% flash sbl1bak %~f1
goto ChoiceBootMode

:rpm
@echo on
%FASTBOOTPATH% flash rpm %~f1
%FASTBOOTPATH% flash rpmbak %~f1
goto ChoiceBootMode

:tz
@echo on
%FASTBOOTPATH% flash tz %~f1
%FASTBOOTPATH% flash tzbak %~f1
goto ChoiceBootMode
:devcfg
%FASTBOOTPATH% flash devcfg %~f1
%FASTBOOTPATH% flash devcfgbak %~f1
goto ChoiceBootMode

:sec
@echo on
%FASTBOOTPATH% flash sec %~f1
goto ChoiceBootMode

:emmc_appsboot
@echo on
%FASTBOOTPATH% flash aboot %~f1
%FASTBOOTPATH% flash abootbak %~f1
goto ChoiceBootMode

:::::::::::::::::::: AP ::::::::::::::::::::::
:boot
@echo on
%FASTBOOTPATH% flash boot %~f1
goto ChoiceBootMode

:system
@echo on
%FASTBOOTPATH% flash system %~f1
goto ChoiceBootMode

:userdata
@echo on
%FASTBOOTPATH% flash userdata %~f1
goto ChoiceBootMode

:persist
@echo on
%FASTBOOTPATH% flash persist %~f1
goto ChoiceBootMode

:recovery
@echo on
%FASTBOOTPATH% flash recovery %~f1
goto ChoiceBootMode

:cache
@echo on
%FASTBOOTPATH% flash cache %~f1
goto ChoiceBootMode

:mdtp
@echo on
%FASTBOOTPATH% flash mdtp %~f1
goto ChoiceBootMode

:APD
@echo on
%FASTBOOTPATH% flash APD %~f1
goto ChoiceBootMode

:splash
@echo on
%FASTBOOTPATH% flash splash %~f1
goto ChoiceBootMode





:::::::::::::::::::::::::::::::::::::: ChoiceBootMode ::::::::::::::::::::::::::::::
:ChoiceBootMode
@echo off

set /p keyChoice="ֱ�ӻس��������� Android������ F �������� fastboot: "
if /I "%keyChoice%" EQU "F" goto rebootfastboot 
if "%keyChoice%"=="" goto rebootandroid

:rebootandroid
%FASTBOOTPATH% reboot
goto end

:rebootfastboot
%FASTBOOTPATH% reboot-bootloader






:end

