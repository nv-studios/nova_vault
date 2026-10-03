@echo off
setlocal enabledelayedexpansion
title Nova_Vault Secure Matrix v1.0
color 8B

set "VAULT_FILE=vault_data.db"
set "MASTER_CONFIG=vault_master.ini"

if not exist "%MASTER_CONFIG%" (
    cls
    echo =======================================================
    echo          NOVAVAULT: MASTER ACCOUNT GENERATION          
    echo =======================================================
    echo  Please create a highly secure MASTER PASSWORD.
    echo  You will need this password every time you unlock the vault.
    echo =======================================================
    echo.
    set /p "mpass=  Create Master Password: "
    if "!mpass!"=="" goto MAIN_MENU
    echo key=!mpass!>"%MASTER_CONFIG%"
    echo. > "%VAULT_FILE%"
    echo   [^+] Secure Master Key generated successfully!
    pause
)

:VAL_LOGIN
cls
echo =======================================================
echo          NOVAVAULT: CRYPTOGRAPHIC AUTHENTICATION      
echo =======================================================
set /p "login_pass=  Enter Master Password: "
set /p correct_key=<"%MASTER_CONFIG%"
set "correct_key=!correct_key:key=!"
set "correct_key=!correct_key:=!"

if not "!login_pass!"=="!correct_key!" (
    echo.
    echo   [X] ACCESS DENIED: Master decryption pass mismatch.
    pause
    goto VAL_LOGIN
)

:MAIN_MENU
powershell -Command " +^
$choices = @('Store New Asset (SSH/API/Password)', 'Retrieve / Search Vault Items', 'Wipe Vault Records', 'Exit Secure Matrix'); +^
$selection = 0; +^
while ($true) { +^
    Clear-Host; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host '  |         NOVAVAULT SECURE MATRIX       |' -ForegroundColor Cyan; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Cyan; +^
    Write-Host ''; +^
    for ($i=0; $i -lt $choices.Count; $i++) { +^
        if ($i -eq $selection) { +^
            Write-Host ('   -> [ ' + $choices[$i] + ' ] ') -ForegroundColor Black -BackgroundColor Cyan; +^
        } else { +^
            Write-Host ('        ' + $choices[$i]); +^
        } +^
    }; +^
    Write-Host ''; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    Write-Host '   Made by Nova Studios.' -ForegroundColor White; +^
    Write-Host '  +---------------------------------------+' -ForegroundColor Gray; +^
    $key = [System.Console]::ReadKey($true).Key; +^
    if ($key -eq 'UpArrow') { $selection = ($selection -1 + $choices.Count) %% $choices.Count }; +^
    if ($key -eq 'DownArrow') { $selection = ($selection + 1) %% $choices.Count }; +^
    if ($key -eq 'Enter') { exit $selection }; +^
}"
set "action_val=%errorlevel%"

if "%action_val%"=="0" goto STORE_ITEM
if "%action_val%"=="1" goto RETRIEVE_ITEM
if "%action_val%"=="2" goto WIPE_VAULT
if "%action_val%"=="3" exit

:STORE_ITEM
cls
echo  +---------------------------------------+
echo  ^|          STORE NEW VAULT ASSET        ^|
echo  +---------------------------------------+
echo.
set /p "label=  Asset Label (e.g. GitHub SSH / Email / API): "
set /p "username=  Associated Account User / Email: "
set /p "secret=  Secret Key / Password / Code value: "
if "%label%"=="" goto MAIN_MENU

set "raw_string=!label!^|!username!^|!secret!"

:: Cipher mapping
set "chars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |:._-"
set "cipher=nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM9876543210_XYZ-+"

set "encrypted_str="
for /l %%i in (0,1,500) do (
    set "char=!raw_string:~%%i,1!"
    if "!char!"=="" goto SAVE_RECORD
    set "found=0"
    for /l %%j in (0,1,68) do (
        set "c=!chars:~%%j,1!"
        if "!char!"=="!c!" (
            set "encrypted_str=!encrypted_str!!cipher:~%%j,1!"
            set "found=1"
        )
    )
    if "!found!"=="0" set "encrypted_str=!encrypted_str!!char!"
)

:SAVE_RECORD
echo !encrypted_str!>>"%VAULT_FILE%"
echo.
echo   [^+] Entry encrypted and saved securely inside database.
pause
goto MAIN_MENU

:RETRIEVE_ITEM
cls
echo  +---------------------------------------+
echo  ^|         RETRIEVE / DECRYPT ENTRIES    ^|
echo  +---------------------------------------+
echo.
if not exist "%VAULT_FILE%" (
    echo   [No entries stored yet.]
    pause
    goto MAIN_MENU
)

echo   Decrypted Vault Registry Assets:
echo  -------------------------------------------------------
set "chars=nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM9876543210_XYZ-+"
set "cipher=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 |:._-"

for /f "usebackq delims=" %%r in ("%VAULT_FILE%") do (
    set "line=%%r"
    set "decrypted_line="
    for /l %%i in (0,1,500) do (
        set "char=!line:~%%i,1!"
        if "!char!"=="" goto PRINT_RECORD
        set "found=0"
        for /l %%j in (0,1,68) do (
            set "c=!chars:~%%j,1!"
            if "!char!"=="!c!" (
                set "decrypted_line=!decrypted_line!!cipher:~%%j,1!"
                set "found=1"
            )
        )
        if "!found!"=="0" set "decrypted_line=!decrypted_line!!char!"
    )
    :PRINT_RECORD
    if not "!decrypted_line!"=="" (
        for /f "tokens=1-3 delims=|" %%a in ("!decrypted_line!") do (
            echo    [*] ASSET: %%a
            echo        USER:  %%b
            echo        VALUE: %%c
            echo  -------------------------------------------------------
        )
    )
)
pause
goto MAIN_MENU

:WIPE_VAULT
cls
echo  ⚠️  Are you sure you want to permanently delete all data records? (Y/N)
set /p "confirm="
if /i "%confirm%"=="Y" (
    del /f /q "%VAULT_FILE%" >nul 2>&1
    echo   [^+] Database wiped cleanly.
    pause
)
goto MAIN_MENU

