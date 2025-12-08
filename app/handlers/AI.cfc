component {
    
    // property name="aiService" inject="AIService"; // Local instantiation to be safe from cache issues

    function chat( event, rc, prc ){
        event.renderData( type="json", data=processChat( rc.message ?: "", rc.context ?: "" ) );
    }

    private function processChat( string message, string context ){
        if ( !len(arguments.message) ) {
            return { "success": false, "response": "Please enter a message." };
        }

        try {
            var aiService = new app.models.AIService();
            var reply = aiService.generateResponse( arguments.message, arguments.context );
            return { "success": true, "response": reply };
        } catch( any e ) {
            return { "success": false, "response": "Error: " & e.message };
        }
    }
}
