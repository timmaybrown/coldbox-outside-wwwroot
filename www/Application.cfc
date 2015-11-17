/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{
	// Application properties
	this.name = hash( getCurrentTemplatePath() ) ;
	
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.setClientCookies = true;

	//MAIN DIRECTORY WHERE ALL PROJECT FILES LIVE - in this case one level up from current directory www
	MAIN_DIR = expandPath('../');
	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );;
	// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING   = "";
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE 	 = "app.config.Coldbox";
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY 		 = "";
	// JAVA INTEGRATION: JUST DROP JARS IN THE LIB FOLDER
	// You can add more paths or change the reload flag as well.
	this.mappings["/app"] = MAIN_DIR & "app";
	this.mappings["/coldbox"] = MAIN_DIR & "coldbox";
	this.javaSettings = { loadPaths = [ "/app/lib" ], reloadOnChange = false };

	this.datasource = "yourDSN";

	//ORM config

	// application start
	public boolean function onApplicationStart(){
		application.cbBootstrap = new coldbox.system.Bootstrap( COLDBOX_CONFIG_FILE, COLDBOX_APP_ROOT_PATH, COLDBOX_APP_KEY, COLDBOX_APP_MAPPING );
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// request start
	public boolean function onRequestStart(String targetPage){
		// RELOAD ORM
		if (structKeyExists(url,"ormreload")) {
			ORMReload();		
		}
		if (structKeyExists(url,"reinit")) {
			onApplicationStart();		
		}
		// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );
		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
	}

	public boolean function onMissingTemplate( template ){
		return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
	}
	
	public boolean function onError( required exception){
		
		writeDump(exception);
		abort;
	}

}