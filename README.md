# docker_bits

this repo contains a few examples of docker work i've done for containerization and standard rebuilding of various useful tools/environments across platforms

the dockerfile is a docker image i built based on an application with a js frontend and a python backend. it builds the dependencies in python, and then builds the npm packages (for react) into js first, and then last copies all of the parts together, in order to reduce rebuilding earlier layers of the docker image if part of the code needs adjusted

the docker compose files are built (generically, needing some info filled in) to dynamically spin up first: gitea (a local, light, git repo platform) and drone which is a lightweight local cicd platform that integrates with gitea. And second: prometheus along with snmp-exporter (the utility that helps ingest targeted snmp endpoint data for prometheus) and alertmanager (which can function to issue alerts when thresholds are reached).
