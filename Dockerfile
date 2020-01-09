FROM python:alpine3.8

ENV VERSION_WAPITI 3.0.2

ENV LANG en
ENV PATH /opt/wapiti/bin:$PATH
ENV HOME /work

RUN buildDeps="libxml2-dev libxslt-dev python3-dev musl-dev gcc" && \
runDeps="openssl libxml2 libxslt" && \
apk --update add $runDeps $buildDeps && \
pip install beautifulsoup4 requests && \
mkdir -p /opt /work && cd /opt && \
wget "http://downloads.sourceforge.net/project/wapiti/wapiti/wapiti-$VERSION_WAPITI/wapiti3-$VERSION_WAPITI.tar.gz" && \
tar xvzf wapiti3-$VERSION_WAPITI.tar.gz && \
rm wapiti3-$VERSION_WAPITI.tar.gz && \
cd wapiti3-$VERSION_WAPITI && \
python setup.py install && \
ln -sf /opt/wapiti3-$VERSION_WAPITI /opt/wapiti && \
chmod 755 /opt/wapiti/bin/wapiti && \
apk del $buildDeps && \
apk add $runDeps && \
rm -f /var/cache/apk/* && \
adduser -D -s /bin/sh user user && chown -R user $HOME

USER user

RUN chmod 775 /work

VOLUME /work
WORKDIR /work

ENTRYPOINT ["wapiti"]

CMD ["--help"]
