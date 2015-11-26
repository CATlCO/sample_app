require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end
  
  test "micropost interface" do
  	log_in_as @user
  	get root_path
  	assert_select 'div.pagination'
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, micropost: { content: " " }
  	end
  	assert_template 'static_pages/home'
  	assert_select 'div#error_explanation'
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, micropost: { content: "testing" }
  	end
  	assert_redirected_to root_path
  	follow_redirect!
  	assert_match "testing", response.body
  	assert_select 'a', text: 'delete'
  	assert_difference 'Micropost.count', -1 do
  		delete micropost_path @user.microposts.first
  	end
  	follow_redirect!
  	get user_path(users(:archer))
  	assert_select 'a', text: 'delete', count: 0
  end

end
