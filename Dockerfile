FROM wiktorn/overpass-api:0.7.61.4

ENV OVERPASS_META="yes" \
	OVERPASS_MODE="init" \
	OVERPASS_PLANET_URL="http://localhost:17267/uruguay.osm.bz2" \
	OVERPASS_STOP_AFTER_INIT="true" \
	OVERPASS_RULES_LOAD="100" \
	OVERPASS_ALLOW_DUPLICATE_QUERIES="yes"

COPY ./osmbz2server ./osmbz2server

RUN \
	# + install gcc
	apt-get update && apt-get install -y gcc \
	# + include osm.bz2 static server
	&& gcc -o ./osmbz2server/server ./osmbz2server/server.c \
	&& ( cd ./osmbz2server && ./server & sleep 1 ) \ 
	&& /app/docker-entrypoint.sh \
	# - remove osm.bz2 static server
	&& rm -rf /osmbz2server \
	# - remove gcc
	&& apt-get remove --purge -y gcc \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV OVERPASS_STOP_AFTER_INIT="false"