# Xcode Plugin to Automatically Show/Hide Utilities

## Overview

This plugin help you save some keyboard shortcuts or mouse events by automatically showing you Utilities area when needed especially while you are working on MacBooks with smaller screen size. This plugin will open-up the Utilities (File Inspector) everytime you open the storyboad or xib file, and hide it if you open any other file including .m/.h/.plist etc. If you refer to QuickHelp Inspector under utilities while writing code (.m/.h), you may want to install Dash by Kapeli and this https://github.com/omz/Dash-Plugin-for-Xcode.

The only reason this plugin was written because my tardiness to find "Option + Command + 0" on my mac keyboard.

## Installation

Build the Xcode project and restart Xcode. The plugin will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. To uninstall, just remove the plugin from there (and restart Xcode).

This is tested on OS X 10.8.2 with Xcode 4.5.2

## License

    Copyright (c) 2012, Guru Inamdar
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.