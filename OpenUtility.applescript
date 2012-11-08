#!/usr/bin/osascript
-- Guru Inamdar Copyright 2012.
-- The script provided as-is, use at your own risk
(*
README 

*)
-- Make sure
tell application "Xcode"
	tell active workspace document
		set firstProject to (get first project)
		set projectID to (get id of firstProject)
		--set orgName to (get organization name of firstProject)
		--set projDir to (get project directory of firstProject)
		
		-- activate tab bar to find file name
		tell application "Xcode"
			activate
			set myFileName to (get name of window 1)
			tell application "System Events"
				tell application process "Xcode"
					try
					-- If its storyboad or xib open Inspector
						if myFileName contains ".storyboard" OR myFileName contains ".xib" then
							tell menu bar 1
								tell menu bar item "View"
									tell menu "View"
										tell menu item "Utilities"
											tell menu "Utilities"
												click menu item "Show Identity Inspector"
											end tell
										end tell
									end tell
								end tell
							end tell
						end if
						
					end try
				end tell
			end tell
		end tell
	end tell
end tell