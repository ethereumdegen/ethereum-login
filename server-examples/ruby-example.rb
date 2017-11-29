#This is a sample method that would be used in a Ruby on Rails Controller.  
#This assumes that you have a basic understanding of Ruby on Rails. If you have implemented Devise or Sorcery this is similar but easier overall.  


#gems that are used: (add to GEMFILE)
# gem 'ruby-ethereum'
# gem 'ethereum.rb'

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


#This method reads the AJAX request from the javascript sample and validate that the client's public key matched the public key that is recovered from their response to your challenge 

#THIS HAS NOT BEEN TESTED AND IS NOT 100% SECURE


def auth_into_eth_address
    
    #read the input data provided by the AJAX method from ethereum-login.js 
    #this data ultimately came from the client's metamask and represents their personal_sign output 
    web3_signature = params[:signature]
    web3_signature_v = params[:signature_v].to_i(16)
    web3_signature_r = params[:signature_r].to_i(16)
    web3_signature_s = params[:signature_s].to_i(16)
    challenge_hash = Ethereum::Utils.decode_hex(params[:challenge] ) 
  
    verified_public_address = recover_verified_public_address_from_signature(web3_signature_v,web3_signature_r,web3_signature_s,challenge_hash)

     p 'authing in with pub addr '
     p verified_public_address    

    #optionally log the user into a session
    #session[:current_public_address] = verified_public_address
    
  
    # optionally log the user into a database record (similar to devise,sorcery etc)
     existing_user = User.find_by(public_address: verified_public_address)
  
     if(existing_user != nil)
       session[:user_id] = existing_user.id
     else 
       created_user = User.create(public_address: verified_public_address)
       session[:user_id] = created_user.id
     end 
      
    
    #One the user is logged in you can either redirect to another page 
     #alert[:flash] = "Logged in!"
     #redirect_to :root_path
  
    #Or you can simply return JSON to the AJAX request and have that client-side function perform a redirect 
    respond_to do |format|

      #format.html # show.html.erb
      format.json { render json: {success:true, verified_public_address: verified_public_address }  }

     end

  end


def recover_verified_public_address_from_signature(web3_signature_v,web3_signature_r,web3_signature_s,challenge_hash)
    #Use the data to recover the public key and then the public address
    vrs_data = [web3_signature_v,web3_signature_r,web3_signature_s]

    public_key_raw =  Ethereum::Secp256k1.recover_pubkey(challenge_hash, vrs_data , compressed: false)

    public_key_hex =  Ethereum::Utils.encode_hex( public_key_raw )

    public_key = Ethereum::PublicKey.new(  public_key_hex)
     
    # it is important to note here that because we 'recovered' this public address from the metamask challenge response, 
    #then that proves to us that the client must know the private key that corresponds to this public address.  
    #That is the basis for this entire authentication method and that is why it is called 'verified_public_address' in this instance
    verified_public_address = Ethereum::Utils.encode_hex( public_key.to_address )
    
     if !verified_public_address.start_with?("0x")
      verified_public_address = "0x" + verified_public_address
    end
    
    return verified_public_address
end 



#This is an optional helper method similar to the one that devise provides. 
#Use this throughout the app to check if the user is logged in and to load/save data to/from their user record 
def current_user 
  if session[:user_id]
    current_user = User.find_by(id: session[:user_id])
    
    if current_user 
      return current_user 
    end 
  end 
  
  return nil #not logged in 
end 
