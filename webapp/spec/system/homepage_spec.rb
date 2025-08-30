# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Application', type: :system do
  it 'renders the health check page' do
    visit rails_health_check_path
    expect(page).to have_http_status(200)
  end

  it 'can access the sign up page' do
    visit new_user_registration_path
    expect(page).to have_content('Sign up')
  end
end
