<!--- Main Layout --->
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <cfoutput><base href="#event.getHTMLBaseURL()#" /></cfoutput>
    <title>Vishubh SmartHelpDesk</title>
    <meta name="description" content="AI-Powered Customer Support Portal">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="includes/css/style.css?v=#createUUID()#_v3">
</head>
<cfoutput>
<body>
    <nav class="app-navbar">
        <div class="container flex justify-between items-center">
            <!-- Brand -->
            <a href="#event.buildLink('main')#" class="nav-brand">
                <div class="nav-icon-bg">
                    <i class="fas fa-headset"></i>
                </div>
                <span>Vishubh SmartHelpDesk</span>
            </a>

            <!-- Navigation -->
            <div class="flex items-center gap-4">
                <div class="nav-links">
                    <a href="#event.buildLink('main')#" class="nav-link">Home</a>
                    <a href="#event.buildLink('main.about')#" class="nav-link">About</a>
                    <cfif structKeyExists( session, "user" )>
                        <a href="#event.buildLink('tickets.index')#" class="nav-link">My Tickets</a>
                         <cfif session.user.role == "admin" || session.user.role == "agent" || session.user.role == "team_lead">
                            <a href="#event.buildLink('dashboard.index')#" class="nav-link">Dashboard</a>
                        </cfif>
                    </cfif>
                </div>

                <div class="flex items-center gap-2" style="margin-left: 1rem; padding-left: 1rem; border-left: 1px solid var(--border-color);">
                    <button id="theme-toggle" class="btn btn-icon" aria-label="Toggle Theme">
                        <i class="fas fa-moon"></i>
                    </button>

                    <cfif structKeyExists( session, "user" )>
                         <div class="flex items-center gap-2">
                            <a href="#event.buildLink('main.profile')#" style="font-weight: 600; font-size: 0.9rem; text-decoration: none; color: inherit;">#session.user.username#</a>
                            <a href="#event.buildLink('sessions.delete')#" class="btn btn-outline" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">Logout</a>
                        </div>
                    <cfelse>
                        <a href="#event.buildLink('sessions.new')#" class="btn btn-primary">Sign In</a>
                    </cfif>
                </div>
            </div>
        </div>
    </nav>

    <main class="container main-content animate-fade-in">
        #view()#
    </main>

    <footer class="footer">
        <p>&copy; 2025 Vishubh SmartHelpDesk. Built for excellence.</p>
    </footer>

    <!-- Custom JS -->
    <script src="includes/js/app.js"></script>

    <!-- AI Assistant Widget -->
    <div id="ai-widget-container">
        <!-- Chat Box -->
        <div id="ai-chat-box" class="ai-chat-box hidden">
            <div class="ai-header">
                <div class="flex items-center gap-2">
                    <i class="fas fa-sparkles"></i>
                    <span>AI Assistant</span>
                </div>
                <button id="ai-close-btn" class="btn-icon-small"><i class="fas fa-times"></i></button>
            </div>
            <div id="ai-messages" class="ai-messages">
                <div class="ai-message ai-message-bot">
                    Hello! I'm your AI assistant. How can I help you today?
                </div>
            </div>
            <div class="ai-input-area">
                <input type="text" id="ai-input" placeholder="Ask me anything..." onkeypress="handleAIKeyPress(event)">
                <button onclick="sendAIMessage()" class="btn-send"><i class="fas fa-paper-plane"></i></button>
            </div>
        </div>

        <!-- FAB -->
        <button id="ai-fab" class="ai-fab" onclick="toggleAIChat()">
            <i class="fas fa-robot"></i>
        </button>
    </div>

    <style>
        /* AI Widget Styles */
        .ai-fab {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background: var(--primary-color, ##2563eb);
            color: white;
            border-radius: 50%;
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            cursor: pointer;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            transition: all 0.3s ease;
        }
        .ai-fab:hover {
            transform: scale(1.1);
            background: var(--primary-hover, ##1d4ed8);
        }

        .ai-chat-box {
            position: fixed;
            bottom: 100px;
            right: 30px;
            width: 350px;
            height: 500px;
            background: var(--bg-card, ##ffffff);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
            z-index: 1000;
            display: flex;
            flex-direction: column;
            border: 1px solid var(--border-color, ##e2e8f0);
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .ai-chat-box.hidden {
            opacity: 0;
            transform: translateY(20px);
            pointer-events: none;
        }

        .ai-header {
            background: var(--primary-color, ##2563eb);
            color: white;
            padding: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
        }
        .btn-icon-small {
            background: transparent;
            border: none;
            color: white;
            cursor: pointer;
            font-size: 1rem;
        }

        .ai-messages {
            flex: 1;
            padding: 1rem;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 0.8rem;
            background: var(--bg-main, ##f8fafc);
        }

        .ai-message {
            max-width: 80%;
            padding: 0.75rem 1rem;
            border-radius: 12px;
            font-size: 0.9rem;
            line-height: 1.4;
        }
        .ai-message-bot {
            background: var(--bg-card, ##ffffff);
            border: 1px solid var(--border-color, ##e2e8f0);
            align-self: flex-start;
            border-bottom-left-radius: 2px;
        }
        .ai-message-user {
            background: var(--primary-color, ##2563eb);
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 2px;
        }
        .ai-message-error {
            background: ##fee2e2;
            color: ##b91c1c;
            align-self: center;
        }

        .ai-input-area {
            padding: 1rem;
            border-top: 1px solid var(--border-color, ##e2e8f0);
            background: var(--bg-card, ##ffffff);
            display: flex;
            gap: 0.5rem;
        }
        ##ai-input {
            flex: 1;
            padding: 0.5rem;
            border: 1px solid var(--border-color, ##cbd5e1);
            border-radius: 8px;
            outline: none;
            background: var(--bg-input, ##ffffff);
            color: var(--text-main, ##0f172a);
        }
        .btn-send {
            background: var(--primary-color, ##2563eb);
            color: white;
            border: none;
            border-radius: 8px;
            width: 40px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-send:hover {
            background: var(--primary-hover, ##1d4ed8);
        }
    </style>

    <script>
        function toggleAIChat() {
            const chatBox = document.getElementById('ai-chat-box');
            chatBox.classList.toggle('hidden');
            if (!chatBox.classList.contains('hidden')) {
                document.getElementById('ai-input').focus();
            }
        }

        document.getElementById('ai-close-btn').addEventListener('click', toggleAIChat);

        function handleAIKeyPress(event) {
            if (event.key === 'Enter') {
                sendAIMessage();
            }
        }

        async function sendAIMessage() {
            const input = document.getElementById('ai-input');
            const message = input.value.trim();
            const messagesDiv = document.getElementById('ai-messages');

            if (!message) return;

            // Add User Message
            addMessage(message, 'user');
            input.value = '';

            // Add Loading Indicator
            const loadingId = 'ai-loading-' + Date.now();
            const loadingDiv = document.createElement('div');
            loadingDiv.className = 'ai-message ai-message-bot';
            loadingDiv.id = loadingId;
            loadingDiv.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Thinking...';
            messagesDiv.appendChild(loadingDiv);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;

            try {
                // Determine context (e.g. current page title)
                const context = "Current Page: " + document.title;

                const response = await fetch('#event.buildLink("ai.chat")#?message=' + encodeURIComponent(message) + '&context=' + encodeURIComponent(context));
                const data = await response.json();

                // Remove loading
                document.getElementById(loadingId).remove();

                if (data.success) {
                    addMessage(data.response, 'bot'); // Use marked.js if markdown needed, but plain text for now
                } else {
                    addMessage('Error: ' + data.response, 'error');
                }

            } catch (error) {
                document.getElementById(loadingId).remove();
                addMessage('Connection error. Please try again.', 'error');
                console.error(error);
            }
        }

        function addMessage(text, type) {
            const messagesDiv = document.getElementById('ai-messages');
            const div = document.createElement('div');
            div.className = 'ai-message ai-message-' + type;
            // Simple text Content to prevent XSS, unless we trust the bot
            div.textContent = text; 
            messagesDiv.appendChild(div);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
        }
    </script>
</body>
</cfoutput>
</html>
