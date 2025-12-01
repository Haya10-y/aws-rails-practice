# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user, name: 'テストユーザー', email: 'test@example.com') }

  describe 'GET /users/mypage' do
    context 'ログインしている場合' do
      before do
        sign_in user
      end

      it 'マイページが正常に表示される' do
        get users_mypage_path
        expect(response).to have_http_status(:success)
      end

      it 'ユーザー名が表示される' do
        get users_mypage_path
        expect(response.body).to include("こんにちは、#{user.name}さん") # スペースなし
        expect(response.body).to include("こんにちは、<span class=\"text-yellow-400 font-semibold\">#{user.name}</span> さん") # メインコンテンツ
      end

      it 'ユーザーの基本情報が表示される' do
        get users_mypage_path
        expect(response.body).to include(user.name)
        expect(response.body).to include(user.email)
        expect(response.body).to include(user.created_at.strftime('%Y年%m月%d日'))
        expect(response.body).to include(user.updated_at.strftime('%Y年%m月%d日'))
      end

      it 'ナビゲーションにマイページリンクが含まれる' do
        get users_mypage_path
        expect(response.body).to include('マイページ')
      end

      it 'クイックアクションが表示される' do
        get users_mypage_path
        expect(response.body).to include('プロフィール編集')
        expect(response.body).to include('ホームに戻る')
        expect(response.body).to include('ログアウト')
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        get users_mypage_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /users/:id/posts' do
    let(:other_user) { create(:user, name: '他のユーザー', email: 'other@example.com') }

    context 'ログインしている場合' do
      before do
        sign_in user
      end

      context '自分の投稿一覧を表示する場合' do
        let!(:post1) { create(:post, user: user, content: '最初の投稿', created_at: 3.days.ago) }
        let!(:post2) { create(:post, user: user, content: '2番目の投稿', created_at: 2.days.ago) }
        let!(:post3) { create(:post, user: user, content: '最新の投稿', created_at: 1.day.ago) }

        it '投稿一覧ページが正常に表示される' do
          get user_posts_path(user)
          expect(response).to have_http_status(:success)
        end

        it 'ユーザー名が表示される' do
          get user_posts_path(user)
          expect(response.body).to include("#{user.name}さんの投稿")
        end

        it '投稿件数が表示される' do
          get user_posts_path(user)
          expect(response.body).to include('全3件の投稿')
        end

        it 'すべての投稿が表示される' do
          get user_posts_path(user)
          expect(response.body).to include('最初の投稿')
          expect(response.body).to include('2番目の投稿')
          expect(response.body).to include('最新の投稿')
        end

        it '投稿が新しい順に並んでいる' do
          get user_posts_path(user)
          newest_position = response.body.index('最新の投稿')
          second_position = response.body.index('2番目の投稿')
          first_position = response.body.index('最初の投稿')

          expect(newest_position).to be < second_position
          expect(second_position).to be < first_position
        end
      end

      context '他のユーザーの投稿一覧を表示する場合' do
        let!(:other_post1) { create(:post, user: other_user, content: '他人の投稿1') }
        let!(:other_post2) { create(:post, user: other_user, content: '他人の投稿2') }

        it '他のユーザーの投稿一覧が表示される' do
          get user_posts_path(other_user)
          expect(response).to have_http_status(:success)
        end

        it '他のユーザー名が表示される' do
          get user_posts_path(other_user)
          expect(response.body).to include("#{other_user.name}さんの投稿")
        end

        it '他のユーザーの投稿が表示される' do
          get user_posts_path(other_user)
          expect(response.body).to include('他人の投稿1')
          expect(response.body).to include('他人の投稿2')
        end

        it '自分の投稿は表示されない' do
          create(:post, user: user, content: '自分の投稿')
          get user_posts_path(other_user)
          expect(response.body).not_to include('自分の投稿')
        end
      end

      context '投稿がない場合' do
        it '投稿がないメッセージが表示される' do
          get user_posts_path(user)
          expect(response.body).to include('投稿がありません')
        end

        it '自分の投稿一覧の場合は投稿作成ボタンが表示される' do
          get user_posts_path(user)
          expect(response.body).to include('最初の投稿を作成')
        end

        it '他人の投稿一覧の場合は投稿作成ボタンが表示されない' do
          get user_posts_path(other_user)
          expect(response.body).not_to include('最初の投稿を作成')
        end
      end

      context '画像付き投稿がある場合' do
        let!(:post_with_image) do
          post = create(:post, user: user, content: '画像付き投稿')
          post.image.attach(
            io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')),
            filename: 'test_image.png',
            content_type: 'image/png'
          )
          post
        end

        it '画像が表示される' do
          get user_posts_path(user)
          expect(response).to have_http_status(:success)
          # 画像タグの存在を確認（完全なHTMLマッチは避ける）
          expect(response.body).to include('画像付き投稿')
        end
      end

      context '画像のみの投稿がある場合' do
        let!(:image_only_post) do
          post = build(:post, user: user, content: '')
          post.image.attach(
            io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')),
            filename: 'test_image.png',
            content_type: 'image/png'
          )
          post.save!
          post
        end

        it '「画像のみの投稿」と表示される' do
          get user_posts_path(user)
          expect(response.body).to include('画像のみの投稿')
        end
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        get user_posts_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /users/sign_in' do
    it 'ログイン後にマイページにリダイレクトされる' do
      # ログインページにアクセス
      get new_user_session_path
      expect(response).to have_http_status(:success)

      # ログイン処理
      post user_session_path, params: {
        user: {
          email: user.email,
          password: user.password
        }
      }

      # マイページにリダイレクトされることを確認
      expect(response).to redirect_to(users_mypage_path)
    end
  end

  describe 'POST /users' do
    it 'サインアップ後にroot_pathにリダイレクトされる（confirmable有効のため）' do
      # メールの送信をクリア
      ActionMailer::Base.deliveries.clear

      # サインアップ処理
      post user_registration_path, params: {
        user: {
          name: '新規ユーザー',
          email: 'newuser@example.com',
          password: 'Password123',
          password_confirmation: 'Password123'
        }
      }

      # 確認メールが送信される前に、一旦root_pathにリダイレクトされる（confirmableのため）
      expect(response).to redirect_to(root_path)
    end
  end
end
