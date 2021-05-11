FROM phusion/passenger-ruby27

ADD bonnie.conf /etc/nginx/sites-enabled/bonnie.conf

RUN rm -f /etc/service/nginx/down \
    && rm -f /etc/nginx/sites-enabled/default \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

COPY --chown=app:app . /home/app/bonnie

RUN su - app -c 'cd /home/app/bonnie \
		 && curl -O https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem \
		 && gem install bundler \
		 && bundle install \
		 && npm install \
		 && RAILS_ENV=production bundle exec rake assets:precompile'
