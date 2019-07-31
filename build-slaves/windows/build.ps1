

# Build the images
swarm, choco, base, java, tools, vs2015, sdk, reportreader, wixtoolset | ForEach-Object { docker-compose build "$" }