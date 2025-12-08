component {
    
    property name="userService" inject="UserService";

    function new( event, rc, prc ){
        event.setView( "sessions/new" );
    }

    function create( event, rc, prc ){
        var user = userService.authenticate( rc.username, rc.password );
        
        if ( !isNull( user ) ) {
            session.user = user;
            flash.put( "message", "Welcome back, " & user.username & "!" );
            relocate( "main.index" );
        } else {
            flash.put( "error", "Invalid username or password." );
            relocate( "sessions.new" );
        }
    }

    function delete( event, rc, prc ){
        structDelete( session, "user" );
        flash.put( "message", "You have been logged out." );
        relocate( "sessions.new" );
    }
}
