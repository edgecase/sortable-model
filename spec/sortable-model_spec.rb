require File.join(File.dirname(__FILE__), 'spec_helper')

describe SortableModel do
  before do
    @model_class = Class.new(ActiveRecord::Base).sortable_model
    @model_class.stub! :reflect_on_association => mock('assoc', :quoted_table_name => '`assoc_table`'),
                       :quoted_table_name => '`model_classes`'
  end

  def define_scope
    @model_class.instance_eval do
      can_sort_by :name
    end
  end

  describe "#sorted_by" do
    it "calls the named scope if it exists" do
      define_scope
      @model_class.should_receive("_sorted_by_name")
      @model_class.sorted_by(:name)
    end

    it "blows up if the sort is not defined" do
      lambda {
        @model_class.sorted_by(:name)
      }.should raise_error(NoMethodError, "Sort condition is not defined: name")
    end
  end

  describe "#can_sort_by" do
    it "delegates to #named_scope" do
      @model_class.should_receive(:named_scope)
      define_scope
    end

    it "works with a simple hash" do
      @model_class.should_receive(:named_scope)
      @model_class.instance_eval do
        can_sort_by :something => :else
      end
    end

    it "can work like a default named_scope" do
      scope = lambda { |x| {:order => x} }
      @model_class.should_receive(:named_scope).with("_sorted_by_foo", scope)
      @model_class.instance_eval do
        can_sort_by :foo, scope
      end
    end
  end
end
