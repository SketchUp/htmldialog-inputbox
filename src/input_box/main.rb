require 'sketchup.rb'

require 'input_box/debug'
require 'input_box/html_ui'
require 'input_box/input/textbox'
require 'input_box/input/dropdown'
require 'input_box/input/listbox'


module Example::HtmlInputBox

  unless file_loaded?(__FILE__)
    menu = UI.menu('Plugins').add_submenu('HTML InputBox')
    menu.add_item('HtmlUI.input - Without Options') {
      self.prompt_without_options
    }
    menu.add_item('HtmlUI.input - With Options') {
      self.prompt_with_options
    }
    menu.add_item('HtmlUI.input - Advanced') {
      self.prompt_advanced
    }
    file_loaded(__FILE__)
  end

  # Simple example with similar calling signature as UI.inputbox.
  def self.prompt_without_options
    title = 'Tell me about yourself'
    prompts = ['What is your Name?', 'What is your Age?', 'Gender']
    defaults = ['Enter name', 42, 'Male']
    results = HtmlUI.inputbox(prompts, defaults, title)
    p results
  end

  # Simple example with similar calling signature as UI.inputbox.
  def self.prompt_with_options
    title = 'Tell me about yourself'
    prompts = ['What is your Name?', 'What is your Age?', 'Gender']
    defaults = ['Enter name', 42, 'Male']
    list = ['', '', 'Male|Female']
    results = HtmlUI.inputbox(prompts, defaults, list, title)
    p results
  end

  # Example of how more advanced inputs can be created.
  def self.prompt_advanced
    options = {
      title: 'HtmlDialog Options',
      accept_button: 'Ok',
      cancel_button: 'Cancel',
      inputs: [
        HtmlUI::Textbox.new('Name'),
        HtmlUI::Textbox.new('Age', 42),
        HtmlUI::Dropdown.new('Gender', 'Male', ['Male', 'Female']),
        HtmlUI::Listbox.new('Profession', 'Minion', [
          'None', 'Developer', 'Dictator', 'Minion'
        ]),
      ]
    }
    dialog = HtmlUI::InputBox.new(options)
    results = dialog.prompt
    p results
  end

end # module
