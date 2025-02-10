# ▶️ YouTube Video Downloader with Progress Bar

A simple, beginner-friendly shell script that allows you to download YouTube videos using `yt-dlp` with a `dialog`-based user interface, including a working progress bar.

## 👍 Features
- **User-friendly text-based interface** powered by `dialog`
- **Download as MP4 or Stream** using `yt-dlp`
- **Real-time progress bar** showing download percentage
- **Option to specify filename**
- **Saves downloads in `~/Downloads`** by default

## 🖼️ Screenshot
![Screenshot_20250128_145853](https://github.com/user-attachments/assets/ad636e15-f54d-4fed-9d9c-5c81038e9f59)

## ‼️ Prerequisites
Before running the script, make sure you have the following installed:

### 📥 Install Required Dependencies
```bash
sudo apt update
sudo apt install dialog
sudo apt install yt-dlp
```
The above commands may vary, depending on your distro.

If you are using another Linux distribution:
- **Arch Linux:** `sudo pacman -S dialog yt-dlp`
- **Fedora:** `sudo dnf install dialog yt-dlp`

## ⬇️ Installation & Setup
1. **Download the script**
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
   cd YOUR_REPOSITORY
   ```

2. **Make the script executable**
   ```bash
   chmod +x yt_downloader.sh
   ```

3. **Run the script**
   ```bash
   ./yt_downloader.sh
   ```

## 📖 Usage Guide
1. **Enter the YouTube video URL**
2. **(Optional) Specify a filename**
3. **Select the download format:**
   - `MP4`: Downloads the video as an MP4 file
   - `Stream`: Downloads using streaming mode
4. **Watch the progress bar as the video downloads**
5. **Find your video in `~/Downloads`**

## 🛠 Customization
You can modify the default download directory by editing the following line in the script:
```bash
DOWNLOAD_DIR="$HOME/Downloads"
```
Change `$HOME/Downloads` to your preferred directory.

## 🆘 Troubleshooting
- If `yt-dlp` is missing, install it with `sudo apt install yt-dlp`. This command may vary, depending on your distro.
- If `dialog` is missing, install it with `sudo apt install dialog`. This command may vary, depending on your distro.
- If downloads fail, try updating `yt-dlp` with:
  ```bash
  sudo yt-dlp -U
