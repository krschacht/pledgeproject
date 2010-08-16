class TinyUrl < ActiveRecord::Base

  def self.for( url )
    chars = %w[ 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z ]
    key = 6.times.collect { chars[ rand( chars.length ) ] }.to_s
    
    t = self.create( :key => key, :url => url )
    
    "#{ App.url_base }url/#{ t.id }-#{ t.key }"
  end
  
  def self.lookup( params = { :id => 0, :key => 'abc' } )
    id = params[:id]
    key = params[:key]
    
    t = self.find( id )
    
    if t.key == key
      t.url
    else
      '/'
    end
  end
  
end
