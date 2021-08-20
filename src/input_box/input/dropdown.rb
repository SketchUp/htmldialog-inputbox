require 'input_box/input/input'


module Example::HtmlInputBox
  module HtmlUI

    class Dropdown < Input

      def initialize(label, default = nil, options = [])
        if !default.nil? && !options.include?(default)
          raise ArgumentError, 'default value is not a valid option'
        end
        super(label: label, default: default, options: options)
      end

    end # class

  end # module
end # module
