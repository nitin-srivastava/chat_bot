FROM ruby:3.0.1-alpine
ENV BUNDLER_VERSION=2.2.15
RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      sqlite-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      tzdata \
      yarn
RUN gem install bundler -v 2.2.15
WORKDIR /chat_app
COPY Gemfile /chat_app/Gemfile
COPY Gemfile.lock /chat_app/Gemfile.lock
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install
COPY package.json yarn.lock /chat_app/
RUN yarn install --check-files
RUN bundle exec rails assets:clobber webpacker:compile

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]