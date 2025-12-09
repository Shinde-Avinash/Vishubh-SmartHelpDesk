component singleton {
    
    property name="apiKey"; // Or read from env

    function init(){
        variables.apiKey = server.system.environment.GEMINI_API_KEY ?: "";
        
        // Fallback: Read .env file directly if finding key fails
        if ( !len(variables.apiKey) && fileExists( expandPath( "/.env" ) ) ) {
            var envContent = fileRead( expandPath( "/.env" ) );
            for ( var line in listToArray( envContent, chr(10) ) ) {
                if ( findNoCase( "GEMINI_API_KEY=", line ) ) {
                    variables.apiKey = listLast( line, "=" );
                    variables.apiKey = trim( variables.apiKey ); // Clean up
                    break;
                }
            }
        }
        return this;
    }

    function generateResponse( required string prompt, string context = "" ){
        // Lazy load key if missing or empty
        var envPath = expandPath( "/.env" );
        if ( !fileExists( envPath ) ) {
            envPath = expandPath( "/../.env" );
        }

        if ( !len( variables.apiKey ) ) {
            variables.apiKey = server.system.environment.GEMINI_API_KEY ?: "";
            
            if ( !len( variables.apiKey ) && fileExists( envPath ) ) {
                var envContent = fileRead( envPath );
                for ( var line in listToArray( envContent, chr(10) ) ) {
                    if ( findNoCase( "GEMINI_API_KEY", line ) ) {
                        var parts = listToArray( line, "=" );
                        if ( arrayLen(parts) >= 2 ) {
                             variables.apiKey = trim( parts[2] );
                             break;
                        }
                    }
                }
            }
        }

        if ( !len( variables.apiKey ) ) {
            return "Error: Gemini API Key is not configured.";
        }
        
        // Determine Model
        var modelName = "gemini-flash-latest"; // Default per user request
        var apiVersion = "v1beta";
        
        // Check .env for GEMINI_MODEL
        if ( fileExists( envPath ) ) {
             var envContent = fileRead( envPath );
             for ( var line in listToArray( envContent, chr(10) ) ) {
                 if ( findNoCase( "GEMINI_MODEL", line ) ) {
                     var parts = listToArray( line, "=" );
                     if ( arrayLen(parts) >= 2 ) {
                          modelName = trim( parts[2] );
                          break;
                     }
                 }
             }
        }
        
        // Map version based on model name
        if ( findNoCase( "gemini-pro", modelName ) && !findNoCase( "1.5", modelName ) && !findNoCase( "1.0", modelName ) ) {
            apiVersion = "v1";
        }
        // Explicitly ensure flash-latest uses v1beta (default is v1beta so this is just for clarity)
        if ( modelName == "gemini-flash-latest" ) {
            apiVersion = "v1beta";
        }

        var apiUrl = "https://generativelanguage.googleapis.com/" & apiVersion & "/models/" & modelName & ":generateContent?key=" & variables.apiKey;
        
        var fullPrompt = arguments.prompt;
        if ( len(arguments.context) ) {
            fullPrompt = "Context: " & arguments.context & ". User Query: " & arguments.prompt;
        }

        var payload = {
            "contents": [{
                "parts": [{
                    "text": fullPrompt
                }]
            }]
        };
        
        try {
             cfhttp( url=apiUrl, method="post", result="httpResult" ) {
                 cfhttpparam( type="header", name="Content-Type", value="application/json" );
                 cfhttpparam( type="body", value=serializeJSON(payload) );
             }
             
             var response = deserializeJSON( httpResult.filecontent );
             
             if ( structKeyExists( response, "candidates" ) && arrayLen( response.candidates ) > 0 ) {
                 return response.candidates[1].content.parts[1].text;
             } else if ( structKeyExists( response, "error" ) ) {
                 var logMsg = "Model: " & modelName & " | Error: " & response.error.message;
                 fileAppend( expandPath("/gemini_debug.log"), logMsg & chr(13) & chr(10) );
                 return "Gemini API Error (" & modelName & "): " & response.error.message;
             }
             
             return "No response generated.";

        } catch ( any e ) {
             fileAppend( expandPath("/gemini_debug.log"), "Exception: " & e.message & chr(13) & chr(10) );
             return "System Error: " & e.message;
        }
    }

    function analyzeTicket( required string title, required string description ){
        var prompt = "Analyze this support ticket. Provide a brief summary, potential technical category, and suggested initial troubleshooting steps.\n\nTitle: " & arguments.title & "\nDescription: " & arguments.description;
        return generateResponse( prompt );
    }

}
