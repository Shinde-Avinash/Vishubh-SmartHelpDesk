<cfscript>
    // Read Key
    envPath = expandPath( "./.env" );
    // Try root if not found
    if ( !fileExists( envPath ) ) {
        envPath = expandPath( "../.env" );
    }

    if ( !fileExists( envPath ) ) {
        fileWrite( expandPath("models_debug.json"), "Error: .env not found at " & envPath );
        abort;
    }

    apiKey = "";
    envContent = fileRead( envPath );
    for ( line in listToArray( envContent, chr(10) ) ) {
            if ( findNoCase( "GEMINI_API_KEY", line ) ) {
                parts = listToArray( line, "=" );
                if ( arrayLen(parts) >= 2 ) {
                    apiKey = trim( parts[2] );
                    break;
                }
            }
    }

    if ( !len(apiKey) ) {
        fileWrite( expandPath("models_debug.json"), "Error: API Key not found in .env" );
        abort;
    }

    // Try v1beta
    url = "https://generativelanguage.googleapis.com/v1beta/models?key=" & apiKey;
    
    try {
        cfhttp( url=url, method="get", result="httpResult" );
        fileWrite( expandPath("models_debug.json"), httpResult.filecontent );
    } catch ( any e ) {
        fileWrite( expandPath("models_debug.json"), "Exception: " & e.message & " " & e.detail );
    }
</cfscript>
