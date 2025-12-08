<cfoutput>
<div class="container mt-4" style="max-width: 800px;">
    <div class="card">
        <h2 class="mb-4" style="color: var(--primary-color);">Create New Ticket (v1.1)</h2>
        
        <cfif structKeyExists( flash, "error" )>
            <div class="alert alert-danger mb-3">#flash.error#</div>
        </cfif>

        <form action="#event.buildLink('tickets.save')#" method="post">
            <div class="form-group mb-3">
                <label for="title" class="form-label">Subject / Title</label>
                <input type="text" id="title" name="title" class="form-control" required placeholder="Brief summary of the issue">
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="category" class="form-label">Category</label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="">Select Category</option>
                        <option value="Technical Support">Technical Support</option>
                        <option value="Billing">Billing</option>
                        <option value="Feature Request">Feature Request</option>
                        <option value="General Inquiry">General Inquiry</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label for="urgency" class="form-label">Urgency</label>
                    <select id="urgency" name="urgency" class="form-control" required>
                        <option value="Low">Low</option>
                        <option value="Medium">Medium</option>
                        <option value="High">High</option>
                        <option value="Critical">Critical</option>
                    </select>
                </div>
            </div>

            <div class="form-group mb-4">
                <label for="description" class="form-label">Description</label>
                <textarea id="description" name="description" class="form-control" rows="6" required placeholder="Please describe your issue in detail..."></textarea>
            </div>

            <div class="d-flex justify-content-end gap-2">
                <a href="#event.buildLink('tickets.index')#" class="btn btn-outline">Cancel</a>
                <button type="submit" class="btn btn-primary">Submit Ticket</button>
            </div>
        </form>
    </div>
</div>
</cfoutput>
