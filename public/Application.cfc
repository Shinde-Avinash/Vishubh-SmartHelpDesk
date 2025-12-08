/**
 * Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Application Bootstrap
 * Force Reload: 2025-12-08 12:20
 */
component {

	/**
	 * --------------------------------------------------------------------------
	 * Application Properties: Modify as you see fit!
	 * --------------------------------------------------------------------------
	 */
	this.name                 = "Vishubh SmartHelpDesk";
	this.sessionManagement    = true;
	this.sessionTimeout       = createTimespan( 0, 1, 0, 0 );
	this.setClientCookies     = true;
	this.setDomainCookies     = true;
	this.timezone             = "UTC";
	this.whiteSpaceManagement = "smart";

	/**
	 * --------------------------------------------------------------------------
	 * Java Settings
	 * --------------------------------------------------------------------------
	 */
	this.javaSettings = {
		loadPaths = [ "lib/java" ],
		reloadOnChange = true
	};

	/**
	 * --------------------------------------------------------------------------
	 * Location Mappings
	 * --------------------------------------------------------------------------
	 * These are pre-defined in the runtime/config/boxlang.json so they can
	 * be reused.  You can change them here if you want.
	 */
	_publicRoot = getDirectoryFromPath( getCurrentTemplatePath() );

	/**
	 * --------------------------------------------------------------------------
	 * ColdBox Bootstrap Settings
	 * --------------------------------------------------------------------------
	 * Modify only if you need to, else default them.
	 * https://coldbox.ortusbooks.com/getting-started/configuration/bootstrapper-application.cfc
	 */
	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = expandPath( "/app" )
	// THE MAPPING LOCATION OF THE COLDBOX CORE APP
	COLDBOX_APP_MAPPING   = "/app"
	// THE WEB PATH LOCATION OF THE PUBLIC ASSETS, USUALLY "/" FOR MOST APPS
	// USE Empty String "" IF YOUR APP IS IN THE ROOT OF THE WEB
	// OR "/yourApp" IF YOUR APP IS IN A SUBFOLDER
	COLDBOX_WEB_MAPPING   = "/"
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE   = ""
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY       = ""
	// By default if an app is reiniting and a request hits it, we will fail fast with a message
	COLDBOX_FAIL_FAST = true

	/**
	 * --------------------------------------------------------------------------
	 * ORM + Datasource Settings
	 * --------------------------------------------------------------------------
	 */
	this.datasource = "Vishubh_SmartHelpDeskDB";
	this.datasources = {
		"Vishubh_SmartHelpDeskDB" = {
			"driver"   = "MySQL",
            "class"    = "com.mysql.cj.jdbc.Driver",
			"url"      = "jdbc:mysql://127.0.0.1:3306/Vishubh_SmartHelpDeskDB?useSSL=false&useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useLegacyDatetimeCode=true&allowPublicKeyRetrieval=true&createDatabaseIfNotExist=true",
			"username" = "avi10",
			"password" = "avi10"
		}
	};

	/**
	 * Fires when the application starts
	 */
	public boolean function onApplicationStart() {
		try {
			createObject( "java", "com.mysql.cj.jdbc.Driver" );
		} catch( any e ) {
			systemOutput( "Failed to load MySQL Driver: " & e.message, true );
		}

		// Auto-migrate schema
		try {
			var schemaPath = expandPath( "/resources/database/schema.sql" );
			if( fileExists( schemaPath ) ){
				var schemaSql = fileRead( schemaPath );
				var statements = listToArray( schemaSql, ";" );
				for( var sql in statements ){
					if( len( trim( sql ) ) ) queryExecute( trim( sql ) );
				}
                
                // Manual Migration for Department
                try {
                    queryExecute("ALTER TABLE users ADD COLUMN department VARCHAR(100) AFTER role");
                } catch(any e) {
                    systemOutput("Migration Error (Department): " & e.message & " " & e.detail, true);
                }

				systemOutput( "Schema executed successfully.", true );
			}
		} catch( any e ) {
			systemOutput( "Schema Error: " & e.message & " " & e.detail, true );
		}

		setting requestTimeout="300";
		application.cbBootstrap= new coldbox.system.Bootstrap(
			COLDBOX_CONFIG_FILE,
			COLDBOX_APP_ROOT_PATH,
			COLDBOX_APP_KEY,
			COLDBOX_APP_MAPPING,
			COLDBOX_FAIL_FAST,
			COLDBOX_WEB_MAPPING
		)
		application.cbBootstrap.loadColdbox()
		return true
	}

	/**
	 * Fires when the application ends
	 *
	 * @appScope The app scope
	 */
	public void function onApplicationEnd( struct appScope ) {
		arguments.appScope.cbBootstrap.onApplicationEnd( arguments.appScope )
	}

	/**
	 * Process a ColdBox Request
	 *
	 * @targetPage The requested page
	 */
	public boolean function onRequestStart( string targetPage ) output=true{
		return application.cbBootstrap.onRequestStart( arguments.targetPage )
	}

	/**
	 * Fires on every session start
	 */
	public void function onSessionStart() {
		if ( !isNull( application.cbBootstrap ) ) {
			application.cbBootStrap.onSessionStart()
		}
	}

	/**
	 * Fires on session end
	 *
	 * @sessionScope The session scope
	 * @appScope     The app scope
	 */
	public void function onSessionEnd( struct sessionScope, struct appScope ) {
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection = arguments )
	}

	/**
	 * On missing template handler
	 *
	 * @template
	 */
	public boolean function onMissingTemplate( template ) {
		return application.cbBootstrap.onMissingTemplate( argumentCollection = arguments )
	}

}
