<cfoutput>
<div class="mt-4">
    <div class="flex justify-between items-center mb-4">
        <h2><i class="fas fa-chart-line text-primary me-2"></i> Analytics</h2>
        <a href="#event.buildLink('dashboard.index')#" class="btn btn-primary">Back to Dashboard</a>
    </div>

    <!-- Overview Cards -->
    <div class="grid-4 mb-4">
        <div class="card text-center">
            <h3 class="text-primary mb-2" style="font-size: 2rem;">#prc.stats.total#</h3>
            <small class="text-muted">Total Tickets</small>
        </div>
        <div class="card text-center">
            <h3 class="text-warning mb-2" style="font-size: 2rem;">#prc.stats.open#</h3>
            <small class="text-muted">Open / In Progress</small>
        </div>
        <div class="card text-center">
            <h3 class="text-success mb-2" style="font-size: 2rem;">#prc.stats.resolved#</h3>
            <small class="text-muted">Resolved</small>
        </div>
        <div class="card text-center">
            <h3 class="text-danger mb-2" style="font-size: 2rem;">#prc.stats.unassigned#</h3>
            <small class="text-muted">Unassigned</small>
        </div>
    </div>

    <div class="grid-2">
        <!-- Status Chart -->
        <div class="card">
            <h4 class="card-title mb-4">Tickets by Status</h4>
            <div style="height: 300px; position: relative;">
                <canvas id="statusChart"></canvas>
            </div>
        </div>
        
        <!-- Category Chart -->
        <div class="card">
            <h4 class="card-title mb-4">Tickets by Category</h4>
            <div style="height: 300px; position: relative;">
                <canvas id="categoryChart"></canvas>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        const textColor = isDark ? '##94A3B8' : '##64748B'; 

        // Status Chart
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        const statusData = #jsonSerialize(prc.ticketsByStatus)#;
        
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: statusData.map(item => item.status),
                datasets: [{
                    data: statusData.map(item => item.count),
                    backgroundColor: [
                        '##3B82F6', '##10B981', '##F59E0B', '##EF4444', '##64748B'
                    ],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { color: textColor }
                    }
                }
            }
        });

        // Category Chart
        const categoryCtx = document.getElementById('categoryChart').getContext('2d');
        const categoryData = #jsonSerialize(prc.ticketsByCategory)#;

        new Chart(categoryCtx, {
            type: 'bar',
            data: {
                labels: categoryData.map(item => item.category),
                datasets: [{
                    label: 'Tickets',
                    data: categoryData.map(item => item.count),
                    backgroundColor: '##3B82F6',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { color: isDark ? '##1E293B' : '##E2E8F0' },
                        ticks: { color: textColor }
                    },
                    x: {
                        grid: { display: false },
                        ticks: { color: textColor }
                    }
                },
                plugins: {
                    legend: { display: false }
                }
            }
        });
    });
</script>
</cfoutput>
