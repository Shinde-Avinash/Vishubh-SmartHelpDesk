component singleton {

    function getAllTeams(){
        return queryExecute( "SELECT * FROM teams ORDER BY name ASC", {}, { returnType = "array" } );
    }

    function createTeam( required string name, required string description ){
        queryExecute( "INSERT INTO teams (name, description) VALUES (:name, :description)", {
            name: { value: arguments.name, cfsqltype: "cf_sql_varchar" },
            description: { value: arguments.description, cfsqltype: "cf_sql_varchar" }
        });
    }

    function getTeamById( required numeric id ){
        var sql = "SELECT * FROM teams WHERE id = :id";
        var result = queryExecute( sql, {
            id: { value: arguments.id, cfsqltype: "cf_sql_integer" }
        });
        
        if ( result.recordCount ) {
            var team = {};
            for( var col in result.columnList ){
                team[ col ] = result[ col ][ 1 ];
            }
            return team;
        }
        return;
    }

    function updateTeam( required numeric id, required string name, required string description ){
        fileAppend( expandPath("/handler_debug.txt"), "TeamManagementService.updateTeam called for ID: #arguments.id#" & chr(13) & chr(10) );
        queryExecute( "UPDATE teams SET name = :name, description = :description WHERE id = :id", {
            name: { value: arguments.name, cfsqltype: "cf_sql_varchar" },
            description: { value: arguments.description, cfsqltype: "cf_sql_varchar" },
            id: { value: arguments.id, cfsqltype: "cf_sql_integer" }
        });
    }

    function deleteTeam( required numeric id ){
        fileAppend( expandPath("/handler_debug.txt"), "TeamManagementService.deleteTeam called for ID: #arguments.id#" & chr(13) & chr(10) );
        queryExecute( "DELETE FROM teams WHERE id = :id", {
            id: { value: arguments.id, cfsqltype: "cf_sql_integer" }
        });
    }
}
