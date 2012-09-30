This is a simple CouchSurfing API
=================================

This used to be a PHP app, but I just changed my mind and went with Ruby instead. I'll probably make a PHP version soon

##Example
See [example.rb](https://github.com/unRob/CouchSurfing-API/blob/master/example.rb)

##Requirements
* HTTParty
* Nokogiri

##Installation
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

##License
Permission is hereby granted, free of charge, to any person obtaining a copy of this software
Licensed under The MIT License and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Redistributions of files must retain the above copyright notice.