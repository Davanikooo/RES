# Overview

Resize (RES) is an advanced file compression tool based on UPX (Ultimate Packer for eXecutables) technology with complete rebranding and modernization. The project provides high-performance executable compression for multiple file formats including Windows PE, Linux ELF, and macOS Mach-O binaries. Resize achieves 50-70% size reduction while maintaining zero runtime overhead through in-place decompression. The tool is designed as a secure, portable, and extendable solution for reducing executable file sizes across different platforms and architectures.

# User Preferences

Preferred communication style: Simple, everyday language.

# System Architecture

## Core Architecture
- **Language**: C++ with C++17 standard requirement
- **Build System**: CMake 3.8+ with custom functions using `resize_*` namespace
- **Binary Name**: `resize` (rebranded from UPX)
- **Macro System**: Uses `RES_*` prefixes instead of `UPX_*`
- **Version System**: `RES_VERSION_*` macro system for version management

## Compression Engine
- **Algorithms**: Multiple compression methods including LZMA, NRV variants
- **Filtering**: Data preprocessing with "naive" and "clever" implementations for ix86 executables
- **Self-Contained**: Compressed executables run independently without external dependencies
- **In-Place Decompression**: No memory overhead during runtime execution

## Platform Support
- **Windows**: PE format (win32/win64), DOS executables, DLLs
- **Linux**: ELF format (x86/x64/ARM/MIPS), kernel images
- **macOS**: Mach-O binaries (Intel/ARM/Universal)
- **Legacy**: Atari TOS, PlayStation, DJGPP, Watcom formats

## Build Infrastructure
- **Compilers**: GCC 8+ or Clang 5+ with full C++17 support
- **Dependencies**: UCL, zlib, LZMA SDK (included as vendor libraries)
- **Static Analysis**: Integrated clang-tidy and formatting tools
- **Testing**: CMake-based test framework with CTest integration

## File Structure
- **Source Code**: Organized in `src/` with stub files renamed to `*-resmain.h` pattern
- **Documentation**: Comprehensive docs in `doc/` including manual pages and technical guides
- **Vendor Libraries**: Self-contained in `vendor/` directory with UCL, zlib, LZMA SDK
- **Build Artifacts**: Generated in `build/release/` with CMake configuration

## Security Model
- **Security Context**: Inherits security context of processed files - only use on trusted files
- **GPL Licensing**: Maintains original UPX GPL-2.0+ license requirements
- **Open Source**: Full source code transparency for security verification

# External Dependencies

## Compression Libraries
- **UCL (Ultimate Compression Library)**: Core compression algorithms, GPL licensed
- **zlib**: Standard compression library for additional format support
- **LZMA SDK**: Advanced compression method, public domain license

## Build Dependencies
- **CMake**: Version 3.8+ for cross-platform build system
- **GNU Make**: Build automation (4.0+)
- **Git**: Version control and dependency management

## Development Tools
- **doctest**: MIT-licensed testing framework for unit tests
- **clang-tidy**: Static analysis and code quality checks
- **Python 2/3**: Build scripts and utilities in `misc/scripts/` and `src/stub/scripts/`

## Platform-Specific Tools
- **ELF Tools**: `elfutils`, `execstack` for Linux binary manipulation
- **Binary Analysis**: Various utilities for cross-platform executable analysis
- **Packaging**: Support for multiple distribution methods and package managers
