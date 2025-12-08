component singleton {
    
    function create( required struct ticketData ){
        // Smart Routing Logic
        var teamId = 3; // Default to Tech Support
        
        if ( arguments.ticketData.category == "Billing" ) {
            teamId = 2;
        } else if ( arguments.ticketData.category == "Technical Support" ) {
            teamId = 3;
        } else if ( arguments.ticketData.category == "Feature Request" ) {
            teamId = 5; // Backend/DevOps
        }

        var sql = "
            INSERT INTO tickets (ticket_uid, title, description, category, urgency, status, user_id, assigned_team_id, ai_analysis_json, created_at)
            VALUES (:ticket_uid, :title, :description, :category, :urgency, 'New', :user_id, :team_id, :ai_analysis_json, NOW())
        ";
        
        // Generate a simple unique ID (e.g., TKT-TIMESTAMP-RANDOM)
        var uid = "TKT-" & dateTimeFormat(now(), "yyyymmddHHnnss") & "-" & randRange(100, 999);
        
        queryExecute( sql, {
            ticket_uid: { value: uid, cfsqltype: "cf_sql_varchar" },
            title: { value: arguments.ticketData.title, cfsqltype: "cf_sql_varchar" },
            description: { value: arguments.ticketData.description, cfsqltype: "cf_sql_varchar" },
            category: { value: arguments.ticketData.category, cfsqltype: "cf_sql_varchar" },
            urgency: { value: arguments.ticketData.urgency, cfsqltype: "cf_sql_varchar" },
            user_id: { value: arguments.ticketData.user_id, cfsqltype: "cf_sql_integer" },
            team_id: { value: teamId, cfsqltype: "cf_sql_integer" },
            ai_analysis_json: { value: arguments.ticketData.ai_analysis_json, cfsqltype: "cf_sql_longvarchar" }
        });
        
        return uid;
    }

    function getUserTickets( required numeric userId ){
        var sql = "
            SELECT * FROM tickets 
            WHERE user_id = :user_id 
            ORDER BY created_at DESC
        ";
        
        return queryExecute( sql, {
            user_id: { value: arguments.userId, cfsqltype: "cf_sql_integer" }
        }, { returnType = "array" });
    }

    function getTicketByUid( required string uid ){
        var sql = "SELECT * FROM tickets WHERE ticket_uid = :uid";
        var result = queryExecute( sql, {
            uid: { value: arguments.uid, cfsqltype: "cf_sql_varchar" }
        });
        
        if ( result.recordCount ) {
            var ticket = {};
            for( var col in result.columnList ){
                ticket[ col ] = result[ col ][ 1 ];
            }
            return ticket;
        }
        return;
    }
    
    function getAgentTeamId( required numeric userId ){
        var sql = "SELECT team_id FROM agents WHERE user_id = :uid";
        var result = queryExecute( sql, {
            uid: { value: arguments.userId, cfsqltype: "cf_sql_integer" }
        });
        if ( result.recordCount ) return result.team_id[1];
        return;
    }

    function getAllTickets( numeric userId, string role ){
         var sql = "SELECT t.*, u.username as created_by_name FROM tickets t JOIN users u ON t.user_id = u.id ";
         var params = {};
         
         if ( structKeyExists( arguments, "role" ) && ( arguments.role == "agent" || arguments.role == "team_lead" ) ) {
             var teamId = getAgentTeamId( arguments.userId );
             fileAppend( expandPath("/handler_debug.txt"), "getAllTickets check: User #arguments.userId# (#arguments.role#) has TeamID: " & (isNull(teamId) ? "NULL" : teamId) & chr(13) & chr(10) );
             
             if ( !isNull( teamId ) ) {
                 sql &= " WHERE t.assigned_team_id = :team_id ";
                 params.team_id = { value: teamId, cfsqltype: "cf_sql_integer" };
             } else {
                 // Fallback: if agent has no team, show no tickets to be safe
                 sql &= " WHERE 1 = 0 "; 
             }
         } else {
             fileAppend( expandPath("/handler_debug.txt"), "getAllTickets check: User #arguments.userId# (#arguments.role#) - No filtering applied (Admin or User)" & chr(13) & chr(10) );
         }

         sql &= " ORDER BY t.created_at DESC";
         return queryExecute( sql, params, { returnType = "array" } );
    }

    function addMessage( required string ticketUid, required numeric userId, required string message, required string type = "user" ){
        // First get ticket ID
        var ticket = getTicketByUid( arguments.ticketUid );
        if ( isNull( ticket ) ) return;

        var sql = "
            INSERT INTO ticket_messages (ticket_id, sender_id, message, is_ai_generated, created_at)
            VALUES (:ticket_id, :sender_id, :message, :is_ai, NOW())
        ";
        
        queryExecute( sql, {
            ticket_id: { value: ticket.id, cfsqltype: "cf_sql_integer" },
            sender_id: { value: arguments.userId, cfsqltype: "cf_sql_integer" },
            message: { value: arguments.message, cfsqltype: "cf_sql_longvarchar" },
            is_ai: { value: (arguments.type == 'ai' ? 1 : 0), cfsqltype: "cf_sql_bit" }
        });
    }

    function getTicketMessages( required string ticketUid ){
        // First get ticket ID
        var ticket = getTicketByUid( arguments.ticketUid );
        if ( isNull( ticket ) ) return [];

        var sql = "
            SELECT tm.*, u.username 
            FROM ticket_messages tm
            LEFT JOIN users u ON tm.sender_id = u.id
            WHERE tm.ticket_id = :ticket_id
            ORDER BY tm.created_at ASC
        ";
        
        return queryExecute( sql, {
            ticket_id: { value: ticket.id, cfsqltype: "cf_sql_integer" }
        }, { returnType = "array" });
    }

    function getStats( numeric userId, string role ){
        var sql = "
            SELECT 
                COUNT(*) as total,
                SUM(CASE WHEN status IN ('New', 'In Progress', 'Awaiting Response') THEN 1 ELSE 0 END) as open_tickets,
                SUM(CASE WHEN status IN ('Resolved', 'Closed') THEN 1 ELSE 0 END) as resolved_tickets,
                SUM(CASE WHEN assigned_team_id IS NULL AND assigned_agent_id IS NULL THEN 1 ELSE 0 END) as unassigned_tickets
            FROM tickets
        ";
        
        var params = {};
        
        if ( structKeyExists( arguments, "role" ) && ( arguments.role == "agent" || arguments.role == "team_lead" ) ) {
             var teamId = getAgentTeamId( arguments.userId );
             if ( !isNull( teamId ) ) {
                 sql &= " WHERE assigned_team_id = :team_id";
                 params.team_id = { value: teamId, cfsqltype: "cf_sql_integer" };
             }
        }
        
        var result = queryExecute( sql, params );
        return {
            total: result.total ?: 0,
            open: result.open_tickets ?: 0,
            resolved: result.resolved_tickets ?: 0,
            unassigned: result.unassigned_tickets ?: 0
        };
    }

    function getTicketsByStatus(){
        var sql = "SELECT status, COUNT(*) as count FROM tickets GROUP BY status";
        return queryExecute( sql, {}, { returnType = "array" } );
    }

    function getTicketsByCategory(){
        var sql = "SELECT category, COUNT(*) as count FROM tickets GROUP BY category";
        return queryExecute( sql, {}, { returnType = "array" } );
    }

    function assignTicket( required string ticketUid, required numeric userId ){
        // First get ticket ID
        var ticket = getTicketByUid( arguments.ticketUid );
        if ( isNull( ticket ) ) return;

        // Get Agent Details (ID and Team) from User ID (args.userId is the select value from user dropdown)
        var sqlAgent = "SELECT id, team_id FROM agents WHERE user_id = :uid";
        var agentResult = queryExecute( sqlAgent, { uid: { value: arguments.userId, cfsqltype: "cf_sql_integer" } } );

        if ( agentResult.recordCount ) {
            var agentId = agentResult.id[1];
            var teamId = agentResult.team_id[1];
            
            // Update both agent and team to ensure visibility follows the assignment
            var sqlUpdate = "UPDATE tickets SET assigned_agent_id = :agent_id, assigned_team_id = :team_id, status = 'In Progress' WHERE id = :id";
            var params = {
                agent_id: { value: agentId, cfsqltype: "cf_sql_integer" },
                team_id: { value: teamId, cfsqltype: "cf_sql_integer" },
                id: { value: ticket.id, cfsqltype: "cf_sql_integer" }
            };
            
            // Handle case where team_id might be null in agents table (though it shouldn't be for assignment)
            if ( !len( teamId ) ) {
                 structDelete( params, "team_id" );
                 sqlUpdate = "UPDATE tickets SET assigned_agent_id = :agent_id, status = 'In Progress' WHERE id = :id";
            }
            
            queryExecute( sqlUpdate, params );
        }
    }

    function updateStatus( required string ticketUid, required string status ){
        var ticket = getTicketByUid( arguments.ticketUid );
        if ( isNull( ticket ) ) return;

        queryExecute( "UPDATE tickets SET status = :status WHERE id = :id", {
            status: { value: arguments.status, cfsqltype: "cf_sql_varchar" },
            id: { value: ticket.id, cfsqltype: "cf_sql_integer" }
        });
    }

    function analyzeTicket( required string ticketUid, required string prompt ){
         // In a real app, this would call OpenAI/Gemini API
         // For now, we simulate a smart response based on keywords
         var ticket = getTicketByUid( arguments.ticketUid );
         var analysis = "AI Analysis for Ticket ##" & ticket.ticket_uid & ":\n\n";
         
         if ( ticket.description contains "login" || ticket.description contains "password" ) {
             analysis &= "Subject: Authentication Issue\nRecommended Action: Reset user password or check Active Directory status.\nRelated Articles: KB-102 (Login Errors)";
         } else if ( ticket.description contains "pay" || ticket.description contains "invoice" ) {
             analysis &= "Subject: Billing Inquiry\nRecommended Action: Verify transaction ID in Stripe dashboard. Check for refund eligibility.\nRelated Articles: KB-205 (Refund Policy)";
         } else {
             analysis &= "Subject: General Inquiry\nRecommended Action: Assign to Triage team for further classification.\nComplexity: Medium";
         }
         
         return analysis;
    }
}
