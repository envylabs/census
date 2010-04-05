module Census
  module Shoulda

    def should_accept_nested_attributes_for(*attr_names)
      klass = self.name.gsub(/Test$/, '').constantize

      context "#{klass}" do
        attr_names.each do |association_name|
          should "accept nested attrs for #{association_name}" do
            meth = "#{association_name}_attributes="
            assert  ([meth,meth.to_sym].any?{ |m| klass.instance_methods.include?(m) }),
                    "#{klass} does not accept nested attributes for #{association_name}"
          end
        end
      end
    end
    
    def should_act_as_list
      klass = self.name.gsub(/Test$/, '').constantize

      context "To support acts_as_list" do
        should_have_db_column('position', :type => :integer)
      end

      should "include ActsAsList methods" do
        assert klass.include?(ActsAsList::InstanceMethods)
      end

      should_have_instance_methods :acts_as_list_class, :position_column, :scope_condition
    end

  end
end

Test::Unit::TestCase.extend(Census::Shoulda)
