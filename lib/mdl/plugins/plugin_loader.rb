def load_plugins(spec)
  return unless File.exist?("#{Dir.home}/.markdownlint/plugin_config")
  config = YAML.load_file("#{Dir.home}/.markdownlint/plugin_config")
  plugins = config.fetch('plugins', [])
  plugins.each do |p|
    spec.add_dependency(p.fetch('gem'))
  rescue => e
    puts "gem failed #{e.inspect}"
  ensure
    next
  end
rescue => e
  puts "failed to load plugins #{e.inspect}"
end
