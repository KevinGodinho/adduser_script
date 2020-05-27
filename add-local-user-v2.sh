#!/bin/bash

# This script creates a new user.
# Pass in username as first argument.
# Optionally, pass in comments as following arguments.
# Password will be auto generated.
# Username, password, and host will be displayed.

# Check for root privileges.
if [[ "${UID}" != 0 ]]
then
  echo "Need root privileges to execute this script (sudo)."
  exit 1
fi

# Check for account name.
if [[ "${#}" < 1 ]] # checks for at least 1 parameter
then
  echo "Usage: ${0} USER_NAME [COMMENT]..."
  exit 1
fi

# Assign first parameter to username.
USER_NAME="${1}"

# Assign comments for rest of parameters.
shift # remove username parameter, leaving comments
COMMENT="${@}"

# Generate random password
PASSWORD=$(date +%sN | sha256sum | head -c48)

# Create user account
useradd -c "${COMMENT}" ${USER_NAME}

# If account could not be created, exit script status 1.
if [[ "${?}" != 0 ]]
then
  echo "Account could not be created."
  exit 1
fi

# Assign password to user account
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# If account could not be created, exit script status 1.
if [[ "${?}" != 0 ]]
then
  echo "Password could not be assigned to new user account."
  exit 1
fi

# Force password change upon first login
passwd -e ${USER_NAME}

# Display username, password, and host of account.
echo
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"
echo
exit 0
