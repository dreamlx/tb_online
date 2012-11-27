require File.dirname(__FILE__) + '/../test_helper'
require 'outsourcings_controller'

# Re-raise errors caught by the controller.
class OutsourcingsController; def rescue_action(e) raise e end; end

class OutsourcingsControllerTest < Test::Unit::TestCase
  fixtures :outsourcings

  def setup
    @controller = OutsourcingsController.new
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

    assert_not_nil assigns(:outsourcings)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:outsourcing)
    assert assigns(:outsourcing).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:outsourcing)
  end

  def test_create
    num_outsourcings = Outsourcing.count

    post :create, :outsourcing => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_outsourcings + 1, Outsourcing.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:outsourcing)
    assert assigns(:outsourcing).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Outsourcing.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Outsourcing.find(1)
    }
  end
end
