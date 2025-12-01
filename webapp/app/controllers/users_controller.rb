# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def mypage; end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end
end
