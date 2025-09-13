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
        expect(response.body).to include(user.created_at.strftime("%Y年%m月%d日"))
        expect(response.body).to include(user.updated_at.strftime("%Y年%m月%d日"))
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

  describe 'POST /users/sign_in' do
    let(:user) { create(:user, name: 'テストユーザー', email: 'test@example.com') }

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
