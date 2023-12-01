# Keep-Active Script

## Introduction

The "keep-active" script is a simple Bash utility designed to simulate mouse movements to keep your Linux system active. This script helps prevent the system from going into sleep mode or appearing inactive, especially useful during long periods of inactivity.

## Dependencies

- `xprintidle`: Tool for fetching the user's idle time.
- `xdotool`: Command-line X11 automation tool.

These dependencies are not typically pre-installed on most Linux distributions. You will need to install them manually.

## Installation

To use the "keep-active" script, first ensure that you have the necessary dependencies installed on your system.

On Debian-based systems (like Ubuntu), you can install them using:

```bash
sudo apt-get install xprintidle xdotool
```
