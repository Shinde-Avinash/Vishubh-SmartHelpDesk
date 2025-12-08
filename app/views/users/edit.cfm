<cfoutput>
<div style="max-width: 600px; margin: 0 auto;" class="mt-4">
    <div class="flex justify-between items-center mb-4">
        <h2>Edit User</h2>
        <a href="#event.buildLink('users.index')#" class="btn btn-outline">Back to Users</a>
    </div>

    <div class="card">
        <form action="#event.buildLink('users.update')#" method="post">
            <input type="hidden" name="user_id" value="#prc.user.id#">
            
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <input type="text" name="username" id="username" class="form-control" value="#prc.user.username#" required>
            </div>
            
            <div class="form-group">
                <label for="email" class="form-label">Email</label>
                <input type="email" name="email" id="email" class="form-control" value="#prc.user.email#" required>
            </div>

            <div class="form-group">
                <label for="phone" class="form-label">Phone</label>
                <input type="tel" name="phone" id="phone" class="form-control" value="#prc.user.phone ?: ''#">
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <label for="role" class="form-label">Role</label>
                    <select name="role" id="role" class="form-control" required>
                        <option value="user" #(prc.user.role == 'user' ? 'selected' : '')#>User</option>
                        <option value="agent" #(prc.user.role == 'agent' ? 'selected' : '')#>Agent</option>
                        <option value="admin" #(prc.user.role == 'admin' ? 'selected' : '')#>Admin</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="team_id" class="form-label">Team Assignment</label>
                    <select name="team_id" id="team_id" class="form-control">
                        <option value="">Select Team</option>
                        <cfloop array="#prc.teams#" item="team">
                            <option value="#team.id#" #(structKeyExists(prc, "currentTeamId") && prc.currentTeamId == team.id ? 'selected' : '')#>
                                #team.name#
                            </option>
                        </cfloop>
                    </select>
                    <small class="text-muted">Required for Agents to see Team Tickets</small>
                </div>
            </div>

            <div class="text-end mt-4">
                <button type="submit" class="btn btn-primary">Update User</button>
            </div>
        </form>
    </div>
</div>
</cfoutput>
