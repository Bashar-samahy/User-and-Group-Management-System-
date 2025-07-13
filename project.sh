#!/bin/bash

# Functions for message boxes
function errorMSG() {
    whiptail --title "Error" --msgbox "$1" 10 60
}

function infoMSG() {
    whiptail --title "Info" --msgbox "$1" 10 60
}

# Main window
while true; do
    CHOICE=$(whiptail --title "User Management System" --menu "Choose an option" 25 78 16 \
        "1) Add User" "Add user to the system." \
        "2) Modify User" "Modify an existing user." \
        "3) List Users" "List all users on the system" \
        "4) Delete User" "Delete a User from the system." \
        "5) Add Group" "Add a user group to the system." \
        "6) Modify Group" "Modify a group and its list of members." \
        "7) List Groups" "List all groups on the system." \
        "8) Delete Group" "Delete a group from the system." \
        "9) Enable User" "Unlock a user account." \
        "10) Disable User" "Lock a user account." \
        "11) Change Password" "Change Password of a user account." \
        "12) About" "Show information about this program." \
        "13) Exit" "Close this program." \
        3>&1 1>&2 2>&3)
    
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "You chose: $CHOICE"
    else
        echo "You chose Cancel."
        break
    fi
    
    case "$CHOICE" in
        "1) Add User")
            # Add User
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            USERNAME=$(whiptail --inputbox "Enter the user name" 8 39 --title "Add User" 3>&1 1>&2 2>&3)
            
            # Check if username is empty
            if [[ -z "$USERNAME" ]]; then
                errorMSG "Username cannot be empty. Enter a valid username" 
                continue
            fi

            # Check if user already exists
            if id "$USERNAME" &>/dev/null; then
                errorMSG "User $USERNAME already exists. Enter another" 
                continue
            fi

            # Create the user
            useradd "$USERNAME"
            infoMSG "User $USERNAME created successfully" 
            ;;
            
        "2) Modify User")
            # Modify user
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi
            USERNAME=$(whiptail --inputbox "Enter the user name" 8 39 --title "Modify User" 3>&1 1>&2 2>&3)

            # Check if username is empty
            if [[ -z "$USERNAME" ]]; then
                errorMSG "Username cannot be empty. Enter a valid username"
                continue
            fi

            # Check if user does not exists
            if ! id "$USERNAME" &>/dev/null; then
                errorMSG "User $USERNAME does not exists. Enter a valid username" 
                continue
            fi

            while true; do
                action=$(whiptail --title "Modify User: $USERNAME" --menu "Select what you want to modify:" 20 60 10 \
                    "Full Name" "Change the user's full name (GECOS field)" \
                    "Shell" "Change the user's login shell" \
                    "Group" "Add user to an additional group" \
                    "Exit" "Return to main menu or quit" 3>&1 1>&2 2>&3)

                case "$action" in
                    "Full Name")
                        fullname=$(whiptail --inputbox "Enter new full name for $USERNAME:" 10 60 --title "Modify Full Name" 3>&1 1>&2 2>&3)
                        usermod -c "$fullname" "$USERNAME" 
                        infoMSG "Full name updated for $USERNAME." 
                        ;;
                    "Shell")
                        shell=$(whiptail --inputbox "Enter new shell for $USERNAME [/bin/bash]:" 10 60 --title "Modify Shell" 3>&1 1>&2 2>&3)
                        shell=${shell:-/bin/bash}
                        usermod -s "$shell" "$USERNAME" 
                        infoMSG "Shell updated for $USERNAME." 
                        ;;
                    "Group")
                        group=$(whiptail --inputbox "Enter the group to add '$USERNAME' to:" 10 60 --title "Add to Group" 3>&1 1>&2 2>&3)
                        if grep -q "^$group:" /etc/group; then
                            usermod -aG "$group" "$USERNAME" 
                            infoMSG "User '$USERNAME' added to the group '$group'."
                        else
                            errorMSG "Group '$group' does not exist."
                        fi
                        ;;
                    "Exit")
                        break
                        ;;
                    *)
                        errorMSG "Invalid selection."
                        ;;
                esac
            done
            ;;
            
        "3) List Users")
            # List Users
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            # List all users
            users=$(cut -d: -f1 /etc/passwd)
            whiptail --title "List of Users" --msgbox "$users" 20 60
            ;;
            
        "4) Delete User")
            # Delete User
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            USERNAME=$(whiptail --inputbox "Enter the user name to delete" 8 39 --title "Delete User" 3>&1 1>&2 2>&3)

            # Check if username is empty
            if [[ -z "$USERNAME" ]]; then
                errorMSG "Username cannot be empty. Enter a valid username" 
                continue
            fi

            # Check if user does not exists
            if ! id "$USERNAME" &>/dev/null; then
                errorMSG "User $USERNAME does not exists. Enter a valid username" 
                continue
            fi

            # Delete the user
            userdel "$USERNAME"
            infoMSG "User $USERNAME deleted successfully"
            ;;
            
        "5) Add Group")
            # Add Group
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            GROUPNAME=$(whiptail --inputbox "Enter the group name" 8 39 --title "Add Group" 3>&1 1>&2 2>&3)

            # Check if group name is empty
            if [[ -z "$GROUPNAME" ]]; then
                errorMSG "Group name cannot be empty. Enter a valid group name" 
                continue
            fi

            # Check if group already exists
            if getent group "$GROUPNAME" >/dev/null; then
                errorMSG "Group $GROUPNAME already exists. Enter another" 
                continue
            fi

            # Create the group
            groupadd "$GROUPNAME"
            infoMSG "Group $GROUPNAME created successfully"
            ;;
            
        "6) Modify Group")
            # Modify Group 
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            GROUPNAME=$(whiptail --inputbox "Enter the group name" 8 39 --title "Modify Group" 3>&1 1>&2 2>&3)

            # Check if group name is empty
            if [[ -z "$GROUPNAME" ]]; then
                errorMSG "Group name cannot be empty. Enter a valid group name" 
                continue
            fi

            # Check if group does not exists
            if ! getent group "$GROUPNAME" >/dev/null; then
                errorMSG "Group $GROUPNAME does not exists. Enter a valid group name" 
                continue
            fi

            while true; do
                action=$(whiptail --title "Modify Group: $GROUPNAME" --menu "Select what you want to modify:" 20 60 10 \
                    "Add User" "Add a user to the group" \
                    "Remove User" "Remove a user from the group" \
                    "Exit" "Return to main menu or quit" 3>&1 1>&2 2>&3)

                case "$action" in
                    "Add User")
                        username=$(whiptail --inputbox "Enter the user name to add to $GROUPNAME:" 10 60 --title "Add User to Group" 3>&1 1>&2 2>&3)
                        if id "$username" &>/dev/null; then
                            usermod -aG "$GROUPNAME" "$username"
                            infoMSG "User '$username' added to the group '$GROUPNAME'."
                        else
                            errorMSG "User '$username' does not exist."
                        fi
                        ;;
                    "Remove User")
                        username=$(whiptail --inputbox "Enter the user name to remove from $GROUPNAME:" 10 60 --title "Remove User from Group" 3>&1 1>&2 2>&3)
                        if id "$username" &>/dev/null; then
                            gpasswd -d "$username" "$GROUPNAME"
                            infoMSG "User '$username' removed from the group '$GROUPNAME'."
                        else
                            errorMSG "User '$username' does not exist."
                        fi
                        ;;
                    "Exit")
                        break
                        ;;
                    *)
                        errorMSG "Invalid selection."
                        ;;
                esac
            done
            ;;
            
        "7) List Groups")
            # List Groups 
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            # List all groups
            groups=$(cut -d: -f1 /etc/group)
            whiptail --title "List of Groups" --msgbox "$groups" 20 60
            ;;
            
        "8) Delete Group")
            # Delete Group
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            GROUPNAME=$(whiptail --inputbox "Enter the group name to delete" 8 39 --title "Delete Group" 3>&1 1>&2 2>&3)

            # Check if group name is empty
            if [[ -z "$GROUPNAME" ]]; then
                errorMSG "Group name cannot be empty. Enter a valid group name" 
                continue
            fi

            # Check if group does not exists
            if ! getent group "$GROUPNAME" >/dev/null; then
                errorMSG "Group $GROUPNAME does not exists. Enter a valid group name" 
                continue
            fi

            # Delete the group
            groupdel "$GROUPNAME"
            infoMSG "Group $GROUPNAME deleted successfully"
            ;;
            
        "9) Enable User")
            # Enable User
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            USERNAME=$(whiptail --inputbox "Enter the user name to enable" 8 39 --title "Enable User" 3>&1 1>&2 2>&3)

            # Check if username is empty
            if [[ -z "$USERNAME" ]]; then
                errorMSG "Username cannot be empty. Enter a valid username" 
                continue
            fi

            # Check if user does not exists
            if ! id "$USERNAME" &>/dev/null; then
                errorMSG "User $USERNAME does not exists. Enter a valid username" 
                continue
            fi

            # Enable the user account
            usermod -U "$USERNAME"
            infoMSG "User $USERNAME enabled successfully"
            ;;
            
        "10) Disable User")
            # Disable User
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            USERNAME=$(whiptail --inputbox "Enter the user name to disable" 8 39 --title "Disable User" 3>&1 1>&2 2>&3)

            # Check if username is empty
            if [[ -z "$USERNAME" ]]; then
                errorMSG "Username cannot be empty. Enter a valid username" 
                continue
            fi

            # Check if user does not exists
            if ! id "$USERNAME" &>/dev/null; then
                errorMSG "User $USERNAME does not exists. Enter a valid username" 
                continue
            fi

            # Disable the user account
            usermod -L "$USERNAME"
            infoMSG "User $USERNAME disabled successfully"
            ;;
            
        "11) Change Password")
            # Change Password
            if [[ $EUID -ne 0 ]]; then
                errorMSG "Only root can run this script. You can use sudo" 
                continue
            fi

            USERNAME=$(whiptail --inputbox "Enter the user name to change password" 8 39 --title "Change Password" 3>&1 1>&2 2>&3)

            # Check if username is empty
            if [[ -z "$USERNAME" ]]; then
                errorMSG "Username cannot be empty. Enter a valid username" 
                continue
            fi

            # Check if user does not exists
            if ! id "$USERNAME" &>/dev/null; then
                errorMSG "User $USERNAME does not exists. Enter a valid username" 
                continue
            fi

            # Change the user's password
            # Prompt for new password
            PASSWORD=$(whiptail --passwordbox "Enter new password for user '$USERNAME':" 10 60 --title "Set Password" 3>&1 1>&2 2>&3)

            # Confirm password
            CONFIRM=$(whiptail --passwordbox "Confirm new password for user '$USERNAME':" 10 60 --title "Confirm Password" 3>&1 1>&2 2>&3)

            if [ "$PASSWORD" != "$CONFIRM" ]; then
                errorMSG "Passwords do not match!"
                continue
            fi

            echo "$USERNAME:$PASSWORD" | chpasswd
            infoMSG "Password for user $USERNAME changed successfully"
            ;;
            
        "12) About")
            # About information
            whiptail --title "About User Management System" --msgbox \
            "Project Title: User Management System\n\nVersion: 1.0\n\nProject Maker: Bashar" \
            12 60
            ;;
            
        "13) Exit")
            exit 0
            ;;
            
        *)
            errorMSG "Invalid option selected."
            ;;
    esac
done
