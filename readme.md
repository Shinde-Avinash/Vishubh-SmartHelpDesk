# 🚀 Vishubh SmartHelpDesk

Vishubh SmartHelpDesk is a modern, enterprise-grade help desk application designed to streamline customer support and internal ticketing workflows. Built on the robust **ColdBox 8** framework and running on the **BoxLang** runtime, it combines performance with developer productivity.

## ✨ Key Features

-   **🎫 Smart Ticket Management**:
    -   Create, track, and manage support tickets efficiently.
    -   Status tracking (Open, In Progress, Resolved, Closed).
    -   Priority levels and categorization.

-   **🤖 AI-Powered Assistance**:
    -   Integrated **Google Gemini AI** to assist agents and users.
    -   Automated suggestions and smart content analysis.

-   **👥 Team & Agent Collaboration**:
    -   Organize support staff into teams.
    -   Assign tickets to specific agents or teams.
    -   Collaborative tools for faster resolution.

-   **👤 User Management**:
    -   Secure authentication and role-based access control.
    -   Manage Customer, Agent, and Admin profiles.

-   **📊 Analytics & Dashboard**:
    -   Visual insights into ticket volume, resolution times, and agent performance.
    -   Real-time statistics to monitor help desk health.

## 🛠️ Tech Stack

-   **Framework**: [ColdBox 8](https://coldbox.org)
-   **Runtime**: [BoxLang](https://boxlang.io)
-   **AI Integration**: Google Gemini API
-   **Database**: Relational Database (MySQL/PostgreSQL compatible) via ORM

## ⚙️ Prerequisites

Before running the application, ensure you have the following installed:

1.  **BoxLang OS** (v1.6+) or **CommandBox** (v6.0+)
2.  **Database Server** (e.g., MySQL 8.0+)
3.  **Google Gemini API Key** (for AI features)

## 🚀 Installation & Setup

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/your-repo/vishubh-smarthelpdesk.git
    cd vishubh-smarthelpdesk
    ```

2.  **Install Dependencies**
    Use CommandBox to install required ColdBox modules and dependencies.
    ```bash
    box install
    ```

3.  **Environment Configuration**
    Copy the `.env.example` file to `.env` and configure your environment variables:
    ```bash
    cp .env.example .env
    ```
    *Edit `.env` to include your Database credentials and `GEMINI_API_KEY`.*

4.  **Start the Server**
    Start the embedded server using CommandBox:
    ```bash
    box server start
    ```

    The application will be accessible at: `http://localhost:8080` (or the port specified in your console).

## 🐳 Docker Support

You can also run the application using Docker:

```bash
# Build and run using the provided script
run-script docker:build
run-script docker:run
```

## 📁 Project Structure

-   `app/` - Core application code (Handlers, Models, Views).
-   `config/` - Application configuration (Router, ColdBox settings).
-   `resources/` - Static assets, migrations, and docker config.
-   `tests/` - TestBox unit and integration tests.

## 🤝 Contributing

Contributions are welcome! Please submit a Pull Request or open an Issue for bug reports and feature requests.

## 📄 License

This project is licensed under the Apache 2.0 License.
