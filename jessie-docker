# --
FROM debian:jessie-slim
# -- set environment variables
# -- upgrade, install dependencies and remove all cache
# -- -- bzip2 required for tar -j
# -- -- libfontconfig required for phantomjs
RUN apt-get update && \
    apt-get install -y curl bzip2 libfontconfig jq && \
    apt-get clean
# -- install build tools
RUN curl -SL https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz | \
    tar -zxv -C /usr/local/lib && \
    ln -sn ../lib/heroku/bin/heroku /usr/local/bin/heroku && \
    curl -SL https://nodejs.org/download/release/v0.12.18/node-v0.12.18-linux-x64.tar.gz | \
    tar -zxv -C /usr/local/ --strip-components 1 && \
    curl -SL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 | \
    tar -jxv -C /usr/local/ && \
    ln -sn /usr/local/phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    npm install -g grunt-cli && \
    npm install -g bower && \
    npm install -g nsp
ADD build_node.sh /usr/local/bin/
ADD build_node-prerelease.sh /usr/local/bin/
ADD build_node-release.sh /usr/local/bin/
# -- change to jenkins user
RUN addgroup --gid 1000 jenkins && \
    adduser --no-create-home --gid 1000 --uid 1000 --gecos "" --shell /bin/bash --disabled-password jenkins
USER jenkins
WORKDIR /home/jenkins
# -- expose the root file system in order to be able to run tool binaries
VOLUME ["/home/jenkins/"]
# -- entry point would be bash for data volume
CMD  ["/bin/bash"]
