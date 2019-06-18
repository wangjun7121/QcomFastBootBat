
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

:: �л����Ҽ�Ŀ¼
cd %1


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


:main


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: �ж��Ƿ��� AB ����

:: Android9 
if exist "abl.elf" (
goto enableAB
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Android 8:
:disableAB

if exist "emmc_appsboot.mbn" (
%FASTBOOTPATH% flash aboot emmc_appsboot.mbn
%FASTBOOTPATH% flash abootbak emmc_appsboot.mbn
)

if exist "system.img" (
%FASTBOOTPATH% flash system system.img
)

if exist "vendor.img" (
%FASTBOOTPATH% flash vendor vendor.img
)

if exist "boot.img" (
%FASTBOOTPATH% flash boot boot.img
)

if exist "userdata.img" (
%FASTBOOTPATH% flash userdata userdata.img
)

if exist "persist.img" (
%FASTBOOTPATH% flash persist persist.img
)

if exist "recovery.img" (
%FASTBOOTPATH% flash recovery recovery.img
)

if exist "cache.img" (
%FASTBOOTPATH% flash cache cache.img
)

if exist "mdtp.img" (
%FASTBOOTPATH% flash mdtp mdtp.img
)



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Android 9.0 ���� 

if exist "splash.img" (
%FASTBOOTPATH% flash splash splash.img
)

if exist "vbmeta.img" (
%FASTBOOTPATH% flash vbmeta vbmeta.img
%FASTBOOTPATH% flash vbmetabak vbmeta.img
)

if exist "dtbo.img" (
%FASTBOOTPATH% flash dtbo dtbo.img
%FASTBOOTPATH% flash dtbobak dtbo.img
)

if exist "NON-HLOS.bin" (
%FASTBOOTPATH% flash modem NON-HLOS.bin
)



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Android 9 �� AB
:enableAB
if exist "abl.elf" (
%FASTBOOTPATH% flash abl_a abl.elf
%FASTBOOTPATH% flash abl_b abl.elf
)

if exist "boot.img" (
%FASTBOOTPATH% flash boot_a boot.img
%FASTBOOTPATH% flash boot_b boot.img
)

if exist "system.img" (
%FASTBOOTPATH% flash system_a system.img
%FASTBOOTPATH% flash system_b system.img
)

if exist "vendor.img" (
%FASTBOOTPATH% flash vendor_a vendor.img
%FASTBOOTPATH% flash vendor_b vendor.img
)




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

:: fastboot flash cmnlib cmnlib_30.mbn
:: fastboot flash cmnlibbak cmnlib_30.mbn
:: fastboot flash cmnlib64 cmnlib64_30.mbn
:: fastboot flash cmnlib64bak cmnlib64_30.mbn
:: 
:: fastboot flash keymaster keymaster64.mbn
:: fastboot flash keymasterbak keymaster64.mbn
:: 
:: ::
:: fastboot flash adsp dsp2.mbn
:: fastboot flash dsp adspso.bin
:: 
:: fastboot flash modem NON-HLOS.bin
:: fastboot flash sbl1 sbl1.mbn
:: fastboot flash sbl1bak sbl1.mbn
:: fastboot flash rpm rpm.mbn
:: fastboot flash rpmbak rpm.mbn
:: fastboot flash tz tz.mbn
:: fastboot flash tzbak tz.mbn
:: 
:: fastboot flash devcfg devcfg.mbn
:: fastboot flash devcfgbak devcfg.mbn
:: fastboot flash sec sec.dat


:: fastboot flash aboot emmc_appsboot.mbn
:: fastboot flash abootbak emmc_appsboot.mbn
:: 
:: :: AP
:: 
:: fastboot flash system system.img
:: fastboot flash vendor vendor.img
:: fastboot flash boot boot.img
:: fastboot flash userdata userdata.img
:: fastboot flash persist persist.img
:: fastboot flash recovery recovery.img
:: fastboot flash cache cache.img
:: fastboot flash mdtp mdtp.img


:: pause

:: fastboot reboot