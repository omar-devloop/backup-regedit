@echo off
setlocal enabledelayedexpansion
set "fname=%~1"

set "filename=%~n1"
set "extension=%~x1"

if /i "%extension%"==".BAK" rename "%fname%" "%filename%"