# Dropbox File Upload Script

**Overview:**

Uploading large files to Dropbox using CURL can sometimes lead to memory-related problems. To address this issue, we've created a handy script that simplifies the process. This script divides your large file into manageable chunks and uploads them to Dropbox using the Dropbox API.

**How It Works:**

Our script takes care of all the heavy lifting for you:

1. It splits your target file into smaller, more manageable chunks.
2. These chunks are then seamlessly uploaded to Dropbox using the Dropbox API.
3. Dropbox automatically merges all the uploaded chunks back into your original file when the transfer is complete.

With this script, you can easily overcome memory limitations and efficiently upload large files to Dropbox hassle-free.

**Usage:**

1. Clone this repository to your local machine.

   ```bash
   git clone https://github.com/bitterdev/dropbox-upload-script.git
   ```

2. Navigate to the script directory.

   ```bash
   cd dropbox-upload-script
   ```

3. Execute the script, specifying the file you want to upload.

   ```bash
   chmod +x upload.sh
   ./upload.sh -f some_local_data.zip -p /target/dropbox/path -t your_dropbox_token
   ```

Sit back and relax while the script takes care of the rest. Your large file will be securely uploaded to Dropbox without any memory issues.

**Note:** Make sure to configure your Dropbox API credentials before using this script. Refer to the documentation for detailed instructions on setting up your API credentials.

Happy uploading!
