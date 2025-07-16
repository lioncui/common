@echo off
setlocal enabledelayedexpansion

:: 定义颜色变量
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
    set "DEL=%%a"
)
set "RED=!DEL! [91m"
set "GREEN=!DEL! [92m"
set "YELLOW=!DEL! [93m"
set "NC=!DEL! [0m"

:: 主函数
if "%~1"=="" (
    call :usage
    exit /b 1
)

:: 命令路由
if /i "%~1"=="package" (
    shift
    call :package %*
) else if /i "%~1"=="push" (
    shift
    call :push %*
) else if /i "%~1"=="test" (
    shift
    call :test %*
) else if /i "%~1"=="clean" (
    shift
    call :clean %*
) else if /i "%~1"=="help" (
    call :usage
) else (
    echo %RED%Unknown command: %1%NC%
    call :usage
    exit /b 1
)

exit /b 0

:: 帮助信息
:usage
echo Usage: %~nx0 [command] [options]
echo.
echo Available commands:
echo    package     Build the package
echo    push        Push the package to registry
echo    test        Run tests
echo    clean       Clean build artifacts
echo    help        Show this help message
echo.
echo Examples:
echo    %~nx0 package
echo    %~nx0 push --tag v1.0
exit /b 0

:: 打包函数
:package
echo %GREEN%Packaging...%NC%

:: 这里替换为你的实际打包逻辑
if not exist dist mkdir dist
powershell -Command "Get-Date -Format 'yyyyMMdd'" > date.txt
set /p build_date=<date.txt
del date.txt
tar -czf dist\myapp-%build_date%.tar.gz src\

echo %GREEN%Package created at dist\myapp-%build_date%.tar.gz%NC%
exit /b 0

:: 推送函数
:push
set tag=latest
set args=%*

:push_loop
if "%args%"=="" goto :push_end

for /f "tokens=1,2,*" %%a in ("%args%") do (
    if /i "%%a"=="--tag" (
        set tag=%%b
        set args=%%c
    ) else (
        echo %RED%Unknown option: %%a%NC%
        call :usage
        exit /b 1
    )
)
goto :push_loop

:push_end
echo %GREEN%Pushing with tag: %tag%%NC%

:: 这里替换为你的实际推送逻辑
echo [模拟] 推送 myapp:%tag% 到仓库
exit /b 0

:: 测试函数
:test
echo %GREEN%Running tests...%NC%

:: 这里替换为你的实际测试逻辑
pytest tests\ || (
    echo %RED%Tests failed!%NC%
    exit /b 1
)
exit /b 0

:: 清理函数
:clean
echo %YELLOW%Cleaning...%NC%

:: 这里替换为你的实际清理逻辑
if exist dist rmdir /s /q dist
if exist build rmdir /s /q build
if exist __pycache__ rmdir /s /q __pycache__
exit /b 0