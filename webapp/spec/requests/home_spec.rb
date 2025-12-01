# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /' do
    context 'when user is not logged in' do
      it 'returns http success' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'does not display recent posts section' do
        get root_path
        expect(response.body).not_to include('あなたの最新投稿')
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'returns http success' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      context 'with no posts' do
        it 'does not display recent posts section' do
          get root_path
          expect(response.body).not_to include('あなたの最新投稿')
        end
      end

      context 'with posts' do
        let!(:post1) { create(:post, user: user, content: 'First post', created_at: 5.days.ago) }
        let!(:post2) { create(:post, user: user, content: 'Second post', created_at: 3.days.ago) }
        let!(:post3) { create(:post, user: user, content: 'Third post', created_at: 2.days.ago) }
        let!(:post4) { create(:post, user: user, content: 'Fourth post (newest)', created_at: 1.day.ago) }
        let!(:post5) { create(:post, user: user, content: 'Fifth post (oldest)', created_at: 10.days.ago) }

        it 'displays recent posts section' do
          get root_path
          expect(response.body).to include('あなたの最新投稿')
        end

        it 'displays only the 3 most recent posts' do
          get root_path
          
          # 最新3件の投稿が含まれていることを確認
          expect(response.body).to include('Fourth post (newest)')
          expect(response.body).to include('Third post')
          expect(response.body).to include('Second post')

          # 4番目以降の投稿は含まれていないことを確認
          expect(response.body).not_to include('First post')
          expect(response.body).not_to include('Fifth post (oldest)')
        end

        it 'displays posts in descending order by created_at' do
          get root_path
          
          # レスポンスボディから投稿の順序を確認
          fourth_position = response.body.index('Fourth post (newest)')
          third_position = response.body.index('Third post')
          second_position = response.body.index('Second post')
          
          expect(fourth_position).to be < third_position
          expect(third_position).to be < second_position
        end
      end
    end
  end
end

