**Note:** On September 18, 2022, the U.S. General Services Administration (GSA) will sunset Go.USA.gov. The Go.USA.gov API will become inaccessible... after August 31, 2022. Source: https://blog.usa.gov/sunsetting-go.usa.gov-frequently-asked-questions

# Go.USA.gov API Library for XQuery

[Go.USA.gov](http://go.usa.gov/) is a URL shortener service that lets government employees create short .gov URLs from 
official government domains, such as .gov, .mil, .si.edu, .fed.us, or .state.xx.us URLs.  Registration is limited to 
people with .mil, .gov, .fed.us, .si.edu, and .state.xx.us e-mail addresses.  The service has a web front end as well 
as [an API](http://go.usa.gov/api) for programmatic access.  

This library, written in XQuery, is a simple wrapper around the API's three methods: 
[Shorten](https://go.usa.gov/api#shorten), [Expand](https://go.usa.gov/api#expand), and [Clicks](https://go.usa.gov/api#clicks).  

## Requirements and Compatibility

To use the Go.USA.gov API, you need a login and API key from Go.USA.gov.

The library written in pure XQuery 1.0 and has a dependency on the 
[EXPath HTTP Client](http://expath.org/modules/http-client/) module for making HTTP requests.  

The library can be pulled out and used on its own, but if your implementation of XQuery supports the EXPath Package system, 
you can use the included [Apache Ant](http://ant.apache.org/) build script to create an EXPath Package for quick, convenient
installation.

The library and package have been tested with eXist-db 2.0.  

## Installation for eXist-db

To install in eXist-db, clone this repository and run ant, which will construct an EXPath Archive (.xar) file in the 
project's build folder. Then install the package via the eXist-db Package Manager, or place it in eXist-db's 'autodeploy' folder.

## Usage

### Import the module

    import module namespace go = "http://go.usa.gov/api";

### go:expand($login as xs:string, $api-key as xs:string, $short-url as xs:string, $output-format as xs:string) as element()?

This function expands a shortened URL.  

    let $login := '[your login]'
    let $api-key := '[your API key]'
    let $short-url := 'http://go.usa.gov/bvDT'
    let $output-format := 'xml'
    return
        go:expand($login, $api-key, $short-url, $output-format)
    
This will return the following result:

    <result>
        <response>
            <item is_array="true">
                <item>
                    <status_code>200</status_code>
                    <status_txt>OK</status_txt>
                </item>
            </item>
            <data>
                <entry is_array="true">
                    <item>
                        <short_url>http://go.usa.gov/bvDT</short_url>
                        <long_url>http://www.state.gov/vsfs/</long_url>
                    </item>
                </entry>
            </data>
        </response>
    </result>
    
If you desire the result in JSON, be sure to use a function in your XQuery implementation that lets you access 
the response as a string.  For example, in eXist-db, apply `util:binary-to-string()`:

    util:binary-to-string(go:expand($login, $api-key, $short-url, $output-format))
    
The JSON response:

    {"response": {
        "0": [{
            "status_code": "200",
            "status_txt": "OK"
        }],
        "data": {"entry": [{
            "short_url": "http://go.usa.gov/bvDT",
            "long_url": "http://www.state.gov/vsfs/"
        }]}
    }}

### go:shorten($login as xs:string, $api-key as xs:string, $long-url as xs:string, $output-format as xs:string)  as item()

This function shortens the `$long-url`.

### go:clicks($login as xs:string, $api-key as xs:string, $short-url as xs:string, $output-format as xs:string)  as item()

This function returns the number of clicks to the `$short-url`.
