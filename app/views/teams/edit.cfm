<cfoutput>
<div class="mt-4" style="max-width: 600px; margin: 0 auto;">
    <div class="mb-4">
        <a href="#event.buildLink('teams.index')#" class="btn btn-outline">
            <i class="fas fa-arrow-left"></i> Back to Teams
        </a>
    </div>

    <div class="card">
        <h3 class="card-title mb-4">Edit Team</h3>
        
        <form action="#event.buildLink('teams.update')#" method="post">
            <input type="hidden" name="id" value="#prc.team.id#">
            
            <div class="form-group mb-3">
                <label class="form-label">Team Name</label>
                <input type="text" name="name" class="form-control" value="#prc.team.name#" required>
            </div>
            
            <div class="form-group mb-4">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3">#prc.team.description#</textarea>
            </div>
            
            <div class="text-end">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i> Update Team
                </button>
            </div>
        </form>
    </div>
</div>
</cfoutput>
