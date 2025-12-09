component extends="coldbox.system.EventHandler" {

	property name="userService" inject="UserService";

	/**
	 * Default Action
	 */
	function index( event, rc, prc ){
		prc.welcomeMessage = "Welcome to ColdBox!";
		event.setView( "main/index" );
	}

	/**
	 * Produce some restfulf data
	 */
	function data( event, rc, prc ){
		return [
			{ "id" : createUUID(), "name" : "Luis" },
			{ "id" : createUUID(), "name" : "Joe" },
			{ "id" : createUUID(), "name" : "Bob" },
			{ "id" : createUUID(), "name" : "Darth" }
		];
	}

	/**
	 * Relocation example
	 */
	function doSomething( event, rc, prc ){
		relocate( "main.index" );
	}

	/**
	 * --------------------------------------------------------------------------
	 * Implicit Actions
	 * --------------------------------------------------------------------------
	 * All the implicit actions below MUST be declared in the config/Coldbox.cfc in order to fire.
	 * https://coldbox.ortusbooks.com/getting-started/configuration/coldbox.cfc/configuration-directives/coldbox#implicit-event-settings
	 */

	function onAppInit( event, rc, prc ){
	}

	function onRequestStart( event, rc, prc ){
	}

	function onRequestEnd( event, rc, prc ){
	}

	function onSessionStart( event, rc, prc ){
	}

	function onSessionEnd( event, rc, prc ){
		var sessionScope     = event.getValue( "sessionReference" );
		var applicationScope = event.getValue( "applicationReference" );
	}

	function profile( event, rc, prc ){
		if ( !structKeyExists( session, "user" ) ) {
			relocate( "sessions.new" );
			return;
		}
		
		// Refresh user data from DB to ensure up-to-date info
		var userService = new app.models.UserService();
		prc.user = userService.getUserById( session.user.id );
		
		// Get Team info if agent/team_lead
		if ( listFindNoCase( "agent,team_lead", prc.user.role ) ) {
			prc.teamId = new app.models.UserManagementService().getAgentTeam( prc.user.id );
			if ( len( prc.teamId ) ) {
				var teamService = new app.models.TeamManagementService();
				var team = teamService.getTeamById( prc.teamId );
				if ( !isNull( team ) ) {
					prc.teamName = team.name;
				}
			}
		}
		
		event.setView( "main/profile" );
	}
	
	function onException( event, rc, prc ){
		event.setHTTPHeader( statusCode = 500 );
		// Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		// Place exception handler below:
	}

}
