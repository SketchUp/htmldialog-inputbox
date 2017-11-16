require 'json'

require 'input_box/argument_parser'


module Example::HtmlInputBox
  module HtmlUI
    # Class that uses UI::HtmlDialog to create a dialog box that operates
    # similar to UI.inputbox.
    class InputBox

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
      def initialize(*args)
        defaults = {
          title: Sketchup.app_name,
          accept_button: 'Accept',
          cancel_button: 'Cancel',
          inputs: [],
        }
        options = ArgumentParser.new.parse(*args)
        @options = defaults.merge(options)
      end

      # @return [Array]
      def prompt
        results = []
        inputbox_file = File.join(__dir__, 'html', 'inputbox.html')
        window_options = {
          :dialog_title => @options[:title],
          :preferences_key => 'com.example.html-input',
          :scrollable => true,
          :resizable => true,
          :width  => 300,
          :height => 450,
          :min_width  => 230,
          :min_height => 200,
          :max_width  => 1000,
          :style => UI::HtmlDialog::STYLE_DIALOG
        }
        window = UI::HtmlDialog.new(window_options)
        window.set_file(inputbox_file)
        window.add_action_callback('ready') { |action_context|
          json_options = JSON.pretty_generate(@options)
          window.execute_script("app.options = #{json_options}")
        }
        window.add_action_callback('accept') { |action_context, values|
          results = type_convert(@options, values)
          window.close
        }
        window.add_action_callback('cancel') { |action_context|
          window.close
        }
        window.center
        window.show_modal
        results
      end

      private

      def type_convert(options, values)
        values.each_with_index.map { |value, index|
          default = options[:inputs][index][:default]
          case default
          when Length
            value.to_l
          when Float
            value.to_f
          when Integer
            value.to_i
          else
            value.to_s
          end
        }
      end

    end # class

    # Compatibility method for {UI.inputbox}.
    #
    # @overload inputbox(prompts, defaults = [], title = '')
    #   @param [Array<String>] prompts
    #   @param [Array<String, Length, Float, Integer>] defaults
    #   @param [String] title
    #
    # @overload inputbox(prompts, defaults = [], list = [], title = '')
    #   @param [Array<String>] prompts
    #   @param [Array<String, Length, Float, Integer>] defaults
    #   @param [Array<String>] list
    #   @param [String] title
    #
    # @return [Array, false]
    def self.inputbox(*args)
      window = InputBox.new(*args)
      results = window.prompt
      results.empty? ? false : results
    end

  end # module
end # module
