## Table of Contents
* [Introduction](#Introduction)
* [Features](#Features)
* [Requirements](#Requirements)
* [Revision History](#Revision-History)

<a name="Introduction"></a>
## Introduction
This is a demo application for B&R vision camera. It is developed and maintained by vision enthusiasts and is not and official B&R product. For a detailed description see this [**documentation**](Logical/Documentation/Vision%20Demo%20Application.pdf). 

**Note:** For better alignment between the index number and IO names most arrays start at index 1 (not 0). This can cause issues with C Task since these tasks do not support arrays starting at index 1. Most arrays can be redefined starting with 0 without any issues from a code perspective but it will cause an empty line in the mappView result tables.

**Note:** All tasks starting with Vi_... should not be changed because it makes updating more difficult. All Vi_... tasks use a global interface structure to interact with the outside world. All additional code and configuration should only be done in "YourTask" and "VisionVariables.var". 

![](Logical/Documentation/screenshot.png)

<a name="Features"></a>
## Features
This vision sample contains a lot of functions that are not included in the mappVision HMI (Vision cockpit). These include:
- Easy-to-use mappView visualization
- All IO data points of the camera are connected to the visualization
- Image archive to save the images
- Simultaneous use of several cameras in one visualization
- Use of the nettime function together with axes
- Integration of Lightbar and Backlight

<a name="Requirements"></a>
## Requirements (current used versions)
Should also work with newer and some older versions
* Automation Studio 4.12
* mapp 5.26
* Automation Runtime I4.93

Recommended task class is #8 with a 10ms cycle time. For the nettime and axis tasks use #1

<a name="Revision-History"></a>
## Revision History
You can find details in the project in "revision.txt"

#### Version 5.26 
- Update to mappVision 4.26 
- Changed image request to official function block 
- Removed recipe management 
- Removed color detection 
- Removed optic details 
- Removed VC4 support 
- Removed TCP proxy task 
- Removed function to load VA applications 
- Removed function to download images

#### Version 5.24
- Update to AS 4.12
- Update to mapp 4.24
- Fixed image download node number is not correct
- Removed old routing files
- Changed image update interval to 500ms

#### Version 5.15
- Update recipe managment to V1.0
- Updated constant for code reader parameter "ParameterMode"
- Fix ViColor
- Make it possible to change connections
- Updated to official 5.15 versions and official lightbar upgrade
- Vi_Optics added

#### Version 2.3
 - Added RouteInfo_Tool.ps1
 - Added color detection first version
 - Split up main task into main and visu, integrated light task into main and visu
 - Added functionality to rotate the image on the main page
 - Click on the image on the main page toggles now the text position (crosshair-details) from left to right
 - CodeReader and OCR Text will be shown on the main page and saved in SVG file
 - Added proxy task to eliminate routing batch file
 - Added Pixel Counter hardware and code
 
#### Version 2.2
- Added new functionality to show images in every size on the web viewer widget on the main page
- Improved repetitive mode
- SVG files save now all information. It is possible to click on the crosshairs to show the details
- Added diagnostic data creation
- Updated recipe management
- Changed public arrays start index to 0 to avoid issues with C task
- Added a VC4 visualization
- Added functionality to show the image on the VC4 visualization (documentation still missing)
- After boot the first found light will be selected
- Some additional improvements, code optimizations & bug fixes

#### Version 2.1
- First public release
