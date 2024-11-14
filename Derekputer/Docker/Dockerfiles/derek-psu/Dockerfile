FROM node
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean

RUN git config --global --add safe.directory /app && git clone https://github.com/Lyall-A/Derek-PSU.git /app

ENTRYPOINT ["/bin/bash", "-c", "cd /app; git pull; git submodule update --init --recursive; node ."]