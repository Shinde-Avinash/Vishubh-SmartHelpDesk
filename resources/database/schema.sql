CREATE DATABASE IF NOT EXISTS Vishubh_SmartHelpDeskDB;
USE Vishubh_SmartHelpDeskDB;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Should be hashed
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin', 'team_lead', 'agent', 'user') NOT NULL DEFAULT 'user',
    department VARCHAR(100), -- For agents/staff
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Teams Table
CREATE TABLE IF NOT EXISTS teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE, -- e.g., Authentication, Billing, Tech Support
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agents Table (Extends Users)
CREATE TABLE IF NOT EXISTS agents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    team_id INT,
    skills TEXT, -- Comma separated tags e.g., "login,payment,api"
    is_available BOOLEAN DEFAULT TRUE,
    current_workload INT DEFAULT 0, -- Number of active tickets
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL
);

-- Knowledge Base Articles
CREATE TABLE IF NOT EXISTS knowledge_base (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    tags VARCHAR(255),
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Tickets Table
CREATE TABLE IF NOT EXISTS tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_uid VARCHAR(50) NOT NULL UNIQUE, -- User facing ID
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100), -- Billing, Technical, etc.
    urgency ENUM('Low', 'Medium', 'High', 'Critical') DEFAULT 'Low',
    status ENUM('New', 'In Progress', 'Awaiting Response', 'Resolved', 'Closed') DEFAULT 'New',
    user_id INT NOT NULL,
    assigned_team_id INT,
    assigned_agent_id INT,
    ai_analysis_json JSON, -- Stores AI analysis result
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (assigned_team_id) REFERENCES teams(id),
    FOREIGN KEY (assigned_agent_id) REFERENCES agents(id)
);

-- Ticket Messages (Chat)
CREATE TABLE IF NOT EXISTS ticket_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    sender_id INT, -- Null if system/AI message (though usually AI messages are flagged)
    message TEXT NOT NULL,
    attachment_url VARCHAR(255),
    is_ai_generated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- AI Logs
CREATE TABLE IF NOT EXISTS ai_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT,
    prompt TEXT,
    response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Initial Data Seeding
-- Admin
INSERT INTO users (username, password, email, role) VALUES ('admin', 'admin123', 'admin@vishubh.com', 'admin');
-- Teams
INSERT INTO teams (name, description) VALUES 
('Authentication Team', 'Handles login, signup, OTP issues'),
('Billing Team', 'Handles payments, refunds, invoices'),
('Tech Support', 'General technical errors'),
('Frontend Team', 'UI bugs, screen issues'),
('Backend/DevOps', 'Server, database, API issues');
