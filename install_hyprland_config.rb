# install_hyprland_config.rb

require 'fileutils'

class HyprlandBindingsCustomizer
  CONFIG_DIR  = "#{ENV['HOME']}/.config/hypr".freeze
  CONFIG_FILE = File.join(CONFIG_DIR, 'bindings.conf').freeze

  # Header added when creating a new file
  FILE_HEADER = <<~HEADER.strip
    # Personal Hyprland keybinding overrides
    # This file is sourced last in hyprland.conf
    # Your custom bindings go here — safe from Omarchy updates
  HEADER

  # Define your custom bindings here as an array of hashes
  # Add new ones anytime — just follow the pattern
  CUSTOM_BINDINGS = [
    {
      comment:  "# Custom: Super + A = Select All (macOS-style)",
      binding:  "bindd = SUPER, A, SELECT, sendshortcut, CTRL, A,"
    }
  ].freeze

  def initialize
    @added_count = 0
  end

  def apply!
    ensure_config_file_exists
    append_missing_bindings
    summarize_result
  end

  private

  def ensure_config_file_exists
    FileUtils.mkdir_p(CONFIG_DIR)

    return if File.exist?(CONFIG_FILE)

    File.write(CONFIG_FILE, FILE_HEADER)
    puts "Created new config file: #{CONFIG_FILE}"
  end

  def append_missing_bindings
    current_content = File.read(CONFIG_FILE)

    CUSTOM_BINDINGS.each do |entry|
      next if binding_exists?(current_content, entry[:binding])

      File.open(CONFIG_FILE, 'a') do |f|
        f.puts "\n#{entry[:comment]}"
        f.puts entry[:binding]
      end

      puts "Added: #{entry[:comment].sub('# Custom: ', '').strip}"
      @added_count += 1
    end
  end

  def binding_exists?(content, binding_line)
    content.include?(binding_line)
  end

  def summarize_result
    if @added_count.zero?
      puts "All custom bindings are already up to date."
    else
      puts "#{@added_count} custom binding(s) added successfully."
      puts "Reload Hyprland with: hyprctl reload"
    end
  end
end

# Run the customizer
HyprlandBindingsCustomizer.new.apply!
