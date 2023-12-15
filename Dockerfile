FROM wiktorn/overpass-api:0.7.61.4

RUN apt-get update \ 
	&& apt-get install xz-utils

COPY ./node-v20.10.0-linux-x64.tar.xz ./node.tar.xz
COPY ./serve ./serve

ENV OVERPASS_META="yes"
ENV OVERPASS_MODE="init"
ENV OVERPASS_PLANET_URL="http://localhost:17267/uruguay.osm.bz2"
ENV OVERPASS_STOP_AFTER_INIT="true"
ENV OVERPASS_RULES_LOAD="100"

COPY dispatcher_start.sh /app/bin/
RUN chmod a+rx /app/bin/dispatcher_start.sh

RUN tar -xJf node.tar.xz \
	&& export PATH="$PATH:/node-v20.10.0-linux-x64/bin" \
	&& cd /serve && npm install \	
	&& ( node index & sleep 1 && /app/docker-entrypoint.sh ) \
	&& rm -rf /serve \
	&& rm -rf /node-v20.10.0-linux-x64 \
	&& rm /node.tar.xz

ENV OVERPASS_STOP_AFTER_INIT="false"