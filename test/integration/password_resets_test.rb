require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
 
	def setup
		ActionMailer::Base.deliveries.clear
		@user = users("michael")
	end

  test "" do
  	get new_password_reset_path
  	assert_template 'password_resets/new'
  	post password_resets_path, password_reset: { email: "email@invalid" }
  	assert_not flash.empty?
  	assert_template 'password_resets/new'
  	assert_equal 0, ActionMailer::Base.deliveries.size
  	post password_resets_path, password_reset: { email: @user.email }		
  	assert_not_equal @user.reset_digest, @user.reload.reset_digest
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	assert_not flash.empty?
  	assert_redirected_to root_url

  	user = assigns(:user)
  	get edit_password_reset_path(user.reset_token, email: "")
  	assert_redirected_to root_url
  	user.toggle!(:activated)
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_redirected_to root_url
  	user.toggle!(:activated)
  	get edit_password_reset_path("wrong token", email: user.email)
  	assert_redirected_to root_url
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_template 'password_resets/edit'
  	assert_select "input[name=email][type=hidden][value=?]", user.email
  	patch password_reset_path(user.reset_token), email: user.email, 
  																							 user: { password: "foobar", password_confirmation: "foobaz" }
  	assert_select "div#error_explanation"
  	patch password_reset_path(user.reset_token), email: user.email, 
  																							 user: { password: "", password_confirmation: "" }
  	assert_select "div#error_explanation"
  	patch password_reset_path(user.reset_token), email: user.email, 
  																							 user: { password: "foobar", password_confirmation: "foobar" }
  	assert_not flash.empty?
  	assert_redirected_to user
  	assert is_logged_in?
  end
end
