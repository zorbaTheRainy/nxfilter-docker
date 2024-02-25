FROM ubuntu:latest

ARG VER_NUM
ARG BUILD_TIME

LABEL maintainer="Rob Asher, forked by ZorbaTheRainy to provide tags"
LABEL version=${VER_NUM}
LABEL release-date=${BUILD_TIME}
LABEL source="https://github.com/zorbaTheRainy/nxfilter-docker"

ENV TZ=${TZ:-Etc/UTC}

RUN apt -y update && apt -y upgrade \
  && apt -y install --no-install-recommends dnsutils iputils-ping tzdata curl openjdk-11-jre-headless \
  && curl -O http://pub.nxfilter.org/nxfilter-${VER_NUM}.deb \
  && apt -y install --no-install-recommends ./nxfilter-${VER_NUM}.deb \
  && apt -y clean autoclean \
  && apt -y autoremove \
  && rm -rf ./nxfilter-${VER_NUM}.deb \
  && rm -rf /var/lib/apt && rm -rf /var/lib/dpkg && rm -rf /var/lib/cache && rm -rf /var/lib/log \
  && echo "${VER_NUM}" > /nxfilter/version.txt

EXPOSE 53/udp 19004/udp 80 443 19002 19003 19004

CMD ["/nxfilter/bin/startup.sh"]
