#!/bin/bash

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
  echo "The tool 'dialog' is not installed. Please install it using 'sudo apt install dialog'."
  exit 1
fi

# Set default download directory
DOWNLOAD_DIR="$HOME/Downloads"

# Create temporary files
TEMP_URL=$(mktemp)
TEMP_FILENAME=$(mktemp)
TEMP_OPTIONS=$(mktemp)

# Function to download with progress bar
function download_with_progress() {
  local url="$1"
  local format="$2"
  local filename="$3"

  # Ensure the download directory exists
  mkdir -p "$DOWNLOAD_DIR"

  # Build the yt-dlp command
  if [ -n "$filename" ]; then
    output_option="-o \"$DOWNLOAD_DIR/$filename\""
  else
    output_option="-o \"$DOWNLOAD_DIR/%(title)s.%(ext)s\""
  fi

  if [ "$format" == "mp4" ]; then
    cmd="yt-dlp -S ext:mp4:m4a $output_option \"$url\""
  elif [ "$format" == "stream" ]; then
    cmd="yt-dlp --no-part --restrict-filenames --user-agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.67 Safari/537.36' $output_option \"$url\""
  fi

  # Start the download and parse progress
  (
    eval "$cmd" 2>&1 | stdbuf -oL grep --line-buffered -o -E "[0-9]{1,3}(\.[0-9]+)?%" | while read -r progress; do
      progress_value=$(echo "$progress" | tr -d '%')  # Remove the '%' symbol
      echo "$progress_value" | awk '{print int($1)}'  # Send percentage to dialog
    done
  ) | dialog --gauge "Downloading $format..." 10 70 0
}

# URL input
dialog --title "YouTube Video Downloader" \
       --inputbox "Enter the video URL:" 8 60 2> "$TEMP_URL"

# Check if user cancelled
if [ $? -ne 0 ]; then
  echo "Cancelled."
  rm -f "$TEMP_URL" "$TEMP_FILENAME" "$TEMP_OPTIONS"
  exit 1
fi

# Read the URL
url=$(<"$TEMP_URL")
rm -f "$TEMP_URL"

# Check if the URL is empty
if [ -z "$url" ]; then
  dialog --msgbox "Error: No URL provided!" 6 40
  exit 1
fi

# Filename input
dialog --title "YouTube Video Downloader" \
       --inputbox "Enter a filename (optional):" 8 60 2> "$TEMP_FILENAME"

# Read the filename
filename=$(<"$TEMP_FILENAME")
rm -f "$TEMP_FILENAME"

# Checkbox menu for download options
dialog --title "Download Options" \
       --checklist "Select the desired download options:" 10 60 2 \
       "MP4" "Download video in MP4 format" off \
       "Stream" "Download video as stream" off 2> "$TEMP_OPTIONS"

# Check if user cancelled
if [ $? -ne 0 ]; then
  echo "Cancelled."
  rm -f "$TEMP_OPTIONS"
  exit 1
fi

# Read selected options
selected_options=$(<"$TEMP_OPTIONS")
rm -f "$TEMP_OPTIONS"

# No option selected
if [ -z "$selected_options" ]; then
  dialog --msgbox "No option selected. Script will exit." 6 40
  exit 1
fi

# Perform download based on selection
if [[ "$selected_options" == *"MP4"* ]]; then
  download_with_progress "$url" "mp4" "$filename"
fi

if [[ "$selected_options" == *"Stream"* ]]; then
  download_with_progress "$url" "stream" "$filename"
fi

# Completion message
dialog --msgbox "Download complete! Files saved in $DOWNLOAD_DIR" 6 50
