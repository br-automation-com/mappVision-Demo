## Table of Contents
* [Introduction](#Introduction)
* [Requirements](#Requirements)
* [Revision History](#Revision-History)

<a name="Introduction"></a>
## Introduction
This is a demo application for B&R vision camera. For a detailed description see this [**documentation**](Logical/Documentation/Vision%20Demo%20Application.pdf). Download the latest release from [**here.**](../../releases)

**Note:** For better alignment between the index number and IO names most arrays start at index 1 (not 0). This can cause issues with C Task since these tasks do not support arrays starting at index 1. Most arrays can be redefined starting with 0 without any issues from a code perspective but it will cause an empty line in the mappView result tables.

![](Logical/Documentation/screenshot.png)

<a name="Requirements"></a>
## Requirements
* Automation Studio 4.7
* mappView 5.10.1
* mappVision 5.10.1
* Automation Runtime A4.73

Recommended task class is #8 with a 10ms cycle time.	

<a name="Revision-History"></a>
## Revision History

#### Version 2.1
- First public release
