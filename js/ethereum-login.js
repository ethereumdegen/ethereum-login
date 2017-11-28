

function renderError(message)
{
  $('.help-message').html(message)
}

function renderHelp(message)
{
  $('.help-message').html(message)
}


window.addEventListener('load', function() {

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
if (typeof web3 !== 'undefined') {
// Use Mist/MetaMask's provider
      window.web3 = new Web3(web3.currentProvider);





      jQuery(".eth-button").on('click', function(event) {

          renderHelp("Starting personal sign... ")

          handlePersonalSignButtonClick(web3,function(response){
              renderHelp("PERSONAL SIGN WORKED ")

          })

          //send the expected public key, challenge, and signature to the server via Ajax to sign in

       });


  } else {

      renderError('No web3? You should consider trying MetaMask!')

      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      //window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

  }


});


function handlePersonalSignButtonClick(web3,callback)
{

  event.preventDefault();
  console.log('trying to sign')

  var text = "Please sign in to this service"


  var msg = ethUtil.bufferToHex(new Buffer(text, 'utf8'));
//   var msg = '0x1' // hexEncode(text)
  console.log(msg)
  var from = web3.eth.accounts[0];

  var msg_hash = ethUtil.hashPersonalMessage( new Buffer(text, 'utf8') );


      if(typeof from == "undefined")
      {
        alert("Please log in to Metamask")
      }else
      {
        web3.personal.sign(msg, from, function (err, result) {
         if (err) return console.error(err)
         console.log('PERSONAL SIGNED:' + result)

          var success = checkLoginSignature(result,msg_hash)

          if(success)
          {
          callback('success');
          }else {
            console.log(err)
          }

       });
      }


}



function checkLoginSignature(_signature_response_hex,_challenge_digest_hash,callback)
{

  if(typeof _challenge_digest_hash != 'buffer')
  {
    _challenge_digest_hash = Buffer.from(_challenge_digest_hash,'hex')
  }


  var vrs_data = ethUtil.fromRpcSig(_signature_response_hex)


  //message is incorrect length
  var public_key_from_sig = ethUtil.ecrecover(_challenge_digest_hash,vrs_data.v,vrs_data.r,vrs_data.s)
  var public_key_from_sig_hex = public_key_from_sig.toString('hex')
  console.log( public_key_from_sig_hex );



  var address_at_pub_key = ethUtil.publicToAddress(public_key_from_sig);
  var public_address_from_sig_hex = address_at_pub_key.toString('hex');
  console.log( public_address_from_sig_hex );

    console.log( public_address_from_sig_hex );

      console.log('VRS');
      console.log( vrs_data  );

          var vrs_data_integer = {
            v: vrs_data.v.toString(16),
            r: vrs_data.r.toString('hex'),
            s: vrs_data.s.toString('hex')

          }

          console.log( vrs_data_integer );

  var auth_url = "/eth_auth_serverside_validation";
  //Perform the signature challenge verification server side also to make sure our front end isnt being tricked
  //this will also store the clients session on the server (log the client in on the server) for persistance.  Implementation of this depends on the backend but an example as been made for ruby on rails.
    $.ajax({
    url: auth_url,
    method: "POST",
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    data: {
      signature: _signature_response_hex,
       challenge: _challenge_digest_hash.toString('hex'),
       signature_v: vrs_data_integer.v,
       signature_r: vrs_data_integer.r,
       signature_s: vrs_data_integer.s,

     },
   }).success(function(result) {
      console.log(result)

      console.log("authed in properly ");
          callback('success')
    }).done(function() {
      console.log("completed ");

    });




}
