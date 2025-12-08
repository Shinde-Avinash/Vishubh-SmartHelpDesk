component {
    
    // property name="ticketService" inject="TicketService";
    property name="aiService" inject="AIService";
    //property name="userService" inject="UserService";

    function index( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) ) {
            relocate( "sessions.new" );
            return;
        }
        
        // If admin/agent/team_lead, show filtered tickets
        var ticketService = new app.models.TicketManagementService();
        if ( session.user.role == "admin" || session.user.role == "agent" || session.user.role == "team_lead" ) {
             prc.tickets = ticketService.getAllTickets( session.user.id, session.user.role );
        } else {
             prc.tickets = ticketService.getUserTickets( session.user.id );
        }
        
        event.setView( "tickets/index" );
    }

    function new( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) ) {
            relocate( "sessions.new" );
            return;
        }
        event.setView( "tickets/new" );
    }

    function save( event, rc, prc ){
        
        if ( !structKeyExists( session, "user" ) ) {
            relocate( "sessions.new" );
            return;
        }

        // AI Analysis
        var analysis = aiService.analyzeTicket( rc.title, rc.description );
        
        var uid = new app.models.TicketManagementService().create({
            title: rc.title,
            description: rc.description,
            category: rc.category,
            urgency: rc.urgency,
            user_id: session.user.id,
            ai_analysis_json: jsonSerialize( analysis )
        });
        
        flash.put( "message", "Ticket created successfully! Ticket ID: " & uid );
        relocate( "tickets.index" );
    }

    function show( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) ) {
            relocate( "sessions.new" );
            return;
        }
        
        var ticketService = new app.models.TicketManagementService();
        prc.ticket = ticketService.getTicketByUid( rc.uid );
        
        if ( isNull( prc.ticket ) ) {
            flash.put( "error", "Ticket not found." );
            relocate( "tickets.index" );
            return;
        }

        prc.messages = ticketService.getTicketMessages( rc.uid );
        
        // Fetch agents for assignment dropdown (admin, team_lead, and agent can reassign)
        if ( listFindNoCase( "admin,team_lead,agent", session.user.role ) ) {
            prc.agents = new app.models.UserManagementService().getAgentsWithTeams();
            // Fetch teams for admin reassignment
            if ( session.user.role == "admin" ) {
                 prc.teams = new app.models.TeamManagementService().getAllTeams();
            }
        }
        
        event.setView( "tickets/show" );
    }

    function reply( event, rc, prc ){
        if ( !structKeyExists( session, "user" ) ) {
            relocate( "sessions.new" );
            return;
        }

        if ( len( trim( rc.message ) ) ) {
            new app.models.TicketManagementService().addMessage( rc.uid, session.user.id, rc.message );
            flash.put( "message", "Reply posted successfully." );
        } else {
            flash.put( "error", "Message cannot be empty." );
        }

        relocate( event="tickets.show", queryString="uid=#rc.uid#" );
    }

    function assign( event, rc, prc ){
        if ( !listFindNoCase( "admin,team_lead,agent", session.user.role ) ) return;
        
        new app.models.TicketManagementService().assignTicket( rc.uid, rc.agent_id );
        flash.put( "message", "Ticket assigned successfully." );
        relocate( event="tickets.show", queryString="uid=#rc.uid#" );
    }

    function assignTeam( event, rc, prc ){
        if ( session.user.role != 'admin' ) return;
        
        new app.models.TicketManagementService().assignTeam( rc.uid, rc.team_id );
        flash.put( "message", "Ticket team re-assigned successfully." );
        relocate( event="tickets.show", queryString="uid=#rc.uid#" );
    }

    function status( event, rc, prc ){
        if ( session.user.role != 'admin' && session.user.role != 'agent' && session.user.role != 'team_lead' ) return;
        
        ticketService.updateStatus( rc.uid, rc.status );
        flash.put( "message", "Ticket status updated." );
        relocate( event="tickets.show", queryString="uid=#rc.uid#" );
    }

    function analyze( event, rc, prc ){
        var analysis = ticketService.analyzeTicket( rc.uid, "" );
        
        // Save as a message or just flash it? Better to add as a private note or internal message
        // For now, let's append it to the chat as an "System/AI" message
        ticketService.addMessage( rc.uid, session.user.id, analysis, 'ai' ); // passing type 'ai'
        
        flash.put( "message", "AI Analysis generated." );
        relocate( event="tickets.show", queryString="uid=#rc.uid#" );
    }
}
