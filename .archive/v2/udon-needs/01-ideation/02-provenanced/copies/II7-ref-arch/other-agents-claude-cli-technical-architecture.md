---
source: ~/src/_ref/_arch/other-agents/TECHNICAL_SPECIFICATIONS.md — whole file,
  promoted 2026-07-21 (rebasing pass) from a witnessed-only II7 disposition
gathered: 2026-07-21
status: gathered (verbatim whole-file copy). Supersedes the II7 witness-line
  disposition ("CLI/MCP ergonomics, not document notation"). Under the Brief's
  full-tooling-surface scope this is harness-consumer prior art: a layered
  architecture reverse-engineering of the reference agent CLI runtime.
paths:
  - /Users/josephwecker-v2/src/_ref/_arch/other-agents/TECHNICAL_SPECIFICATIONS.md
source_commit: (non-git — _ref/_arch)
source_mtime: 2025-08-20
categories: [harness, agent-cli, runtime-architecture, protocol, error-handling, security, reference-implementation, superseded-disposition]
why_included: >
  The architecture companion to the CLI feature spec: a four-layer decomposition of
  Claude Code (CLI / Core Services / Transport / Infrastructure), component
  responsibilities, design patterns, protocol/data-structure/API specs, security
  architecture, and an error-handling framework — reverse-engineered Aug 2025. For
  the harness master thesis this is a concrete prior-art model of how a shipping
  agent runtime is structured. Signal is the architecture/protocol/error/security
  layers; the webpack bundle-internals sections (§2) are implementation plumbing —
  keep at synthesis as an "as reverse-engineered" caveat. The reified tool-input
  CONTRACT itself travels separately as
  `other-agents-claude-cli-tool-input-schemas.md`; the deobfuscated
  `CLI_DEOBFUSCATED_SOURCE.js` + `sdk.d.ts` bundle internals remain witnessed-only
  (plumbing — the contract travels via these three files).
---


# Claude Code CLI - Technical Specifications Library

## Table of Contents
1. [System Architecture](#system-architecture)
2. [Module System](#module-system)
3. [Protocol Specifications](#protocol-specifications)
4. [Data Structures](#data-structures)
5. [API Specifications](#api-specifications)
6. [Security Architecture](#security-architecture)
7. [Performance Specifications](#performance-specifications)
8. [Error Handling Framework](#error-handling-framework)
9. [Testing Requirements](#testing-requirements)
10. [Deployment Specifications](#deployment-specifications)

---

## 1. System Architecture

### 1.1 Overall Architecture Pattern
```
┌─────────────────────────────────────────────────────────────┐
│                         CLI Layer                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │ Commander│ │   Args   │ │  Input   │ │  Output  │      │
│  │  Parser  │ │Validator │ │ Handler  │ │ Formatter│      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Core Services Layer                     │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │   Auth   │ │  Config  │ │   MCP    │ │  Update  │      │
│  │  Manager │ │ Manager  │ │ Manager  │ │ Manager  │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Transport Layer                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │  STDIO   │ │   SSE    │ │   HTTP   │ │WebSocket │      │
│  │Transport │ │Transport │ │Transport │ │Transport │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Infrastructure Layer                      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │   File   │ │  Network │ │  Process │ │  Crypto  │      │
│  │  System  │ │    I/O   │ │  Manager │ │ Services │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Component Responsibilities

| Component | Responsibility | Dependencies |
|-----------|---------------|--------------|
| CLI Layer | Command parsing, user interaction | Commander.js |
| Core Services | Business logic, state management | Node.js core |
| Transport Layer | Protocol implementations | EventEmitter, streams |
| Infrastructure | System resources, I/O operations | OS APIs |

### 1.3 Design Patterns

- **Singleton Pattern**: Configuration Manager, Authentication Manager
- **Factory Pattern**: MCP Server creation
- **Observer Pattern**: Event-driven server communication
- **Strategy Pattern**: Transport type selection
- **Command Pattern**: CLI command execution
- **Repository Pattern**: Configuration storage

---

## 2. Module System

### 2.1 Webpack Bundle Structure

```javascript
// Module Definition Pattern
var moduleCache = {};
var moduleDefinitions = {
  [moduleId]: function(module, exports, require) {
    // Module code
  }
};

// Module Loader
function webpackRequire(moduleId) {
  if (moduleCache[moduleId]) {
    return moduleCache[moduleId].exports;
  }
  var module = moduleCache[moduleId] = {
    id: moduleId,
    loaded: false,
    exports: {}
  };
  moduleDefinitions[moduleId].call(
    module.exports, 
    module, 
    module.exports, 
    webpackRequire
  );
  module.loaded = true;
  return module.exports;
}
```

### 2.2 Module Dependencies Graph

```
cli.js (entry)
├── commander
├── config/
│   ├── ConfigurationManager
│   └── ConfigValidator
├── mcp/
│   ├── MCPServer (base)
│   ├── StdioServer
│   ├── SSEServer
│   ├── HTTPServer
│   └── WebSocketServer
├── auth/
│   ├── AuthenticationManager
│   ├── TokenManager
│   └── OAuthFlow
├── update/
│   ├── UpdateManager
│   ├── VersionChecker
│   └── Installer
├── diagnostics/
│   ├── DoctorManager
│   └── HealthChecks
└── utils/
    ├── Logger
    ├── ErrorHandler
    └── PlatformUtils
```

### 2.3 Module Loading Order

1. Core utilities and constants
2. Infrastructure services
3. Manager classes
4. Transport implementations
5. Command handlers
6. CLI initialization

---

## 3. Protocol Specifications

### 3.1 MCP (Model Context Protocol)

#### 3.1.1 Message Format
```typescript
interface MCPMessage {
  jsonrpc: "2.0";
  id?: string | number;
  method?: string;
  params?: any;
  result?: any;
  error?: MCPError;
}

interface MCPError {
  code: number;
  message: string;
  data?: any;
}
```

#### 3.1.2 Method Types
```typescript
enum MCPMethods {
  // Lifecycle
  INITIALIZE = "initialize",
  SHUTDOWN = "shutdown",
  
  // Communication
  REQUEST = "request",
  RESPONSE = "response",
  NOTIFICATION = "notification",
  
  // Tools
  TOOL_LIST = "tools/list",
  TOOL_EXECUTE = "tools/execute",
  
  // Resources
  RESOURCE_LIST = "resources/list",
  RESOURCE_GET = "resources/get",
  
  // Prompts
  PROMPT_LIST = "prompts/list",
  PROMPT_GET = "prompts/get"
}
```

#### 3.1.3 Transport Protocols

##### STDIO Transport
```javascript
// Message framing
const frame = {
  header: {
    contentLength: number,
    contentType: "application/json"
  },
  body: MCPMessage
};

// Serialization
process.stdout.write(`Content-Length: ${length}\r\n\r\n${JSON.stringify(message)}`);
```

##### SSE Transport
```javascript
// Event stream format
const event = {
  event: "message",
  data: JSON.stringify(MCPMessage),
  id: messageId,
  retry: 10000
};

// Serialization
`event: ${event.event}\ndata: ${event.data}\nid: ${event.id}\n\n`
```

##### HTTP Transport
```javascript
// Request format
const httpRequest = {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "X-MCP-Version": "1.0.0"
  },
  body: JSON.stringify(MCPMessage)
};
```

### 3.2 Authentication Protocol

#### 3.2.1 OAuth 2.0 Flow
```typescript
interface OAuthConfig {
  authorizationUrl: string;
  tokenUrl: string;
  clientId: string;
  redirectUri: string;
  scope: string[];
}

interface TokenResponse {
  access_token: string;
  refresh_token?: string;
  expires_in: number;
  token_type: "Bearer";
}
```

#### 3.2.2 API Key Authentication
```typescript
interface APIKeyAuth {
  key: string;
  header: "X-API-Key" | "Authorization";
  prefix?: "Bearer" | "ApiKey";
}
```

---

## 4. Data Structures

### 4.1 Configuration Schema

```typescript
interface Configuration {
  version: string;
  mcpServers: {
    [name: string]: MCPServerConfig;
  };
  auth?: AuthConfig;
  preferences?: UserPreferences;
  telemetry?: TelemetryConfig;
}

interface MCPServerConfig {
  transport: "stdio" | "sse" | "http" | "ws";
  command?: string;
  args?: string[];
  url?: string;
  env?: Record<string, string>;
  headers?: Record<string, string>;
  healthCheck?: boolean;
  healthCheckInterval?: number;
  autoRestart?: boolean;
  timeout?: number;
  maxRetries?: number;
  scope?: "user" | "project" | "local";
  addedAt?: string;
  updatedAt?: string;
}

interface AuthConfig {
  token?: string;
  apiKey?: string;
  refreshToken?: string;
  expiresAt?: string;
  provider?: "anthropic" | "custom";
}

interface UserPreferences {
  debug: boolean;
  outputFormat: "json" | "text" | "table";
  colorOutput: boolean;
  updateChannel: "stable" | "beta" | "nightly";
  telemetryEnabled: boolean;
  logLevel: "error" | "warn" | "info" | "debug";
}
```

### 4.2 State Management

```typescript
interface ApplicationState {
  servers: Map<string, ServerState>;
  config: Configuration;
  auth: AuthState;
  diagnostics: DiagnosticState;
}

interface ServerState {
  name: string;
  status: ServerStatus;
  transport: Transport;
  process?: ChildProcess;
  connection?: Connection;
  stats: ServerStats;
  lastError?: Error;
}

interface ServerStats {
  startTime: number;
  messagesSent: number;
  messagesReceived: number;
  errors: number;
  restarts: number;
  avgResponseTime: number;
}
```

### 4.3 Message Queue

```typescript
class MessageQueue<T> {
  private queue: T[] = [];
  private processing: boolean = false;
  private maxSize: number = 1000;
  private handlers: Map<string, MessageHandler<T>>;
  
  enqueue(message: T): void;
  dequeue(): T | undefined;
  process(): Promise<void>;
  clear(): void;
  size(): number;
}
```

---

## 5. API Specifications

### 5.1 Internal APIs

#### Configuration API
```typescript
interface IConfigurationManager {
  loadConfiguration(): Configuration;
  saveConfiguration(config: Configuration, scope: string): void;
  get(key: string, defaultValue?: any): any;
  set(key: string, value: any, scope?: string): void;
  has(key: string): boolean;
  validate(config: Configuration): ValidationResult;
}
```

#### MCP Server API
```typescript
interface IMCPServerManager {
  startServer(name: string, config: MCPServerConfig): Promise<MCPServer>;
  stopServer(name: string): Promise<void>;
  restartServer(name: string): Promise<void>;
  listServers(): ServerInfo[];
  getServer(name: string): MCPServer | undefined;
  sendMessage(name: string, message: MCPMessage): Promise<void>;
}
```

#### Authentication API
```typescript
interface IAuthenticationManager {
  authenticate(credentials: Credentials): Promise<AuthToken>;
  refreshToken(token: string): Promise<AuthToken>;
  validateToken(token: string): boolean;
  revokeToken(token: string): Promise<void>;
  getStoredToken(): AuthToken | null;
}
```

### 5.2 External APIs

#### Claude API Endpoints
```typescript
const CLAUDE_API = {
  base: "https://api.anthropic.com",
  endpoints: {
    auth: "/v1/auth",
    token: "/v1/auth/token",
    validate: "/v1/auth/validate",
    version: "/claude-code/version",
    telemetry: "/claude-code/telemetry"
  }
};
```

#### MCP Server Endpoints
```typescript
interface MCPServerEndpoints {
  capabilities: "/capabilities";
  tools: "/tools";
  resources: "/resources";
  prompts: "/prompts";
  execute: "/execute";
  health: "/health";
}
```

---

## 6. Security Architecture

### 6.1 Encryption Specifications

```typescript
interface EncryptionConfig {
  algorithm: "aes-256-gcm";
  keyDerivation: "scrypt";
  saltLength: 32;
  tagLength: 16;
  iterations: 100000;
}

class TokenEncryption {
  private deriveKey(password: string, salt: Buffer): Buffer;
  encrypt(plaintext: string, password: string): EncryptedData;
  decrypt(encrypted: EncryptedData, password: string): string;
}

interface EncryptedData {
  encrypted: string;
  salt: string;
  iv: string;
  tag: string;
  algorithm: string;
}
```

### 6.2 Permission Model

```typescript
interface PermissionModel {
  fileSystem: {
    read: string[];
    write: string[];
    execute: string[];
  };
  network: {
    allowedHosts: string[];
    blockedHosts: string[];
    allowedPorts: number[];
  };
  process: {
    maxProcesses: number;
    allowedCommands: string[];
    environmentVars: string[];
  };
}
```

### 6.3 Input Validation

```typescript
class InputValidator {
  validateCommand(command: string): ValidationResult;
  validateServerName(name: string): ValidationResult;
  validateURL(url: string): ValidationResult;
  validateJSON(json: string): ValidationResult;
  sanitizePath(path: string): string;
  escapeShellArgs(args: string[]): string[];
}
```

---

## 7. Performance Specifications

### 7.1 Resource Limits

```typescript
interface ResourceLimits {
  memory: {
    maxHeapSize: number; // MB
    maxRSS: number; // MB
    gcInterval: number; // ms
  };
  cpu: {
    maxUsage: number; // percentage
    throttling: boolean;
  };
  io: {
    maxFileHandles: number;
    maxSockets: number;
    bufferSize: number; // KB
  };
  process: {
    maxChildProcesses: number;
    processTimeout: number; // ms
  };
}
```

### 7.2 Caching Strategy

```typescript
interface CacheConfig {
  configuration: {
    ttl: number; // seconds
    maxSize: number; // entries
    strategy: "LRU" | "LFU";
  };
  responses: {
    ttl: number;
    maxSize: number;
    keyGenerator: (req: Request) => string;
  };
  files: {
    enableCache: boolean;
    maxFileSize: number; // bytes
    cacheLocation: string;
  };
}
```

### 7.3 Performance Metrics

```typescript
interface PerformanceMetrics {
  startup: {
    initTime: number;
    moduleLoadTime: number;
    configLoadTime: number;
  };
  runtime: {
    avgResponseTime: number;
    p95ResponseTime: number;
    p99ResponseTime: number;
    throughput: number;
  };
  resources: {
    memoryUsage: MemoryUsage;
    cpuUsage: CPUUsage;
    activeConnections: number;
    openFileHandles: number;
  };
}
```

---

## 8. Error Handling Framework

### 8.1 Error Classification

```typescript
enum ErrorSeverity {
  FATAL = "fatal",
  ERROR = "error",
  WARNING = "warning",
  INFO = "info"
}

enum ErrorCategory {
  CONFIGURATION = "configuration",
  AUTHENTICATION = "authentication",
  NETWORK = "network",
  PERMISSION = "permission",
  VALIDATION = "validation",
  RUNTIME = "runtime",
  SYSTEM = "system"
}

class ApplicationError extends Error {
  severity: ErrorSeverity;
  category: ErrorCategory;
  code: string;
  context?: any;
  recoverable: boolean;
  timestamp: Date;
}
```

### 8.2 Error Recovery Strategies

```typescript
interface ErrorRecoveryStrategy {
  shouldRecover(error: ApplicationError): boolean;
  recover(error: ApplicationError): Promise<void>;
  maxRetries: number;
  retryDelay: number;
  backoffMultiplier: number;
}

const recoveryStrategies: Map<ErrorCategory, ErrorRecoveryStrategy> = new Map([
  [ErrorCategory.NETWORK, new NetworkErrorRecovery()],
  [ErrorCategory.AUTHENTICATION, new AuthErrorRecovery()],
  [ErrorCategory.CONFIGURATION, new ConfigErrorRecovery()]
]);
```

### 8.3 Error Reporting

```typescript
interface ErrorReport {
  id: string;
  timestamp: Date;
  error: {
    message: string;
    stack?: string;
    code?: string;
    category?: ErrorCategory;
    severity?: ErrorSeverity;
  };
  context: {
    command?: string;
    args?: string[];
    config?: any;
    environment?: any;
  };
  system: {
    platform: string;
    arch: string;
    nodeVersion: string;
    cliVersion: string;
  };
}
```

---

## 9. Testing Requirements

### 9.1 Test Coverage Requirements

```typescript
interface TestCoverage {
  unit: {
    minimum: 80;
    target: 90;
    excludePatterns: string[];
  };
  integration: {
    minimum: 70;
    target: 85;
    testEnvironments: string[];
  };
  e2e: {
    minimum: 60;
    target: 75;
    platforms: string[];
  };
}
```

### 9.2 Test Specifications

```typescript
interface TestSpecification {
  name: string;
  category: "unit" | "integration" | "e2e";
  requirements: string[];
  setup?: () => Promise<void>;
  teardown?: () => Promise<void>;
  timeout?: number;
  retries?: number;
  skip?: boolean;
  only?: boolean;
}
```

### 9.3 Mock Specifications

```typescript
interface MockSpecification {
  MCPServer: {
    transport: "stdio" | "sse" | "http";
    responses: Map<string, any>;
    latency?: number;
    errorRate?: number;
  };
  FileSystem: {
    files: Map<string, string>;
    permissions: Map<string, number>;
  };
  Network: {
    endpoints: Map<string, MockEndpoint>;
    latency?: number;
    timeout?: number;
  };
}
```

---

## 10. Deployment Specifications

### 10.1 Build Configuration

```typescript
interface BuildConfig {
  target: "node14" | "node16" | "node18";
  platform: "darwin" | "linux" | "win32";
  arch: "x64" | "arm64";
  optimization: {
    minify: boolean;
    treeshake: boolean;
    compress: boolean;
    sourceMap: boolean;
  };
  bundle: {
    format: "cjs" | "esm";
    externals: string[];
    includeNodeModules: boolean;
  };
}
```

### 10.2 Distribution Channels

```typescript
interface DistributionChannel {
  name: "npm" | "homebrew" | "apt" | "direct";
  config: {
    registry?: string;
    repository?: string;
    cdnUrl?: string;
    signatures?: boolean;
  };
  platforms: string[];
  architectures: string[];
}
```

### 10.3 Installation Requirements

```typescript
interface InstallationRequirements {
  node: {
    minimum: "14.0.0";
    recommended: "18.0.0";
  };
  system: {
    memory: 512; // MB
    disk: 100; // MB
    permissions: ["read", "write", "execute"];
  };
  dependencies: {
    runtime: string[];
    optional: string[];
  };
  postInstall?: {
    scripts: string[];
    verification: string[];
  };
}
```

### 10.4 Update Mechanism

```typescript
interface UpdateMechanism {
  strategy: "in-place" | "side-by-side" | "rolling";
  channels: {
    stable: UpdateChannel;
    beta: UpdateChannel;
    nightly: UpdateChannel;
  };
  verification: {
    checksum: boolean;
    signature: boolean;
    certificatePin?: string;
  };
  rollback: {
    enabled: boolean;
    maxVersions: number;
    automaticOnFailure: boolean;
  };
}

interface UpdateChannel {
  url: string;
  checkInterval: number;
  autoUpdate: boolean;
  prerelease: boolean;
}
```

---

## Appendix A: Error Codes

| Code | Category | Description |
|------|----------|-------------|
| AUTH_001 | Authentication | Invalid token |
| AUTH_002 | Authentication | Token expired |
| AUTH_003 | Authentication | Permission denied |
| CONFIG_001 | Configuration | Invalid JSON |
| CONFIG_002 | Configuration | Missing required field |
| CONFIG_003 | Configuration | File not found |
| NET_001 | Network | Connection timeout |
| NET_002 | Network | DNS resolution failed |
| NET_003 | Network | Connection refused |
| MCP_001 | MCP | Server start failed |
| MCP_002 | MCP | Invalid transport |
| MCP_003 | MCP | Protocol error |
| SYS_001 | System | Insufficient permissions |
| SYS_002 | System | Resource limit exceeded |
| SYS_003 | System | Platform not supported |

## Appendix B: Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| CLAUDE_API_KEY | API authentication key | - |
| CLAUDE_CONFIG_PATH | Configuration directory | ~/.claude |
| CLAUDE_DEBUG | Enable debug logging | false |
| CLAUDE_NO_TELEMETRY | Disable telemetry | false |
| CLAUDE_UPDATE_CHANNEL | Update channel | stable |
| CLAUDE_TIMEOUT | Request timeout (ms) | 30000 |
| CLAUDE_MAX_RETRIES | Maximum retry attempts | 3 |
| CLAUDE_PROXY | HTTP proxy URL | - |
| CLAUDE_CA_BUNDLE | CA certificate bundle | - |
| CLAUDE_SKIP_TLS_VERIFY | Skip TLS verification | false |

## Appendix C: File Formats

### Configuration File (.mcp.json)
```json
{
  "$schema": "https://claude.ai/schemas/mcp-config.json",
  "version": "1.0.0",
  "mcpServers": {},
  "auth": {},
  "preferences": {}
}
```

### Server Definition
```json
{
  "name": "example-server",
  "transport": "stdio",
  "command": "node",
  "args": ["server.js"],
  "env": {
    "DEBUG": "true"
  }
}
```

### Project Manifest (CLAUDE.md)
```markdown
# Claude Code Project Configuration

## MCP Servers
- server1: Description
- server2: Description

## Commands
- build: npm run build
- test: npm test
- lint: npm run lint

## Environment
- Node: 18.x
- Platform: darwin
```