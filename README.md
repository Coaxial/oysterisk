This is the Asterisk dialplan my partner and I are using to stay in touch with our families in Europe. All variables in the dialplan and the sip.conf file have been obfuscated.

It has several uses:
1. Processes calls received on a Polish DID
2. Waits for callback requests using a Canadian DID
3. Allows us to place international calls using either a PSTN connected phone or a SIP connection
4. Provides recording features for our calls
5. Handles the callback requests from webpages

I will briefly explain each usages.

Polish DID:
-----------
My partner has all of her family and friends in Poland, we needed a way for them to connect and call each other at reasonable rates. Thus, we registered a DID billed as a local call in Poland for the relatives to dial.
Once the call is established, Asterisk determines whether this number is in the authorized callers list using the information stored in the AstDB.
If the caller is not recognized, it plays a message stating the error and hangs up.
If the caller is recognized, Asterisk proceeds on checking what time it is where we live. If the call is received outside of our daytime hours, a prompt is played informing the caller what the current time is and asks the caller to confirm she would like to go ahead.
The CallerID is set to the relative calling (fetched from the AstDB) and my partner's mobile phone is dialled along with the residential phone we have in our flat that is connected to an ATA. Whichever is picked up first gets the call.
Although CallerID is reliable in 99% of the calls, I implemented a missed call notification using Notify My Android in case the caller hangs up before my partner answers, before reaching the voicemail or calls outside the daytime hours and chooses not to go through.

Canadian DID:
-------------
I set up a number for us to call either from our mobile phones when it is not practical to use a SIP client over the data connection or if we need to call from another phone than our mobile.
When the number is rung, Asterisk saves the CallerID(num) and hangs up the call with a busy tone without ever picking up to avoid charges for the calling party and allow for international callback requests.
Asterisk then checks if the retrieved CallerID(num) is one of our mobile phones. If not, it checks whether this number has failed to authenticate on previous callbacks. If it did, Asterisk discards the callback request to avoid wasting money calling back autodialers or wrong numbers.
If the call came from one of our mobile phones, Asterisk calls back, prompts us for the number to call and bridges the call while sending our mobile phones' CallerID.
If the call came from an unrecognized phone, it calls back and prompts for a user number and a PIN. If these two match then Asterisk prompts for the number to call and bridges the call using our respective CallerIDs.
When the call finishes, Asterisk prompts the caller for another number to dial if need be.

PSTN or SIP:
------------
We can also register on the PBX and place calls using the softphones on our mobile phones, computers or using the residential phone connected to the ATA in our flat.

Call features:
--------------
- Whenever required, the user can press *5 and trigger a recording of the call. When the recording is stopped at anytime during the call using *5 again or when the called party hangs up, Asterisk converts the recording to mp3 and emails it to the user along with the time of the call and the numbers dialled.
- The user can also press *9 during a call to hang up the dialled number and be prompted for a new number to call.
- After every call, a notification is sent to the user's mobile phone using Notify My Android stating the total call cost and how much money is left on our account with the SIP provider.
- After a valid number has been entered and before dialling the number, Asterisk fetches the per minute rate for that destination and informs the caller of the rate. Asterisk also reminds the user of the available features (i.e. *5 and *9)

Web callback:
-------------
I am working on my personal website where I intend to put an interactive version of my CV. When a visitor clicks on my phone number on my CV, she will be asked to enter her phone number. The webpage then makes an ajax call to a PHP script (available here: https://github.com/Coaxial/click2call) triggering the callback.

For the TTS, I am using googletts.agi which retrieves the sentences from the Google Translate TTS engine. It can speak virtually any language and the talking speed can be adjusted.
The Notify My Android notifications are sent using the service's API with a HTTP POST request.
The calling rates are retrieved using the SIP provider's API also with HTTP POST requests.
To originate the web callback, I am using a TLS encrypted TCP socket to Asterisk using AMI.