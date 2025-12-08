component {
    
    property name="ticketService" inject="TicketService";

    function index( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) || session.user.role != "admin" ) {
             relocate( "main" );
             return;
        }

        prc.stats = ticketService.getStats();
        prc.ticketsByStatus = ticketService.getTicketsByStatus();
        prc.ticketsByCategory = ticketService.getTicketsByCategory();
        
        event.setView( "stats/index" );
    }

}
