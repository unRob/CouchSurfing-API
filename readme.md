This is a simple CouchSurfing API
=================================

This a unofficial CS API client written in Ruby.

Using this client will likely result in a **violation of [Couchsurfing's TOS](https://www.couchsurfing.org/n/terms)**. I have contacted the [tech team](https://support.couchsurfing.org/hc/en-us/requests/new?category=support) as well as the [twitter](https://twitter.com/couchsurfing) folks to ask for permission of any sort to use the API, but I've yet to hear back from them.

The API was reverse-engineered, and if you'd like some pointers on that, please read [unRob/CouchSurfing-API#2](https://github.com/unRob/CouchSurfing-API/pull/2#issuecomment-16404056).

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

(C) 2012 Roberto Hidalgo <un@rob.mx>,  Those listed at CONTRIBUTORS

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.
