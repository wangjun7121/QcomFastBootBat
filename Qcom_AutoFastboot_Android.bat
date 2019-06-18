
:: �л������д���֧�� utf8 
::chcp 65001

:: chcp 936 Ĭ�� GBK
:: chcp 437 ����Ӣ��


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo ʹ�÷�����
@echo      1. ֱ��˫���ű�,���� imagePath ָ��·���еİ汾��Ĭ��Ϊ��ǰ·��
@echo.
@echo      2. ֱ���Ϸŵ��ű�������
@echo      3. ���������ؾ������Ҽ���ѡ�� Qcom_AutoFastboot_Android
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
::      ��� md5 У�鹦��                                             --20180115
::      ������Զ����                                                  --20190422
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
Set installPath=C:\Qcom_AutoFastboot_Android\

:::::::::::::::::::::::::::::::::
:: ʹ�õ�����ɫ����

Set ADBPATH=%installPath%ADB\adb.exe
Set FASTBOOTPATH=%installPath%ADB\fastboot.exe
Set UZIPPATH=%installPath%7-Zip\App\ProgramFiles64\7z.exe
Set MD5PATH=%installPath%Tools\md5sum.exe
Set GitPATH=%installPath%PortableGit\bin\git.exe

:: ע���Ҽ�ִ��ʱ��Ĭ�ϵ�ǰĿ¼Ϊ�Ҽ���ǰĿ¼
:::::::::::::::::::::::::::::::::

:: git �Զ�ͬ�����
:: ��ʼͬ�� git clone https://github.com/wangjun7121/QcomFastBootBat.git
::%GitPATH% remote add origin https://github.com/wangjun7121/QcomFastBootBat.git
::%GitPATH% checkout .
::%GitPATH% clean -df
::%GitPATH% pull --rebase origin master

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
%ADBPATH% wait-for-device
%ADBPATH% root
%ADBPATH% wait-for-device
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
:: ����������׺���񣬽���ƥ������
:main

:: �汾У�鵥��
@echo off
@echo ************************
@echo   Start md5 check . . .
@echo ************************

if not exist "checklist.md5" (
echo checklist.md5 is not found!
goto md5nofileend
)


findstr %~n1 checklist.md5 > %installPath%temp.md5

%MD5PATH% -c %installPath%temp.md5

erase %installPath%temp.md5

@echo ************************
@echo   Done.
@echo ************************
goto selectDownload

:md5nofileend
@echo ************************
@echo Don't have checklist.md5
@echo ************************
goto selectDownload




::::::::::::::::::::::::::::::::::::::::::
:: ����֮ǰ�ű�ˢ�����з���
::::::::::::::::::::::::::::::::::::::::::
:: ֱ�ӵ�� 
:selectDownload

@echo off
:: �жϵ�ǰĿ¼���Ƿ��� AB ������ؾ���
Set "enableABPartition="
if exist "abl.elf" (
Set "enableABPartition=Yes"
) else (

if not exist "recovery.img" (
Set "enableABPartition=Yes"
)

)


:: ��� user �汾���� fastboot ����
::%FASTBOOTPATH% oem enable-unlock-once


IF {%~n1}=={} (goto flash_all) 

::::::::::::::::::::::::::::::::::::::::::
:: ���ݴ��뾵������ȥ��׺��ѡ��ˢ�����
::::::::::::::::::::::::::::::::::::::::::
@echo off


:: %~n1: ���� 1 ȥ����׺
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
IF {%~n1}=={dtbo} (goto dtbo) 
IF {%~n1}=={vbmeta} (goto vbmeta) 
IF {%~n1}=={lksecapp} (goto lksecapp) 
IF {%~n1}=={km4} (goto km4) 

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
IF {%~n1}=={abl} (goto abl) 
IF {%~n1}=={xbl} (goto xbl) 
IF {%~n1}=={hyp} (goto hyp) 
IF {%~n1}=={pmic} (goto pmic) 
IF {%~n1}=={cmnlib} (goto cmnlib) 
IF {%~n1}=={cmnlib64} (goto cmnlib64) 
IF {%~n1}=={mdtpsecapp} (goto mdtpsecapp) 
IF {%~n1}=={BTFM} (goto BTFM) 
IF {%~n1}=={storsec} (goto storsec) 

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

:: �汾 md5 У��
@echo off
@echo ************************
@echo   Start md5 check . . .
@echo ************************

if not exist "checklist.md5" (
echo checklist.md5 is not found!
goto md5nofileend
)

%MD5PATH% -c checklist.md5


@echo ************************
@echo   Done.
@echo ************************
goto flash_all_start

:md5nofileend
@echo ************************
@echo Don't have checklist.md5
@echo ************************
goto flash_all_start

:flash_all_start
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

%FASTBOOTPATH% flash vbmeta vbmeta.img
%FASTBOOTPATH% flash vbmetabak vbmeta.img

%FASTBOOTPATH% flash dtbo dtbo.img
%FASTBOOTPATH% flash dtbobak dtbo.img

%FASTBOOTPATH% flash lksecapp lksecapp.mbn
%FASTBOOTPATH% flash lksecappbak lksecapp.mbn

%FASTBOOTPATH% flash keymaster km4.mbn
%FASTBOOTPATH% flash keymasterbak km4.mbn

if exist "fs_image.tar.gz.mbn.8917.full.band.img" (
%FASTBOOTPATH% flash fsg fs_image.tar.gz.mbn.8917.full.band.img
)
if exist "fs_image.tar.gz.mbn.8937.full.band.img" (
%FASTBOOTPATH% flash fsg fs_image.tar.gz.mbn.8937.full.band.img
)


%FASTBOOTPATH% erase misc

%FASTBOOTPATH% flash asusfw asusfw.img
%FASTBOOTPATH% flash logo logo.bin
%FASTBOOTPATH% flash vendor vendor.img
%FASTBOOTPATH% flash apdp  dp_AP_signed.mbn
%FASTBOOTPATH% flash msadp dp_MSA_signed.mbn
goto ChoiceBootMode

:::::::::::::::::::::::
::: ˢ�벿�־���
:::::::::::::::::::::::

::  %~f1 �� %1 ���䵽һ����ȫ�ϸ��·����
:storsec
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash storsec "%~f1"
) else (
%FASTBOOTPATH% flash storsec "%~f1"
)
goto ChoiceBootMode

:BTFM
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash bluetooth_a "%~f1"
%FASTBOOTPATH% flash bluetooth_b "%~f1"
) else (
%FASTBOOTPATH% flash bluetooth_a "%~f1"
%FASTBOOTPATH% flash bluetooth_b "%~f1"
)
goto ChoiceBootMode

:mdtpsecapp
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash mdtpsecapp_a "%~f1"
%FASTBOOTPATH% flash mdtpsecapp_b "%~f1"
) else (
%FASTBOOTPATH% flash mdtpsecapp_a "%~f1"
%FASTBOOTPATH% flash mdtpsecapp_b "%~f1"
)
goto ChoiceBootMode

:cmnlib
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash cmnlib "%~f1"
%FASTBOOTPATH% flash cmnlibbak "%~f1"
) else (
%FASTBOOTPATH% flash cmnlib_a "%~f1"
%FASTBOOTPATH% flash cmnlib_b "%~f1"
)
goto ChoiceBootMode

:cmnlib64
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash cmnlib64 "%~f1"
%FASTBOOTPATH% flash cmnlib64bak "%~f1"
) else (
%FASTBOOTPATH% flash cmnlib64_a "%~f1"
%FASTBOOTPATH% flash cmnlib64_b "%~f1"
)
goto ChoiceBootMode

:pmic
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash pmic "%~f1"
) else (
%FASTBOOTPATH% flash pmic_a "%~f1"
%FASTBOOTPATH% flash pmic_b "%~f1"
)

:hyp
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash hyp "%~f1"
) else (
%FASTBOOTPATH% flash hyp_a "%~f1"
%FASTBOOTPATH% flash hyp_b "%~f1"
)


:xbl
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash xbl "%~f1"
) else (
%FASTBOOTPATH% flash xbl_a "%~f1"
%FASTBOOTPATH% flash xbl_b "%~f1"
)

:abl
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash abl "%~f1"
) else (
%FASTBOOTPATH% flash abl_a "%~f1"
%FASTBOOTPATH% flash abl_b "%~f1"
)

goto ChoiceBootMode

:apdp
@echo on
%FASTBOOTPATH% flash apdp "%~f1"
goto ChoiceBootMode

:msadp
@echo on
%FASTBOOTPATH% flash msadp "%~f1"
goto ChoiceBootMode

:vendor
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash vendor "%~f1"
) else (
%FASTBOOTPATH% flash vendor_a "%~f1"
%FASTBOOTPATH% flash vendor_b "%~f1"
)

goto ChoiceBootMode

:logo
@echo on
%FASTBOOTPATH% flash logo "%~f1"
goto ChoiceBootMode

:asusfw
@echo on
%FASTBOOTPATH% flash asusfw "%~f1"
goto ChoiceBootMode

:fs_image.tar.gz.mbn
@echo on
%FASTBOOTPATH% erase modemst1
%FASTBOOTPATH% erase modemst2
%FASTBOOTPATH% erase fsg
%FASTBOOTPATH% flash fsg "%~f1"
goto ChoiceBootMode

:cmnlib_30
@echo on
%FASTBOOTPATH% flash cmnlib "%~f1"
%FASTBOOTPATH% flash cmnlibbak "%~f1"
goto ChoiceBootMode

:cmnlib64_30
@echo on
%FASTBOOTPATH% flash cmnlib64 "%~f1"
%FASTBOOTPATH% flash cmnlib64bak "%~f1"
goto ChoiceBootMode

:keymaster64
@echo on
%FASTBOOTPATH% flash keymaster "%~f1"
%FASTBOOTPATH% flash keymasterbak "%~f1"
goto ChoiceBootMode

:::::::::::::::::::
:dsp2
@echo on
%FASTBOOTPATH% flash adsp "%~f1"
goto ChoiceBootMode

:adspso
@echo on
%FASTBOOTPATH% flash dsp "%~f1"
goto ChoiceBootMode

:NON-HLOS
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash modem "%~f1"
) else (
%FASTBOOTPATH% flash modem_a "%~f1"
%FASTBOOTPATH% flash modem_b "%~f1"
)
goto ChoiceBootMode

:sbl1
@echo on
%FASTBOOTPATH% flash sbl1 "%~f1"
%FASTBOOTPATH% flash sbl1bak "%~f1"
goto ChoiceBootMode

:rpm
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash rpm "%~f1"
%FASTBOOTPATH% flash rpmbak "%~f1"
) else (
%FASTBOOTPATH% flash rpm_a "%~f1"
%FASTBOOTPATH% flash rpm_b "%~f1"
)
goto ChoiceBootMode

:tz
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash tz "%~f1"
%FASTBOOTPATH% flash tzbak "%~f1"
) else (
%FASTBOOTPATH% flash tz_a "%~f1"
%FASTBOOTPATH% flash tz_b "%~f1"
)

goto ChoiceBootMode

:devcfg
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash devcfg "%~f1"
%FASTBOOTPATH% flash devcfgbak "%~f1"
) else (
%FASTBOOTPATH% flash devcfg_a "%~f1"
%FASTBOOTPATH% flash devcfg_b "%~f1"
)
goto ChoiceBootMode

:sec
@echo on
%FASTBOOTPATH% flash sec "%~f1"
goto ChoiceBootMode

:emmc_appsboot
@echo on
%FASTBOOTPATH% flash aboot "%~f1"
%FASTBOOTPATH% flash abootbak "%~f1"
goto ChoiceBootMode

:::::::::::::::::::: AP 
:boot
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash boot "%~f1"
) else (
%FASTBOOTPATH% flash boot_a "%~f1"
%FASTBOOTPATH% flash boot_b "%~f1"
)
goto ChoiceBootMode

:system
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash system "%~f1"
) else (
%FASTBOOTPATH% flash system_a "%~f1"
%FASTBOOTPATH% flash system_b "%~f1"
)
goto ChoiceBootMode

:userdata
@echo on
%FASTBOOTPATH% flash userdata "%~f1"
goto ChoiceBootMode

:persist
@echo on
%FASTBOOTPATH% flash persist "%~f1"
goto ChoiceBootMode

:recovery
@echo on
%FASTBOOTPATH% flash recovery "%~f1"
goto ChoiceBootMode

:cache
@echo on
%FASTBOOTPATH% flash cache "%~f1"
goto ChoiceBootMode

:mdtp
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash mdtp "%~f1"
) else (
%FASTBOOTPATH% flash mdtp_a "%~f1"
%FASTBOOTPATH% flash mdtp_b "%~f1"
)
goto ChoiceBootMode

:APD
@echo on
%FASTBOOTPATH% flash APD "%~f1"
goto ChoiceBootMode

:splash
@echo on
%FASTBOOTPATH% flash splash "%~f1"
goto ChoiceBootMode

:dtbo
@echo on
%FASTBOOTPATH% flash dtbo "%~f1"
%FASTBOOTPATH% flash dtbobak "%~f1"
goto ChoiceBootMode

:vbmeta
@echo on
%FASTBOOTPATH% flash vbmeta "%~f1"
%FASTBOOTPATH% flash vbmetabak "%~f1"
goto ChoiceBootMode

:lksecapp
@echo on
%FASTBOOTPATH% flash lksecapp "%~f1"
%FASTBOOTPATH% flash lksecappbak "%~f1"
goto ChoiceBootMode


:km4
@echo on
if "%enableABPartition%"=="" (
%FASTBOOTPATH% flash keymaster "%~f1"
%FASTBOOTPATH% flash keymasterbak "%~f1"
) else (
%FASTBOOTPATH% flash keymaster_a "%~f1"
%FASTBOOTPATH% flash keymaster_b "%~f1"
)
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

