<cfscript>
    data = queryExecute("SELECT u.id, u.username, a.team_id, t.name as team_name FROM users u JOIN agents a ON u.id = a.user_id LEFT JOIN teams t ON a.team_id = t.id WHERE u.id IN (3,6)");
    systemOutput("VERIFICATION RESULT:", true);
    loop query="#data#" {
        systemOutput("User: #username# (#id#) -> TeamID: #team_id# (#team_name#)", true);
    }
</cfscript>
