<cfscript>
    var dbConfig = {
        "url"      = "jdbc:mysql://127.0.0.1:3306/Vishubh_SmartHelpDeskDB?useSSL=false&useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&useLegacyDatetimeCode=true&allowPublicKeyRetrieval=true&createDatabaseIfNotExist=true",
        "username" = "avi10",
        "password" = "avi10"
    };

    try {
        var props = createObject("java", "java.util.Properties").init();
        props.put("user", dbConfig.username);
        props.put("password", dbConfig.password);
        
        var driver = createObject("java", "com.mysql.cj.jdbc.Driver");
        var conn = driver.connect(dbConfig.url, props);
        var stmt = conn.createStatement();
        
        // Select ALL columns
        var rs = stmt.executeQuery("SELECT * FROM users");
        var meta = rs.getMetaData();
        var colCount = meta.getColumnCount();
        
        systemOutput("--- User Table Columns ---", true);
        for(var i=1; i<=colCount; i++) {
             systemOutput("Msg: " & meta.getColumnName(i) & " (" & meta.getColumnTypeName(i) & ")", true);
        }

        systemOutput("--- Data ---", true);
        while(rs.next()) {
            var row = "ID: " & rs.getString("id");
            // Check specific timestamps if they exist
            try {
               row &= ", CreatedAt: " & rs.getString("created_at"); 
            } catch(any e){}
            
            systemOutput(row, true);
        }
        
        conn.close();
        
    } catch(any e) {
        systemOutput("JDBC Error: " & e.message & " " & e.detail, true);
    }
</cfscript>
