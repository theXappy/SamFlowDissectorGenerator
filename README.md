# SamFlowDissectorGenerator
Generates a wireshark dissector (in Lua) for the Sаmsung Flow protocol.

## Compilation
1. Clone
2. Open .sln file in VisualStudio (2019 Community recommended)
3. Restore NuGet Packages
4. Build
5. Locate SamFlowDissectorGenerator.exe in either bin\Debug or bin\Release

## Usage:
```
Usage: SamFlowDissectorGenerator.exe <sam_flow_framework_net_dll_path>
```
Where sam_flow_framework_net_dll_path should point to SаmsungFlowFramework.NET.dll

When the program finishes it opens the dissector, saved to the %TEMP%, in the default .lua editor.

To use the dissector save the .lua file to:
```
C:\Program Files\Wireshark\plugins\3.2\epan\flow.lua
```
.lua extension is a must.

The version folder on your machine might be different (not 3.2).