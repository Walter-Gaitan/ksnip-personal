# ksnip (personal build)

A personal Windows build of [ksnip](https://github.com/ksnip/ksnip), a screenshot tool with a tabbed editor, used as a free PicPick replacement.

## Portable version

This build is fully portable: nothing is installed and nothing is written to the Windows registry.

- **The whole program is the `app` folder** (about 34 MB) that `build.cmd` produces. Copy it to a USB drive, OneDrive, or another PC and run `ksnip.exe`.
- **Settings travel with it.** They are saved in `app\ksnip\ksnip.ini`, next to `ksnip.exe`. The file appears the first time a setting is saved.
- **No prerequisites on the other PC.** The Qt and Visual C++ runtime DLLs are inside the folder.
- **Start with Windows** (optional): press Win+R, type `shell:startup`, and put a shortcut to `ksnip.exe` there.
- **Imgur upload** would also need the OpenSSL DLLs, which aren't included. Capture, edit, save and copy all work without them.

The `app` folder isn't stored in git (it's build output). Build it with `build.cmd`, or download it from this repo's Releases if one has been published.

## What's different from upstream ksnip

| Change | Where |
|---|---|
| Selection capture is **Ctrl+Alt+S** | `ksnip/src/backend/config/Config.cpp` |
| Full screen **Ctrl+PrintScreen**, active window **Alt+PrintScreen**, last region **Shift+PrintScreen** | `ksnip/src/backend/config/Config.cpp` |
| Starts hidden in the tray | `ksnip/src/backend/config/Config.cpp` |
| Portable: settings saved to `ksnip\ksnip.ini` next to `ksnip.exe` instead of the registry | `ksnip/src/main.cpp` |
| Yellow highlight box is the default tool | `kImageAnnotator/src/backend/Config.cpp` |
| Editor shortcuts: **H** highlight box, **N** number, **A** arrow (Text Arrow moved to J) | `kImageAnnotator/src/widgets/ToolPicker.cpp` |

## Build (Windows)

Needs Visual Studio 2022 Build Tools (C++ workload), Python, and:

```powershell
python -m pip install --user aqtinstall cmake ninja
python -m aqt install-qt windows desktop 5.15.2 win64_msvc2019_64 --outputdir C:\Qt
```

Then run `build.cmd` (full build) or `build.cmd ksnip` (only ksnip, after changing its code).
The portable app ends up in `app\`; copy that folder anywhere and run `ksnip.exe`.

## Upstream versions this is based on

| Folder | Upstream | Commit |
|---|---|---|
| ksnip | https://github.com/ksnip/ksnip | `059f022` |
| kImageAnnotator | https://github.com/ksnip/kImageAnnotator | `ba5692e` |
| kColorPicker | https://github.com/ksnip/kColorPicker | `2781a26` |

## License

ksnip, kImageAnnotator and kColorPicker are GPL/LGPL licensed; see the `LICENSE` file in each folder. This repository keeps the same licenses.
