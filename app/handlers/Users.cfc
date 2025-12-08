component {
    property name="userService" inject="UserService";

    function index( event, rc, prc ){
        // Ensure admin
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
            flash.put( "error", "Access denied." );
            relocate( "main" );
            return;
        }

        prc.users = userService.getAllUsers();
        event.setView( "users/index" );
    }

    function updateRole( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) return;
        
        userService.updateUserRole( rc.user_id, rc.role );
        flash.put( "message", "User role updated." );
        relocate( "users.index" );
    }

    function edit( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "main" );
             return;
        }
        
        prc.user = userService.getUserById( rc.user_id );
        if ( isNull( prc.user ) ) {
            flash.put( "error", "User not found." );
            relocate( "users.index" );
            return;
        }
        
        prc.teams = new app.models.TeamManagementService().getAllTeams();
        prc.currentTeamId = new app.models.UserManagementService().getAgentTeam( rc.user_id );
        
        event.setView( "users/edit" );
    }

    function update( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) return;
        
        userService.updateUser( 
            userId = rc.user_id, 
            username = rc.username, 
            email = rc.email, 
            phone = rc.phone, 
            role = rc.role, 
            role = rc.role, 
            department = rc.keyExists("department") ? rc.department : ""
        );
        
        // Update Team Mapping
        if ( structKeyExists( rc, "team_id" ) ) {
            new app.models.UserManagementService().assignAgentTeam( rc.user_id, rc.team_id );
        }
        
        flash.put( "message", "User updated successfully." );
        relocate( "users.index" );
    }

    function delete( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) return;
        
        // Prevent deleting self
        if ( rc.user_id == session.user.id ) {
            flash.put( "error", "Cannot delete yourself." );
            relocate( "users.index" );
            return;
        }

        userService.deleteUser( rc.user_id );
        flash.put( "message", "User deleted." );
        relocate( "users.index" );
    }
}
