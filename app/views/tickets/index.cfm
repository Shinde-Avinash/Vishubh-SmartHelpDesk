<cfoutput>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 style="color: var(--primary-color);"><i class="fas fa-ticket-alt"></i> My Tickets</h2>
        <a href="#event.buildLink('tickets.new')#" class="btn btn-primary">
            <i class="fas fa-plus"></i> Create New Ticket
        </a>
    </div>

    <cfif structKeyExists( flash, "message" )>
        <div class="alert alert-success" style="color: var(--secondary-color); background: rgba(16, 185, 129, 0.1); padding: 0.75rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
            #flash.message#
        </div>
    </cfif>
    <cfif structKeyExists( flash, "error" )>
        <div class="alert alert-danger" style="color: var(--danger-color); background: rgba(239, 68, 68, 0.1); padding: 0.75rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
            #flash.error#
        </div>
    </cfif>

    <div class="card">
        <cfif arrayLen( prc.tickets )>
            <div class="table-responsive">
                <table class="table" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="border-bottom: 1px solid var(--border-color); text-align: left;">
                            <th style="padding: 1rem;">ID</th>
                            <th style="padding: 1rem;">Title</th>
                            <th style="padding: 1rem;">Team</th>
                            <th style="padding: 1rem;">Status</th>
                            <th style="padding: 1rem;">Urgency</th>
                            <th style="padding: 1rem;">Date</th>
                            <th style="padding: 1rem;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop array="#prc.tickets#" item="ticket">
                            <tr style="border-bottom: 1px solid var(--border-color);">
                                <td style="padding: 1rem;"><strong>#ticket.ticket_uid#</strong></td>
                                <td style="padding: 1rem;">#ticket.title#</td>
                                <td style="padding: 1rem;">
                                    <span class="badge" style="background: var(--bg-color); padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.875rem;">
                                        #len(ticket.assigned_team_name) ? ticket.assigned_team_name : 'Unassigned'#
                                    </span>
                                </td>
                                <td style="padding: 1rem;">
                                    <span class="badge" style="
                                        padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.875rem;
                                        background: #(ticket.status == 'New' ? 'var(--primary-color)' : (ticket.status == 'Resolved' ? 'var(--secondary-color)' : 'var(--warning-color)'))#;
                                        color: white;
                                    ">
                                        #ticket.status#
                                    </span>
                                </td>
                                <td style="padding: 1rem;">
                                    <span style="color: #(ticket.urgency == 'High' ? 'var(--danger-color)' : (ticket.urgency == 'Medium' ? 'var(--warning-color)' : 'var(--secondary-color)'))#; font-weight: 600;">
                                        #ticket.urgency#
                                    </span>
                                </td>
                                <td style="padding: 1rem;">#dateFormat(ticket.created_at, "medium")#</td>
                                <td style="padding: 1rem;">
                                    <a href="#event.buildLink('tickets.show', {uid: ticket.ticket_uid})#" class="btn btn-primary" style="padding: 0.25rem 0.5rem; font-size: 0.875rem;">
                                        View
                                    </a>
                                </td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>
        <cfelse>
            <div class="text-center py-5">
                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                <p class="text-muted">No tickets found. Create one to get started!</p>
            </div>
        </cfif>
    </div>
</div>
</cfoutput>
