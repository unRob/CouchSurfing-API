This is a simple CouchSurfing API
=================================

This used to be a PHP app, but I just changed my mind and went with Ruby instead. I'll probably make a PHP version soon

##Example
See [example.rb](https://github.com/unRob/CouchSurfing-API/blob/master/examples/example.rb)

##Requirements
* HTTParty
* Nokogiri

##Installation

As a gem:

	gem install CSApi
	
Or by hand:

    gem install httparty 
	gem install nokogiri
    git clone https://github.com/unRob/Couchsurfing-API


##Currently implemented features

* Look up you current requests
* Get a user's profile, pictures, friends, references
* Create a new couchrequest, but **I have yet to figure out the correct way to address it! The request will most likely go to Casey, so BEWARE**
* Search for users meeting specific criteria (location, can host, has photo, verified, minimum & maximum age, etc.)

##Roadmap

* Reply to CouchRequests

## Contributors

* [Peter Nosko](https://github.com/pnosko) - Search
* [Davit-gh](https://github.com/davit-gh) - Messages


##License
DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
Version 2, December 2004

(C) 2012 Roberto Hidalgo <un@rob.mx>,  Aquellos listados en CONTRIBUTORS

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.