require 'input_box/input/input'


module Example::HtmlInputBox
  module HtmlUI

    class Checkbox < Input

      def initialize(label, default = false)
        default = !!default # Force boolean value.
        super(label: label, default: default)
      end

    end # class

  end # module
end # module
