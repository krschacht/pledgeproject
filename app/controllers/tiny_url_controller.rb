class TinyUrlController < ApplicationController
  
  def index
    id, key = params[:id].split('-')
        
    redirect_to TinyUrl.lookup( :id => id, :key => key )
  end

end
