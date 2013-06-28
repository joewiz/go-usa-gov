xquery version "1.0";

module namespace go = "http://go.usa.gov/api";

(:~  
 : An XQuery library module for interacting with the Go.USA.gov URL shortener API, which offers 
 : methods for shortening and expanding URLs, as well as reporting on the number of clicks 
 : to a shortened URL.
 :
 : @see http://go.usa.gov/api
 :
 : @author Joe Wicentowski
 :)

(:~
 : Helper function that sends the requests to the Go.USA.gov API 
 : @param $login a Go.USA.gov username
 : @param $api-key a Go.USA.gov API key
 : @param $api-method the API method name
 : @param $output-format the desired output format
 : @return response body, or response header in case of an error
 :)
declare function go:send-request($login as xs:string, $api-key as xs:string, $api-method as xs:string, $output-format as xs:string, $options as xs:string*) {
    let $api-base-url := 'https://go.usa.gov/api/'
    let $http-method := 'GET'
    let $url := concat($api-base-url, '/', $api-method, '.', $output-format)
    let $options := ($options, concat('apiKey=', $api-key), concat('login=', $login))
    let $parameters := string-join($options, '&amp;')
    let $request-url := concat($url, '?', $parameters)
    let $request := <http:request href="{$request-url}" method="{$http-method}"/>
    let $response := http:send-request($request)
    let $response-head := $response[1]
    let $response-body := $response[2]
    return 
        if ($response-head/@status = '200') then
            $response-body
        else 
            <go:error>{$response-body}</go:error>
};

(:~
 : Expand Method: Preview the Destination of a Short URL
 : @param $login a Go.USA.gov username
 : @param $api-key a Go.USA.gov API key
 : @param $short-url a URL already shortened by the Go.USA.gov API
 : @param $output-format the desired output format
 : @return a status code, the short URL, and the long URL
 :)
declare function go:expand($login as xs:string, $api-key as xs:string, $short-url as xs:string, $output-format as xs:string) as item() {
    let $method := 'expand'
    let $options := concat("shortUrl=", encode-for-uri($short-url))
    return
        go:send-request($login, $api-key, $method, $output-format, $options)
};

(:~
 : Clicks Method: Get the Number of Clicks on a Short URL
 : @param $login a Go.USA.gov username
 : @param $api-key a Go.USA.gov API key
 : @param $long-url a long URL that you wish to shorten 
 : @param $output-format the desired output format
 : @return a status code, the new shortened URL, and the long URL
 :)
declare function go:shorten($login as xs:string, $api-key as xs:string, $long-url as xs:string, $output-format as xs:string)  as item() {
    let $method := 'shorten'
    let $options := concat('longUrl=', encode-for-uri($long-url))
    return
        go:send-request($login, $api-key, $method, $output-format, $options)
};

(:~
 : Clicks Method: Get the Number of Clicks on a Short URL
 : @param $login a Go.USA.gov username
 : @param $api-key a Go.USA.gov API key
 : @param $short-url a URL already shortened by the Go.USA.gov API
 : @param $output-format the desired output format
 : @return a status code, the short URL, and the number of clicks on the short URL
 :)
declare function go:clicks($login as xs:string, $api-key as xs:string, $short-url as xs:string, $output-format as xs:string)  as item() {
    let $method := 'clicks'
    let $options := concat("shortUrl=", encode-for-uri($short-url))
    return
        go:send-request($login, $api-key, $method, $output-format, $options)
};