#!/bin/bash

#
# MIT License
#
# Copyright (c) 2024 David Frings
#

BASE_PATH="/mnt/Festplatte/Server/Minecraft/Server9-Velocity"

# Function to check if a screen session is running and start it if not
function start_screen {
  local screen_name=$1
  local script_path=$2

  if screen -list | grep -q "\.${screen_name}"; then
    echo "Screen session ${screen_name} is already running."
  else
    echo "Starting screen session ${screen_name}..."
    "$script_path"
  fi
}

# Function to start selected servers
function start {
  start_screen "velocity" "$BASE_PATH/velocity/screen-create.sh"
  start_screen "lobby" "$BASE_PATH/lobby/screen-create.sh"
  
  while true; do
    read -p "Please select between: Project 1[1], Project 2[2], Project 3[3], Test world [4], All servers[8] & End[9]: " server  
    case $server in
      1 | "Project 1")
        start_screen "project-1" "$BASE_PATH/project-1/screen-create.sh"
        ;;
      2 | "Project 2")
        start_screen "project-2" "$BASE_PATH/project-2/screen-create.sh"
        ;;
      3 | "Project 3")
        start_screen "project-3" "$BASE_PATH/project-3/screen-create.sh"
        ;;
      4 | "Test world")
        start_screen "test-world" "$BASE_PATH/test-world/screen-create.sh"
        ;;
      8 | "All servers")
        start_screen "project-1" "$BASE_PATH/project-1/screen-create.sh"
        start_screen "project-2" "$BASE_PATH/project-2/screen-create.sh"
        start_screen "project-3" "$BASE_PATH/project-3/screen-create.sh"
        start_screen "test-world" "$BASE_PATH/test-world/screen-create.sh"
		exit 1
        ;;
      9 | "End" | 0)
        exit 1
        ;;
      *)
        echo "Invalid option. Please try again."
        ;;
    esac
  done
}

# Function to handle connecting to a server
function connect {
  while true; do
    read -p "Please select between: Velocity[0], Project 1[1], Project 2[2], Project 3[3], Test world[4], Lobby[5] & Kill all[9] (Use kill only in Emergency): " server
    case $server in
      0 | "Velocity")
        screen -r velocity
        break
        ;;
      1 | "Project 1")
        screen -r project-1
        break
        ;;
      2 | "Project 2")
        screen -r project-2
        break
        ;;
      3 | "Project 3")
        screen -r project-3
        break
        ;;
      4 | "Test world")
        screen -r test-world
        break
        ;;
      5 | "Lobby")
        screen -r lobby
        break
        ;;
      9 | "Kill all")
        read -p "Are you sure you want to force kill all screens? [y/N]: " kill
        if [[ $kill == "y" || $kill == "Y" || $kill == "1" ]]; then
          sudo pkill screen
        else
          echo "Aborted."
        fi
        break
        ;;
      *)
        echo "Invalid option. Please try again."
        ;;
    esac
  done
}

# Main loop to prompt user for action
while true; do
  read -p "Do you want to connect to a server (c) or start a server (s)? [c/s]: " state

  if [[ "$state" == "c" ]]; then
    connect
    break
  elif [[ "$state" == "s" ]]; then
    start
    break
  else
    echo "Invalid option. Please enter 'c' to connect or 's' to start."
  fi
done