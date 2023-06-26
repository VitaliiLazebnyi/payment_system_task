FROM ruby:3.2.2

EXPOSE 3000

WORKDIR /usr/src/app

COPY . .
RUN bundle install
