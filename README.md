# aws-rails-practice

This is my practice repository.

## 概要

RailsアプリケーションをAWS上にデプロイするための練習プロジェクトです。

## アプリケーション構成

### 主要な技術スタック

- **Ruby**: 3.3.9
- **Rails**: 7.1.5
- **データベース**: MySQL 8.3
- **キャッシュ/セッションストア**: Redis
- **バックグラウンドジョブ**: Sidekiq
- **認証**: Devise
- **フロントエンド**: Hotwire (Turbo + Stimulus) + Tailwind CSS
- **ストレージ**: AWS S3

### コンテナ構成

- **web**: Railsアプリケーション (Puma)
- **worker**: Sidekiqワーカー
- **db**: MySQL 8.3
- **redis**: Redis (キャッシュ、セッション、Sidekiq用)
- **mailhog**: 開発環境用メールサーバー

## ディレクトリ構成

```
aws-rails-practice/
├── webapp/              # Railsアプリケーション本体
│   ├── app/            # アプリケーションコード
│   ├── config/         # 設定ファイル
│   ├── db/             # マイグレーションファイル等
│   └── ...
├── terraform/          # AWSインフラのTerraformコード
├── db_data/            # MySQL の永続化データ (Git管理外)
├── data/
│   └── redis/          # Redis の永続化データ (Git管理外)
├── compose.yml         # Docker Compose設定
├── Dockerfile          # Dockerイメージビルド定義
└── README.md
```

**注意**: `db_data/` と `data/redis/` はデータベースとキャッシュの永続化データを保存するディレクトリで、`.gitignore` に含まれています。

## 環境構築

### 前提条件

- Docker Desktop あるいはそれに準ずるものがインストールされていること
- Git がインストールされていること

### セットアップ手順

1. **リポジトリのクローン**

```bash
git clone https://github.com/Haya10-y/aws-rails-practice.git
cd aws-rails-practice
```

2. **環境変数ファイルの作成**

`webapp/.env` ファイルを作成し、以下の環境変数を設定してください。

**開発環境では、AWS関連の環境変数（`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `S3_BUCKET`）にはダミーの値を入れておいてください。開発環境ではローカルストレージを使用するため、実際のAWS認証情報は不要です。**

```bash
# Rails
APP_HOST=

# AWS (開発環境ではダミー値でOK)
AWS_ACCESS_KEY_ID=dummy
AWS_SECRET_ACCESS_KEY=dummy
AWS_REGION=ap-northeast-1
S3_BUCKET=dummy

# Redis
REDIS_HOST=
REDIS_PORT=
REDIS_URL=

# Database
WEBAPP_DATABASE_PASSWORD=

# Email (開発環境ではMailHogを使用)
SENDER_ADDRESS=
SMTP_HOST=
SMTP_USERNAME=
SMTP_PASSWORD=
```

**注意**: 本番環境（AWS）では、実際のAWS認証情報とS3バケット名を設定する必要があります。

3. **master.key の設定**

`master.key` はセキュリティ上リポジトリに含まれていません。以下のいずれかの方法で設定してください。

- リポジトリ主から `master.key` をもらった場合: `webapp/config/master.key` に配置
- 新規に生成する場合: `webapp/config/credentials.yml.enc` を削除してから以下を実行

```bash
docker compose run --rm web rails credentials:edit
```

4. **Dockerイメージのビルド**

```bash
docker compose build
```

うまくいかない場合は、キャッシュを使わずにビルドしてください。

```bash
docker compose build --no-cache
```

5. **コンテナの起動**

```bash
docker compose up -d
```

6. **データベースのセットアップ**

```bash
docker compose exec web rails db:create
docker compose exec web rails db:migrate
```

7. **アプリケーションへのアクセス**

- アプリケーション: http://localhost:3000
- MailHog (メール確認用): http://localhost:8025

### その他の便利なコマンド

```bash
# コンテナの停止
docker compose down

# ログの確認
docker compose logs -f web

# Railsコンソール
docker compose exec web rails c

# コンテナに直接入る（execがうまくいかない場合）
docker compose exec -it web bash

# テストの実行
docker compose exec web rspec

# コードのフォーマット
docker compose exec web rubocop -A
```

## AWS構成

詳細なAWS構成図は `aws-architecture.drawio` を参照してください。

- **ECS Fargate**: コンテナ実行環境 (webapp + worker)
- **RDS MySQL**: データベース (Multi-AZ構成)
- **ElastiCache Valkey**: キャッシュ・セッションストア (Multi-AZ構成)
- **ALB**: Application Load Balancer
- **S3**: ファイルストレージ
- **ECR**: コンテナレジストリ
- **Secrets Manager**: 機密情報管理
- **CloudWatch Logs**: ログ管理

## Terraform

`terraform/` ディレクトリにAWSインフラのコード化されたリソース定義があります。
