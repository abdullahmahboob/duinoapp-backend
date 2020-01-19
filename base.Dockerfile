FROM node:10-alpine

USER root
RUN addgroup -S duino && adduser -S duino -G duino

COPY setup /home/duino/setup
COPY data /home/duino/data
# COPY Arduino /home/duino/Arduino

RUN chown duino:duino /home/duino -R
RUN apk update && apk add build-base

WORKDIR /home/duino
USER duino

RUN wget https://github.com/arduino/arduino-cli/releases/download/0.7.2/arduino-cli_0.7.2_Linux_64bit.tar.gz -O - | tar -xz

RUN ls

ENV CLI_ARGS="--config-file /home/duino/data/arduino-cli.yml --format json"
RUN ./arduino-cli core update-index ${CLI_ARGS}
RUN ./arduino-cli core search "" ${CLI_ARGS} > /home/duino/data/cores.json

RUN ./arduino-cli lib update-index ${CLI_ARGS}
RUN ./arduino-cli lib search "" ${CLI_ARGS} > /home/duino/data/libs.json

RUN node setup/ cores
RUN node setup/ libs
RUN node setup/ boards

RUN rm -rf /home/duino/data/arduino/staging