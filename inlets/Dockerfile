FROM python:3.7-slim-buster

RUN apt-get -qy update && apt-get -qy install curl && \
    curl -sLS https://get.inlets.dev | sh

ADD start.sh /

CMD [ "/start.sh" ]
