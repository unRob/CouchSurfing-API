<pre><?
error_reporting(E_ALL);
require 'couchsurfing.php';

$username = 'myusername';
$password = 'mypassword';

//If you want to test how to break things, please logout first!
//CouchSurfing::logout();

//Log-in, or at least try to:
$cs = new CouchSurfing($username, $password);

//Get all the hosting requests
$requests = $cs->getRequests();
//and pick the second one
$second = next($requests);

//get detailed information about this request
$request = $cs->viewRequest($second->id);
//and print the resulting array
print_r($request);