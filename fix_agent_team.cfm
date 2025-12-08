<cfscript>
    try {
        // Fix for User 3 (Technical Support Agent) -> Team 3
        var checkAgent = queryExecute("SELECT * FROM agents WHERE user_id = 3");
        
        if ( checkAgent.recordCount ) {
             queryExecute("UPDATE agents SET team_id = 3 WHERE user_id = 3");
             fileWrite(expandPath("./public/verify_fix.txt"), "Updated User 3 to Team 3\n");
        } else {
             queryExecute("INSERT INTO agents (user_id, team_id) VALUES (3, 3)");
             fileWrite(expandPath("./public/verify_fix.txt"), "Inserted User 3 into agents with Team 3\n");
        }
        
        // Also check User 6 (Billing Agent) -> Team 2 (Billing) just in case
        var checkAgent6 = queryExecute("SELECT * FROM agents WHERE user_id = 6");
         if ( checkAgent6.recordCount ) {
             // Assuming User 6 IS the billing agent based on logs (User 6 is showing NULL too in logs!)
             // Wait, logs showed "User 6 (agent) has TeamID: NULL" in lines 81-92. 
             // And "User 3 (agent) has TeamID: NULL" in lines 51-60.
             // So BOTH need fixing.
             queryExecute("UPDATE agents SET team_id = 2 WHERE user_id = 6");
             fileAppend(expandPath("./public/verify_fix.txt"), "Updated User 6 to Team 2\n");
        } else {
            // Check if User 6 exists first?
             var user6 = queryExecute("SELECT * FROM users WHERE id = 6");
             if ( user6.recordCount ) {
                 queryExecute("INSERT INTO agents (user_id, team_id) VALUES (6, 2)");
                 fileAppend(expandPath("./public/verify_fix.txt"), "Inserted User 6 into agents with Team 2\n");
             }
        }

    } catch( any e ) {
        systemOutput("Error: " & e.message & " " & e.detail, true);
    }
</cfscript>
