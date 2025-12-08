<cfoutput>
<div class="mt-4">
    <div class="mb-4">
        <a href="#event.buildLink('tickets.index')#" class="btn btn-primary" style="font-size: 0.9rem;">
            <i class="fas fa-arrow-left"></i> Back to Tickets
        </a>
    </div>

    <!-- Custom Grid for Ticket View -->
    <div style="display: grid; grid-template-columns: 1fr 320px; gap: 1.5rem;" class="ticket-grid">
        
        <!-- Main Content -->
        <div style="min-width: 0;"> <!-- min-width 0 prevents grid blowout -->
            <div class="card mb-4">
                <div class="flex justify-between items-start mb-4">
                    <div>
                        <h2 class="mb-1" style="font-size: 1.5rem;">#prc.ticket.title#</h2>
                        <span class="text-muted" style="font-size: 0.85rem;">Ticket ID: #prc.ticket.ticket_uid#</span>
                    </div>
                    
                    <cfset statusColor = "var(--warning)">
                    <cfif prc.ticket.status eq "New"><cfset statusColor = "var(--primary)"></cfif>
                    <cfif prc.ticket.status eq "Resolved"><cfset statusColor = "var(--success)"></cfif>
                    
                    <span class="badge" style="background: #statusColor#; color: var(--bg-card);">
                        #prc.ticket.status#
                    </span>
                </div>

                <div class="mb-4">
                    <p style="white-space: pre-wrap; line-height: 1.6; color: var(--text-main);">#prc.ticket.description#</p>
                </div>

                <div style="border-top: 1px solid var(--border-color); padding-top: 1rem; margin-top: 1rem;" class="flex gap-4 text-muted" style="font-size: 0.9rem;">
                    <div class="flex items-center gap-2"><i class="fas fa-folder"></i> #prc.ticket.category#</div>
                    <div class="flex items-center gap-2"><i class="fas fa-exclamation-circle"></i> #prc.ticket.urgency#</div>
                    <div class="flex items-center gap-2"><i class="fas fa-user"></i> #prc.ticket.created_by_name#</div>
                    <div class="flex items-center gap-2"><i class="far fa-clock"></i> #dateFormat(prc.ticket.created_at, "medium")# #timeFormat(prc.ticket.created_at, "short")#</div>
                </div>
            </div>

            <!-- Chat Section -->
            <div class="card">
                <h3 class="card-title mb-4 flex items-center gap-2">
                    <i class="fas fa-comments text-primary"></i> Conversation
                </h3>
                
                <div class="mb-4" style="max-height: 500px; overflow-y: auto; display: flex; flex-direction: column; gap: 1rem;">
                    <cfif arrayLen( prc.messages )>
                        <cfloop array="#prc.messages#" item="msg">
                            <cfset isSelf = msg.sender_id == session.user.id>
                            
                            <div style="display: flex; justify-content: #(isSelf ? 'flex-end' : 'flex-start')#;">
                                <div style="
                                    max-width: 80%;
                                    padding: 1rem;
                                    border-radius: 1rem;
                                    background: #(isSelf ? 'var(--primary)' : 'var(--bg-hover)')#;
                                    color: #(isSelf ? 'white' : 'var(--text-main)')#;
                                    border: #(isSelf ? 'none' : '1px solid var(--border-color)')#;
                                    font-size: 0.95rem;
                                ">
                                    <div class="flex justify-between items-center mb-1" style="font-size: 0.8rem; opacity: 0.9;">
                                        <strong>#msg.username#</strong>
                                        <span style="margin-left: 1rem;">#timeFormat(msg.created_at, "short")#</span>
                                    </div>
                                    <p style="white-space: pre-wrap; margin: 0;">#msg.message#</p>
                                </div>
                            </div>
                        </cfloop>
                    <cfelse>
                        <div class="text-center py-4 text-muted">
                            <p>No messages yet. Start the conversation!</p>
                        </div>
                    </cfif>
                </div>
                
                <form action="#event.buildLink('tickets.reply')#" method="post" class="mt-4">
                    <input type="hidden" name="uid" value="#prc.ticket.ticket_uid#">
                    <div class="form-group">
                        <textarea name="message" class="form-control" rows="3" placeholder="Type your reply here..." required></textarea>
                    </div>
                    <div class="text-end">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane me-2"></i> Send Reply
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Sidebar Info -->
        <div style="min-width: 0;">
            
            <!-- Management Tools (Admin/Lead/Agent) -->
            <cfif session.user.role == 'admin' || session.user.role == 'team_lead' || session.user.role == 'agent'>
                <div class="card mb-4">
                    <h4 class="card-title mb-4 flex items-center gap-2">
                        <i class="fas fa-tasks text-primary"></i> Management
                    </h4>

                    <!-- Status Update -->
                    <form action="#event.buildLink('tickets.status')#" method="post" class="mb-4">
                        <input type="hidden" name="uid" value="#prc.ticket.ticket_uid#">
                        <label class="form-label text-muted" style="font-size: 0.85rem;">Ticket Status</label>
                        <div class="flex gap-2">
                            <select name="status" class="form-control" style="font-size: 0.9rem;">
                                <option value="New" <cfif prc.ticket.status eq 'New'>selected</cfif>>New</option>
                                <option value="In Progress" <cfif prc.ticket.status eq 'In Progress'>selected</cfif>>In Progress</option>
                                <option value="Awaiting Response" <cfif prc.ticket.status eq 'Awaiting Response'>selected</cfif>>Awaiting Response</option>
                                <option value="Resolved" <cfif prc.ticket.status eq 'Resolved'>selected</cfif>>Resolved</option>
                                <option value="Closed" <cfif prc.ticket.status eq 'Closed'>selected</cfif>>Closed</option>
                            </select>
                            <button type="submit" class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-check"></i>
                            </button>
                        </div>
                    </form>

                    <!-- Assign Agent (Admin/Lead only) -->
                    <cfif (session.user.role == 'admin' || session.user.role == 'team_lead') && structKeyExists(prc, "agents")>
                        <form action="#event.buildLink('tickets.assign')#" method="post">
                            <input type="hidden" name="uid" value="#prc.ticket.ticket_uid#">
                            <label class="form-label text-muted" style="font-size: 0.85rem;">Assign To</label>
                            <div class="flex gap-2">
                                <select name="agent_id" class="form-control" style="font-size: 0.9rem;">
                                    <option value="">-- Select Agent --</option>
                                    <cfloop array="#prc.agents#" item="agent">
                                        <!--- Only show actual agents or admins ??? Actually getAgentsWithTeams filters already --->
                                        <option value="#agent.id#" <cfif prc.ticket.assigned_agent_id eq agent.id>selected</cfif>>
                                            #agent.username# <cfif structKeyExists(agent, "team_name") && len(agent.team_name)>[#agent.team_name#]</cfif>
                                        </option>
                                    </cfloop>
                                </select>
                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                    <i class="fas fa-user-plus"></i>
                                </button>
                            </div>
                        </form>
                    </cfif>
                    
                    <!-- Assign Team (Admin Only) -->
                    <cfif session.user.role == 'admin' && structKeyExists(prc, "teams")>
                        <form action="#event.buildLink('tickets.assignTeam')#" method="post" class="mt-4 pt-3 border-top">
                            <input type="hidden" name="uid" value="#prc.ticket.ticket_uid#">
                            <label class="form-label text-muted" style="font-size: 0.85rem;">Assign Team</label>
                            <div class="flex gap-2">
                                <select name="team_id" class="form-control" style="font-size: 0.9rem;">
                                    <option value="">-- Select Team --</option>
                                    <cfloop array="#prc.teams#" item="team">
                                        <option value="#team.id#" <cfif prc.ticket.assigned_team_id eq team.id>selected</cfif>>
                                            #team.name#
                                        </option>
                                    </cfloop>
                                </select>
                                <button type="submit" class="btn btn-sm btn-outline-warning">
                                    <i class="fas fa-users-cog"></i>
                                </button>
                            </div>
                        </form>
                    </cfif>
                </div>
            </cfif>

            <!-- AI Info -->
            <div class="card">
                <h4 class="card-title mb-4 flex items-center gap-2">
                    <i class="fas fa-robot text-primary"></i> AI Assistant
                </h4>
                
                <div class="mb-3">
                    <a href="#event.buildLink('tickets.analyze', {uid: prc.ticket.ticket_uid})#" class="btn btn-sm btn-outline-success w-100">
                        <i class="fas fa-magic me-2"></i> Generate AI Response
                    </a>
                </div>

                <cfif isJson( prc.ticket.ai_analysis_json )>
                    <cfset analysis = jsonDeserialize( prc.ticket.ai_analysis_json )>
                    
                    <div class="mb-4">
                        <label class="form-label text-muted" style="font-size: 0.85rem;">Detected Sentiment</label>
                        <!--- JSON Check for safety --->
                        <cfif structKeyExists(analysis, "sentiment")>
                            <div class="flex items-center gap-2" style="font-weight: 600;">
                                <cfif analysis.sentiment == "Positive">
                                    <i class="fas fa-smile text-success"></i>
                                <cfelseif analysis.sentiment == "Negative">
                                    <i class="fas fa-frown text-danger"></i>
                                <cfelse>
                                    <i class="fas fa-meh text-warning"></i>
                                </cfif>
                                #analysis.sentiment#
                            </div>
                        </cfif>
                    </div>
                <cfelse>
                    <div class="text-muted small">Initial analysis pending...</div>
                </cfif>
            </div>
        </div>
    </div>
</div>

<style>
    @media (max-width: 768px) {
        .ticket-grid {
            grid-template-columns: 1fr !important;
        }
    }
</style>
</cfoutput>
