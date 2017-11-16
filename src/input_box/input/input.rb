require 'json'


module Example::HtmlInputBox
  module HtmlUI

    class Input

      def initialize(label: '', default: nil, options: [])
        @label = label
        @default = default
        @options = options
      end

      def as_json(options = {})
        {
          label: @label,
          value: @default || '',
          default: @default,
          options: @options,
          type: self.class.name.downcase.split('::').last
        }
      end

      def to_json(*options)
        as_json(*options).to_json(*options)
      end

    end # class

  end # module
end # module
