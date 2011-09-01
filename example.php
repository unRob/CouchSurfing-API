<pre><?
error_reporting(E_ALL ^ E_NOTICE);
require 'couchsurfing.php';

$username = 'myusername';
$password = 'mypassword';

session_start();
//If you want to test how to break things, please logout first!
//session_destroy(); exit;

//Log-in, or at least try to:
$cs = new CouchSurfing($_SESSION['cookie']);


//Are we logged in?
if( !isset($_SESSION['cookie']) ){
	$success = $cs->login($username, $password);
	if( $success ){
		//Did we successfully log-in?
		$_SESSION['cookie'] = $cookie;
	} else {
		//Not.
		die("$username couldn't login!");
	}
	
}

//Get all the hosting requests
$requests = $cs->getRequests();
//and pick the second one
$second = next($requests);

//get detailed information about this request
$request = $cs->getRequest($second->id);
//and print the resulting array
print_r($request);