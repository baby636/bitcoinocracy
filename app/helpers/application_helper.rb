module ApplicationHelper
	def bch_human(satoshis, options = {prefix: '', suffix: '&nbsp;BCH'} )
    "#{options[:prefix]}%.8f#{options[:suffix]}".html_safe % (1.0*satoshis.to_i/1e8)
	end

  def usd_human(dollars, hide_cents_threshold=100_000)
    number_to_currency(dollars, precision: dollars.abs < hide_cents_threshold ? 2 : 0)
  end

  def bch2usd(satoshis)
    satoshis * BitcoinPrice.get / 1e8
  end

	def bch_human_spaced(satoshies, options = {prefix: '', suffix: ' BCH'} )
		number_to_currency(1.0*satoshies.to_i/1e8, unit: options[:suffix], precision: 8, delimiter: " ", format: "%n %u").html_safe
	end

  def percent_human(x)
    if x.present?
      "(%.2f%%)" % (100.0*x)
    else
      ""
    end
  end

  def argument_details(argument)
    "Updated #{time_ago_in_words(argument.updated_at)} ago"
  end

end
