<cfscript>
    try {
        userService = new app.models.UserService();
        
        username = "testuser_" & getTickCount();
        email = "test_" & getTickCount() & "@example.com";
        
        writeOutput("Attempting to create user: " & username & "<br>");
        
        userService.create({
            username: username,
            password: "password123",
            email: email,
            role: "user",
            phone: "1234567890"
        });
        
        writeOutput("User created successfully.<br>");
        
        // Verify user exists
        checkUser = userService.authenticate(username, "password123");
        if (!isNull(checkUser)) {
            writeOutput("User authenticated successfully.<br>");
        } else {
            writeOutput("User authentication failed.<br>");
        }

    } catch (any e) {
        writeOutput("Error: " & e.message & "<br>" & e.detail & "<br>");
    }
</cfscript>
