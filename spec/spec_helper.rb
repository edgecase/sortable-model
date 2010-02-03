unless Object.const_defined?(:ActiveRecord)
  module ActiveRecord
    class Base
      def self.named_scope(*args) end
    end
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sortable-model'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end
