
# ethereum-login

## Foreword
Typically, websites and apps use email addresses as digital identifiers in apps.  These are paired with passwords or with OAuth to validate ownership.  This creates many headaches including password management (bad for users and for developers, great for hackers) and including reliance on third party servers.  

However, it is now easy to ditch emails and passwords and instead provide a more elegant, safer, and simpler option.  Many more online users are creating Ethereum accounts every day.  These accounts can 'securely sign' in order to prove their identity using a web3.js function called personal_sign.  This can be used as the basis for an authentication system for websites; one that doesn't even need to talk to the blockchain or to an API but can rely simply on mathematics (similar to SSL key authentication but managed by metamask).

## Intro
Allow users to authenticate themselves to your websites and apps  without relying on passwords and without relying on a centralized corporation such as Google, Twitter or Facebook.  Instead, users can use an Ethereum account that they control.  
  
Those users will need to use a plugin such as Metamask or a browser such as Mist in order to authenticate themselves in this way.  Any web3 enabled browser will work.  There are many advantages including:


* No need to locally store user passwords, only sessions
* No need to include 'reset password' functions
* No need to store API keys for Oauth services
* No reliance on an external corporation whose API could go down at any time, grinding your app to a halt


Codepen for buttons:
https://codepen.io/admazzola/pen/LOgpOV

Sample implementation: (client side only)
http://starflask.com/ethereum-login/index.html

## Fundamentals

This methodology uses a button to call the web3 'personal sign' function.  This sends a challenge to the browser (metamask/mist) and a popup will appear for the user which they can choose to Accept/Sign.  Their response can be checked against your challenge in order to validate that the user controls the private key for their given public address.  This validated public address can be used as a persistent identity for that user across your application. 

## Why use Ethereum for Authentication

1. Passwords are a major security flaw of the modern web.   Most website developers do not implement password storage properly i.e. do not salt or encrypt passwords which leaves treasure troves of plaintext passwords for hackers.   
2. By using central authorities for OAuth, you and your users and freely sacrificing all privacy and usage rights to that authority.  This is a decentralized solution so the user remains in control of their own data (which sites they have logged in to.) 
3. This does not require running an Ethereum node on your server, but you can.  This only uses offline ECDSA mathematics to validate that the client controls the private key to a given public address.  The private key is never revealed by the client and should never be revealed under any circumstance.    

## Backend validation

Once the metamask response signature is returned, it should be sent to the server backend (this example uses AJAX for this) so that the server can extract the validated public address from the signature, log in the user, and create a new record for the user in the app's database if one does not already exist.  Some example backend controller methods will be provided here:

https://github.com/admazzola/ethereum-login/tree/master/server-examples

----------

This whole implementation is based off of this metamask technology: 
https://medium.com/metamask/the-new-secure-way-to-sign-data-in-your-browser-6af9dd2a1527


This is compatible with metamask 3.12.0

(This project is not directly affiliated with the ethereum foundation, it is open source.)

#### Note: This has not undergone security analysis yet.  The web3 protocol is also still under development. 


## Other literature/similar projects
https://github.com/metamask/eth-sig-util
