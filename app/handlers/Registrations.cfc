component {
    
    property name="userService" inject="UserService";

    function new( event, rc, prc ){
        event.setView( "registrations/new" );
    }

    function create( event, rc, prc ){
        // Basic validation
        if ( rc.password != rc.confirm_password ) {
            flash.put( "error", "Passwords do not match." );
            relocate( "registrations.new" );
            return;
        }

        try {
            userService.create({
                username: rc.username,
                password: rc.password,
                email: rc.email,
                role: "user", // Default role
                phone: rc.phone
            });
            
            flash.put( "message", "Registration successful! Please login." );
            relocate( "sessions.new" );
        } catch ( any e ) {
            flash.put( "error", "Error creating account: " & e.message );
            relocate( "registrations.new" );
        }
    }
}
