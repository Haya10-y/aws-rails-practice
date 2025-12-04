FROM ruby:3.3.9

WORKDIR /webapp

# Gemfile とロックファイルだけを先にコピーして bundle install（キャッシュのため）
COPY webapp/Gemfile* /webapp/
RUN bundle install

# Rails アプリ全体をコピー
COPY webapp /webapp

EXPOSE 3000

# アセットのプリコンパイル
# Tailwind CSS などのビルドに必要
ENV RAILS_ENV=production
RUN bundle exec rails assets:precompile

# Entrypoint スクリプトをコピーして実行権限を付与
# pid ファイルの削除を行う
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
