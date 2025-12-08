<cfscript>
    agents = queryExecute("SELECT a.id, a.user_id, a.team_id, u.username, t.name as team_name FROM agents a JOIN users u ON a.user_id = u.id LEFT JOIN teams t ON a.team_id = t.id");
    teams = queryExecute("SELECT * FROM teams");
    
    fileWrite(expandPath("./agent_debug_data.txt"), "AGENTS:\n");
    loop query="#agents#" {
        fileAppend(expandPath("./agent_debug_data.txt"), "ID: #id#, UserID: #user_id#, Username: #username#, TeamID: #team_id#, Team: #team_name#\n");
    }
    
    fileAppend(expandPath("./agent_debug_data.txt"), "\nTEAMS:\n");
    loop query="#teams#" {
        fileAppend(expandPath("./agent_debug_data.txt"), "ID: #id#, Name: #name#\n");
    }
    
    systemOutput("Done writing agent_debug_data.txt", true);
</cfscript>
