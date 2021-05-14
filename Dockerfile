FROM phusion/passenger-full

ARG RUBY_VERSION=2.7.2
ARG PASSENGER_APP_ENV=production
ENV RAILS_ENV=${PASSENGER_APP_ENV}

ADD bonnie.conf /etc/nginx/sites-enabled/bonnie.conf
#ADD mime.types /etc/nginx/mime.types

COPY --chown=app:app . /home/app/bonnie

RUN bash -lc "rvm install ruby-${RUBY_VERSION} && rvm --default use ruby-${RUBY_VERSION}"

RUN rm -f /etc/service/nginx/down \
    && rm -f /etc/nginx/sites-enabled/default \
    && apt update \
    && apt-get install shared-mime-info -y 

RUN su - app -c 'cd /home/app/bonnie \
		 && curl -O https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem \
		 && gem install bundler -v 2.1.4 \
		 && bundle install \
		 && npm install \
		 && RAILS_ENV=production bundle exec rake assets:precompile'
