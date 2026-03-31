# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SDKFoundation is a Swift package providing foundational types and utilities for an iOS SDK. It uses Swift 6.3 with strict concurrency (Swift language mode v6).

## Build & Test Commands

```bash
# Build
swift build

# Run all tests
swift test

# Run a single test
swift test --filter SDKFoundationTests/testName
```

## Architecture

Single-module Swift package:
- **SDKFoundation** — library target under `Sources/SDKFoundation/`
- **SDKFoundationTests** — test target under `Tests/SDKFoundationTests/`, uses Swift Testing framework (`import Testing`, `@Test`)

No external dependencies. No platform restrictions declared (builds for all Swift-supported platforms).

## Key Conventions

- Swift 6 strict concurrency is enforced (`swiftLanguageModes: [.v6]`)
- Tests use Swift Testing (`@Test`, `#expect`), not XCTest
