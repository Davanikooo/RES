# Resize (RES) - Advanced File Compression Tool

```
    ██████  ███████ ███████ ██ ███████ ███████ 
    ██   ██ ██      ██      ██    ███  ██      
    ██████  █████   ███████ ██   ███   █████   
    ██   ██ ██           ██ ██  ███    ██      
    ██   ██ ███████ ███████ ██ ███████ ███████ 
```

**Resize** is an advanced file compression tool based on UPX (Ultimate Packer for eXecutables) technology with complete enhancements and rebranding. This tool is designed to compress executable files with high compression ratios while maintaining full functionality.

---

## 🚀 Key Features

- **High Compression Rate**: Reduces executable file size by 50-70%
- **Self-Contained**: Compressed files run independently without external dependencies
- **Multi-Platform**: Supports various executable formats (Windows PE, Linux ELF, macOS Mach-O)
- **Zero Runtime Overhead**: No performance penalty at runtime
- **Reversible**: Can be restored to original size at any time
- **Batch Processing**: Supports processing multiple files simultaneously

## 📋 System Requirements

### Minimum Requirements:
- **OS**: Linux (64-bit), Windows 10+, macOS 10.14+
- **RAM**: 512 MB available
- **Storage**: 50 MB free space
- **CPU**: Intel/AMD x64 or ARM64

### Build Requirements (for compilation):
- **Compiler**: GCC 8+ or Clang 5+ with full C++17 support
- **CMake**: Version 3.8 or newer
- **Make**: GNU Make 4.0+
- **Git**: For cloning dependencies

## 🛠️ Installation

### Build from Source
```bash
# 1. Clone repository
git clone https://github.com/WHO-AM-I-404/RES
cd RES

# 2. Prepare build directory
mkdir -p build/release
cd build/release

# 3. Configure with CMake
cmake ../.. -DCMAKE_BUILD_TYPE=Release

# 4. Compile
make -j$(nproc)

# 5. Install (optional)
sudo make install
```

### Developer Build
```bash
# For developers who want to contribute
mkdir -p build/debug
cd build/debug
cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DUSE_STRICT_DEFAULTS=ON
make -j$(nproc)
```

## 🎯 Basic Usage

### General Syntax
```bash
resize [OPTIONS] [FILE(S)]
```

### Simple Usage Examples

#### 1. Single File Compression
```bash
# Basic compression (default level)
resize myprogram.exe

# Fast compression (level 1)
resize -1 myprogram.exe

# Best compression (level 9)
resize -9 myprogram.exe

# Compression with maximum level
resize --best myprogram.exe

# Compression with brute force algorithm (most optimal)
resize --brute myprogram.exe
```

#### 2. Multiple Files Compression
```bash
# Compress all .exe files in directory
resize *.exe

# Compression with specific pattern
resize program1.exe program2.exe program3.exe
```

#### 3. Decompression (Restore)
```bash
# Restore to original size
resize -d compressed_program.exe

# Test file integrity
resize -t compressed_program.exe
```

## ⚙️ Complete Options and Parameters

### Compression Options
| Option | Description | Example |
|--------|-------------|---------|
| `-1` | Fast compression (less optimal result) | `resize -1 app.exe` |
| `-9` | High level compression | `resize -9 app.exe` |
| `--best` | Best compression (slow but optimal) | `resize --best app.exe` |
| `--brute` | Brute force algorithm (very slow, best result) | `resize --brute app.exe` |
| `--ultra-brute` | Ultra compression mode (extremely slow) | `resize --ultra-brute app.exe` |
| `--lzma` | Use LZMA algorithm | `resize --lzma app.exe` |

### Output Options
| Option | Description | Example |
|--------|-------------|---------|
| `-oFILE` | Write output to FILE | `resize -oresult.exe input.exe` |
| `-k, --backup` | Create backup of original file | `resize -k app.exe` |
| `--no-backup` | Don't create backup (default) | `resize --no-backup app.exe` |
| `-f` | Force compression of suspicious files | `resize -f app.exe` |

### Information Options
| Option | Description | Example |
|--------|-------------|---------|
| `-l` | Display compressed file info | `resize -l app.exe` |
| `-t` | Test file integrity | `resize -t app.exe` |
| `-v` | Detailed output | `resize -v app.exe` |
| `-q` | Silent mode | `resize -q app.exe` |
| `-V` | Show program version | `resize -V` |
| `-h` | Show help | `resize -h` |
| `-L` | Show license | `resize -L` |

### Advanced Options
| Option | Description | Example |
|--------|-------------|---------|
| `--fileinfo` | Display compressed file parameters | `resize --fileinfo app.exe` |
| `--overlay=copy` | Copy overlay data (default) | `resize --overlay=copy app.exe` |
| `--overlay=strip` | Strip overlay data | `resize --overlay=strip app.exe` |
| `--overlay=skip` | Skip files with overlay | `resize --overlay=skip app.exe` |
| `--force-overwrite` | Force overwrite output files | `resize --force-overwrite app.exe` |
| `--no-color` | Disable color output | `resize --no-color app.exe` |
| `--mono` | Monochrome output | `resize --mono app.exe` |
| `--color` | Enable color output | `resize --color app.exe` |
| `--no-progress` | Disable progress display | `resize --no-progress app.exe` |

### Windows PE Options
| Option | Description | Example |
|--------|-------------|---------|
| `--compress-exports=0` | Don't compress export section | `resize --compress-exports=0 app.exe` |
| `--compress-exports=1` | Compress export section (default) | `resize --compress-exports=1 app.exe` |
| `--compress-icons=0` | Don't compress icons | `resize --compress-icons=0 app.exe` |
| `--compress-icons=1` | Compress except first icon | `resize --compress-icons=1 app.exe` |
| `--compress-icons=2` | Compress except first icon directory (default) | `resize --compress-icons=2 app.exe` |
| `--compress-icons=3` | Compress all icons | `resize --compress-icons=3 app.exe` |
| `--compress-resources=0` | Don't compress resources | `resize --compress-resources=0 app.exe` |
| `--keep-resource=list` | Don't compress specific resources | `resize --keep-resource=list app.exe` |
| `--strip-relocs=0` | Don't strip relocations | `resize --strip-relocs=0 app.exe` |
| `--strip-relocs=1` | Strip relocations (default) | `resize --strip-relocs=1 app.exe` |

### Linux ELF Options
| Option | Description | Example |
|--------|-------------|---------|
| `--preserve-build-id` | Copy .gnu.note.build-id to output | `resize --preserve-build-id app` |
| `--catch-sigsegv` | Debug errors in hardware/decompressor | `resize --catch-sigsegv app` |

## 📚 Detailed Usage Guide

### 🔧 Common Usage Scenarios

#### 1. Compressing Desktop Applications
```bash
# For Windows applications
resize --best -k MyApp.exe

# For Linux applications
resize --best -k ./myapp

# For macOS applications
resize --best -k MyApp.app/Contents/MacOS/MyApp
```

#### 2. Distribution Optimization
```bash
# Compression for online distribution (size priority)
resize --brute --compress-icons=3 --compress-exports=1 installer.exe

# Compression for offline distribution (balanced)
resize --best -k setup.exe
```

#### 3. Batch Processing for Developers
```bash
# Compress all executables in project
find . -name "*.exe" -exec resize --best {} \;

# Compression with minimum size filter
find . -name "*.exe" -size +1M -exec resize --brute {} \;
```

#### 4. CI/CD Integration
```bash
# Script for pipeline
#!/bin/bash
for file in dist/*.exe; do
    if [ -f "$file" ]; then
        echo "Compressing $file..."
        resize --best -k "$file"
        if [ -f "$file.backup" ]; then
            echo "Original: $(du -h "$file.backup" | cut -f1)"
            echo "Compressed: $(du -h "$file" | cut -f1)"
        fi
        echo "---"
    fi
done
```

### 🎛️ Advanced Configuration

#### 1. Custom Compression Levels
```bash
# Level 1-9 (1=fastest, 9=best)
resize -9 app.exe

# Use LZMA algorithm
resize --lzma app.exe
```

#### 2. Platform-Specific Options
```bash
# Windows PE specific
resize --compress-resources=0 app.exe
resize --compress-exports=1 app.exe
resize --compress-icons=3 app.exe

# Linux ELF specific  
resize --preserve-build-id ./app
resize --catch-sigsegv ./app

# macOS Mach-O (no specific options, use general options)
resize --best ./app
```

#### 3. Security Considerations
```bash
# Test file after compression
resize --best app.exe && resize -t app.exe

# Preserve overlay data (default)
resize --overlay=copy app.exe
```

## 📊 Performance and Statistics

### Estimated Compression Rates:
*Results may vary depending on executable type, content, and system*
- **Small executables (< 1MB)**: Typically 40-60% reduction
- **Medium executables (1-10MB)**: Typically 50-70% reduction  
- **Large executables (> 10MB)**: Typically 55-75% reduction

### Estimated Speed Benchmarks:
*Performance varies significantly based on hardware and file characteristics*
- **-1 (fastest)**: Fastest compression
- **-9 (high compression)**: Slower but better compression
- **--best**: Best compression (can be slow)
- **--brute**: Very slow but thorough
- **--ultra-brute**: Extremely slow but maximum compression

## 🔍 Troubleshooting

### Error Messages and Solutions

#### "Cannot pack: file is already packed"
```bash
# File is already compressed, decompress first
resize -d packed_file.exe
resize --best packed_file.exe
```

#### "Cannot pack: file has overlay"
```bash
# Handle overlay data
resize --overlay=copy app.exe    # Copy overlay
resize --overlay=skip app.exe    # Skip overlay
resize --overlay=strip app.exe   # Remove overlay
```

#### "Cannot pack: executable format not supported"
```bash
# Check format
file myapp.exe
# Resize auto-detects format, check supported formats with:
resize -h
```

#### "Out of memory during compression"
```bash
# Use faster compression method
resize -1 app.exe
# Or try smaller files first
```

### Recovery Commands
```bash
# If compression fails and file is corrupted
cp app.exe.backup app.exe       # Restore from backup

# Test file integrity
resize -t app.exe              # Verify compressed file
```

## 🧪 Testing and Verification

### Pre-compression Checks
```bash
# Verify file before compression
file myapp.exe
ldd myapp                      # Check dependencies (Linux)
otool -L myapp                 # Check dependencies (macOS)
```

### Post-compression Verification
```bash
# Test compressed file
resize -t compressed_app.exe

# Compare functionality
./original_app --version
./compressed_app --version

# Performance test
time ./compressed_app benchmark
```

## 🔧 Build from Source Code

### Prerequisites Check
```bash
# Check compiler
gcc --version
clang++ --version

# Check CMake
cmake --version

# Check dependencies
pkg-config --list-all | grep -E "(zlib|bzip2)"
```

### Detailed Build Process
```bash
# 1. Environment preparation
export CC=clang
export CXX=clang++
export CFLAGS="-O3 -march=native"
export CXXFLAGS="-O3 -march=native"

# 2. Configure for production
mkdir -p build/production
cd build/production
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DRES_CONFIG_DISABLE_WERROR=ON \
    -DRES_CONFIG_DISABLE_GITREV=OFF

# 3. Build with maximum optimization
make -j$(nproc) VERBOSE=1

# 4. Run tests
ctest --output-on-failure

# 5. Install
sudo make install
```

### Custom Build Options
```bash
# Debug build
cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DUSE_STRICT_DEFAULTS=ON

# Static build (no dependencies)
cmake ../.. -DBUILD_SHARED_LIBS=OFF -DCMAKE_EXE_LINKER_FLAGS="-static"

# Cross-compile for Windows (from Linux)
cmake ../.. -DCMAKE_TOOLCHAIN_FILE=mingw-w64.cmake
```

## 🌐 Platform-Specific Notes

### Windows
```cmd
REM Compression for Windows PE
resize.exe --best --compress-resources=0 MyApp.exe

REM Compression with backup
resize.exe -k MyApp.exe

REM Handle overlay data (default is copy)
resize.exe --overlay=copy MyApp.exe
```

### Linux
```bash
# Preserve build ID (for debugging)
resize --preserve-build-id ./myapp

# Compress ELF executable
resize --best ./myapp

# Handle SIGSEGV for debugging
resize --catch-sigsegv ./myapp
```

### macOS
```bash
# Compress macOS Mach-O binary (use general options)
resize --best ./MyApp

# Compression with backup
resize -k ./MyApp

# For application bundle
resize --best ./MyApp.app/Contents/MacOS/MyApp

# Note: No macOS-specific options, use general options
```

## 🔄 Integration with Build Systems

### Makefile Integration
```makefile
# Add to Makefile
compress: $(TARGET)
        @echo "Compressing executable..."
        resize --best -k $(TARGET)
        @echo "Compression complete."

.PHONY: compress
```

### CMake Integration
```cmake
# Add custom target
add_custom_target(compress
    COMMAND resize --best -k $<TARGET_FILE:myapp>
    DEPENDS myapp
    COMMENT "Compressing executable"
)
```

### GitHub Actions
```yaml
# .github/workflows/build.yml
- name: Compress executables
  run: |
    chmod +x resize
    ./resize --best -k dist/*.exe
    
- name: Upload compressed artifacts
  uses: actions/upload-artifact@v3
  with:
    name: compressed-binaries
    path: dist/*.exe
```

## 📈 Monitoring and Logging

### Enable Detailed Logging
```bash
# Verbose output
resize -v app.exe

# Quiet mode
resize -q app.exe
```

### Basic Information
```bash
# List compressed file info
resize -l app.exe

# Test compressed file
resize -t app.exe
```

## 🛡️ Security Best Practices

### 1. Verification Workflow
```bash
# Always verify after compression
resize -t compressed_file.exe

# Check hash integrity
sha256sum original_file.exe > original.sha256
sha256sum compressed_file.exe > compressed.sha256
```

### 2. Backup Strategy
```bash
# Create backup during compression
resize -k app.exe

# Manual backup before compression
cp app.exe app.exe.backup
resize app.exe
```

### 3. Safe Batch Processing
```bash
#!/bin/bash
# Safe batch compression script
for file in *.exe; do
    if [ -f "$file" ]; then
        echo "Processing $file..."
        
        # Create backup
        cp "$file" "$file.backup"
        
        # Compress
        if resize --best "$file"; then
            echo "✓ Successfully compressed $file"
            
            # Verify
            if resize -t "$file"; then
                echo "✓ Verification passed"
            else
                echo "✗ Verification failed, restoring backup"
                mv "$file.backup" "$file"
            fi
        else
            echo "✗ Compression failed for $file"
            mv "$file.backup" "$file"
        fi
    fi
done
```

## 📞 Support and Contribution

### Getting Help
- **Built-in Help**: `resize -h` for complete help
- **Version Info**: `resize -V` for version information
- **License**: `resize -L` for license information

### Contributing
```bash
# Clone repository
git clone https://github.com/WHO-AM-I-404/RES
cd RES

# Create feature branch
git checkout -b feature/amazing-feature

# Build and test
mkdir -p build/release
cd build/release
cmake ../.. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# Test changes
ctest --output-on-failure
```

### Development Setup
```bash
# Install development dependencies
sudo apt-get install -y \
    build-essential \
    cmake \
    git \
    clang-format \
    clang-tidy \
    valgrind

# Setup pre-commit hooks
cp hooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

## 📄 License and Copyright

**Resize** is open source software based on UPX with GPL v2+ license.

```
Copyright (c) 2025 WHO-AM-I-404
Based on UPX - Ultimate Packer for eXecutables
Copyright (C) 2025 WHO-AM-I-404
Based on UPX Copyright (C) 1996-2025 Laszlo Molnar & John Reiser

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
```

## 🎖️ Acknowledgments

- **UPX Team**: For the amazing foundational technology
- **Contributors**: Everyone who has contributed to this project
- **Community**: For feedback and bug reports

---

**Made with ❤️ by WHO-AM-I-404**

*Resize - Making executables smaller, one byte at a time.*
