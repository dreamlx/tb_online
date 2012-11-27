require File.dirname(__FILE__) + '/../test_helper'
require 'receive_amounts_controller'

# Re-raise errors caught by the controller.
class ReceiveAmountsController; def rescue_action(e) raise e end; end

class ReceiveAmountsControllerTest < Test::Unit::TestCase
  fixtures :receive_amounts

  def setup
    @controller = ReceiveAmountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:receive_amounts)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:receive_amount)
    assert assigns(:receive_amount).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:receive_amount)
  end

  def test_create
    num_receive_amounts = ReceiveAmount.count

    post :create, :receive_amount => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_receive_amounts + 1, ReceiveAmount.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:receive_amount)
    assert assigns(:receive_amount).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ReceiveAmount.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ReceiveAmount.find(1)
    }
  end
end
