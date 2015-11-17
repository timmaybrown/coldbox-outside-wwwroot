/**
* ********************************************************************************
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Base RESTFul handler spice up as needed.
* This handler will create a Response model and prepare it for your actions to use
* to produce RESTFul responses.
*/
component extends="coldbox.system.EventHandler"{

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 		= "";
	this.prehandler_except 		= "";
	this.posthandler_only 		= "";
	this.posthandler_except 	= "";
	this.aroundHandler_only 	= "";
	this.aroundHandler_except 	= "";		

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};
	
	/**
	* Around handler for all actions it inherits
	*/
	function aroundHandler( event, rc, prc, targetAction, eventArguments ){
		try{
			// start a resource timer
			var stime = getTickCount();
			// prepare our response object
			prc.response = getModel( "Response" );
			// prepare argument execution
			var args = { event = arguments.event, rc = arguments.rc, prc = arguments.prc };
			structAppend( args, arguments.eventArguments );
			// Execute action
			arguments.targetAction( argumentCollection=args );
		} catch( Any e ){
			// Log Locally
			log.error( "Error calling #event.getCurrentEvent()#: #e.message# #e.detail#", e );

			// Setup General Error Response
			prc.response
				.setError( true )
				.setErrorCode( 500 )
				.addMessage( "General application error: #e.message#" )
				.setStatusCode( 500 )
				.setStatusText( "General application error" );
			// Development additions
			if( getSetting( "environment" ) eq "development" ){
				prc.response.addMessage( "Detail: #e.detail#" )
					.addMessage( "StackTrace: #e.stacktrace#" );
			}
		}
		
		// Development additions
		if( getSetting( "environment" ) eq "development" ){
			prc.response.addHeader( "x-current-route", event.getCurrentRoute() )
				.addHeader( "x-current-routed-url", event.getCurrentRoutedURL() )
				.addHeader( "x-current-routed-namespace", event.getCurrentRoutedNamespace() )
				.addHeader( "x-current-event", event.getCurrentEvent() );
		}
		// CORS HEADERS since we are using JWT
		// prc.response.addHeader("Access-Control-Allow-Origin", "*")
		// 						.addHeader( "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE,OPTIONS")
		// 						.addHeader( "Access-Control-Allow-Headers", "Content-Type, Authorization");
		// END CORS HEADERS

		// end timer
		prc.response.setResponseTime( getTickCount() - stime );
		
		// Magical renderings
		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket(),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
		
		// Global Response Headers
		prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
				.addHeader( "x-cached-response", prc.response.getCachedResponse() );
		
		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
	}

	/*
	* on localized errors
	*/
	function onError( event, rc, prc, faultAction, exception, eventArguments ){
		//writeDump(arguments); abort;
		// Log Locally
		log.error( "Error in base handler (#arguments.faultAction#): #arguments.exception.message# #arguments.exception.detail#", arguments.exception );
		// Verify response exists, else create one
		if( !structKeyExists( prc, "response" ) ){ prc.response = getModel( "Response" ); }
		// Setup General Error Response
		writeDump(arguments);abort;
		prc.response
			.setError( true )
			.setErrorCode( 501 )
			.addMessage( "Base Handler Application Error: #arguments.exception.message#" )
			.setStatusCode( 500 )
			.setStatusText( "General application error" );
		
		// Development additions
		if( getSetting( "environment" ) eq "development" ){
			prc.response.addMessage( "Detail: #arguments.exception.detail#" )
				.addMessage( "StackTrace: #arguments.exception.stacktrace#" );
		}

		// Global Response Headers
		prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
				.addHeader( "x-cached-response", prc.response.getCachedResponse() );
		
		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
		
		// Render Error Out
		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket(),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);
	}

	/*
	* on invalid http verbs
	*/
	function onInvalidHTTPMethod( event, rc, prc, faultAction, eventArguments ){
		// Log Locally
		log.warn( "InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#", getHTTPRequestData() );
		// Setup Response
		prc.response = getModel( "Response" )
			.setError( true )
			.setErrorCode( 405 )
			.addMessage( "InvalidHTTPMethod Execution of (#arguments.faultAction#): #event.getHTTPMethod()#" )
			.setStatusCode( 405 )
			.setStatusText( "Invalid HTTP Method" );
			// CORS HEADERS since we are using JWT
			// .addHeader("Access-Control-Allow-Origin", "*")
			// .addHeader( "Access-Control-Allow-Methods", "GET,PUT,POST,DELETE,OPTIONS")
			// .addHeader( "Access-Control-Allow-Headers", "Content-Type, Authorization");
			// END CORS HEADERS
		// Render Error Out
		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket(),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);

		// Global Response Headers
		prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
				.addHeader( "x-cached-response", prc.response.getCachedResponse() );
		
		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
	}

	/*
	* on invalid event
	*/
	public function onInvalidEvent( event, rc, prc ){
		writeDump(arguments); abort;
		// Log Locally
		log.warn( "Invalid URI Endpoint :: routed-uri=/#prc.currentRoutedURL# :: :: event=#rc.event#", getHTTPRequestData() );
		// Setup Response
		prc.response = getModel( "Response" )
			.setError( true )
			.setErrorCode( 404 )
			.addMessage( "Invalid URI Endpoint of /#prc.currentRoutedURL# :: #event.getHTTPMethod()#" )
			.setStatusCode( 404 )
			.setStatusText( "Invalid HTTP Method" );

		event.renderData( 
			type		= prc.response.getFormat(),
			data 		= prc.response.getDataPacket(),
			contentType = prc.response.getContentType(),
			statusCode 	= prc.response.getStatusCode(),
			statusText 	= prc.response.getStatusText(),
			location 	= prc.response.getLocation(),
			isBinary 	= prc.response.getBinary()
		);

		// Global Response Headers
		prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
				.addHeader( "x-cached-response", prc.response.getCachedResponse() );
		
		// Response Headers
		for( var thisHeader in prc.response.getHeaders() ){
			event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
		}
	}

	/*
	* onException
	*/
	public function onException( event, rc, prc ){
		var errCode = ( len( prc.exception.getErrorCode() ) ) ? prc.exception.getErrorCode() : 500;
		prc.response = getModel( "Response" )
			.setError( true )
			.setErrorCode( errCode )
			.addMessage( prc.exception.getMessage() )
			.addMessage( prc.exception.getDetail() )
			.setStatusCode( errCode )
			.setStatusText( prc.exception.getMessage() );
			
			// Development additions
			if( getSetting( "environment" ) eq "development" ){
				prc.response.addMessage( "StackTrace: #prc.exception.getStackTrace()#" );
			}

			// Global Response Headers
			prc.response.addHeader( "x-response-time", prc.response.getResponseTime() )
					.addHeader( "x-cached-response", prc.response.getCachedResponse() );
			
			// Response Headers
			for( var thisHeader in prc.response.getHeaders() ){
				event.setHTTPHeader( name=thisHeader.name, value=thisHeader.value );
			}
	}

	/*
	* onException
	*/
	public function badRequest( required component response, string msg = "Bad Request", string detail = "" ){
		return response.setError( true )
				.setErrorCode( 400 )
				.addMessage( msg )
				.addMessage( detail )
				.setStatusCode( 400 )
				.setStatusText( "Bad Request" );
	}

}