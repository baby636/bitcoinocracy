class Signature < ActiveRecord::Base
  self.primary_key = 'signature'

  belongs_to :argument
  belongs_to :bitcoin_address

  scope :ordered_by_value, -> {
    joins(:bitcoin_address).order('bitcoin_addresses.balance desc')
  }

  validates_with SignatureValidator

  # scope :pro, where is_negation?: false
  # scope :con, where is_negation?: true

  def message
    if negation?
  		argument.con_statement
  	else
  		argument.pro_statement
  	end
  end

  def signature_address
	  @signature_address || BitcoinCigs::get_signature_address(signature, message)
  end

  def create_bitcoin_address_if_needed
    if signature_address
      if btc_addr = BitcoinAddress.find_by_bitcoin_address(signature_address)
        self.bitcoin_address_id = btc_addr.id
      else
        res = BitcoinAddress.fetch_balance(signature_address)
        if (balance=res.to_i) > 0
          btc_addr = BitcoinAddress.create({bitcoin_address: signature_address, balance: balance })
          self.bitcoin_address_id = btc_addr.id
        end
      end
    end
  end

  def to_s
    signature
  end

end
