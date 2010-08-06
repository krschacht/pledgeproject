module PledgesHelper

  def pledge_field( p, f )
    eval "p.#{f}"
  end
end
