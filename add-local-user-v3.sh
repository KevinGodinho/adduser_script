#!/bin/bash

# This script creates a new user.
# Pass in username as first argument.
# Optionally, pass in comments as following arguments.
# Password will be auto generated.
# Username, password, and host will be displayed.

# Check for root privileges, redirect STDOUT to STDERR.
if [[ "${UID}" != 0 ]]
then
  echo "Need root privileges to execute this script (sudo)." >&2
  exit 1
fi

# Check for account name, redirect STDOUT to STDERR
if [[ "${#}" < 1 ]] # checks for at least 1 parameter
then
  echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
  exit 1
fi

# Assign first parameter to username.
USER_NAME="${1}"

# Assign comments for rest of parameters.
shift # remove username parameter, leaving comments
COMMENT="${@}"

# Generate random password
PASSWORD=$(date +%sN | sha256sum | head -c48)

# Create user account, redirect/discard STDOUT and STDERR to null
useradd -c "${COMMENT}" ${USER_NAME} &> /dev/null

# If account could not be created, exit script status 1.
# redirect STDOUT to STDERR
if [[ "${?}" != 0 ]]
then
  echo "Account could not be created." >&2
  exit 1
fi

# Assign password to user account.
# redirect/discard STDOUT and STDERR to null
echo ${PASSWORD} | passwd --stdin ${USER_NAME} &> /dev/null

# If account could not be created, exit script status 1.
# redirect STDOUT to STDERR
if [[ "${?}" != 0 ]]
then
  echo "Password could not be assigned to new user account." >&2
  exit 1
fi

# Force password change upon first login.
# redirect/discard STDOUT and STDERR to null
passwd -e ${USER_NAME} &> /dev/null

# Display username, password, and host of account.
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"
echo
exit 0
