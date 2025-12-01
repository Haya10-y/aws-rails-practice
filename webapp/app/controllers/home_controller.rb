# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @recent_posts = current_user.posts.order(created_at: :desc).limit(3) if user_signed_in?
  end
end
