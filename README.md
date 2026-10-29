# Backup File / Restore File

Windows Explorer context-menu helpers that create timestamped backups of any file and restore them later.

Right-click a file → **Backup File** leaves a copy in a `BACKUPS` folder next to it. Right-click a `.BAK` file → **Restore File** strips the `.BAK` extension and puts the original name back.

The project is a single `.reg` file plus two batch scripts. There is nothing to build and no dependencies beyond Windows.

## Requirements

- Windows (tested on Windows 10/11)
- `regedit` to import the installer
- Administrator rights to write the `HKEY_CLASSES_ROOT` keys

## Installation

1. Copy the `BackupFiles` folder to `C:\src`, so the scripts live at:
   - `C:\src\BackupFiles\Backup.bat`
   - `C:\src\BackupFiles\Restore.bat`
2. Double-click `Backup Regedit.reg` and confirm the UAC / registry prompt.

> The installer hard-codes `C:\src\BackupFiles`. If you keep the scripts somewhere else, edit the two `command` values in the `.reg` file before importing it.

No reboot is needed. The two entries appear the next time you right-click a file in Explorer.

## Usage

### Backup

Right-click any file that is **not** a `.BAK` file and choose **Backup File**.

The backup is written next to the original:

```
<folder of the file>\
└── BACKUPS\
    └── Backup[report.docx]\
        ├── [2026-10-29_14-30-00-12] report.docx.BAK
        └── [2026-10-29_18-05-41-08] report.docx.BAK
```

The timestamp comes from `%date%` / `%time%` with `/`, `:` and `.` replaced by `-`, so the exact format follows your regional settings. Every backup of the same file lands in the same `Backup[...]` folder, which keeps a full history.

### Restore

Right-click a `.BAK` file and choose **Restore File**. The `.BAK` extension is removed and the file is renamed back to its original name **in the same folder**. Move the `.BAK` file out of the `BACKUPS` folder first if you want the restored copy elsewhere.

Because the script uses `rename`, a file that already has the original name will block the restore. Delete or move the current file first.

## Uninstall

Remove the context-menu entries (no files are deleted):

```bat
reg delete "HKEY_CLASSES_ROOT\*\shell\Backup File" /f
reg delete "HKEY_CLASSES_ROOT\*\shell\Restore File" /f
```

Then delete `C:\src\BackupFiles` and any `BACKUPS` folders you no longer need.

## What the installer registers

| Registry key | Purpose |
| --- | --- |
| `HKEY_CLASSES_ROOT\*\shell\Backup File` | Adds **Backup File** to the context menu for every file type. |
| `...\Backup File\AppliesTo` | `NOT System.FileName:"*.bak"` — hides the entry for `.BAK` files. |
| `HKEY_CLASSES_ROOT\*\shell\Backup File\command` | Runs `C:\src\BackupFiles\Backup.bat "%1"`. |
| `HKEY_CLASSES_ROOT\*\shell\Restore File` | Adds **Restore File** to the context menu. |
| `...\Restore File\AppliesTo` | `System.FileName:"*.bak"` — shows the entry only for `.BAK` files. |
| `HKEY_CLASSES_ROOT\*\shell\Restore File\command` | Runs `C:\src\BackupFiles\Restore.bat "%1"`. |

## Project layout

| Path | Description |
| --- | --- |
| `Backup Regedit.reg` | Registry installer for the two context-menu entries (UTF-16LE). |
| `BackupFiles\Backup.bat` | Copies the selected file into a timestamped `BACKUPS` folder. |
| `BackupFiles\Restore.bat` | Renames a `.BAK` file back to its original name. |

## Known limitations

- The registry entries point at the fixed path `C:\src\BackupFiles`, so the `BackupFiles` folder has to be copied there.
- Backup timestamps are locale-dependent because they are built from `%date%` and `%time%`.
- The `BACKUPS` folder is created relative to the working directory while the copy target is resolved from the selected file's own folder. Launched from Explorer these normally match; launching the script by hand from another directory can create the folder in the wrong place.
- Failures are silent — there is no confirmation dialog and no log file. Check the `BACKUPS` folder after the first run.

## Contributing

Small, focused changes are welcome. Please keep the batch scripts compatible with plain `cmd.exe` (no PowerShell required) and test both the backup and the restore path before opening a pull request.

## License

[MIT](LICENSE) © 2026 omar-devloop
