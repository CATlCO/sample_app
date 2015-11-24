require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
  	@admin = users(:michael)
  	@another = users(:archer)
  end

  test 'index includes pagination and delete links for admin' do
  	log_in_as(@admin)
  	get users_path
  	assert_template 'users/index'
  	assert_select 'div.pagination'
  	User.paginate(page: 1).each do |user|
      #does not display users that has not been activated
      assert user.activated
  		assert_select 'a[href=?]', user_path(user), text: user.name
  		assert_select 'a[href=?]', user_path(user), text: 'delete' unless user == @admin
  	end
  end

  test 'admin should be able to delete user' do
  	log_in_as(@admin)
  	assert_difference 'User.count', -1 do
  		delete user_path(@another)
  	end
  	assert_redirected_to users_path
  end

  test 'index should not include delete links when logged as non-admin' do
  	log_in_as(@another)
  	get users_path
  	assert_select 'a', text: 'delete', count: 0
  end

end
