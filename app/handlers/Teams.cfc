component {

    // variables.teamService = new app.models.TeamManagementService();

    function index( event, rc, prc ){
        var teamService = new app.models.TeamManagementService();
        fileAppend( expandPath("/handler_debug.txt"), "Teams.index: Injected Service is " & getMetadata(teamService).name & chr(13) & chr(10) );
        // Only Admin
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "dashboard.index" );
             return;
        }

        prc.teams = teamService.getAllTeams();
        event.setView( "teams/index" );
    }

    function new( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "dashboard.index" );
             return;
        }
        event.setView( "teams/new" );
    }

    function create( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "dashboard.index" );
             return;
        }

        if ( len( trim( rc.name ) ) ) {
            try {
                var teamService = new app.models.TeamManagementService();
                teamService.createTeam( rc.name, rc.description );
                flash.put( "message", "Team created successfully!" );
            } catch( any e ) {
                flash.put( "error", "Error creating team: " & e.message );
                relocate( "teams.new" );
                return;
            }
        } else {
            flash.put( "error", "Team Name is required." );
            relocate( "teams.new" );
            return;
        }

        relocate( "teams.index" );
    }

    function edit( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "dashboard.index" );
             return;
        }
        
        prc.team = new app.models.TeamManagementService().getTeamById( rc.id );
        if ( isNull( prc.team ) ) {
            flash.put( "error", "Team not found." );
            relocate( "teams.index" );
            return;
        }
        
        event.setView( "teams/edit" );
    }

    function update( event, rc, prc ){
        fileAppend( expandPath("/handler_debug.txt"), "Teams.update called at #now()# with ID: " & (structKeyExists(rc, "id") ? rc.id : "missing") & " Name: " & (structKeyExists(rc, "name") ? rc.name : "missing") & chr(13) & chr(10) );

        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "dashboard.index" );
             return;
        }

        if ( len( trim( rc.name ) ) ) {
            try {
                var teamService = new app.models.TeamManagementService();
                teamService.updateTeam( rc.id, rc.name, rc.description );
                flash.put( "message", "Team updated successfully!" );
            } catch( any e ) {
                fileAppend( expandPath("/handler_debug.txt"), "Teams.update Error: " & e.message & " Detail: " & e.detail & chr(13) & chr(10) );
                flash.put( "error", "Error updating team: " & e.message );
                relocate( event="teams.edit", queryString="id=#rc.id#" );
                return;
            }
        } else {
            flash.put( "error", "Team Name is required." );
            relocate( event="teams.edit", queryString="id=#rc.id#" );
            return;
        }

        relocate( "teams.index" );
    }

    function delete( event, rc, prc ){
        fileAppend( expandPath("/handler_debug.txt"), "Teams.delete called at #now()# with ID: " & (structKeyExists(rc, "id") ? rc.id : "missing") & chr(13) & chr(10) );

        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "dashboard.index" );
             return;
        }
        
        try {
            var teamService = new app.models.TeamManagementService();
            teamService.deleteTeam( rc.id );
            flash.put( "message", "Team deleted successfully." );
        } catch( any e ) {
            fileAppend( expandPath("/handler_debug.txt"), "Teams.delete Error: " & e.message & " Detail: " & e.detail & chr(13) & chr(10) );
            flash.put( "error", "Error deleting team: " & e.message );
        }
        
        relocate( "teams.index" );
    }
}
