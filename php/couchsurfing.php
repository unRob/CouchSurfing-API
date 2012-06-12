<?
/**
 * Website: https://github.com/unRob/CouchSurfing-API
 * Acknowledge: Partido Surrealista Mexicano (http://partidosurrealista.com/)
 * Contributions by:
 *		None yet
 *
 * Licensed under The MIT License
 * Copyright (c) 2011 Partido Surrealista Mexicano
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * Licensed under The MIT Licenseand associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
 * to whom the Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Redistributions of files must retain the above copyright notice.
 *
 * @author Roberto Hidalgo <rob@partidosurrealista.com>
 * @version 0.1 ($Rev: 4 $)
 * @package Couchsurfing
 * @subpackage API
 */


require 'simplehtmldom.php';
class CouchSurfing {
	
	//Headers to be sent with each request.
	public $headers = array('Cookie' => '', 'Accept-Encoding'=> 'compress, gzip');
	
	
	//Basic sanity checks
	public function __construct($cookie=false)
	{
		error_reporting(E_ALL ^ E_NOTICE);
		
		if( !function_exists('http_request') ){
			die("PECL_HTTP is required for this to work, please 'sudo pecl install http'");
		}
		
		$this->headers['Cookie'] = $cookie;
		
	}
	
	
	/**
	 * Log into the CouchSurfing.org website
	 *
	 * @param	string	$username 
	 * @param	string	$password 
	 * @return	string	$cookies
	 * @author	Roberto Hidalgo
	 */
	public function login($username, $password)
	{
		$headers = array(
			'auth_login[un]' => $username,
			'auth_login[pw]' => $password,
			'auth_login[persistant]' => 'no'
		);
		list($body, $headers) = self::request('login.html', "post", $headers, TRUE);
		
		if( $headers['Location']=='/home.html?login=1' ){

			array_walk($headers['Set-Cookie'], function(&$cookie, $index){
				$c = explode(';', $cookie);
				$cookie = $c[0];
			});


			$cookies = join("; ", $headers['Set-Cookie']);
			#apc_store('cookies', $cookies, 3600*2);
			$this->headers['Cookie'] = $cookies;
			return $cookies;
		} else {
			return FALSE;
		}
	}
	
	
	/**
	 * Get a kind of or all recent requests
	 *
	 * @param	string	$role 
	 * @return	array
	 * @author	Roberto Hidalgo
	 */
	public function getRequests($role='host')
	{
		$body = self::csrequest('couchmanager/a_get_inbox', array('tab'=>'couchrequest', 'role'=>$role));
		$doc = str_get_html($body);
				
		if( count($doc->find('#no_requests_div'))==1 ){
			return array();
		}
		
		$trs = $doc->find('tr.request');
		$requests = array();
		
		foreach($trs as $tr){
			$status = $tr->find('.class_name a');
			$status = $status[0];
			$replied = trim($status->innertext);
			$url = $status->getAttribute('href');
			$id = preg_replace('/[^\d]/', '', $url);
			
			$imgSource = $tr->find('.profile-image img');
			$name = $imgSource[0]->getAttribute('alt');
			$image = $imgSource[0]->getAttribute('src');
			
			$userSource = $tr->find('.row-title');
			$userId = str_replace('/profile.html?id=', '', $userSource[0]->getAttribute('href'));
			$from = explode('<br />', $userSource[0]->parent()->innertext);
			$from = trim($from[1]);
			
			$subject = trim(strip_tags(current($tr->find('td.message_sum'))->innertext));
			
			$arrives = trim(current($tr->find('td.adate'))->innertext);
			$departs = trim(current($tr->find('td.ddate'))->innertext);
			$people = current($tr->find('td.number'))->innertext;
			
			$requests[$id] = (object) array(
				'id'		=> $id,
				'status'	=> $replied,
				'user'		=> array(
					'name'	=> $name,
					'from'	=> $from,
					'id'	=> $userId
				),
				'arriving'	=> $arrives,
				'departing' => $departs ,
				'subject'	=> $subject,
				'people'	=> $people,
				'image'		=> $image
			);
			//die();
		}
		return $requests;
	}
	
	
	/**
	 * Get the details for a specific requet
	 *
	 * @param	string	$id 
	 * @return	array
	 * @author	Roberto Hidalgo
	 */
	public function getRequest($id=FALSE)
	{
		if( !$id ){
			return FALSE;
		}
		
		$body = self::csrequest('couchrequest/read/'.$id);
		
		$subject = trim($body->find('.thread_subject', 0)->plaintext);
		$basicInfo = $body->find('#crinfo_bar', 0);
		$messages = $body->find('.msg');
		array_pop($messages);
		
		$image = $basicInfo->find('.media img', 0)->getAttribute('src');
		$name = $basicInfo->find('.row-title', 0)->innertext;
		$from = $basicInfo->find('.media > p', 0)->innertext;
		
		$request = array(
			'id'		=> $id,
			'status'	=> 'pending',
			'user'		=> array(
				'name'	=> $name,
				'from'	=> $from,
				'gender'	=> $gender,
				'age'	=> $age,
				'references' => $references,
				'id'	=> $userId
			),
			'arriving'	=> '0',
			'flexible'	=> 'false',
			'departing' => '0' ,
			'subject'	=> $subject,
			'people'	=> '0',
			'image'		=> $image
		);
		
		
		$keys = array('', 'arriving', 'departing', 'people', 'via', 'status');
		foreach( $basicInfo->find('tr') as $tr ){
			$request[next($keys)] = trim(strip_tags($tr->find('td', 1)->innertext));
		}
		
		if( stristr($request['arriving'], 'flexible') ){
			$request['arriving'] = trim(preg_replace('/[\s\t]+(.+)/', '', $request['arriving']));
			$request["flexible"] = "true";
		}
		
		
		$keys = array('', 'age', 'gender', 'grew', 'references', 'friends');
		foreach( $basicInfo->find('.unit li') as $li ){
			list($k, $v) = explode(":", $li->innertext);
			if( trim($k)!='' ){
				$va = next($keys);
				$request['user'][$va] = trim($v);
			}
			
		}
		
		$msg = array();
		foreach( $messages as $message ){
			$id = $message->getAttribute('id');
			$class = stristr($message->getAttribute('class'), 'host')? 'mine' : 'theirs';
			$date = $message->find('.date', 0)->innertext;
			$text = $message->find('.msgtext', 0)->plaintext;
			
			
			$msg[] = array(
				'id' => $id,
				'class' => $class,
				'date' => $date,
				'text' => trim($text)
			);
		}
		
		$request['messages'] = $msg;
		
		return $request;
	}
	
	
	/**
	 * Requests to CS something that could be, one drunken night, be considered as an unofficial
	 * API of sorts.
	 *
	 * @param	string	$url 
	 * @param	string	$encodedData 
	 * @return	string	$body
	 * @author	Roberto Hidalgo
	 */
	private function csrequest($url, $encodedData=array())
	{
		list($body, $headers) = self::request($url, "POST", array(
			'encoded_data' => json_encode($encodedData),
			'dataonly' => 'false',
			'csstandard_request' => 'true',
			'type' => 'html'
		));
		
		$body = json_decode($body);
		return str_get_html($body[0]->data);
		
	}
	
	
	/**
	 * Make an HTTP call
	 *
	 * @param	string	$url 
	 * @param	string	$method 
	 * @param	string	$data 
	 * @param	string	$https 
	 * @return	array
	 * @author	Roberto Hidalgo
	 */
	private function request($url, $method="GET", $data=false, $https=FALSE)
	{
		$method = strtoupper($method);
		$protocol = $https? 'https' : 'http';
		$request = new HttpRequest("$protocol://www.couchsurfing.org/$url", constant("HTTP_METH_$method"));
		
		if( $data ){
			$request->setPostFields($data);
		}
		
		$request->setHeaders($this->headers);
		
		$response = $request->send();
		//var_dump($response);
		
		return array(
			$response->getBody(),
			$response->getHeaders()
		);
		
	}
	
	
}