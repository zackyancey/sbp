# SBP - Simple Bash Prompt
[![Build Status](https://travis-ci.org/brujoand/sbp.svg?branch=master)](https://travis-ci.org/brujoand/sbp)

Simple Bash Prompt (SBP) is a bash prompt, which strives to be simple. But it isn't. But it looks kind of nice. I think. 
This started out as a pure ripoff from powerline-shell, which is great, but written in python.
SBP is all bash, which makes it fast and fun.

I've tried makeing the code as readable and extendable as possible. 
If something seems wrong, lacking or bad in some way; feel free to rant, review and create a pull request.

![Screenshot](https://raw.githubusercontent.com/brujoand/sbp/master/resources/timer.png)

## Requirements
If you want the fancy pointy segment seperators, you need the powerline fonts _installed_ and _enabled_. Both.
You can get them [here](https://github.com/powerline/fonts).
Then run the install.sh script. Now the hard_to_remember part. Change the settings of your terminal emulator. 
Something like "Settings" and then "Fonts" will probably be the right place.
All done? 
Great :)

## Installing
There is an install script, you could use that. It will copy the settings.default to ~/.sbp, and it will ask you
to set the ```sbp_path``` variable to point to the install location and to source the sbp.bash file. So you could just do that.
Or run the install script. Up to you. It's nothing fancy.

## Usage
So you're ready to go. Now you do nothing. Just use it. But you could. If you want. Change stuff up a bit.
If all is well you can use the ```sbp``` command:
```
Usage: sbp <command>

Commands:
segments  - List all available segments
hooks     - List all available hooks
colors    - List all defined colors
powerline - Toggle the use of powerline fonts
reload    - Reload SBP and user settings
```

## Features
### Segments
- Host; shows the username and maybe host depending on your settings
- Path; shows the path
- Git; shows the git branch and status
- Filler; fills the space between the left and right part of the prompt, if you like that kind of thing
- Command; shows the time spent on the last command, and turns red if it failed 
- Timestamp; shows a timestamp

### Hooks
- Alert; will trigger an alert if the previous command took more than some value you specified in the settings
- Timer; will time the previous command

## Contribute
I would love to have some more shiny segments.

## FAQ
Can I not use powerline fonts?
  - Yes, just run ```sbp powerline``` to toggle the use of powerline fonts.

![Screenshot](https://raw.githubusercontent.com/brujoand/sbp/master/resources/powerline-toggle.png)
