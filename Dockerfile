FROM phusion/passenger-full

ARG RUBY_VERSION=2.7.2

ADD bonnie.conf /etc/nginx/sites-enabled/bonnie.conf

RUN rm -f /etc/service/nginx/down \
    && rm -f /etc/nginx/sites-enabled/default \
    && /usr/local/rvm/bin/rvm install ruby-${RUBY_VERSION} \
    && bash -lc 'rvm --default use ruby-${RUBY_VERSION}' 

COPY --chown=app:app . /home/app/bonnie

RUN su - app -c 'cd /home/app/bonnie && curl -O https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem && gem install bundler && bundle install && npm install && RAILS_ENV=production bundle exec rake assets:precompile'
