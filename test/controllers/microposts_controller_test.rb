require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

	def setup
		@micropost = microposts(:orange)
	end
	
	test 'must be logged in before create or destroy' do
		assert_no_difference 'Micropost.count' do
			post :create, micropost: { content: "example" }
		end
		assert_redirected_to login_url
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: @micropost
		end
		assert_redirected_to login_url
	end

	test 'should redirect destroy for wrong micropost' do
		log_in_as users(:michael)
		micropost = microposts(:ants)
		assert_no_difference 'Micropost.count' do
			delete :destroy, id: micropost
		end
		assert_redirected_to root_url
	end

end
