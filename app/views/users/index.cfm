<cfoutput>
<div class="mt-4">
    <div class="flex justify-between items-center mb-4">
        <h2>User Management</h2>
        <a href="#event.buildLink('dashboard.index')#" class="btn btn-primary">Back to Dashboard</a>
    </div>

    <cfif structKeyExists( flash, "message" )>
        <div class="mb-4" style="padding: 1rem; border-radius: var(--radius); background-color: var(--success-light); color: var(--success); border: 1px solid var(--success);">
            #flash.message#
        </div>
    </cfif>
    <cfif structKeyExists( flash, "error" )>
        <div class="mb-4" style="padding: 1rem; border-radius: var(--radius); background-color: var(--danger-light); color: var(--danger); border: 1px solid var(--danger);">
            #flash.error#
        </div>
    </cfif>

    <div class="card">
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop array="#prc.users#" item="user">
                        <tr>
                            <td>#user.id#</td>
                            <td>
                                <div style="font-weight: 600;">#user.username#</div>
                                <small class="text-muted">#user.phone#</small>
                            </td>
                            <td>#user.email#</td>
                            <td>
                                <span class="badge" style="border: 1px solid var(--border-color);">#uCase(user.role)#</span>
                            </td>
                            <td>
                                <div class="flex gap-2">
                                    <a href="#event.buildLink('users.edit', {user_id: user.id})#" class="btn btn-sm btn-primary">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <cfif user.id != session.user.id>
                                        <a href="#event.buildLink('users.delete', {user_id: user.id})#" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </cfif>
                                </div>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
    </div>
</div>
</cfoutput>
