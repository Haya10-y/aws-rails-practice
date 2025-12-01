# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }

  describe 'POST /posts' do
    context 'when user is logged in' do
      before do
        sign_in user
      end

      context 'with valid parameters' do
        it 'creates a new post with content only' do
          expect do
            post posts_path, params: { post: { content: 'Test post content' } }
          end.to change(Post, :count).by(1)

          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq('Post was successfully created.')
        end

        it 'creates a new post with image only' do
          image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), 'image/png')

          expect do
            post posts_path, params: { post: { content: '', image: image } }
          end.to change(Post, :count).by(1)

          expect(response).to redirect_to(root_path)
          expect(Post.last.image).to be_attached
        end

        it 'creates a new post with both content and image' do
          image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png'), 'image/png')

          expect do
            post posts_path, params: { post: { content: 'Test content', image: image } }
          end.to change(Post, :count).by(1)

          expect(response).to redirect_to(root_path)
          expect(Post.last.content).to eq('Test content')
          expect(Post.last.image).to be_attached
        end
      end

      context 'with invalid parameters' do
        it 'does not create a post when both content and image are blank' do
          expect do
            post posts_path, params: { post: { content: '' } }
          end.not_to change(Post, :count)

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create a post when content exceeds 200 characters' do
          expect do
            post posts_path, params: { post: { content: 'a' * 201 } }
          end.not_to change(Post, :count)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post posts_path, params: { post: { content: 'Test content' } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /posts/new' do
    context 'when user is logged in' do
      before do
        sign_in user
      end

      it 'returns http success' do
        get new_post_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get new_post_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
