#!/bin/bash -ex

pip install pyyaml

pip list

# Executes all tasks defined in the "tasks" directory.
# Writes log and report files to "output" directory.
robot -d output --logtitle "Task log" tasks/
