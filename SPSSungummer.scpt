(*
the purpose of this script is to deal with issues of SPSS 22 causing hair-pulling delays with MacOS 10.9.x+
:: Created by Daniel James June 1, 2015 at 2:08:45 PM CDT For the College of Applied Health Sciences :: 

Based off the help files located here: http://www-01.ibm.com/support/docview.wss?uid=swg21651225

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++ University of Illinois, Urbana-Champaign ++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*)

display dialog "This is going to fix the preferences on SPSS 22 on your Mac (hopefully). This is for Mac users losing their minds because SPSS is so utterly slow." with icon note buttons {"Proceed.", "Let's Not Do This."} default button 1 cancel button 2


try
	tell application "SPSSstatistics" to quit
end try


display dialog "Please give me the account name of the user whose SPSS settings we need to clear out." default answer "stevejobs"

-- here I define variables we use later
set punter to text returned of result -- because this is the punter we are looking at

set piker to "/users/" & punter

set pittedDate to do shell script "date '+%Y%m%d'"
-- this is a variable that puts todays date in an ASCII friendly way
-- such as 20140812




try
	do shell script "chflags nohidden " & piker & "/Library" with administrator privileges
on error
	display dialog "Looking for the Library folder for the new user: " & punter & ". That doesn't appear to be where it should be.  Double check, please."
end try

(*

- PLEASE NOTE: If you are using Mac OSX Mavericks 10.9.x, you will additionally need to kill the process that protects this file and restores it (it will be deleted):

Since OSX 10.9.x Mavericks a cached copy of your .plist file is stored using a background process: CFPREFSD
Even after deleting the above .plist file, restarting SPSS Statistics will not create a new copy of these file, 
but rather, Mavericks will restore the cached copy it has stored. 
Only by stopping the "cfprefsd" process and starting SPSS Statistics, will generate a new .plist preference file
and therefore a default toolbar will be back.

When you go to Finder - Applications - Utilities and open Activity Monitor on the 10.9.x computer you should see there is a CFPREFSD process visible for root user and for the current logged in user.
You need to kill the CFPREFSD process for the current user. this can only be done via Terminal application by running the command below:

*)

-- Killing CFPREFSD

try
	do shell script "killall -u" & space & punter & space & "cfprefsd" with administrator privileges
end try

-- The Plist must die
try
	do shell script "rm -fR" & space & piker & "/Library/Preferences/com.ibm.spss.plist" with administrator privileges
end try


-- ++++++++++++++++++++++++++++++++++++++++++++++++++
--- Lastly we'll properly hide the Library files again as should be
-- ++++++++++++++++++++++++++++++++++++++++++++++++++


try
	do shell script "chflags hidden" & space & piker & "/Library" with administrator privileges
end try


delay 1

display dialog "Done.  Try and start SPSS again and let's see if this works."

(*

set reRun to true
set reSpawn to "osascript -e 'tell app " & quote & "loginwindow" & quote & " to «event aevtrrst»'"

display dialog "Done.  Restart your Mac and restart Lync, and that will hopefully do it." with icon note buttons {"Restart Now.", "D'oh. Too Busy. Let's Do It Later."}
if result = {button returned:"Restart Now."} then
	try
		do shell script reSpawn with administrator privileges
	end try
else if result = {button returned:"D'oh. Too Busy. Let's Do It Later."} then
	display dialog "OK. Restart at your own leisure, but Lync won't work until you do." giving up after 3 with icon note buttons {"Okay.", "Super Okay."}
end if

*)
