---
source: ~/src/_ref/_arch/other-agents/CLI_SPECIFICATION.md — whole file,
  promoted 2026-07-21 (rebasing pass) from a witnessed-only II7 disposition
gathered: 2026-07-21
status: gathered (verbatim whole-file copy). Supersedes the II7 witness-line
  disposition ("Relevant for understanding how the primary agent tool consumes
  files/tools, but about CLI/MCP ergonomics, not document notation" — a
  pre-broadening notation-scoped judgment). Under the Brief's full-tooling-surface
  scope this is harness-consumer prior art: the reified command/MCP surface of the
  reference agent CLI.
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/other-agents/CLI_SPECIFICATION.md
source_commit: (non-git — _ref/_arch)
source_mtime: 2025-08-20
categories: [harness, agent-cli, mcp, tool-surface, config-model, reference-implementation, superseded-disposition]
why_included: >
  A reverse-engineered feature spec of Anthropic's Claude Code CLI (Aug 2025 — the
  earliest era in the corpus). For the harness consumer this is requirements-grade
  prior art on how the reference agent runtime presents itself: the `claude mcp`
  command surface (serve/add/remove/list/get/add-json/add-from-claude-desktop),
  the three-scope config hierarchy (project > local > user) and its JSON shape,
  transport model (stdio/sse/http, JSON-RPC), the error taxonomy, and the
  auth/security/update mechanics. Companion to the Apr-2026 leaked-source tool
  implementations (Part II §8, cc-snapshot) — same subject eight months earlier and
  at the CLI/MCP-surface altitude rather than the tool-handler altitude, so it is
  restatement-across-era, not verbatim redundancy. Its original disposition is a
  clean instance of "for the notation?" as the bar silently excluding harness-grade
  material.
---


# Claude Code CLI - Feature Specification Library

## Overview
Claude Code is Anthropic's official CLI tool for interacting with Claude AI through a command-line interface. This webpack-compiled CommonJS TypeScript application provides comprehensive features for managing Model Context Protocol (MCP) servers, authentication, and AI interactions.

## Core Architecture

### Module System
- **Webpack Module Pattern**: Custom CommonJS wrapper with module definitions
- **Entry Point**: `#!/usr/bin/env node` executable
- **Bundle Size**: ~8.7MB (includes all dependencies)
- **Module Loader**: `var E=(A,B)=>()=>(B||A((B={exports:{}}).exports,B),B.exports)`

## Command Structure

### Main Command: `claude`
The root command for all CLI operations.

### 1. MCP (Model Context Protocol) Commands

#### `claude mcp serve`
**Purpose**: Start the Claude Code MCP server
**Options**:
- `-d, --debug`: Enable debug mode
- `-p, --port <port>`: Specify server port
**Features**:
- WebSocket server implementation
- Real-time communication with Claude
- Session management

#### `claude mcp add <name> <commandOrUrl> [args...]`
**Purpose**: Add a new MCP server configuration
**Options**:
- `-s, --scope <scope>`: Configuration scope (local/user/project)
- `-t, --transport <transport>`: Transport type (stdio/sse/http)
- `--env <key=value>`: Environment variables
- `--project <path>`: Project-specific configuration
**Transport Types**:
- **stdio**: Standard input/output communication
- **sse**: Server-Sent Events for real-time streaming
- **http**: HTTP-based REST API communication

#### `claude mcp remove <name>`
**Purpose**: Remove an MCP server configuration
**Options**:
- `-s, --scope <scope>`: Configuration scope
- `--project <path>`: Project path

#### `claude mcp list`
**Purpose**: List all configured MCP servers
**Output Format**:
- Server name
- Transport type
- Command/URL
- Configuration scope
- Status

#### `claude mcp get <name>`
**Purpose**: Get detailed information about a specific MCP server
**Options**:
- `-s, --scope <scope>`: Configuration scope
- `--project <path>`: Project path

#### `claude mcp add-json <name> <json>`
**Purpose**: Add server with JSON configuration
**JSON Schema**:
```json
{
  "command": "string",
  "args": ["array"],
  "env": {"key": "value"},
  "transport": "stdio|sse|http"
}
```

#### `claude mcp add-from-claude-desktop`
**Purpose**: Import MCP server configurations from Claude Desktop
**Features**:
- Automatic detection of Claude Desktop configuration
- Batch import of multiple servers
- Conflict resolution

#### `claude mcp reset-project-choices`
**Purpose**: Reset project-scoped server selections
**Use Case**: Clear cached server choices for current project

### 2. Setup & Configuration Commands

#### `claude setup-token`
**Purpose**: Configure long-lived authentication token
**Features**:
- OAuth flow integration
- API key management
- Secure token storage
- Environment variable configuration

#### `claude migrate-installer`
**Purpose**: Migrate from global to local installation
**Features**:
- Preserves configurations
- Updates PATH references
- Handles version conflicts

### 3. Maintenance Commands

#### `claude doctor`
**Purpose**: Run health diagnostics
**Checks**:
- Auto-updater status
- Configuration integrity
- MCP server connectivity
- Authentication status
- File permissions
- Network connectivity

#### `claude update`
**Purpose**: Check and install updates
**Options**:
- `--check`: Only check for updates
- `--force`: Force update regardless of version
**Features**:
- Automatic update detection
- Version comparison
- Rollback capability

#### `claude install`
**Purpose**: Install Claude Code native build
**Features**:
- Platform detection
- Architecture selection
- Binary installation
- PATH configuration

## Configuration System

### Scope Hierarchy
1. **Project Scope** (`.mcp.json` in project root)
   - Highest priority
   - Project-specific servers
   - Version control friendly

2. **Local Scope** (current directory)
   - Directory-specific configurations
   - Temporary overrides

3. **User Scope** (`~/.claude/config.json`)
   - User-wide settings
   - Default configurations
   - Authentication tokens

### Configuration File Format
```json
{
  "mcpServers": {
    "serverName": {
      "command": "command",
      "args": ["arg1", "arg2"],
      "env": {
        "KEY": "value"
      },
      "transport": "stdio"
    }
  },
  "auth": {
    "token": "encrypted_token",
    "apiKey": "api_key"
  },
  "preferences": {
    "debug": false,
    "telemetry": true
  }
}
```

## MCP Server Protocol

### Transport Mechanisms

#### STDIO Transport
- **Communication**: Standard input/output streams
- **Use Case**: Local command execution
- **Protocol**: JSON-RPC over stdio
- **Example**: Language servers, local tools

#### SSE (Server-Sent Events) Transport
- **Communication**: HTTP EventSource protocol
- **Use Case**: Real-time streaming from web services
- **Protocol**: JSON messages over SSE
- **Example**: Live data feeds, monitoring services

#### HTTP Transport
- **Communication**: REST API endpoints
- **Use Case**: Traditional web services
- **Protocol**: HTTP/HTTPS requests
- **Example**: External APIs, cloud services

### Protocol Messages
```typescript
interface MCPMessage {
  jsonrpc: "2.0";
  method: string;
  params?: any;
  id?: string | number;
}

interface MCPResponse {
  jsonrpc: "2.0";
  result?: any;
  error?: MCPError;
  id: string | number;
}
```

## Error Handling

### Error Categories
1. **Configuration Errors**
   - Invalid JSON syntax
   - Missing required fields
   - Permission issues

2. **Network Errors**
   - Connection timeouts
   - DNS resolution failures
   - Protocol mismatches

3. **Authentication Errors**
   - Invalid tokens
   - Expired credentials
   - Permission denied

4. **Runtime Errors**
   - Process spawn failures
   - Memory issues
   - File system errors

### Error Tracking
- **Sentry Integration**: Automatic error reporting
- **Stack Trace Enhancement**: Source map support
- **User Privacy**: Anonymized telemetry
- **Error Aggregation**: Pattern detection

## Cross-Platform Support

### Platform Detection
```javascript
const platform = process.platform; // darwin, win32, linux
const arch = process.arch; // x64, arm64
```

### Platform-Specific Features
- **Windows**: PowerShell integration, Windows paths
- **macOS**: Keychain integration, Apple Silicon support
- **Linux**: Package manager integration, systemd support

### Path Handling
- Automatic path normalization
- Home directory expansion
- Environment variable substitution

## Security Features

### Authentication
- OAuth 2.0 flow
- API key management
- Token encryption at rest
- Secure credential storage

### Data Protection
- Local configuration encryption
- Secure communication channels
- Permission validation
- Input sanitization

## Performance Optimizations

### Caching
- Configuration caching
- Command result caching
- Network response caching

### Resource Management
- Connection pooling
- Process lifecycle management
- Memory usage optimization
- Stream handling

## Telemetry & Analytics

### Data Collection
- Anonymous usage statistics
- Error patterns
- Performance metrics
- Feature adoption

### Privacy Controls
- Opt-out mechanism
- Data anonymization
- Local-only mode
- GDPR compliance

## Extension Points

### Plugin Architecture
- Custom MCP servers
- Transport plugins
- Authentication providers
- Command extensions

### API Hooks
- Pre-command hooks
- Post-command hooks
- Error handlers
- Custom validators

## Debugging Features

### Debug Mode
- Verbose logging
- Request/response tracing
- Performance profiling
- Memory monitoring

### Logging
- Structured logging
- Log levels (error, warn, info, debug)
- File and console output
- Log rotation

## Update Mechanism

### Auto-Update Flow
1. Version check against remote
2. Download new version
3. Verify checksums
4. Backup current version
5. Install update
6. Rollback on failure

### Version Management
- Semantic versioning
- Channel selection (stable, beta)
- Version pinning
- Compatibility checks

## Dependencies

### Core Libraries
- **Commander.js**: CLI framework
- **Cross-spawn**: Process management
- **Sentry SDK**: Error tracking
- **WebSocket**: Real-time communication
- **EventSource**: SSE client

### Utility Libraries
- Stream utilities
- Path manipulation
- JSON parsing
- HTTP clients
- Cryptography

## File Structure

### Installation Locations
- **Binary**: `/usr/local/bin/claude` or user directory
- **Config**: `~/.claude/` or `%APPDATA%\claude`
- **Cache**: System temp directory
- **Logs**: `~/.claude/logs/`

### Project Files
- `.mcp.json`: Project configuration
- `.claude/`: Project-specific data
- `CLAUDE.md`: Project documentation