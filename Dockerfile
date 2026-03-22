ARG BASE_IMAGE=dhi.io/debian-base:trixie-debian13-dev
FROM ${BASE_IMAGE}

ARG VER_NUM=4.7.4.5
ARG BUILD_DATE=$(date +%Y-%m-%d)

LABEL maintainer="Rob Asher, forked by ZorbaTheRainy to provide tags"
LABEL version=${VER_NUM}
LABEL release-date=${BUILD_TIME}
LABEL source="https://github.com/zorbaTheRainy/nxfilter-docker"

ENV TZ=${TZ:-Etc/UTC}

RUN apt-get -y update
RUN apt -y upgrade
RUN apt -y install --no-install-recommends dnsutils iputils-ping tzdata curl
RUN apt -y install --no-install-recommends openjdk-21-jre-headless
RUN curl -O http://pub.nxfilter.org/nxfilter-${VER_NUM}.deb
RUN apt -y install --no-install-recommends ./nxfilter-${VER_NUM}.deb
RUN apt -y clean autoclean
RUN apt -y autoremove
RUN rm -rf ./nxfilter-${VER_NUM}.deb
RUN rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log
RUN echo "${VER_NUM}" > /nxfilter/version.txt

EXPOSE 53/udp 19004/udp 80 443 19002 19003 19004

CMD ["/nxfilter/bin/startup.sh"]
