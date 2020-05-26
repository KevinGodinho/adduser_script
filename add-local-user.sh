#!/bin/bash

# This script creates a new user.

# Check if user is root. If NOT root, exit script status 1.
if [[ "${UID}" != 0 ]]
then
  echo 'Please run with sudo or as root.'
  exit 1
fi

# Ask for username.
read -p 'Enter username: ' USER_NAME

# Ask for real name of user.
read -p 'Enter real name of user: ' COMMENT

# Ask for password.
read -p 'Enter password: ' PASSWORD

# Create user with username and comment of real name.
useradd -c "${COMMENT}" -m ${USER_NAME}

# If account could NOT be created, exit script status 1.
if [[ "${?}" -ne 0 ]] # ${?} contains the exit status of previous 'useradd' command.
then
  echo 'Account could not be created.'
  exit 1
fi

# Create specified password for user.
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# If password was NOT created successfully, exit script status 1.
if [[ "${?}" != 0 ]]
then
  echo 'Password could not be created.'
  exit 1
fi

# Force password change upon first login.
passwd -e ${USER_NAME}

# Display username, password, and host where account was created.
echo # prints a blank line when no arguments are specified.
echo "username: ${USER_NAME}"
echo "password: ${PASSWORD}"
echo "host: ${HOSTNAME}"
echo
exit 0
