FROM ruby:3.2.2

RUN mkdir /rails_app
WORKDIR /rails_app
COPY Gemfile /rails_app/Gemfile
COPY Gemfile.lock /rails_app/Gemfile.lock
RUN bundle install
COPY . /rails_app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
