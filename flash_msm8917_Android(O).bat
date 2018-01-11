
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo 使用方法：
@echo      1. 直接双击脚本,下载 imagePath 指定路径中的版本，默认为当前路径
@echo.
@echo      2. 直接拖放到脚本上下载
@echo      3. 在所需下载镜像上右键，选择 flash_msm8917_Android(O) 
@echo             2/3 行为：
@echo              1^> apk 后缀，可选择安装或解压(服务器释放镜像)
@echo              2^> 其他后缀，进行下载
@echo.
@echo 暂支持平台：8917/8937
@echo.
:: 
:: 更新记录：(按需更新,有想法可交流定制 ( ^_^ ) wangjun
::      添加 fsg 新增分区下载前擦除命令                               --20171120
::      添加到右键添加/取消 reg          
::      添加 asusfw.img/logo.bin                                      --20171204
::      添加 重启时启动模式选择，默认为进安卓，输入 f 进入 fastboot   --20171221
::      添加 通过 adb 进入 fastboot 进行下载                          --20171223
::      添加 APK 通过 adb 安装                                        --20180103
::      添加 user 版本解锁 fastboot 命令                              --20180104
::      添加服务器释放的 apk 右键解压功能                             --20180107
::      添加 vendor.img                                               --20180108
:: 关于 Bug: 自行解决
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: 添加新分区镜像步骤：(以 asusfw.img 为例)
::      1. 在根据选择刷入分区中添加一行
::          IF {%~n1}=={asusfw} (goto asusfw) 
::      2. 在 flash_all 标签中添加一行
::          fastboot flash asusfw asusfw.img
::      3. 刷入部分镜像位置，添加新标号：
::              :asusfw
::              @echo on
::              fastboot flash asusfw asusfw.img
::              goto ChoiceBootMode
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off

:: 安装目录设置
Set installPath=C:\C_FastBoot_Flash8917\

:::::::::::::::::::::::::::::::::
:: 使用到的绿色工具

Set ADBPATH=%installPath%ADB\adb.exe
Set FASTBOOTPATH=%installPath%ADB\fastboot.exe
Set UZIPPATH=%installPath%7-Zip\App\ProgramFiles64\7z.exe

:::::::::::::::::::::::::::::::::


@echo off
::CHOICE /T 10 /C:yn  /D n /M "是否通过 adb 进入 fastboot?"
::If ErrorLevel 2 goto main
::If ErrorLevel 1 goto adbfastboot

:: 匹配后缀为 APK 的情况
::  1. 通过 adb 安装 
::  2. 为服务器释放的文件，进行二次解压 
IF {%~x1}=={.apk} (goto handleApk) 



:: 匹配其他后缀镜像的情况：通过 adb/fastboot 下载
:handleOthers
set /p bootChoice="直接回车下载 或输入 a 通过 adb 进入 fastboot 下载: "
if /I "%bootChoice%" EQU "F" goto adbfastboot 
if "%bootChoice%"=="" goto main
:adbfastboot
@echo on
%ADBPATH% reboot bootloader
goto main


:: 处理 apk 安装的情况
:handleApk
set /p bootChoice="直接回车安装 或输入 x 解压释放镜像: "
if /I "%bootChoice%" EQU "X" goto unzipApk 
if "%bootChoice%"=="" goto adbinstall

:adbinstall
@echo on
%ADBPATH% wait-for-device
%ADBPATH% install %1 
pause
goto end

:: 处理 apk 服务器释放的镜像
:unzipApk
:: 传入参数文件名带后缀
Set argOneFileName=%~nx1


:: 切换到 apk 所在目录
cd /d  %~dp1

:: 解压 *.apk 到目录中
%UZIPPATH% x %argOneFileName% -aoa -o%argOneFileName:~0,-11%
cd /d %argOneFileName:~0,-11%
:: 解析 *.gz 当前路径 
%UZIPPATH% x %argOneFileName:~0,-4% -aoa
:: 解析 *.tar 当前路径 
%UZIPPATH% x %argOneFileName:~0,-7% -aoa

pause
goto end

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:main

:: 添加 user 版本解锁 fastboot 命令
::fastboot oem enable-unlock-once

::::::::::::::::::::::::::::::::::::::::::
:: 兼容之前脚本刷入所有分区
::::::::::::::::::::::::::::::::::::::::::
:: 直接点击 
@echo off
IF {%~n1}=={} (goto flash_all) 

::::::::::::::::::::::::::::::::::::::::::
:: 根据传入镜像名（去后缀）选择刷入分区
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

:: %~n1 变量 1 文件名无后缀
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
:: 进行 fastboot 刷入镜像
::::::::::::::::::::::::::::::::::::::::::

:flash_all
::::::::::::::::::::::::::::::::
::修改为版本通道映射的分区
:: imgePath 去掉下行注释指定版本通道
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
::: 刷入部分镜像
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

set /p keyChoice="直接回车重启进入 Android，输入 F 重启进入 fastboot: "
if /I "%keyChoice%" EQU "F" goto rebootfastboot 
if "%keyChoice%"=="" goto rebootandroid

:rebootandroid
%FASTBOOTPATH% reboot
goto end

:rebootfastboot
%FASTBOOTPATH% reboot-bootloader






:end

