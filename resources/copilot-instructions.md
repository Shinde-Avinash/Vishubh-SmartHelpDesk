# BoxLang ColdBox Template - AI Coding Instructions

This is a BoxLang application template using the ColdBox HMVC framework. These instructions are designed to help AI assistants understand the project structure and provide better coding assistance.

## 🎯 Project Overview

**Language**: BoxLang (modern JVM language, successor to CFML)
**Framework**: ColdBox HMVC Framework v8+
**Template Type**: Full-stack web application template
**Architecture**: Model-View-Controller with Hierarchical MVC support

## ⚙️ Requirements

This project requires the following to be installed on your operating system:

### Required Software

1. **CommandBox** - CLI toolchain, package manager, and server runtime
   - Installation: https://commandbox.ortusbooks.com/getting-started/installation
   - Minimum Version: 6.0+
   - Used for: dependency management, server starting, testing, and task automation

2. **BoxLang** - Modern JVM language runtime
   - Installation: https://boxlang.ortusbooks.com/getting-started/installation
   - Minimum Version: 1.0+
   - Can be installed via CommandBox: `box install commandbox-boxlang`
   - Used for: running BoxLang applications and scripts

### Verification

Verify installations:
```bash
# Check CommandBox is installed
box version

# Check BoxLang is available
box boxlang version

# Verify project setup (run from project root)
boxlang Setup.bx
```

### Optional but Recommended

- **Java JDK** - Required for BoxLang runtime (JDK 11+ recommended)
- **Docker** - For containerized development (if using Docker setup)
- **Git** - For version control

## 📁 Project Structure

```
/app/                       # Application source code
├── Application.bx          # Application entry point
├── config/                 # Framework configuration
│   ├── CacheBox.bx        # Caching configuration
│   ├── ColdBox.bx         # Main ColdBox settings
│   ├── Router.bx          # Route definitions
│   ├── Scheduler.bx       # Scheduled tasks
│   └── WireBox.bx         # Dependency injection configuration
├── handlers/               # Controllers (request handlers)
├── helpers/                # View helper functions
├── interceptors/           # Event interceptors/listeners
├── layouts/                # Page layouts/templates
├── logs/                   # Application logs
├── models/                 # Business logic and data models
├── modules/                # Application-specific modules (HMVC)
└── views/                  # View templates

/public/                    # Web-accessible files (document root)
├── Application.bx          # Public application bootstrap
├── index.bxm               # Application entry point (markup)
├── favicon.ico             # Site favicon
├── robots.txt              # Search engine directives
└── includes/               # Static assets
    ├── i18n/              # Client-side translations
    └── images/            # Image assets (CSS, JS in subfolders)

/resources/                 # Non-web resources
├── database/               # Database management
│   └── migrations/        # Database migration files
└── copilot-instructions.md # This file (AI coding instructions)

/tests/                     # Test suites
├── Application.bx          # Test application setup
├── index.bxm               # Test runner entry point
├── runner.bxm              # TestBox runner
├── specs/                  # BDD test specifications
└── resources/              # Test resources and fixtures

/docker/                    # Docker configuration
├── Dockerfile              # Container image definition
└── docker-compose.yml      # Multi-container setup

/runtime/                   # BoxLang runtime files (auto-generated)
├── boxlang.json           # Runtime configuration
└── global/                # Global runtime cache

/.devcontainer/             # VS Code dev container configuration
/.github/                   # GitHub Actions workflows and settings
/.vscode/                   # VS Code workspace settings

# Root Configuration Files
├── Build.bx               # Build automation script
├── box.json               # CommandBox package descriptor
├── server.json            # CommandBox server configuration
├── .env.example           # Environment variable template
├── .cfformat.json         # Code formatting rules
├── .cflintrc              # Linting configuration
├── .editorconfig          # Editor configuration
└── pom.xml                # Maven build configuration (optional)
```

## 🔧 Key Technologies

### Core Stack

- **BoxLang**: Modern JVM language with CFML compatibility
- **ColdBox**: HMVC framework for enterprise applications
- **WireBox**: Dependency injection and AOP container
- **CacheBox**: Enterprise caching engine
- **LogBox**: Logging and debugging framework

### Development Tools

- **CommandBox**: CLI toolchain and package manager
- **TestBox**: BDD/TDD testing framework
- **CFFormat**: Code formatting and linting

## 📝 BoxLang Syntax Guidelines

### File Extensions

- `.bx` - BoxLang classes and components
- `.bxm` - BoxLang markup (templates/views)
- `.bxs` - BoxLang scripts

### Class Declaration

```js
// BoxLang uses 'class' keyword instead of 'component'
class extends="BaseHandler" {

    function index( event, rc, prc ){
        return "Hello from BoxLang!";
    }

}
```

### Function Syntax

```js
// Modern function syntax
function getUserById( required numeric id ){
    return userService.findById( arguments.id );
}

// Arrow functions supported as closures
variables.transform = ( item ) => item.toUpperCase();

// Thin Arrow function supported as pure lambdas
// BoxLang lambdas only have acess to arguments and function local scope
variables.filter = ( item ) -> item.isActive();
```

### Dependency Injection

```js
class UserService {
	// Long Form
	@inject( "UserDAO" )
    property userDAO;

	// Short Form if the property name matches the class name
	@inject
	property userDAO;

	@inject
    property wirebox;

    function getUsers(){
        return userDAO.list();
    }
}
```

## 🎛️ ColdBox Patterns

### Handler Actions

```js
class extends="BaseHandler" {

    function index( event, rc, prc ){
        prc.users = userService.list();
        event.setView( "users/index" );
    }

    function show( event, rc, prc ){
        prc.user = userService.get( rc.id );
        event.setView( "users/show" );
    }
}
```

### Models with Dependency Injection

```js
class extends="BaseService" {

	@inject( "UserGateway" )
    property userGateway;

	@inject
    property cachebox;

    function list(){
        return cachebox.get( "users" ) ?: userGateway.getAll();
    }
}
```

### Event-Driven Architecture

```js
// Interceptors for cross-cutting concerns
class SecurityInterceptor {

    function preProcess( event, data ){
        if( !security.isLoggedIn() ){
            relocate( "auth.login" );
        }
    }
}
```

## 🧪 Testing Patterns

### BDD Test Structure

```js
class extends="BaseTestCase" {

    function beforeAll(){
        super.beforeAll();
        userService = getInstance( "UserService" );
    }

    function run(){
        describe( "UserService", () => {

            it( "should return all users", () => {
                var users = userService.list()
                expect( users ).toBeArray()
            })

        })
    }
}
```

## 🔗 Common Integrations

### Database Operations

- Use ColdBox ORM or Query Builder or Quick ORM or native queries
- Migration files in `/resources/database/migrations/`
- Seeders in `/resources/database/seeds/`

### API Development

- RESTful handlers in `/handlers/api/`
- **Use RESTHandler base class** for REST API endpoints
- Use `event.renderData()` for JSON responses
- JWT authentication via ColdBox Security module

#### RESTHandler Pattern

For REST API development, extend `coldbox.system.RestHandler` instead of `BaseHandler`:

```js
class extends="coldbox.system.RestHandler" {

    // RESTHandler provides automatic:
    // - Content negotiation (JSON, XML, HTML)
    // - HTTP status code handling
    // - Error response formatting
    // - CORS support

    function index( event, rc, prc ){
        // Automatically serializes to requested format
        return userService.list();
    }

    function show( event, rc, prc ){
        prc.response = userService.get( rc.id );
    }

    function create( event, rc, prc ){
        var result = userService.create( rc );
        prc.statusCode = 201;
        return result;
    }

    function update( event, rc, prc ){
        return userService.update( rc.id, rc );
    }

    function delete( event, rc, prc ){
        userService.delete( rc.id );
        prc.statusCode = 204;
    }

    // Handle errors with proper HTTP status codes
    function onError( event, rc, prc, faultAction, exception ){
        prc.statusCode = 500;
        return {
            "error": true,
            "messages": [ exception.message ]
        };
    }
}
```

**RESTHandler Benefits**:

- Automatic content type detection and rendering
- Built-in HTTP verb routing (GET, POST, PUT, DELETE, PATCH)
- Standardized error handling with `onError()` and `onInvalidHTTPMethod()`
- Easy status code management via `prc.statusCode`
- Return data directly from actions (auto-serialization)

**Documentation**: https://coldbox.ortusbooks.com/digging-deeper/rest-handler

#### Resourceful Routes (RECOMMENDED for ALL Resource-Based Handlers)

**Always use resourceful routes** for both web handlers and REST APIs. ColdBox provides automatic route generation following RESTful conventions, reducing boilerplate and ensuring consistency.

```js
// In /app/config/Router.bx
function configure(){

    // Standard resourceful routes (web handlers with views)
    resources( "photos" );
    // Generates: index, new, create, show, edit, update, delete
    // Perfect for traditional CRUD web interfaces

    // API resourceful routes (REST APIs, JSON responses)
    apiResources( "users" );
    // Generates: index, show, create, update, delete (no 'new' or 'edit' forms)
    // Use with RestHandler for REST APIs

    // Nested resources for hierarchical data
    resources( "photos", function(){
        resources( "comments" );
    });
    // Generates: /photos/:photoId/comments

    // Restrict to specific actions
    resources( resource="articles", only="index,show" );
    resources( resource="profiles", except="delete" );

    // Customize parameter name
    resources( resource="users", parameterName="userId" );
}
```

**Generated Routes for `resources( "photos" )` (Web)**:

| HTTP Verb | Route            | Action   | Purpose                    |
|-----------|------------------|----------|----------------------------|
| GET       | /photos          | index    | List all photos            |
| GET       | /photos/new      | new      | Show create form           |
| POST      | /photos          | create   | Create new photo           |
| GET       | /photos/:id      | show     | Show specific photo        |
| GET       | /photos/:id/edit | edit     | Show edit form             |
| PUT/PATCH | /photos/:id      | update   | Update specific photo      |
| DELETE    | /photos/:id      | delete   | Delete specific photo      |

**Generated Routes for `apiResources( "users" )` (API)**:

| HTTP Verb | Route            | Action   | Purpose                    |
|-----------|------------------|----------|----------------------------|
| GET       | /users           | index    | List all users             |
| GET       | /users/:id       | show     | Get specific user          |
| POST      | /users           | create   | Create new user            |
| PUT/PATCH | /users/:id       | update   | Update specific user       |
| DELETE    | /users/:id       | delete   | Delete specific user       |

**Benefits**:
- **Use `resources()` for web handlers** (with forms and views) and `apiResources()` for REST APIs
- Automatic RESTful route generation following industry standards
- Consistent URL patterns across your entire application
- Reduced boilerplate route definitions
- Easy to understand and maintain
- Works seamlessly with BaseHandler (web) and RestHandler (API) base classes
- Supports nested resources for hierarchical data
- Self-documenting route structure

**When to Use**:
- ✅ Any CRUD-based resource (users, posts, photos, products, etc.)
- ✅ Traditional web interfaces with forms (`resources()`)
- ✅ REST APIs returning JSON/XML (`apiResources()`)
- ✅ Nested/hierarchical resources (posts with comments)
- ❌ Non-resource actions (search, reports, utilities) - use custom routes

**Documentation**: https://coldbox.ortusbooks.com/the-basics/routing/routing-dsl/resourceful-routes

### Frontend Integration

- Assets managed via `/public/assets/`
- View helpers for asset compilation
- Modern JavaScript/CSS build tools supported

## 🚀 Development Workflow

### Local Development
```bash
# Install dependencies
box install

# Start development server
box server start

# Run tests
box testbox run

# Format code
box run-script format
```

### Code Quality

- Follow Ortus coding standards
- Use CFFormat for consistent formatting
- Write tests for all business logic
- Document public APIs with JavaDoc-style comments

## 🔍 AI Assistant Guidelines

### When Generating Code

1. **Use BoxLang syntax** (class, not component)
2. **Follow ColdBox conventions** for handlers, models, views
3. **Include proper dependency injection** when creating services
4. **Write accompanying tests** for new functionality
5. **Use modern BoxLang features** (arrow functions, proper typing)

### File Creation Patterns

- **Handlers**: Extend `BaseHandler`, use dependency injection
- **Models**: Extend appropriate base classes, implement interfaces
- **Tests**: Follow BDD patterns with `describe()` and `it()`
- **Views**: Use `.bxm` extension, leverage ColdBox view helpers

### Security Considerations

- Always validate input parameters
- Use ColdBox Security module for authentication
- Implement CSRF protection for forms
- Sanitize output in views

## 📚 Documentation References

- [BoxLang Documentation](https://boxlang.ortusbooks.com/)
- [ColdBox Documentation](https://coldbox.ortusbooks.com/)
- [TestBox Documentation](https://testbox.ortusbooks.com/)
- [WireBox Documentation](https://wirebox.ortusbooks.com/)
- [CacheBox Documentation](https://cachebox.ortusbooks.com/)
- [LogBox Documentation](https://logbox.ortusbooks.com/)
- [Ortus Coding Standards](https://github.com/Ortus-Solutions/coding-standards)

## 🤖 MCP (Model Context Protocol) Servers

For AI assistants that support MCP, access comprehensive documentation through these servers:

### Framework Documentation
- **ColdBox MCP Server**: `https://coldbox.ortusbooks.com/~gitbook/mcp`
- **WireBox MCP Server**: `https://wirebox.ortusbooks.com/~gitbook/mcp`
- **CacheBox MCP Server**: `https://cachebox.ortusbooks.com/~gitbook/mcp`
- **LogBox MCP Server**: `https://logbox.ortusbooks.com/~gitbook/mcp`

### Language & Testing Documentation
- **BoxLang MCP Server**: `https://boxlang.ortusbooks.com/~gitbook/mcp`
- **TestBox MCP Server**: `https://testbox.ortusbooks.com/~gitbook/mcp`

These MCP servers provide real-time access to official documentation, examples, and API references. AI assistants can query these servers for:
- Framework APIs and configuration options
- Code examples and patterns
- Best practices and conventions
- Troubleshooting guides
- Version-specific documentation

## 🎯 Best Practices

### Performance

- Use CacheBox for expensive operations
- Implement proper database indexing
- Lazy load dependencies when appropriate
- Use async patterns for I/O operations

### Maintainability

- Keep handlers thin, move logic to services
- Use events for decoupled communication
- Implement proper error handling
- Write comprehensive tests

### Security

- Validate all inputs
- Use parameterized queries
- Implement proper session management
- Regular security audits of dependencies