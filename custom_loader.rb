ENV["RAILS_ENV"] = "development"

[
  "active_record/railtie",
].each do |railtie|
  begin
    require railtie
  rescue LoadError
  end
end

Racecar.config.load_file("config/racecar.yml", "development")
ENV["RACECAR_CONSUMER"] = "true"

INITIALIZERS_EXCLUDED = [:load_config_initializers]
Rails::Application.class_eval do
  def run_initializers(group = :default, *args)
    return if instance_variable_defined?(:@ran)
    initializers.tsort_each do |initializer|
      next if INITIALIZERS_EXCLUDED.include?(initializer.name)
      initializer.run(*args) if initializer.belongs_to?(group)
    end
    @ran = true
  end
end

require "./config/application"

module RacecarLean
  class Application < Rails::Application
    config.eager_load = false
  end
end

Rails.application.initialize!

puts ">" * 80

puts Bumbler::Stats.print_slow_items

puts "<" * 80
sleep 1
