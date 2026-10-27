@echo off
:: (========================зпшку подниметееее==========================)
:: Скрипт делает локальный запрос к веб-интерфейсу УТМ (порт 8080)
:: и ищет в коде страницы маркеры ошибок ("Ошибка связи", "Недоступен").
:: (====================================================================)

chcp 65001 >nul
title Проверка УТМ ЕГАИС

:: Если у вас другой порт, просто ниже вместо 8080 поменяйте на нужный <3
set "UTM_URL=http://localhost:8080/home"

echo Проверка связи УТМ с ЕГАИС...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop';" ^
  "try {" ^
  "  $r = Invoke-WebRequest -Uri '%UTM_URL%' -TimeoutSec 5 -UseBasicParsing;" ^
  "  if ($r.Content -match 'Ошибка связи' -or $r.Content -match 'Недоступен') {" ^
  "    Write-Host 'НЕТ: База УТМ доступна, но УТМ НЕ может достучаться до ЕГАИС!!!!!!!!!!!!!!' -ForegroundColor Red;" ^
  "    exit 1" ^
  "  } else {" ^
  "    Write-Host 'ОК: Связь УТМ с ЕГАИС в порядке!!' -ForegroundColor Green;" ^
  "    exit 0" ^
  "  }" ^
  "} catch {" ^
  "  Write-Host 'ОШИБКА: Служба УТМ не отвечает!!!! ->>>>>>>> Проверьте службы Transport и Transport-Updater.' -ForegroundColor Red;" ^
  "  exit 1" ^
  "}"

echo.
if %ERRORLEVEL% == 0 (
    echo [РЕЗУЛЬТАТ]: Связь с ЕГАИС ЕСТЬ.
) else (
    echo [РЕЗУЛЬТАТ]: ПРОБЛЕМА со связью УТМ с ЕГАИС.
)

echo.
pause