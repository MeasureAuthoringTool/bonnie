FROM phusion/passenger-full

ENV PASSENGER_APP_ENV=production

ADD bonnie.conf /etc/nginx/sites-enabled/bonnie.conf

RUN rm -f /etc/service/nginx/down \
    && rm -f /etc/nginx/sites-enabled/default \
    && apt update \
    && apt-get install shared-mime-info

RUN bash -lc 'rvm --default use ruby-2.7.3'

COPY --chown=app:app . /home/app/bonnie

RUN su - app -c 'cd /home/app/bonnie \
		 && curl -O https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem \
		 && gem install bundler -v 2.1.4 \
		 && bundle install \
		 && npm install \
		 && bundle exec rake assets:precompile'
