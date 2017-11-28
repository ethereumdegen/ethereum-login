  require 'rlp'
require 'secp256k1'
#require 'ethereum'
require 'ethereum/constant'
require 'ethereum/secp256k1'
require 'ethereum/fast_rlp'
require 'ethereum/utils'
require 'ethereum/public_key'
require 'ethereum/base_convert'
require 'ethereum/address'
require 'ethereum/encoder'




include Ethereum::FastRLP
include Ethereum::Constant
include Ethereum::Utils
include Ethereum::Secp256k1


#http://www.rubydoc.info/gems/ruby-ethereum/0.9.1/Ethereum/Utils#decode_hex-instance_method

#reads the AJAX request from the javascript sample and validate that the client's public key matched the public key that is recovered from their response to your challenge 

#THIS HAS NOT BEEN TESTED AND IS NOT 100% SECURE


def auth_into_eth_address

    web3_signature = params[:signature]
    web3_signature_v = params[:signature_v].to_i(16)
    web3_signature_r = params[:signature_r].to_i(16)
    web3_signature_s = params[:signature_s].to_i(16)


    challenge_hash = Ethereum::Utils.decode_hex(params[:challenge] )

    vrs_data = [web3_signature_v,web3_signature_r,web3_signature_s]


    public_key_raw =  Ethereum::Secp256k1.recover_pubkey(challenge_hash, vrs_data , compressed: false)


    public_key_hex =  Ethereum::Utils.encode_hex( public_key_raw )

    public_key = Ethereum::PublicKey.new(  public_key_hex)

    verified_public_address = Ethereum::Utils.encode_hex( public_key.to_address )

     p 'authing in with pub addr '
     p verified_public_address


    

    if !verified_public_address.start_with?("0x")
      verified_public_address = "0x" + verified_public_address
    end

    #login
    session[:current_public_address] = verified_public_address


    #alert[:flash] = "Logged in to your Punk!"
    #redirect_to :root_path

    respond_to do |format|

      #format.html # show.html.erb
      format.json { render json: {success:true, verified_public_address: verified_public_address }  }

     end

  end
