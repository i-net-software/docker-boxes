# Jenkins/autosetup Docker

Docker image with Jenkins with a custom start script. You can/have to provide an environment variable to setup the container while it starts.

	docker run -dp 80:8080 -e AUTOSETUP="svn://<user>:<password>@<url>/<path>" inetsoftware/jenkins-autosetup

Though it seems to re-setup jenkins every time the container starts seems like a disadvantage it will keep the Jenkins configuration up to date.
