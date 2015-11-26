require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end
  
  test "micropost interface" do
  	log_in_as @user
  	get root_path
  	assert_select 'div.pagination'
    assert_select 'input[type=file]'
  	assert_no_difference 'Micropost.count' do
  		post microposts_path, micropost: { content: " " }
  	end
  	assert_template 'static_pages/home'
  	assert_select 'div#error_explanation'
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, micropost: { content: "testing", picture: picture }
  	end
    assert assigns(:micropost).picture?
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

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end

end
