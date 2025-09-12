# Overview

Resize (RES) is an advanced file compression tool based on UPX (Ultimate Packer for eXecutables) technology with complete rebranding and modernization. The project provides high-performance executable compression with support for multiple file formats including Windows PE, Linux ELF, and macOS Mach-O binaries. It achieves 50-70% size reduction while maintaining zero runtime overhead through in-place decompression.

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
- **Algorithms**: Multiple compression methods including LZMA, UCL variants, zlib, and bzip2
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
- **zlib**: Standard compression library for deflate/inflate algorithms
- **LZMA SDK**: High-compression ratio LZMA algorithm implementation
- **bzip2**: Block-sorting file compressor for additional compression options

## Development Tools
- **CMake**: Build system generator (minimum version 3.8)
- **Git**: Version control system for source code management
- **Python**: Build scripts and utilities (Python 2/3 compatible)
- **clang-tidy**: Static analysis tool for code quality
- **doctest**: C++ testing framework (MIT licensed)

## System Libraries
- **Standard C++ Library**: C++17 standard library features
- **POSIX APIs**: For Unix-like operating system integration
- **Windows APIs**: For Windows platform-specific functionality
- **ELF libraries**: For Linux executable format handling