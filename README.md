# Goestools for Windows
Goestools port for Windows. For documentation, see the original Linux documentation [here](https://pietern.github.io/goestools/commands.html).

## Running the programs
Once you have a dish, amplifier, and SDR set up, Download the lastest build from [releases](/releases). Then, extract the zip and start goesrecv, followed by goesproc.

### System Requirements
- Windows Vista or newer, 64-bit (Windows 10 or newer recommended).
- Microsoft Visual C++ Redistributable 64-bit. You probably have it already, but if not you can get it [here](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist). The 2022 redistributable is recommended, but it will run with the 2019 version as well.
- An RTL-SDR or AirSpy SDR with driver installed
- Proper dish and amplifier for LRIT/HRIT reception

### Tools verified to work:
- goesrecv
- goesproc
- goeslrit
- lritdump
- areadump
- goespackets
- packetinfo
- benchmark
- compute_sync_words
- goesemwin - GOES-N EMWIN only. Built and verified operation for completeness.
- dcsdump - Old DCS lrit files only. New ones don't work on Linux either.
- unzip - Can extract zips with a single file in it, like the data section of NWS/EMWIN lrit image files. For debugging purposes.

### Untested
- goesrecv (with an AirSpy). I'd love to get confirmation if this works!
- goesproc (with GOES-N series data). Goesproc has been validated against GOES-R series data only
- packetdump - takes LRIT packets into STDIN and does some analysis. Let me know if you use this, and it works for you.

## Compiling from source
May the odds be ever in your favor

### Configure Visual Studio
Install Visual Studio Community 2022 or greater. On install, set it up for "Desktop development with C++." Make sure "Git for Windows" gets installed as well.

### Configure vcpkg and build
Goestools for Windows comes with PowerShell scripts to set up vcpkg and build. vcpkg must be installed at C:\vcpkg, but don't worry - we'll take care of that for you.

1. Clone goestools-win somewhere on you from your start menu
3. Run Configure-VCPKG.ps1 in this repo to install and configure vcpkg at C:\vcpkg.
4. If everything succeded, run Build.ps1 in this repo
5. Your compiled code will be in <goestools-win>\build\dist

## About Pull Requests
In an attempt to keep this goestools fork compatible with the official Goestools for Linux repo, I will only accept pull requests and bug reports for Windows-specific issues. If you want to add a feature, open a PR on the official branch, then let me know about it. I will merge PRs from the official repo as requested, even if it has not been accepted in the official repo.

## License
Goestools for Windows is licensed under the "BSD 2-Clause 'Simplified' License." License for goestools, and for all bundled libraries, are in the LICENSES folder.