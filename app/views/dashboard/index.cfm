<cfoutput>
<div class="mt-4">
    <div class="flex justify-between items-center mb-4">
        <h2 class="text-primary">
            <i class="fas fa-tachometer-alt me-2"></i> #uCase(prc.role)# Dashboard
        </h2>
        <div class="text-muted">
            Welcome, #session.user.username#
        </div>
    </div>

    <!-- Stats Cards -->
    <cfif prc.role == "admin">
        <div class="flex justify-end mb-4">
            <a href="#event.buildLink('users.index')#" class="btn btn-primary me-2">
                <i class="fas fa-users-cog"></i> Manage Users
            </a>
            <a href="#event.buildLink('teams.index')#" class="btn btn-primary me-2">
                <i class="fas fa-users"></i> Manage Teams
            </a>
            <a href="#event.buildLink('stats.index')#" class="btn btn-outline">
                <i class="fas fa-chart-pie"></i> Analytics
            </a>
        </div>
    </cfif>

    <div class="grid-4 mb-4">
        <div class="card text-center">
            <h4 class="text-primary mb-2" style="font-size: 2rem;">#prc.stats.total#</h4>
            <small class="text-muted">Total Tickets</small>
        </div>
        <div class="card text-center">
            <h4 class="text-warning mb-2" style="font-size: 2rem;">#prc.stats.open#</h4>
            <small class="text-muted">Open</small>
        </div>
        <div class="card text-center">
            <h4 class="text-success mb-2" style="font-size: 2rem;">#prc.stats.resolved#</h4>
            <small class="text-muted">Resolved</small>
        </div>
        <div class="card text-center">
            <h4 class="text-info mb-2" style="font-size: 2rem;">#prc.stats.unassigned#</h4>
            <small class="text-muted">Unassigned</small>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <h4 class="card-title">Recent Activity</h4>
        </div>
        <div class="table-container" style="overflow-x: auto;">
            <table class="table table-sm" style="font-size: 0.85rem;">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Subject</th>
                        <th>User</th>
                        <th>Status</th>
                        <th>Urgency</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop array="#prc.recentTickets#" item="ticket">
                        <tr>
                            <td title="#ticket.ticket_uid#">
                                #left(ticket.ticket_uid, 8)#...#right(ticket.ticket_uid, 4)#
                            </td>
                            <td>#left(ticket.title, 30)#<cfif len(ticket.title) gt 30>...</cfif></td>
                            <td>#ticket.created_by_name#</td>
                            <td>
                                <cfset badgeClass = "badge-primary">
                                <cfif ticket.status eq "Resolved"><cfset badgeClass = "badge-success"></cfif>
                                <cfif ticket.status eq "Open"><cfset badgeClass = "badge-warning"></cfif>
                                <span class="badge #badgeClass#" style="font-size: 0.75rem; padding: 0.2rem 0.5rem;">
                                    #ticket.status#
                                </span>
                            </td>
                            <td>#ticket.urgency#</td>
                            <td style="padding: 0.25rem;">
                                <a href="#event.buildLink('tickets.show', {uid: ticket.ticket_uid})#" class="btn btn-sm btn-outline" style="font-size: 0.75rem; padding: 0.2rem 0.5rem;">View</a>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
        </div>
    </div>
</div>
</cfoutput>
