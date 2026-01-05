@home = ENV['HOME']

# Load all install scripts
Dir.glob('install_*.rb').each do |file|
  load "./#{file}"
end

