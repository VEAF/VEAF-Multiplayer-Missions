
## How to use this ?

### Prerequisites


#### Manual installation

You need a few things set up on your PC for these scripts to function.

- LUA : you need a working LUA interpreter, in your PATH, ready to be called with the `lua` command
- 7zip : you need 7zip, or another zip tool, in your PATH, ready to be called with the `7zip` command
- Powershell : you need Powershell, and you need it to be configured to allow script execution (read [this article](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.1)) ; basically you need to run this command in an elevated (admin) Powershell prompt : `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine`
- npm : you need the NPM package manager from NodeJS to get the VEAF mission creation tools ; see [here](https://www.npmjs.com/get-npm)

#### Using Chocolatey

The required tools can easily be installed using *Chocolatey* (see [here](https://chocolatey.org/)).

**WARNING** : do not do both *manual installation* and *Chocolatey installation*

To install Chocolatey, use this command  in an elevated (admin) Powershell prompt : `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

After *Chocolatey* is installed, use these simple commands (in a regular command prompt) to install the required tools :

- LUA : `choco install -y lua`
- 7zip : `choco install -y 7zip.commandline`
- npm : `choco install -y nodejs`

### Choose a starting mission

You must start with a DCS mission file as the basis of your VEAF scripted mission.

We provided a blank canvas for Caucasus (`empty-caucasus.miz`), Syria (`empty-syria.miz`) and Persian Gulf (`empty-persiangulf.miz`)

Copy the mission of your choice in the root of this folder, and name it `template.miz`.

### Run the init.cmd script

In a command shell, simply type `init.cmd` with the name of the mission you want to build (no space, no underscore, please).

The name of the mission will be the name of your project. It should also be the same name as your mission folder (not mandatory, but recommended).

It should not contain any space or underscore, and no trailing .miz (it's not a mission file name) !

#### Example

Let's say I want to initialize a new mission called "My cool and shiny mission - Caucasus".

I'll start with replacing spaces with dashes : "My-cool-and-shiny-mission-Caucasus". I'll make a fresh copy of this `VEAF-mission-directory-template` folder and name it `My-cool-and-shiny-mission-Caucasus` (we'll refer to this as "mission folder").

As I want to create a mission in Caucasus, and I have no existing mission, I'll copy the `empty-caucasus.miz` to `template.miz` in my mission folder.

Then I'll start a command prompt, `cd` into the mission folder, and run : `init.cmd My-cool-and-shiny-mission-Caucasus`


The script will take `template.miz` (which I copied from `empty-caucasus.miz`) as its basis, and prepare the folder with everything needed to compile the mission.

### Advanced settings

#### Selecting a specific template mission file

By default, the script looks for a `template.miz` file and uses it as the basis for the new mission.

It's possible to specifiy a specific file as the template ; for example : `init.cmd My-cool-and-shiny-mission-Caucasus empty-caucasus.miz`

#### Setting the logging level of the trigger injector

By setting a value to the `LUA_SCRIPTS_DEBUG_PARAMETER` variable, it is possible to tune the logging level of the trigger injector LUA program.

Possible values are :

- `-debug` : debug level, additional information
- `-trace` : trace level, everything is written

This is useful to understand why a specific run does not work

#### Setting the location of the 7zip executable

If your 7zip tool is not in your path, you can set its location in the `SEVENZIP` variable. It's a string which should point to the 7za executable (e.g. `c:\tools\7zip\bin\7zip.exe`)

#### Setting the location of the LUA executable

In the same way, you can set its location of the LUA executable in the `LUA` variable. It's a string which should point to the LUA executable (e.g. `c:\tools\lua\bin\lua.exe`)

#### Skip the pauses

If you set the `NOPAUSE` variable to "true", then the pauses in the script will not be marked.

## How to use this - graphic version

### Initialize a new Mission Folder with this tool

![schema](https://user-images.githubusercontent.com/172286/109006666-9a96ee80-76ab-11eb-871c-a77a1ffa4fd9.jpg)

### Use an initialized Mission Folder

![schema](https://user-images.githubusercontent.com/172286/109007616-9ddeaa00-76ac-11eb-89ba-370e16810240.jpg)

