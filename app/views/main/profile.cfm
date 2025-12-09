<cfoutput>
<div class="container" style="max-width: 800px; margin-top: 2rem;">
    <div class="card" style="display: flex; flex-direction: row; overflow: hidden; padding: 0;">
        
        <!-- Sidebar: Identity (Compact) -->
        <div style="width: 250px; background: var(--bg-main); padding: 2rem 1rem; text-center; display: flex; flex-direction: column; align-items: center; justify-content: center; border-right: 1px solid var(--border-color);">
            <div style="width: 80px; height: 80px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; color: var(--primary-color); border: 2px solid var(--border-color); margin-bottom: 1rem;">
                <i class="fas fa-user"></i>
            </div>
            <h4 style="margin: 0; font-size: 1.1rem; color: var(--text-main);">#prc.user.username#</h4>
            <span class="badge badge-primary" style="margin-top: 0.5rem; font-size: 0.75rem;">#uCase(prc.user.role)#</span>
            
            <p class="text-muted" style="font-size: 0.8rem; margin-top: 1rem;">
                <i class="fas fa-calendar-alt me-1"></i> Joined #dateFormat(now(), 'MMM yyyy')#
            </p>
        </div>

        <!-- Main Content: Details -->
        <div style="flex: 1; padding: 2rem;">
            <div class="flex justify-between items-center mb-4" style="border-bottom: 1px solid var(--border-color); padding-bottom: 1rem;">
                <h3 style="margin: 0; font-size: 1.25rem;">General Information</h3>
                <a href="#event.buildLink('main')#" class="btn btn-sm btn-outline"><i class="fas fa-arrow-left"></i> Back</a>
            </div>

            <div class="grid-2 gap-4">
                <div>
                    <label class="text-muted" style="font-size: 0.8rem; display: block; margin-bottom: 0.2rem;">EMAIL ADDRESS</label>
                    <div style="font-weight: 500;">#prc.user.email#</div>
                </div>
                <div>
                    <label class="text-muted" style="font-size: 0.8rem; display: block; margin-bottom: 0.2rem;">PHONE</label>
                    <div style="font-weight: 500;">
                        <cfif len(prc.user.phone)>#prc.user.phone#<cfelse><span class="text-muted italic">Not set</span></cfif>
                    </div>
                </div>
                
                <div>
                    <label class="text-muted" style="font-size: 0.8rem; display: block; margin-bottom: 0.2rem;">DEPARTMENT</label>
                    <div style="font-weight: 500;">
                        <cfif len(prc.user.department)>#prc.user.department#<cfelse><span class="text-muted italic">N/A</span></cfif>
                    </div>
                </div>

                <cfif structKeyExists(prc, "teamName")>
                    <div>
                        <label class="text-muted" style="font-size: 0.8rem; display: block; margin-bottom: 0.2rem;">ASSIGNED TEAM</label>
                        <div style="font-weight: 500;">#prc.teamName#</div>
                    </div>
                </cfif>
            </div>

            <div class="mt-4" style="background: var(--bg-main); padding: 1rem; border-radius: 8px; border: 1px dashed var(--border-color);">
                <div class="flex items-start gap-3">
                    <i class="fas fa-info-circle text-primary" style="margin-top: 3px;"></i>
                    <p class="text-muted" style="font-size: 0.85rem; margin: 0;">
                        This information is managed by the system administrator. To update your role or department, please contact IT support.
                    </p>
                </div>
            </div>

        </div>
    </div>
</div>
</cfoutput>
