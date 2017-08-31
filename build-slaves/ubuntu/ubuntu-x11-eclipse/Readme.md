# Eclipse in a docker container

Eclipse (Oxygen) in docker container is a convenient way to start an eclipse development environment with a persistent workspace and plugins for ad-hoc debugging.

This container will build up on the Java/Gradle and X11/VNC image from our repository. It comes with Java 7, 8 and 9 as well as Gradle 3.3

The container provides VNC at port `5900` and additional ssh at port `22`. The display resolution can be set using the environment variable `DISPLAY_RESOLUTION`.
