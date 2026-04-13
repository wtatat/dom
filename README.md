# DOM

`DOM` is a bootstrap repository for a desktop messenger based on:

- `teamgram-server` for the Go/Docker backend
- `teamgram-tdesktop` for the C++/Qt desktop client

This repository keeps the orchestration scripts, pinned upstream commits, and the DOM rebrand patch. The heavy upstream sources and generated dependencies are cloned locally when you run the bootstrap/build scripts.

## What is included

- `bootstrap-dom.ps1` clones the upstream repositories, checks out pinned commits, updates submodules, and applies the DOM client patch.
- `build-dom-client.ps1` bootstraps the client and starts the Windows desktop build.
- `start-dom-server.ps1` bootstraps and starts the Teamgram server stack with Docker.
- `stop-dom-server.ps1` stops the Docker stack.
- `dom.sources.json` pins the exact upstream repositories and commits.
- `patches/teamgram-tdesktop-dom.patch` contains the DOM branding and local server connection changes for the desktop client.

## Local build flow

1. Start the backend:

```powershell
powershell -ExecutionPolicy Bypass -File .\start-dom-server.ps1
```

2. Build the desktop client:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-dom-client.ps1
```

Or run the full local stack bootstrap in one command:

```powershell
powershell -ExecutionPolicy Bypass -File .\build-full-dom.ps1
```

## Current client patch

The patch currently does these minimum changes:

- rebrands the Teamgram desktop client to `DOM`
- changes Windows metadata and installer names to `DOM`
- points the built-in MTProto DC to `127.0.0.1:10443`
- makes the upstream `prepare.py` less fragile for unattended bootstrap on Windows

## Notes

- The first client bootstrap is expensive because Teamgram Desktop pulls and builds a large native dependency stack.
- Generated folders like `Libraries`, `ThirdParty`, cloned upstream sources, and build logs are intentionally ignored from git.
