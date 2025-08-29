FROM ruby:3.3

WORKDIR /webapp

# GemfileとGemfile.lockファイルを
# イメージのwebappディレクトリ内にコピー
COPY Gemfile* /webapp/

RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
