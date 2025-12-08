<cfscript>
    envPath = expandPath( "/.env" );
    // Try root
    if ( !fileExists( envPath ) ) {
        envPath = expandPath( "/../.env" );
    }

    apiKey = "";
    if ( fileExists( envPath ) ) {
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
    }

    if ( !len(apiKey) ) {
        print.line("No API Key found in .env");
        abort;
    }

    print.line("Using API Key: " & left(apiKey, 5) & "...");

    cfhttp( url="https://generativelanguage.googleapis.com/v1beta/models?key=" & apiKey, method="get", result="httpResult" );

    if ( isJSON( httpResult.filecontent ) ) {
        data = deserializeJSON( httpResult.filecontent );
        if ( structKeyExists( data, "models" ) ) {
            print.line("Available Models:");
            for ( model in data.models ) {
                if ( arrayContains( model.supportedGenerationMethods, "generateContent" ) ) {
                     print.line( " - " & model.name );
                }
            }
        } else {
            print.line("Error: " & httpResult.filecontent);
        }
    } else {
        print.line("Raw Response: " & httpResult.filecontent);
    }
</cfscript>
