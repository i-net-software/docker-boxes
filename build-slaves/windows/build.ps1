

# Build the images
"swarm", "choco", "base", "java", "tools", "vs2015", "sdk", "reportreader", "wixtoolset", "vs2017" | ForEach-Object { docker-compose build $_ }
