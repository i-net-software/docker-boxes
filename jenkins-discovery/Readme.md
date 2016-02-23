# Jenkins Discovery

##Quickstart

Run the folliwng command from the bash:

    curl -fsSL https://raw.githubusercontent.com/i-net-software/docker-boxes/master/jenkins-discovery/build.sh | bash -s --

It will download the newest version of the ```build.sh``` (then the repository) and and tries to run ```docker-compose -f <yml> up -d``` to start the whole discovery setup.

##Manual start

###Preparations

You need ```docker``` [see here](https://docs.docker.com/engine/installation/)

You need ```docker-compose``` to run the current setup and you need to specify ```HOST_ADDRESS``` as environment variable.

  * For ```docker-compose```:

		apt-get install python-pip # if you are on Ubuntu or similar
        pip install docker-compose functools32

  * The ```HOST_ADDRESS``` - this IP will be used to advertise the correct IP to Nginx for the redirects.

        export HOST_ADDRESS=X.X.X.X

### Running the discovery

From this directory run:

    docker-compose build && docker-compose up

##Running the Jenkins Docker container

Our setup is based up on the ```inetsoftware/jenkins-autosetup``` iamge. You need to specify some more environment variables for the docker process to correctly register and use the Jenkins with this auto discovery.

	export SERVICE_NAME=<your service name>
	docker run -dp 80:8080 -e AUTOSETUP="svn://<user>:<password>@<url>/<path>" -e SERVICE_8080_NAME="$SERVICE_NAME"" -e JENKINS_OPTS="--prefix=/$SERVICE_NAME" -e SERVICE_8080_TAGS=jenkins inetsoftware/jenkins-autosetup

Please make sure that the ```SERVICE_NAME``` does only contain urlencodable characters. e.g. do not use spaces or special chars.