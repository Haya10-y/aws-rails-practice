# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'validations' do
    context 'content' do
      it 'allows content up to 200 characters' do
        post = build(:post, user: user, content: 'a' * 200)
        expect(post).to be_valid
      end

      it 'does not allow content over 200 characters' do
        post = build(:post, user: user, content: 'a' * 201)
        expect(post).to be_invalid
        expect(post.errors[:content]).to include('is too long (maximum is 200 characters)')
      end

      it 'allows blank content if image is attached' do
        post = build(:post, user: user, content: '')
        post.image.attach(
          io: Rails.root.join('spec', 'fixtures', 'files', 'test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/png'
        )
        expect(post).to be_valid
      end
    end

    context 'content or image presence' do
      it 'is invalid when both content and image are blank' do
        post = build(:post, user: user, content: '')
        expect(post).to be_invalid
        expect(post.errors[:base]).to include('Content or image must be present')
      end

      it 'is invalid when content is nil and no image' do
        post = build(:post, user: user, content: nil)
        expect(post).to be_invalid
        expect(post.errors[:base]).to include('Content or image must be present')
      end

      it 'is valid when content is present and no image' do
        post = build(:post, user: user, content: 'Valid content')
        expect(post).to be_valid
      end

      it 'is valid when content is blank but image is attached' do
        post = build(:post, user: user, content: '')
        post.image.attach(
          io: Rails.root.join('spec', 'fixtures', 'files', 'test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/png'
        )
        expect(post).to be_valid
      end

      it 'is valid when both content and image are present' do
        post = build(:post, user: user, content: 'Valid content')
        post.image.attach(
          io: Rails.root.join('spec', 'fixtures', 'files', 'test_image.png').open,
          filename: 'test_image.png',
          content_type: 'image/png'
        )
        expect(post).to be_valid
      end
    end
  end
end
