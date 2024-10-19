FROM node
RUN apt-get update && \
    apt-get install -y git ffmpeg && \
    apt-get clean

RUN git config --global --add safe.directory /app && git clone https://github.com/Lyall-A/Derek-Cam.git /app

ENTRYPOINT ["/bin/bash", "-c", "cd /app; git pull; git submodule update --init --recursive; node ."]