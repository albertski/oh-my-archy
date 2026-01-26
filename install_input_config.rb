# install_input_config.rb

require 'fileutils'

class InputConfigCustomizer
  CONFIG_DIR  = "#{ENV['HOME']}/.config/hypr".freeze
  CONFIG_FILE = File.join(CONFIG_DIR, 'input.conf').freeze

  # Define your custom input settings here as an array of hashes
  # Add new ones anytime — just follow the pattern
  #
  # section: nil for root input{} block, or "touchpad" for touchpad{} block
  CUSTOM_SETTINGS = [
    {
      description: "natural scrolling (macOS-style)",
      setting:     "natural_scroll = true",
      section:     "touchpad"
    }
  ].freeze

  def initialize
    @modified_count = 0
  end

  def apply!
    unless File.exist?(CONFIG_FILE)
      puts "Input config not found: #{CONFIG_FILE}"
      return
    end

    @content = File.read(CONFIG_FILE)

    CUSTOM_SETTINGS.each do |entry|
      apply_setting(entry)
    end

    summarize_result
  end

  private

  def apply_setting(entry)
    setting = entry[:setting]
    description = entry[:description]
    section = entry[:section]

    commented = "# #{setting}"

    if @content.include?(commented)
      # Uncomment existing setting
      @content.gsub!(commented, setting)
      save_config
      puts "Enabled: #{description}"
      @modified_count += 1
    elsif @content.include?(setting)
      puts "Already enabled: #{description}"
    else
      # Add new setting to appropriate section
      section_marker = section ? "#{section} {" : "input {"

      if @content.include?(section_marker)
        @content.gsub!(/#{Regexp.escape(section_marker)}/, "#{section_marker}\n    #{setting}")
        save_config
        puts "Added: #{description}"
        @modified_count += 1
      else
        puts "Could not find #{section_marker} block in input.conf"
      end
    end
  end

  def save_config
    File.write(CONFIG_FILE, @content)
  end

  def summarize_result
    if @modified_count.zero?
      puts "All input settings are already up to date."
    else
      puts "#{@modified_count} input setting(s) modified successfully."
      puts "Reload Hyprland with: hyprctl reload"
    end
  end
end

# Run the customizer
InputConfigCustomizer.new.apply!
