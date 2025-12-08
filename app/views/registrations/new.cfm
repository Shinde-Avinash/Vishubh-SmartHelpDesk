<cfoutput>
<div class="container" style="max-width: 500px; margin-top: 4rem;">
    <div class="card">
        <div class="text-center mb-4">
            <h2 style="color: var(--primary-color);"><i class="fas fa-user-plus"></i> Register</h2>
            <p class="text-muted">Create your account</p>
        </div>

        <cfif structKeyExists( flash, "error" )>
            <div class="alert alert-danger" style="color: var(--danger-color); background: rgba(239, 68, 68, 0.1); padding: 0.75rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                #flash.error#
            </div>
        </cfif>

        <form action="#event.buildLink('registrations.create')#" method="post">
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input type="text" name="username" id="username" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="email" class="form-label">Email</label>
                <input type="email" name="email" id="email" class="form-control" required>
            </div>

            <div class="form-group">
                <label for="phone" class="form-label">Phone</label>
                <input type="tel" name="phone" id="phone" class="form-control">
            </div>
            
            <div class="grid grid-cols-2 gap-4">
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="confirm_password" class="form-label">Confirm Password</label>
                    <input type="password" name="confirm_password" id="confirm_password" class="form-control" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">
                Register
            </button>
        </form>
        
        <div class="text-center mt-4">
            <p class="text-muted">Already have an account? <a href="#event.buildLink('sessions.new')#">Login here</a></p>
        </div>
    </div>
</div>
</cfoutput>
