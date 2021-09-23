FROM phusion/passenger-full

ARG PASSENGER_APP_ENV=production

ENV RAILS_ENV=${PASSENGER_APP_ENV}
ENV RUBY_VERSION=2.7.2

ADD bonnie.conf /etc/nginx/sites-enabled/bonnie.conf

COPY --chown=app:app . /home/app/bonnie

RUN bash -lc "rvm install ruby-${RUBY_VERSION} && rvm --default use ruby-${RUBY_VERSION}"

RUN rm -f /etc/service/nginx/down \
    && rm -f /etc/nginx/sites-enabled/default \
    && apt update \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && apt-get install shared-mime-info -y

RUN su - app -c "cd /home/app/bonnie \
                 && curl -O https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem \
                 && gem install bundler -v 2.1.4 \
                 && bundle install \
                 && npm install \
                 && RAILS_ENV=${PASSENGER_APP_ENV} bundle exec rake assets:precompile"
