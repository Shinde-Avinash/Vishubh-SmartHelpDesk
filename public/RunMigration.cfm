<cfscript>
    try {
        var ds = "Vishubh_SmartHelpDeskDB";
        writeOutput("Migration Script Running...<br>");
        
        try {
             queryExecute("SELECT department FROM users LIMIT 1", {}, {datasource=ds});
             writeOutput("Column 'department' already exists.<br>");
        } catch(any e) {
             writeOutput("Column 'department' missing. Adding...<br>");
             try {
                queryExecute("ALTER TABLE users ADD COLUMN department VARCHAR(100) NULL AFTER role", {}, {datasource=ds});
                writeOutput("<strong>SUCCESS: Column 'department' added.</strong><br>");
             } catch(any e2) {
                writeOutput("<strong>ERROR:</strong> " & e2.message & " " & e2.detail & "<br>");
             }
        }
    } catch (any e) {
        writeOutput("<strong>CRITICAL ERROR:</strong> " & e.message & " " & e.detail);
    }
</cfscript>
