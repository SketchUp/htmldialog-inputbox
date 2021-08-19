require 'sketchup.rb'

require 'input_box/debug'
require 'input_box/html_ui'
require 'input_box/input/checkbox'
require 'input_box/input/dropdown'
require 'input_box/input/listbox'
require 'input_box/input/textbox'


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
    prompts = ['What is your name?', 'What is your age?', 'Pet?']
    defaults = ['Enter name', 42, 'None']
    results = HtmlUI.inputbox(prompts, defaults, title)
    p results
  end

  # Simple example with similar calling signature as UI.inputbox.
  def self.prompt_with_options
    title = 'Tell me about yourself'
    prompts = ['What is your Name?', 'What is your age?', 'Pet?']
    defaults = ['Enter name', 42, 'Cat']
    list = ['', '', 'None|Cat|Dog|Other']
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
        HtmlUI::Dropdown.new('Pet', 'Cat', [
          'None', 'Cat', 'Dog', 'Parrot (Resting)', 'Other'
        ]),
        HtmlUI::Listbox.new('Profession', 'Minion', [
          'None', 'Architect', 'Urban Planner', 'Model Railroad Designer', 'Other'
        ]),
        HtmlUI::Checkbox.new('Married', false),
        HtmlUI::Checkbox.new('Retired', true),
      ]
    }
    dialog = HtmlUI::InputBox.new(options)
    results = dialog.prompt
    p results
  end

  def self.reload
    t = Time.now
    original_verbose = $VERBOSE
    $VERBOSE = nil
    x = Dir.glob(File.join(PATH, '**/*.rb')).each { |file|
      load file
    }
    x.size
  ensure
    $VERBOSE = original_verbose
  end

end # module
