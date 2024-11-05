#!/bin/sh

# Check if the required files are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <local_file1> <local_file2>"
    exit 1
fi

# Variables
FILE1="$1"
FILE2="$2"
IMAGE_NAME="cyclonedx-cli-$(date +%s)"  # Random image name using timestamp
OUTPUT_FILE="merged-bom.json"

# Step 1: Create a new container from the CycloneDX CLI image
echo "Creating container from the CycloneDX CLI image..."
# CONTAINER_ID=$(docker create cyclonedx/cyclonedx-cli merge --input-files /local-file1.json /local-file2.json --output-file /$OUTPUT_FILE)
CONTAINER_ID=$(docker create hoppr/hopctl merge --deep-merge --sbom /local-file1.json --sbom /local-file2.json --output-file /$OUTPUT_FILE)

# Step 2: Copy files into the container
echo "Copying files into the container..."
docker cp "$FILE1" "$CONTAINER_ID:/local-file1.json"
docker cp "$FILE2" "$CONTAINER_ID:/local-file2.json"

# Step 3: Execute the CycloneDX merge command in the container
echo "Executing the merge command..."
RESULT=$(docker start -ai "$CONTAINER_ID")

# Step 4: Copy the output file back to the host
echo "Copying the merged output file back to the host..."
docker cp "$CONTAINER_ID:/$OUTPUT_FILE" .

# Step 5: Clean up the container
echo "Cleaning up the container..."
docker rm "$CONTAINER_ID"

# Step 6: Print the result
echo "Merged SBOM output:"
echo "$RESULT"
echo "Merged file saved as $OUTPUT_FILE."