# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  # Validations
  validates :content, length: { maximum: 200 }, allow_blank: true
  validate :content_or_image_present

  private

  def content_or_image_present
    if content.blank? && !image.attached?
      errors.add(:base, 'Content or image must be present')
    end
  end
end
