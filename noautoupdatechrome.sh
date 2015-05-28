#!/bin/sh
#output to log
exec >> "/Library/Logs/Getty Script.log" 2>&1 

# Check to see if the uninstall bundle is present in Library. If it is, run it.
uninstaller1="/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/ksinstall"
    if [ -e "$uninstaller1" ]
    then $uninstaller1 --uninstall
    wait
    if [ -s "/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle" ]
    then rm -Rf /Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle
    cp -R /private/tmp/GoogleSoftwareUpdate.bundle /Library/Google/GoogleSoftwareUpdate/
    else
    echo "ksinstall not found in Library."
    fi
    fi

#If plist exists in Library, write defaults to 0
    if [ -e "/Library/Preferences/com.google.Keystone.Agent.plist" ]
    then defaults write /Library/Preferences/com.google.Keystone.Agent checkInterval 0
    else echo "No plist in Library."
    fi

# For each user on the machine other than shared, check to see if the uninstall bundle is present in ~/Library. If it is, run it. Copy Empty GoogleSoftwareUpdate.bundle to the Google folder.

for USER_HOME in /Users/*
    do
    USER_UID=`basename "${USER_HOME}"`
        if [ ! "${USER_UID}" = "Shared" ]
        then
            if [ -e "/Users/"${USER_UID}"/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/ksinstall" ]
            then /Users/"${USER_UID}"/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle/Contents/Resources/ksinstall --uninstall
            if [ -s "/Users/"${USER_UID}"/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle" ]
            then rm -Rf /Users/"${USER_UID}"/Library/Google/GoogleSoftwareUpdate/GoogleSoftwareUpdate.bundle
            cp -R /private/tmp/GoogleSoftwareUpdate.bundle /Users/"${USER_UID}"/Library/Google/GoogleSoftwareUpdate/
            else
            echo "ksinstall not found in User/Library."
            fi

        # Set the checkinterval to 0.
        #If plist exists in ~/Library, write defaults to 0
            if [ -e "/Users/"${USER_UID}"/Library/Preferences/com.google.Keystone.Agent.plist" ]
            then defaults write /Users/"${USER_UID}"/Library/Preferences/com.google.Keystone.Agent checkInterval 0
            else echo "No plist in User/Library."
            fi
        fi
        fi

done

echo "Unannounced automatic updates that can't be easily opted out are evil."
echo "********** $0 Completed" `date "+%A %m/%d/%Y %H:%M"`" **********"

exit 0