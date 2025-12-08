<cfoutput>
<div class="mt-4">
    <div class="flex justify-between items-center mb-4">
        <h2 class="text-primary">
            <i class="fas fa-users-cog me-2"></i> Team Management
        </h2>
        <a href="#event.buildLink('teams.new')#" class="btn btn-primary">
            <i class="fas fa-plus"></i> Create New Team
        </a>
    </div>

    <div class="card">
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Team Name</th>
                        <th>Description</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop array="#prc.teams#" item="team">
                        <tr>
                            <td>#team.id#</td>
                            <td class="font-bold">#team.name#</td>
                            <td>#team.description#</td>
                            <td>#dateformat(team.created_at, "medium")#</td>
                            <td class="flex gap-2">
                                <a href="#event.buildLink('teams.edit', {id: team.id})#" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                                <form action="#event.buildLink('teams.delete')#" method="post" onsubmit="return confirm('Are you sure you want to delete this team?');">
                                    <input type="hidden" name="id" value="#team.id#">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </cfloop>
                    <cfif arrayLen(prc.teams) eq 0>
                        <tr>
                            <td colspan="5" class="text-center text-muted">No teams found.</td>
                        </tr>
                    </cfif>
                </tbody>
            </table>
        </div>
    </div>
</div>
</cfoutput>
