# -- alpine-nodejessie:
FROM nodesource/jessie:0.12.8
# -- set environment variables
# -- upgrade and remove all cache
RUN curl -SL https://cli-assets.heroku.com/branches/stable/heroku-linux-amd64.tar.gz | \
    tar -zxv -C /usr/local/lib && \
    ln -sn /usr/local/lib/heroku/bin/heroku /usr/local/bin/heroku
