require 'test_helper'

class DataGroupsControllerTest < ActionController::TestCase

  tests Census::DataGroupsController
  
  should_route :get, '/census/admin',
    :controller => 'census/data_groups', :action  => 'index'

  should_route :get, '/census/data_groups/new',
    :controller => 'census/data_groups', :action  => 'new'

  should_route :post, '/census/data_groups',
    :controller => 'census/data_groups', :action  => 'create'
  
  should_route :get, '/census/data_groups/1/edit',
    :controller => 'census/data_groups', :action  => 'edit', :id => '1'

  should_route :put, '/census/data_groups/1',
    :controller => 'census/data_groups', :action  => 'update', :id => '1'

  should_route :delete, '/census/data_groups/1',
    :controller => 'census/data_groups', :action  => 'destroy', :id => '1'

  should_route :put, '/census/data_groups/sort',
    :controller => 'census/data_groups', :action  => 'sort'

  context 'The Census::DataGroupsController' do
    
    context 'using GET to index' do
    
      setup do
        @group = Factory(:data_group)
        get :index
      end
    
      should_respond_with               :success
      should_respond_with_content_type  :html
      should_render_template            :index
      should_assign_to                  :data_groups
    
    end
    
    context 'using GET to new' do
    
      setup do
        get :new
      end
    
      should_respond_with               :success
      should_respond_with_content_type  :html
      should_render_template            :new
      should_assign_to                  :data_group
    
      should 'have a new data group record' do
        assert assigns(:data_group).new_record?
      end
    
    end
  
    context 'using POST to create' do
    
      context 'with invalid attributes' do
      
        setup do
          DataGroup.any_instance.stubs(:valid?).returns(false)
          post :create, :data_group => Factory.attributes_for(:data_group)
        end
      
        should_respond_with               :unprocessable_entity
        should_respond_with_content_type  :html
        should_render_template            :new
        should_assign_to                  :data_group
      
        should 'not create the data group' do
          assert assigns(:data_group).new_record?
        end
      
      end
    
      context 'with valid attributes' do
      
        setup do
          post :create, :data_group => Factory.attributes_for(:data_group)
        end
      
        should_respond_with       :redirect
        should_assign_to          :data_group
        should_redirect_to('census admin page') { census_admin_url }
      
        should 'create the data group' do
          assert !assigns(:data_group).new_record?
        end
      
      end
    
    end
  
    context 'using GET to edit' do
    
      setup do
        @group = Factory(:data_group)
        get :edit, :id => @group.to_param
      end
    
      should_respond_with               :success
      should_respond_with_content_type  :html
      should_render_template            :edit
      should_assign_to(:data_group) { @group }
    
    end
  
    context 'using PUT to update' do
    
      context 'with valid attributes' do
      
        setup do
          @group = Factory(:data_group)
          put :update, :id => @group.to_param, :data_group => {:name => 'CHANGED'}
        end
      
        should_respond_with           :redirect
        should_assign_to(:data_group) { @group }
        should_redirect_to('census admin page') { census_admin_url }
      
        should 'update the data group' do
          assert_equal('CHANGED', @group.reload.name)
        end
      
      end
    
      context 'with invalid attributes' do
      
        setup do
          @group = Factory(:data_group)
          DataGroup.any_instance.stubs(:valid? => false)
          put :update, :id => @group.to_param, :data_group => {:name => 'CHANGED'}
        end
      
        should_respond_with               :unprocessable_entity
        should_respond_with_content_type  :html
        should_assign_to(:data_group)     { @group }
        should_render_template            :edit
      
      end
    
    end
  
    context 'using DELETE to destroy' do
    
      setup do
        @group = Factory(:data_group)
        delete :destroy, :id => @group.to_param
      end
    
      should_respond_with             :redirect
      should_assign_to(:data_group)   { @group }
      should_redirect_to('census admin page') { census_admin_url }
    
      should 'destroy the data group' do
        assert_nil(DataGroup.find_by_id(@group.id))
      end
    
    end

    context 'using PUT to sort' do
    
      setup do
        @group_a = Factory(:data_group, :position => 1)
        @group_b = Factory(:data_group, :position => 2)
        @group_c = Factory(:data_group, :position => 3)
        put :sort, :data_group => [@group_b.id.to_s, @group_a.id.to_s, @group_c.id.to_s]
      end
    
      should_respond_with               :success
      should_respond_with_content_type  :html
    
      should 'rearrange the data groups' do
        assert_equal @group_b, DataGroup.all[0]
        assert_equal @group_a, DataGroup.all[1]
        assert_equal @group_c, DataGroup.all[2]
      end
    
    end
    
  end
  
end
