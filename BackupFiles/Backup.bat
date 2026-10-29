@echo off
setlocal enabledelayedexpansion

set "fname=%~1"
set "filename=%~n1"
set "path=%~dp1"
set "extension=%~x1"

set "timestamp=%date:/=-%_%time::=-%"
set "timestamp=%timestamp:.=-%"

set "newname=%path%BACKUPS\Backup[%filename%%extension%]\[%timestamp%] %filename%%extension%.BAK"

if /i not "%extension%"==".BAK" (

md "BACKUPS\Backup[%filename%%extension%]"
copy "%fname%" "%newname%"

)
