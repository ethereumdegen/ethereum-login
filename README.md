
# ethereum-login




Allow users to authenticate themselves to your websites and apps  without relying on a centralized corporation such as Google, Twitter or Facebook.  Instead, users can use an Ethereum account that they control and authenticate with the web3.js library.  

Codepen for buttons:
https://codepen.io/admazzola/pen/LOgpOV



Those users will need to use a plugin such as Metamask or a browser such as Mist in order to authenticate themselves in this way.  However, there are many advantages including:

* Accept payments easily via the Ethereum network
* No need to locally store user passwords, only sessions
* No need to include 'reset password' functions
* No need to store API keys for Oauth services
* No reliance on an external corporation whose API could go down at any time, grinding your app to a halt


# Fundamentals

This methodology uses a button to call the web3 'personal sign' function.  This sends a challenge to the browser (metamask/mist) and a popup will appear for the user which they can choose to Accept/Sign.  Their response can be checked against your challenge in order to validate that the user must control the private key for their given public address.  This validated public address can be used as a persistent identity for that user across your application. 

https://medium.com/metamask/the-new-secure-way-to-sign-data-in-your-browser-6af9dd2a1527


(This project is not directly affiliated with the ethereum foundation, it is open source.)
