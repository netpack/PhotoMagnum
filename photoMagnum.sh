#!/bin/bash
photographer_code="SPM"
year=$(date +%Y)
letter_code="G"
declare -g photo_number=0
pwd=$(dirname "$1")

story_number=$(osascript <<EOD
  tell application "System Events"
    activate
    set myReply to text returned of (display dialog "Please enter story number:" default answer "")
  end tell
  return myReply
EOD)

#check if the story number has 4 digits
if ! [[ $story_number =~ ^[0-9]{4}$ ]]; then
  osascript -e 'display dialog "The story number MUST have 4 digits!" buttons {"OK"}'
  exit 0
fi

#check if there is already files with this story number
regex="([A-Z])\w+"
regex+=$story_number
regex+="G\w+"
story_files_count=0
story_files_count=$(find "$pwd" -type f -maxdepth 1 | grep -E "$regex" | wc -l)


#if (($story_files_count>0)); then
#  osascript -e 'display dialog "The story has'"$story_files_count"' photos!" buttons {"OK"}'
#else
#  osascript -e 'display dialog "The story has no photos! Starting a new story!" buttons {"OK"}'
#fi

photo_number=$story_files_count

function increment_story_files() {
  ((photo_number++))
}

#process each file
for file in "$@"
do
  #increment story files from last one

  increment_story_files

  new_name=$pwd
  new_name+="/"
  new_name+=$photographer_code
  new_name+=$year
  new_name+=$story_number
  new_name+=$letter_code
  new_name+=$(printf "%04d" "$photo_number")
  new_name+="."
  new_name+="${file##*.}"

  #osascript -e 'display dialog "The name of the next file whould be '"$new_name"'!" buttons {"OK"}'
  mv "$file" "$new_name"
done

#osascript -e 'display dialog "All done!" buttons {"Thank you Fred!"}'
