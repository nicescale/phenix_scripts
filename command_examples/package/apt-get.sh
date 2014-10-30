#!/bin/bash

set -e

# Example1: To list installed softwares execute below command
dpkg –get-selections

# Example2: To count all installed softwares use below command which is modified version of above one.
dpkg –get-selections | wc -l

# Example3: To know the version and other details about installed package use below command
aptitude show <package-name>
