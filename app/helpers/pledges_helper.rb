module PledgesHelper

  def pledge_field( p, f )
    result = eval "p.#{f}"
    result = number_to_currency(result)  if f.to_s =~ /amount/

    result
  end
end
