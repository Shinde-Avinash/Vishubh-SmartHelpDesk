<cfoutput>
<div class="mt-4" style="max-width: 600px; margin: 0 auto;">
    <div class="mb-4">
        <a href="#event.buildLink('teams.index')#" class="btn btn-outline">
            <i class="fas fa-arrow-left"></i> Back to Teams
        </a>
    </div>

    <div class="card">
        <h3 class="card-title mb-4">Create New Team</h3>
        
        <form action="#event.buildLink('teams.create')#" method="post">
            <div class="form-group mb-3">
                <label class="form-label">Team Name</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. Security, QA" required>
            </div>
            
            <div class="form-group mb-4">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3" placeholder="What does this team handle?"></textarea>
            </div>
            
            <div class="text-end">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save me-2"></i> Create Team
                </button>
            </div>
        </form>
    </div>
</div>
</cfoutput>
