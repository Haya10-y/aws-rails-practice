# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create sample users
users_data = [
  {
    name: 'User One',
    email: 'someone@example.com',
    password: 'Password1',
    password_confirmation: 'Password1'
  },
  {
    name: 'User Two',
    email: 'someone2@example.com',
    password: 'Password2',
    password_confirmation: 'Password2'
  },
  {
    name: 'User Three',
    email: 'someone3@example.com',
    password: 'Password3',
    password_confirmation: 'Password3'
  }
]

users_data.each do |user_data|
  user = User.find_or_initialize_by(email: user_data[:email])
  if user.new_record?
    user.assign_attributes(user_data)
    user.skip_confirmation! # Skip email confirmation for seed data
    user.save!
    puts "Created user: #{user.email}"
  else
    puts "User already exists: #{user.email}"
  end
end
