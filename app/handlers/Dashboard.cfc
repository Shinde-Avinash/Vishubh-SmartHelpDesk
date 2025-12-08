component {
    
    //property name="ticketService" inject="TicketService";
    property name="userService" inject="UserService";

    function index( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) ) {
            relocate( "sessions.new" );
            return;
        }

        // Role-based dashboard logic
        prc.role = session.user.role;
        
        // Fetch stats based on role
        var ticketService = new app.models.TicketManagementService();
        prc.stats = ticketService.getStats( session.user.id, prc.role );

        if ( prc.role == "admin" ) {
            prc.recentTickets = ticketService.getAllTickets( session.user.id, prc.role );
        } else if ( prc.role == "agent" || prc.role == "team_lead" ) {
             // Agents see tickets assigned to their team
             prc.recentTickets = ticketService.getAllTickets( session.user.id, prc.role );
        } else {
            // Regular user
            relocate( "tickets.index" );
        }

        event.setView( "dashboard/index" );
    }
}
