require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end
  
	test 'invalid edit information' do
		log_in_as @user
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), user: {name: "", email: "user@invalid", password: "foo", password_confirmation: "bar"}
		assert_template 'users/edit'
	end

	test 'valid edit information with friendly forwarding' do
		name = "ex"
		email = "user@ex.com"
		get edit_user_path(@user)
		assert_redirected_to login_path #*** not originally there 
		log_in_as @user
		assert_redirected_to edit_user_path(@user)
		assert_nil session[:forwarding_url]
		patch user_path(@user), user: {name: name, email: email, password: "", password_confirmation: ""}
		assert flash[:success]
	  assert_redirected_to @user
	  @user.reload
	  assert_equal name, @user.name
	  assert_equal email, @user.email
	end
end
