require 'json'

require 'input_box/input'


module Example::HtmlInputBox
  module HtmlUI

    class Textbox < Input

      def initialize(label, default = nil)
        super(label: label, default: default)
      end

    end # class

  end # module
end # module
