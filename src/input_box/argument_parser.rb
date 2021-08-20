module Example::HtmlInputBox
  # Class that parses the arguments for HtmlUI::InputBox.
  #
  # It process the arguments similar to UI.inputbox as well as offering an
  # alternate variant.
  class ArgumentParser

    # @overload initialize(options)
    #   @param [Hash] options
    #   @option options [String] :title ('')
    #   @option options [Array<Input>] :inputs ([])
    #
    # @overload initialize(prompts, defaults = [], title = '')
    #   @param [Array<String>] prompts
    #   @param [Array<String, Length, Float, Integer>] defaults
    #   @param [String] title
    #
    # @overload initialize(prompts, defaults = [], list = [], title = '')
    #   @param [Array<String>] prompts
    #   @param [Array<String, Length, Float, Integer>] defaults
    #   @param [Array<String>] list
    #   @param [String] title
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

    # Parse arguments similar to UI.inputbox.
    #
    # @overload get_options_args(prompts, defaults = [], title = '')
    #   @param [Array<String>] prompts
    #   @param [Array<String, Length, Float, Integer>] defaults
    #   @param [String] title
    #
    # @overload get_options_args(prompts, defaults = [], list = [], title = '')
    #   @param [Array<String>] prompts
    #   @param [Array<String, Length, Float, Integer>] defaults
    #   @param [Array<String>] list
    #   @param [String] title
    #
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
      # The position of the `title` argument depend on whether the `list`
      # argument is being used.
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
          type: 'textbox',
        }
        # Default
        if default = arguments[:defaults][index]
          input[:default] = default
          input[:value] = default
        end
        # Options
        list = arguments[:list][index]
        if list && !list.empty?
          input[:options] = list
          input[:type] = 'dropdown'
        end
        options[:inputs] << input
      }
      options
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
