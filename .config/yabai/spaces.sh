spaces.sh
 #!/bin/bash

# Space Mapper
setup_space() {
  local idx="$1"
  local name="$2"
  local space=
  echo "setup space $idx : $name"

  space=$(yabai -m query --spaces --space "$idx")
  if [ -z "$space" ]; then
    yabai -m space --create
  fi

  yabai -m space "$idx" --label "$name"
  if [ "$idx" -eq "11" ]; then
    yabai -m space "$idx" --display 2
  else
    yabai -m space "$idx" --display 1
  fi
}

# Set Up Spaces
setup_space 1 1
setup_space 2 2
setup_space 3 3
setup_space 4 4
setup_space 5 5
setup_space 6 6
setup_space 7 7
setup_space 8 8
setup_space 9 9
setup_space 10 0
setup_space 11 11
