module Example::HtmlInputBox
  class ArgumentParser

    # @return [Hash]
    def parse(*args)
      if args.size == 1 && args[0].is_a?(Hash)
        get_options_hash(args.first)
      else
        get_options_args(*args)
      end
    end

    private

    # @return [Hash]
    def get_options_hash(options)
      options = {
        title: options[:title],
        accept_button: options[:accept_button],
        cancel_button: options[:cancel_button],
        inputs: options[:inputs].map(&:as_json),
      }
    end

    # @return [Hash]
    def get_options_args(*args)
      unless (1..4).include?(args.size)
        raise ArgumentError, '1 to 4 arguments required'
      end
      # Extract the arguments.
      arguments = {
        title: '',
        prompts: ensure_array(args, 0),
        defaults: [],
        list: [],
      }
      if args.size > 1
        arguments[:defaults] = ensure_array(args, 1)
      end
      title_index = 2
      if args.size > 2 && args[2].is_a?(Array)
        arguments[:list] = args[2].map { |object| object.to_s.split('|') }
        title_index += 1
      end
      if args.size > title_index
        arguments[:title] = args[title_index].to_s
      end
      # Convert to option hash.
      options = {
        title: arguments[:title],
        inputs: [],
      }
      arguments[:prompts].each_with_index { |prompt, index|
        # Label
        input = {
          label: prompt.to_s,
          value: '',
          options: [],
        }
        # Default
        if default = arguments[:defaults][index]
          input[:default] = default
          input[:value] = default
          input[:type] = get_type(default)
        end
        # Options
        if list = arguments[:list][index]
          input[:options] = list
        end
        options[:inputs] << input
      }
      options
    end

    # @param [Object] object
    # @return [String]
    def get_type(object)
      case object
      when Length
        'length'
      when Float
        'float'
      when Integer
        'integer'
      else
        'string'
      end
    end

    # @param [Array] arguments
    # @param [Integer] index
    # @return [Hash]
    def ensure_array(arguments, index)
      unless arguments[index].is_a?(Array)
        raise ArgumentError, "argument #{index} must be an array"
      end
      arguments[index]
    end

  end # class
end # module
