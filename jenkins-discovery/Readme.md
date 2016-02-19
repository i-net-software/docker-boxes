# Jenkins Discovery

##Preparations

You need ```docker-compose``` to run the current setup and you need to specify ```HOST_IP``` as environment variable.

  * For ```docker-compose```:

        pip install docker-compose

  * The ```HOST_IP``` - this IP will be used to advertise the correct IP to Nginx for the redirects.

        export HOST_IP=X.X.X.X

## Running the discovery

From this directory run:

    docker-compose build && docker-compose up

##Running the Jenkins Docker container

Our setup is based up on the ```inetsoftware/jenkins-autosetup``` iamge. You need to specify some more environment variables for the docker process to correctly register and use the Jenkins with this auto discovery.

	export SERVICE_NAME=<your service name>
	docker run -dp 80:8080 -e AUTOSETUP="svn://<user>:<password>@<url>/<path>" -e SERVICE_8080_NAME="$SERVICE_NAME"" -e JENKINS_OPTS="--prefix=/$SERVICE_NAME" -e SERVICE_8080_TAGS=jenkins inetsoftware/jenkins-autosetup

Please make sure that the ```SERVICE_NAME``` does only contain urlencodable characters. e.g. do not use spaces or special chars.