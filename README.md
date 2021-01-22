## Table of Contents
* [Introduction](#Introduction)
* [Requirements](#Requirements)
* [Revision History](#Revision-History)

<a name="Introduction"></a>
## Introduction
This is a demo application for B&R vision camera. It is devloped and maintained by vision enthusiasts and is not and official B&R product. For a detailed description see this [**documentation**](Logical/Documentation/Vision%20Demo%20Application.pdf). 

**Note:** For better alignment between the index number and IO names most arrays start at index 1 (not 0). This can cause issues with C Task since these tasks do not support arrays starting at index 1. Most arrays can be redefined starting with 0 without any issues from a code perspective but it will cause an empty line in the mappView result tables.

![](Logical/Documentation/screenshot.png)

<a name="Requirements"></a>
## Requirements (current used versions)
Should also work with newer and some older versions
* Automation Studio 4.9
* mapp 5.13
* Automation Runtime C4.90

Recommended task class is #8 with a 10ms cycle time. For the nettime and axis tasks use #1

<a name="Revision-History"></a>
## Revision History
You can find details in the project in "revision.txt"

#### Version 2.3
 - Added RouteInfo_Tool.ps1
 - Added color detection first version
 - Split up main task into main and visu, integrated light task into main and visu
 - Added funkctionality to rotate the image on the main page
 - Click on the image on the main page toggles now the textposition (crosshair-details) from left to right
 - CodeReader and OCR Text will be shown on the main page and saved in SVG file
 - Added proxy task to eliminate routing batch file
 - Added Pixel Counter hardware and code
 
#### Version 2.2
- Added new functionality to show images in every size on the webviewer widget on the mainpage
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
