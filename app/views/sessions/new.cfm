<cfoutput>
<div class="container" style="max-width: 400px; margin-top: 4rem;">
    <div class="card">
        <div class="text-center mb-4">
            <h2 style="color: var(--primary-color);"><i class="fas fa-sign-in-alt"></i> Login</h2>
            <p class="text-muted">Access your dashboard</p>
        </div>

        <cfif structKeyExists( flash, "error" )>
            <div class="alert alert-danger" style="color: var(--danger-color); background: rgba(239, 68, 68, 0.1); padding: 0.75rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                #flash.error#
            </div>
        </cfif>
        <cfif structKeyExists( flash, "message" )>
            <div class="alert alert-success" style="color: var(--secondary-color); background: rgba(16, 185, 129, 0.1); padding: 0.75rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                #flash.message#
            </div>
        </cfif>

        <form action="#event.buildLink('sessions.create')#" method="post">
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <div style="position: relative;">
                    <i class="fas fa-user" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                    <input type="text" name="username" id="username" class="form-control" style="padding-left: 2.5rem;" required placeholder="Enter your username">
                </div>
            </div>
            
            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <div style="position: relative;">
                    <i class="fas fa-lock" style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                    <input type="password" name="password" id="password" class="form-control" style="padding-left: 2.5rem;" required placeholder="Enter your password">
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">
                Login
            </button>
        </form>
        
        <div class="text-center mt-4">
            <p class="text-muted">Don't have an account? <a href="#event.buildLink('registrations.new')#">Register here</a></p>
        </div>
    </div>
</div>
</cfoutput>
