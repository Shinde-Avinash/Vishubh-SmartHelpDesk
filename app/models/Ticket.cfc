component accessors="true" {
    property name="id";
    property name="ticket_uid";
    property name="title";
    property name="description";
    property name="category";
    property name="urgency";
    property name="status";
    property name="user_id";
    property name="assigned_team_id";
    property name="assigned_agent_id";
    property name="ai_analysis_json";
    property name="created_at";
    property name="updated_at";

    function init(){
        return this;
    }
}
