# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  # Associations
  has_many :posts, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 8 },
                       format: {
                         with: /\A(?=.*[a-z])(?=.*[A-Z]).+\z/,
                         message: 'must contain at least one lowercase and one uppercase letter'
                       },
                       on: :create
  validates :password, length: { minimum: 8 },
                       format: {
                         with: /\A(?=.*[a-z])(?=.*[A-Z]).+\z/,
                         message: 'must contain at least one lowercase and one uppercase letter'
                       },
                       on: :update, allow_blank: true
end
