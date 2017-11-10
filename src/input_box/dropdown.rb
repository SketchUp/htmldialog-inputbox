require 'json'

require 'input_box/input'


module Example::HtmlInputBox
  module HtmlUI

    class Dropdown < Input

      def initialize(label, default = nil, options = [])
        super(label: label, default: default, options: options)
      end

    end # class

  end # module
end # module
