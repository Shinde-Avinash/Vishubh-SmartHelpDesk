component singleton {
    
    function create( required struct userData ){
        var sql = "
            INSERT INTO users (username, password, email, role, phone)
            VALUES (:username, :password, :email, :role, :phone)
        ";
        
        // In a real app, use BCrypt or similar. For now, simple hash or plain text (as per user "avi10" example, but I should hash it)
        // I'll use hash() for basic security
        var hashedPassword = hash( arguments.userData.password, "SHA-256" );
        
        queryExecute( sql, {
            username: { value: arguments.userData.username, cfsqltype: "cf_sql_varchar" },
            password: { value: hashedPassword, cfsqltype: "cf_sql_varchar" },
            email: { value: arguments.userData.email, cfsqltype: "cf_sql_varchar" },
            role: { value: arguments.userData.role, cfsqltype: "cf_sql_varchar" },
            phone: { value: arguments.userData.phone, cfsqltype: "cf_sql_varchar" }
        });
    }

    function authenticate( required string username, required string password ){
        var hashedPassword = hash( arguments.password, "SHA-256" );
        
        var sql = "
            SELECT * FROM users 
            WHERE username = :username AND password = :password
        ";
        
        var result = queryExecute( sql, {
            username: { value: arguments.username, cfsqltype: "cf_sql_varchar" },
            password: { value: hashedPassword, cfsqltype: "cf_sql_varchar" }
        });
        
        if ( result.recordCount ) {
            var user = {};
            for( var col in result.columnList ){
                user[ col ] = result[ col ][ 1 ];
            }
            return user;
        }
        return;
    }
    
    function getByUsername( required string username ){
        var sql = "SELECT * FROM users WHERE username = :username";
        var result = queryExecute( sql, {
            username: { value: arguments.username, cfsqltype: "cf_sql_varchar" }
        });
        
        if ( result.recordCount ) {
            var user = {};
            for( var col in result.columnList ){
                user[ col ] = result[ col ][ 1 ];
            }
            return user;
        }
        return;
    }

     function getAllUsers(){
          return queryExecute( "SELECT id, username, email, role, department, phone FROM users ORDER BY username ASC", {}, { returnType = "array" } );
     }

     function getAgentsWithTeams(){
          var sql = "
            SELECT u.id, u.username, u.role, t.name as team_name 
            FROM users u 
            LEFT JOIN agents a ON u.id = a.user_id 
            LEFT JOIN teams t ON a.team_id = t.id 
            WHERE u.role IN ('agent', 'team_lead', 'admin')
            ORDER BY t.name ASC, u.username ASC
          ";
          return queryExecute( sql, {}, { returnType = "array" } );
     }

    function updateUserRole( required numeric userId, required string role ){
        queryExecute( "UPDATE users SET role = :role WHERE id = :id", {
            role: { value: arguments.role, cfsqltype: "cf_sql_varchar" },
            id: { value: arguments.userId, cfsqltype: "cf_sql_integer" }
        });
    }

    function getUserById( required numeric userId ){
        var sql = "SELECT id, username, email, role, department, phone FROM users WHERE id = :id";
        var result = queryExecute( sql, {
            id: { value: arguments.userId, cfsqltype: "cf_sql_integer" }
        });
        
        if ( result.recordCount ) {
            var user = {};
            for( var col in result.columnList ){
                user[ col ] = result[ col ][ 1 ];
            }
            return user;
        }
        return;
    }

    function updateUser( required numeric userId, required string username, required string email, required string phone, required string role, string department = "" ){
        var sql = "
            UPDATE users 
            SET username = :username,
                email = :email,
                phone = :phone,
                role = :role,
                department = :department
            WHERE id = :id
        ";
        
        var params = {
            username: { value: arguments.username, cfsqltype: "cf_sql_varchar" },
            email: { value: arguments.email, cfsqltype: "cf_sql_varchar" },
            phone: { value: arguments.phone, cfsqltype: "cf_sql_varchar" },
            role: { value: arguments.role, cfsqltype: "cf_sql_varchar" },
            department: { value: arguments.department, cfsqltype: "cf_sql_varchar", null: !len(arguments.department) },
            id: { value: arguments.userId, cfsqltype: "cf_sql_integer" }
        };
        
        try {
            queryExecute( sql, params );
        } catch( any e ) {
            // Self-healing: Add column if missing
            if ( e.message contains "Unknown column 'department'" ) {
                try {
                    queryExecute( "ALTER TABLE users ADD COLUMN department VARCHAR(100) NULL AFTER role" );
                    // Retry update
                    queryExecute( sql, params );
                } catch( any e2 ) {
                    rethrow;
                }
            } else {
                rethrow;
            }
        }
    }

    function deleteUser( required numeric userId ){
        // Typically soft delete is better, but for now hard delete
        queryExecute( "DELETE FROM users WHERE id = :id", {
            id: { value: arguments.userId, cfsqltype: "cf_sql_integer" }
        });
    }

}
