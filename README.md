# Goestools for Windows
Goestools port for Windows. Originally by Pieter Noordhuis; ported to Windows by Jamie Vital. For goestools documentation, see the original docs [here](https://pietern.github.io/goestools/commands.html).

**Video Demo:** [https://www.youtube.com/watch?v=pOpxVbBFl3Y](https://www.youtube.com/watch?v=pOpxVbBFl3Y)

![image](https://github.com/JVital2013/goestools-win/assets/24253715/6436a7ef-8612-4594-8d25-f391ec095517)

## Running the programs
Once you have a dish, amplifier, and SDR set up, Download the lastest build from [releases](https://github.com/JVital2013/goestools-win/releases). Then, extract the zip and start goesrecv, followed by goesproc.

**NOTE:** if you are receiving GOES, download the release named goestools-win\*. The release named gk2a-goesrecv-win\* is a build of goesrecv for the GK-2A satellite only, and will not work with GOES satellites.

### System Requirements
- Windows Vista or newer
- Microsoft Visual C++ Redistributable. You probably have it already, but if not you can get it [here](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist).
- An RTL-SDR or AirSpy SDR with driver installed
- Proper dish and amplifier for LRIT/HRIT reception

### Tools verified to work:
- goesrecv
- goesproc
- goeslrit
- lritdump
- areadump
- goespackets
- packetdump
- packetinfo
- benchmark
- compute_sync_words
- goesemwin - GOES-N EMWIN only. Built and verified operation for completeness.
- dcsdump - Old DCS lrit files only. New ones don't work on Linux either.
- unzip - Can extract zips with a single file in it, like the data section of NWS/EMWIN lrit image files. For debugging purposes.

## Troubleshooting
Having issues running Goestools for Windows? Here are some troubleshooting tips:
1. **Double-check that your Visual C++ Redistributable is up-to-date**
2. **If you're using a RTL-SDR**, make sure the correct driver is installed. Use [Zadig](https://zadig.akeo.ie/) and install the latest WinUSB driver.
3. **Make sure your antivirus did not delete or block any program files.**
    - There should be 35 files in your goestools `bin` folder - if there's less than that, look to see what's missing.
    - To verify the safety of all program files, run them through a reputable virus scanner like https://www.virustotal.com/.
4. **Verify that Windows Firewall has not blocked goestools:** When you run goesrecv for the first time, Windows Firewall should prompt you to allow access - make sure you select "yes". If you don't get the prompt, or if you close out of it, you may need to add a firewall exception manually.
5. **Still having issues?** [Open an issue](https://github.com/JVital2013/goestools-win/issues) or [start a discussion](https://github.com/JVital2013/goestools-win/discussions)!

## Compiling from source
For most users, I recommend using one of the pre-compiled releases. If you choose to compile from source: may the odds be ever in your favor.

### Configure Visual Studio
Install Visual Studio Community 2022 or greater. On install, set it up for "Desktop development with C++." Make sure "Git for Windows" gets installed as well.

![image](https://github.com/JVital2013/goestools-win/assets/24253715/396cc01e-f35d-46ca-b2b4-e240170068de)

### Configure vcpkg and build
Goestools for Windows comes with PowerShell scripts to set up vcpkg and build the software.

1. Open "Developer PowerShell for VS 2022" from the start Menu

    ![image](https://github.com/JVital2013/goestools-win/assets/24253715/ef7af001-c45e-4ee7-88e6-d9bb33d6a5fe)

2. Clone goestools-win somewhere on your computer via `git clone --recursive https://github.com/JVital2013/goestools-win`
3. Run Configure-VCPKG.ps1 in this repo to install and configure vcpkg.
4. If everything succeded, run Build.ps1 in this repo
5. Your compiled code will be in \<goestools-win\>\build\dist

## About Pull Requests
In an attempt to keep this goestools fork compatible with the official Goestools for Linux repo, I will only accept pull requests and bug reports for Windows-specific issues. If you want to add a feature, open a PR on the official branch, then let me know about it. I may merge PRs from the official repo as requested.

## Changes and Credits
Of course, a huge thanks to @pietern for the original goestools software. All I did was swap out parts to make it work on Windows, so all credit for this program should go to him.

This port was forked from goestools at 865e5c7. I made several (hundred?) code changes to facilitate compilation on Windows, but the core of the code has remained unchanged. The following additional patches have also been applied: 

- [Differentiate between DSI-CAPE and DSI-LI](https://github.com/pietern/goestools/pull/163) by @JVital2013
- [Update to support proj >= 8](https://github.com/pietern/goestools/pull/148) by @jim-minter
- [Fix getting admin text messages](https://github.com/pietern/goestools/pull/105) by @spinomaly
- [Added config option for EMWIN handler to disable output of TXT files](https://github.com/pietern/goestools/pull/79) by @tmbates12
- On the GK-2A build, I copied the sample rates for LRIT/HRIT from @sam210723's [fork of goestools](https://github.com/sam210723/goestools). My build is not the same as Sam's - there are additional changes he made that did not make it into the Windows build, but I do not believe they are necessary for successful use.

Additionally, thanks to @Aang23 for keeping his custom vcpkg public so I could see how to compile software like this.

## License
Goestools for Windows is licensed under the "BSD 2-Clause 'Simplified' License." License for goestools, and for all bundled libraries, are in the LICENSES folder.
