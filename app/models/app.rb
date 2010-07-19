class App
  
  def self.config( name = nil )
    unless defined? @@app
      @@app = {}
    
      app_config_file = "#{Rails.root}/config/application.yml"
      return nil  unless File.exist?( app_config_file )
      @@app = YAML.load(ERB.new(File.read( app_config_file )).result)
      @@app.symbolize_keys!
    end
    
    if name.nil?
      @@app
    else
      @@app[ name.to_sym ]
    end
  end
  
  def self.key( name = nil )
    self.config( name )
  end
  
  def self.method_missing(method_name, *args )
    self.config( method_name.to_sym )
  end
  
end
