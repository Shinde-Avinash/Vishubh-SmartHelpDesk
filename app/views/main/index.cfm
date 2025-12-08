<cfoutput>
<div class="hero-section">
    <div class="mb-4">
        <span class="badge" style="background: var(--primary-light); color: var(--primary);">AI-Powered Support v2.0</span>
    </div>
    
    <h1 class="hero-title">
        Future of Customer Support<br>
        <span class="text-primary">Is Here</span>
    </h1>
    
    <p class="hero-subtitle">
        Experience instant resolutions with our advanced AI engine. Smart routing, real-time analytics, and seamless communication all in one platform.
    </p>
    
    <div class="flex justify-center gap-4 mt-8">
        <cfif structKeyExists( session, "user" )>
            <a href="#event.buildLink('tickets.index')#" class="btn btn-primary" style="padding: 0.8rem 1.5rem; font-size: 1.1rem;">
                <i class="fas fa-ticket-alt"></i> Go to Dashboard
            </a>
        <cfelse>
            <a href="#event.buildLink('sessions.new')#" class="btn btn-primary" style="padding: 0.8rem 1.5rem; font-size: 1.1rem;">
                <i class="fas fa-rocket"></i> Get Started
            </a>
        </cfif>
        <a href="#event.buildLink('main.about')#" class="btn btn-outline" style="padding: 0.8rem 1.5rem; font-size: 1.1rem;">
            <i class="fas fa-info-circle"></i> Learn More
        </a>
    </div>
</div>

<div class="grid-3 mt-4">
    <div class="card text-center">
        <div style="font-size: 2.5rem; color: var(--primary); margin-bottom: 1rem;"><i class="fas fa-robot"></i></div>
        <h3 class="mb-2">AI Analysis</h3>
        <p class="text-muted">
            Our AI analyzes every ticket instantly, suggesting solutions and categorizing issues before human agents even see them.
        </p>
    </div>
    
    <div class="card text-center">
        <div style="font-size: 2.5rem; color: var(--primary); margin-bottom: 1rem;"><i class="fas fa-network-wired"></i></div>
        <h3 class="mb-2">Smart Routing</h3>
        <p class="text-muted">
            Tickets are automatically routed to the correct department (Billing, Tech, Sales) based on content analysis.
        </p>
    </div>
    
    <div class="card text-center">
        <div style="font-size: 2.5rem; color: var(--primary); margin-bottom: 1rem;"><i class="fas fa-bolt"></i></div>
        <h3 class="mb-2">Real-time Action</h3>
        <p class="text-muted">
            Live chat capabilities and instant status updates keep your customers informed and happy throughout the process.
        </p>
    </div>
</div>
</cfoutput>
