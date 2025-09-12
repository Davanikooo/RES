# 📖 Panduan Penggunaan Lengkap Resize

## Daftar Isi
1. [Quick Start](#quick-start)
2. [Instalasi Detail](#instalasi-detail)
3. [Command Line Interface](#command-line-interface)
4. [Skenario Penggunaan](#skenario-penggunaan)
5. [Troubleshooting](#troubleshooting)
6. [Best Practices](#best-practices)
7. [Advanced Features](#advanced-features)

## Quick Start

### Langkah 1: Verifikasi Instalasi
```bash
# Check apakah resize sudah terinstall
which resize

# Tampilkan versi
resize -V

# Tampilkan help
resize -h
```

### Langkah 2: Kompresi Pertama
```bash
# Siapkan file test
cp /bin/ls test_program

# Kompresi basic
resize test_program

# Check hasil
ls -la test_program*
```

### Langkah 3: Verifikasi Hasil
```bash
# Test file yang dikompres
./test_program

# Decompresi jika perlu
resize -d test_program
```

## Instalasi Detail

### Prerequisites
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y build-essential cmake git

# CentOS/RHEL/Fedora
sudo yum groupinstall "Development Tools"
sudo yum install cmake git

# macOS (dengan Homebrew)
brew install cmake git

# Windows (dengan MinGW-w64)
# Install MSYS2 dari https://www.msys2.org/
pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-cmake
```

### Build dari Source - Langkah Demi Langkah

#### Step 1: Download Source Code
```bash
# Clone repository
git clone https://github.com/who-am-i-404/resize
cd resize

# Check struktur project
ls -la
```

#### Step 2: Persiapan Dependencies
```bash
# Check vendor dependencies
ls -la vendor/

# Jika kosong, init submodules
git submodule update --init --recursive
```

#### Step 3: Configure Build
```bash
# Buat direktori build
mkdir -p build/release
cd build/release

# Configure untuk release build
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DRES_CONFIG_DISABLE_WERROR=ON

# Untuk debug build (optional)
mkdir -p ../debug
cd ../debug
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DUSE_STRICT_DEFAULTS=ON
```

#### Step 4: Kompilasi
```bash
# Build (gunakan semua CPU cores)
make -j$(nproc)

# Atau dengan verbose output
make -j$(nproc) VERBOSE=1

# Check hasil build
ls -la resize
file resize
```

#### Step 5: Testing
```bash
# Basic test
./resize -V
./resize -h

# Advanced testing
ctest --output-on-failure

# Manual test
./resize /bin/echo
./echo "Hello World"
```

#### Step 6: Installation
```bash
# Install system-wide (optional)
sudo make install

# Atau copy manual
sudo cp resize /usr/local/bin/
sudo chmod +x /usr/local/bin/resize

# Verify installation
which resize
resize -V
```

## Command Line Interface

### Syntax Lengkap
```
resize [-123456789dlthVL] [-qvfk] [-oFILE] file..
```

### Global Options

#### Basic Options
```bash
-v                   # Tampilkan output detail
-q                   # Mode silent (minimal output)
-f                   # Force compression of suspicious files
-V                   # Tampilkan versi program
-h                   # Tampilkan bantuan
-L                   # Tampilkan informasi lisensi
```

#### Advanced Options
```bash
--lzma               # Gunakan algoritma LZMA
--brute              # Brute force compression
--ultra-brute        # Ultra brute force (sangat lambat)
--overlay=copy       # Handle overlay data (copy/strip/skip)
```

### Commands (Perintah Utama)
```bash
# Kompresi (default)
resize myapp.exe
resize -9 myapp.exe              # Level 9 compression
resize --best myapp.exe          # Best compression
resize --brute myapp.exe         # Try all methods (slow)
resize --ultra-brute myapp.exe   # Even more variants (very slow)

# Decompresi
resize -d compressed_app.exe

# Testing dan Info
resize -t compressed_app.exe     # Test compressed file
resize -l compressed_app.exe     # List compressed file info
resize --fileinfo compressed_app.exe  # Show parameters

# Output ke file lain
resize -ooutput.exe input.exe
```

### Compression Options

#### Level Kompresi
```bash
-1                   # Fastest compression (level 1)
-9                   # High compression (level 9)
--best               # Best compression
--brute              # Brute force (very slow, best result)
--ultra-brute        # Ultra compression (extremely slow)

# Manual level (1-9)
-5                   # Level 5 compression
```

#### Algorithm Options
```bash
--lzma               # Use LZMA algorithm (best)
# Note: NRV methods are built-in, no separate flags needed
```

#### Platform-Specific Options
```bash
# Windows PE
--compress-exports=0     # Don't compress export section
--compress-exports=1     # Compress export section [default]
--compress-icons=0       # Don't compress any icons  
--compress-icons=1       # Compress all but first icon
--compress-icons=2       # Compress all but first icon directory [default]
--compress-icons=3       # Compress all icons
--compress-resources=0   # Don't compress any resources
--keep-resource=list     # Don't compress specified resources
--strip-relocs=0         # Don't strip relocations
--strip-relocs=1         # Strip relocations [default]

# Linux ELF
--preserve-build-id      # Copy .gnu.note.build-id to output
--catch-sigsegv          # Debug hardware/decompressor errors

# Note: No specific macOS options - use general options
```

### Output Options

#### File Handling
```bash
-oFILE                  # Write output to FILE (no space between -o and filename)
-k, --backup            # Keep backup files  
--no-backup             # No backup files [default]
-f                      # Force compression of suspicious files
--force-overwrite       # Force overwrite of output files
```

#### Notes
```bash
# Additional display options
--no-color              # Disable color output
--mono                  # Monochrome output  
--color                 # Enable color output
--no-progress           # Disable progress display
```

## Skenario Penggunaan

### 1. Developer Workflow

#### Kompresi Build Artifacts
```bash
#!/bin/bash
# build_and_compress.sh

# Build project
make clean && make release

# Compress all executables
echo "Compressing executables..."
for exe in bin/*.exe bin/*; do
    if [ -x "$exe" ] && [ ! -d "$exe" ]; then
        echo "Compressing $exe..."
        resize --best -k "$exe"
        
        # Show compression ratio
        original_size=$(stat -f%z "$exe.backup" 2>/dev/null || stat -c%s "$exe.backup")
        compressed_size=$(stat -f%z "$exe" 2>/dev/null || stat -c%s "$exe")
        ratio=$(echo "scale=2; (1 - $compressed_size/$original_size) * 100" | bc)
        echo "  Compression: ${ratio}%"
    fi
done

echo "Compression complete!"
```

#### Testing Compressed Executables
```bash
#!/bin/bash
# test_compressed.sh

failed=0

for exe in bin/*; do
    if [ -x "$exe" ] && [ ! -d "$exe" ]; then
        echo "Testing $exe..."
        
        # Test integrity
        if ! resize -t "$exe"; then
            echo "❌ Integrity test failed for $exe"
            failed=1
            continue
        fi
        
        # Test execution (jika ada --version flag)
        if $exe --version >/dev/null 2>&1; then
            echo "✅ $exe works correctly"
        else
            echo "⚠️  $exe may have issues (no --version support)"
        fi
    fi
done

if [ $failed -eq 1 ]; then
    echo "Some tests failed!"
    exit 1
else
    echo "All tests passed!"
fi
```

### 2. CI/CD Integration

#### GitHub Actions
```yaml
# .github/workflows/build-and-compress.yml
name: Build and Compress

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y build-essential cmake
    
    - name: Build Resize
      run: |
        mkdir -p build/release
        cd build/release
        cmake ../.. -DCMAKE_BUILD_TYPE=Release
        make -j$(nproc)
    
    - name: Build sample project
      run: |
        # Your project build commands here
        make clean && make release
    
    - name: Compress executables
      run: |
        cd build/release
        
        # Compress project executables
        for exe in ../../bin/*; do
          if [ -x "$exe" ] && [ ! -d "$exe" ]; then
            echo "Compressing $exe..."
            ./resize --best  "$exe"
          fi
        done
    
    - name: Test compressed executables
      run: |
        cd build/release
        
        for exe in ../../bin/*; do
          if [ -x "$exe" ] && [ ! -d "$exe" ]; then
            echo "Testing $exe..."
            ./resize -t "$exe"
          fi
        done
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v3
      with:
        name: compressed-binaries
        path: bin/*
```

#### Jenkins Pipeline
```groovy
// Jenkinsfile
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh '''
                    mkdir -p build/release
                    cd build/release
                    cmake ../.. -DCMAKE_BUILD_TYPE=Release
                    make -j$(nproc)
                '''
            }
        }
        
        stage('Compress') {
            steps {
                sh '''
                    cd build/release
                    
                    # Find and compress all executables
                    find ../../ -type f -executable -not -path "*/.*" | while read exe; do
                        if file "$exe" | grep -q "executable"; then
                            echo "Compressing $exe..."
                            ./resize --best -k "$exe"
                        fi
                    done
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    cd build/release
                    
                    # Test all compressed files
                    find ../../ -type f -executable -not -path "*/.*" | while read exe; do
                        if file "$exe" | grep -q "executable"; then
                            echo "Testing $exe..."
                            ./resize -t "$exe"
                        fi
                    done
                '''
            }
        }
        
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: '**/bin/**', fingerprint: true
            }
        }
    }
    
    post {
        always {
            publishTestResults testResultsPattern: 'test-results.xml'
        }
    }
}
```

### 3. Batch Processing

#### Mass Compression Script
```bash
#!/bin/bash
# mass_compress.sh

# Configuration
COMPRESSION_LEVEL="--best"
BACKUP_DIR="./backups"
LOG_FILE="compression.log"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --level)
            COMPRESSION_LEVEL="$2"
            shift 2
            ;;
        --backup-dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        --log)
            LOG_FILE="$2"
            shift 2
            ;;
        *)
            SEARCH_PATH="$1"
            shift
            ;;
    esac
done

# Validate inputs
if [ -z "$SEARCH_PATH" ]; then
    echo "Usage: $0 [OPTIONS] <search_path>"
    echo "Options:"
    echo "  --dry-run          Show what would be compressed"
    echo "  --level LEVEL      Compression level (--fast, --best, --brute)"
    echo "  --backup-dir DIR   Backup directory"
    echo "  --log FILE         Log file"
    exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Initialize log
echo "=== Compression Session Started: $(date) ===" >> "$LOG_FILE"

# Find executable files
echo "Scanning for executable files in $SEARCH_PATH..."
files_found=0
files_compressed=0
total_original_size=0
total_compressed_size=0

find "$SEARCH_PATH" -type f -executable -not -path "*/.*" | while read file; do
    # Skip if already compressed
    if resize -t "$file" 2>/dev/null; then
        echo "Skipping $file (already compressed)"
        continue
    fi
    
    files_found=$((files_found + 1))
    
    # Get original size
    original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    total_original_size=$((total_original_size + original_size))
    
    if [ "$DRY_RUN" = true ]; then
        echo "Would compress: $file ($(numfmt --to=iec $original_size))"
        continue
    fi
    
    echo "Compressing $file ($(numfmt --to=iec $original_size))..."
    
    # Create backup
    backup_file="$BACKUP_DIR/$(basename "$file").backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup_file"
    
    # Compress
    if resize $COMPRESSION_LEVEL  "$file" 2>&1 | tee -a "$LOG_FILE"; then
        files_compressed=$((files_compressed + 1))
        
        # Get compressed size
        compressed_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
        total_compressed_size=$((total_compressed_size + compressed_size))
        
        # Calculate ratio
        ratio=$(echo "scale=2; (1 - $compressed_size/$original_size) * 100" | bc)
        
        echo "✅ Success: $file"
        echo "   Original: $(numfmt --to=iec $original_size)"
        echo "   Compressed: $(numfmt --to=iec $compressed_size)"
        echo "   Saved: ${ratio}%"
        echo ""
        
        # Log success
        echo "SUCCESS: $file - Ratio: ${ratio}%" >> "$LOG_FILE"
    else
        echo "❌ Failed: $file"
        
        # Restore from backup
        cp "$backup_file" "$file"
        
        # Log failure
        echo "FAILED: $file" >> "$LOG_FILE"
    fi
done

# Summary
echo "=== Compression Summary ==="
echo "Files found: $files_found"
echo "Files compressed: $files_compressed"

if [ $files_compressed -gt 0 ]; then
    overall_ratio=$(echo "scale=2; (1 - $total_compressed_size/$total_original_size) * 100" | bc)
    echo "Total original size: $(numfmt --to=iec $total_original_size)"
    echo "Total compressed size: $(numfmt --to=iec $total_compressed_size)"
    echo "Overall compression: ${overall_ratio}%"
fi

echo "=== Session Completed: $(date) ===" >> "$LOG_FILE"
```

### 4. Integration dengan Package Managers

#### RPM Spec Integration
```spec
# example.spec
Name:           myapp
Version:        1.0.0
Release:        1%{?dist}
Summary:        My Application

%description
My application with compressed binaries

%prep
%setup -q

%build
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

# Compress executables
find $RPM_BUILD_ROOT%{_bindir} -type f -executable | while read exe; do
    resize --best "$exe"
done

%files
%{_bindir}/*

%changelog
* Wed Sep 12 2025 Developer <dev@example.com> - 1.0.0-1
- Initial package with compressed binaries
```

#### Debian Package Integration
```bash
# debian/rules
#!/usr/bin/make -f

%:
        dh $@

override_dh_auto_install:
        dh_auto_install
        
        # Compress binaries
        find debian/myapp/usr/bin -type f -executable | while read exe; do \
                resize --best "$$exe"; \
        done

override_dh_strip:
        # Skip stripping untuk compressed binaries
        dh_strip --exclude=usr/bin/
```

## Troubleshooting

### Common Issues dan Solutions

#### 1. "Command not found: resize"
```bash
# Check installation
which resize

# If not found, check PATH
echo $PATH

# Add to PATH jika perlu
export PATH="/usr/local/bin:$PATH"

# Atau install ulang
sudo make install
```

#### 2. "Permission denied"
```bash
# Check file permissions
ls -la resize

# Fix permissions
chmod +x resize

# Atau untuk system installation
sudo chmod +x /usr/local/bin/resize
```

#### 3. "Cannot pack: file format not supported"
```bash
# Check file format
file myapp.exe

# Supported formats: PE, ELF, Mach-O
# If unsupported, convert atau gunakan tools lain
```

#### 4. "Cannot pack: already packed"
```bash
# File sudah dikompres, decompress dulu
resize -d myapp.exe

# Lalu compress ulang jika perlu
resize --best myapp.exe
```

#### 5. "Out of memory"
```bash
# Reduce memory usage
# Use faster compression method
resize -1 myapp.exe

# Check available memory
free -h
```

#### 6. Build Errors

##### CMake Configuration Errors
```bash
# Error: CMake version too old
# Solution: Update CMake
sudo apt update && sudo apt install cmake

# Error: Compiler not found
# Solution: Install build tools
sudo apt install build-essential

# Error: Missing dependencies
# Solution: Install development packages
sudo apt install zlib1g-dev libbz2-dev
```

##### Compilation Errors
```bash
# Error: C++17 not supported
# Solution: Update compiler
sudo apt install gcc-8 g++-8
export CC=gcc-8 CXX=g++-8

# Error: Missing headers
# Solution: Install dev packages
sudo apt install libc6-dev linux-libc-dev

# Error: Linking failed
# Solution: Check library paths
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
```

### Debug Mode

#### Enable Debug Output
```bash
# Verbose output
# Verbose output
resize -v myapp.exe

# Analyze log
grep -i error debug.log
grep -i warning debug.log
```

#### Debugging Build Issues
```bash
# Clean build
rm -rf build
mkdir -p build/debug
cd build/debug

# Debug build dengan verbose
cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_VERBOSE_MAKEFILE=ON
make VERBOSE=1

# Run dengan debugger
gdb ./resize
(gdb) run --test /bin/ls
```

### Performance Issues

#### Slow Compression
```bash
# Use faster method
resize --fast myapp.exe

# Limit memory usage
# Use appropriate compression level for your system
resize --best myapp.exe

# Check system resources
top
iostat 1
```

#### Large Files
```bash
# For very large files
resize --best large_app.exe

# Split compression untuk file sangat besar
split -b 100M large_app.exe large_app_part_
for part in large_app_part_*; do
    resize --best "$part"
done
```

## Best Practices

### 1. Pre-Compression Checklist
```bash
# ✅ Backup original file
cp myapp.exe myapp.exe.backup

# ✅ Check file format
file myapp.exe

# ✅ Test original file works
./myapp.exe --version

# ✅ Check file size (apakah worth it untuk dikompresi)
du -h myapp.exe

# ✅ Check available space
df -h .
```

### 2. Compression Strategy
```bash
# Untuk distribusi: prioritas size
resize --brute --compress-exports=1 myapp.exe

# Untuk development: prioritas speed
resize --fast myapp.exe

# Untuk production: balanced
resize --best myapp.exe

# Untuk archival: maximum compression
resize --ultra-brute myapp.exe
```

### 3. Post-Compression Validation
```bash
# ✅ Test compressed file
resize -t myapp.exe

# ✅ Test functionality
./myapp.exe --version
./myapp.exe --help

# ✅ Performance test
time ./myapp.exe benchmark

# ✅ Compare with original
./myapp.exe.backup --version
./myapp.exe --version
```

### 4. Backup Management
```bash
# Organized backup structure
mkdir -p backups/$(date +%Y%m%d)
cp *.exe.backup backups/$(date +%Y%m%d)/

# Cleanup old backups (keep 30 days)
find backups/ -type f -mtime +30 -delete

# Compress backup files
tar -czf backups_$(date +%Y%m%d).tar.gz backups/$(date +%Y%m%d)/
```

### 5. Automation Scripts

#### Daily Compression Script
```bash
#!/bin/bash
# daily_compress.sh

PROJECTS_DIR="/home/user/projects"
LOG_FILE="/var/log/daily_compress.log"

echo "=== Daily Compression: $(date) ===" >> "$LOG_FILE"

# Find projects yang perlu dikompres
find "$PROJECTS_DIR" -name "*.exe" -o -name "bin/*" -executable | while read file; do
    # Skip jika sudah dikompres
    if resize -t "$file" 2>/dev/null; then
        continue
    fi
    
    # Skip file kecil (< 1MB)
    size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    if [ $size -lt 1048576 ]; then
        continue
    fi
    
    echo "Compressing $file..." >> "$LOG_FILE"
    
    if resize --best --backup "$file" >> "$LOG_FILE" 2>&1; then
        echo "Success: $file" >> "$LOG_FILE"
    else
        echo "Failed: $file" >> "$LOG_FILE"
    fi
done

echo "=== Completed: $(date) ===" >> "$LOG_FILE"
```

#### Continuous Integration Helper
```bash
#!/bin/bash
# ci_compress.sh

# Exit on any error
set -e

echo "🔄 Starting CI compression process..."

# Validate environment
if ! command -v resize >/dev/null 2>&1; then
    echo "❌ resize not found in PATH"
    exit 1
fi

# Find build artifacts
BUILD_DIR="${BUILD_DIR:-./build}"
ARTIFACTS=$(find "$BUILD_DIR" -type f -executable -not -path "*/test/*")

if [ -z "$ARTIFACTS" ]; then
    echo "⚠️  No executable artifacts found in $BUILD_DIR"
    exit 0
fi

echo "📦 Found $(echo "$ARTIFACTS" | wc -l) executable(s) to compress"

# Compress each artifact
for artifact in $ARTIFACTS; do
    echo "🔸 Processing $artifact..."
    
    # Get size before
    size_before=$(stat -f%z "$artifact" 2>/dev/null || stat -c%s "$artifact")
    
    # Compress
    if resize --best  "$artifact"; then
        size_after=$(stat -f%z "$artifact" 2>/dev/null || stat -c%s "$artifact")
        ratio=$(echo "scale=1; (1 - $size_after/$size_before) * 100" | bc)
        
        echo "✅ $artifact compressed by ${ratio}%"
        
        # Verify
        if ! resize -t "$artifact"; then
            echo "❌ Verification failed for $artifact"
            exit 1
        fi
    else
        echo "❌ Failed to compress $artifact"
        exit 1
    fi
done

echo "🎉 All artifacts compressed successfully!"
```

## Advanced Features

### 1. Custom Configuration Files

#### Configuration Format
```ini
# ~/.resizerc
[compression]
default_level = best
backup = true
verify_after = true
progress = true

[output]
log_level = info
stats = true
quiet = false

[memory]
limit = 512m
temp_dir = /tmp

[advanced]
preserve_timestamps = true
preserve_permissions = true
parallel_processing = true
```

#### Standard Usage
```bash
# Standard compression
resize myapp.exe

# Best compression
resize --best myapp.exe
```

### 2. Plugin System (Future Feature)

#### Plugin Directory Structure
```
~/.resize/plugins/
├── compression/
│   ├── super_lzma.so
│   └── quantum_compress.so
├── filters/
│   ├── custom_filter.so
│   └── optimization.so
└── hooks/
    ├── pre_compress.sh
    └── post_compress.sh
```

#### Plugin Usage
```bash
# List available plugins
resize --list-plugins

# Use specific compression plugin
resize --plugin=super_lzma myapp.exe

# Enable preprocessing filter
resize --filter=optimization myapp.exe
```

### 3. Remote Compression Service

#### Client Mode
```bash
# Compress menggunakan remote server
resize --remote=compression.example.com:8080 myapp.exe

# Dengan authentication
resize --remote=user:pass@compression.example.com:8080 myapp.exe

# Batch remote compression
resize --remote=compression.example.com:8080 --batch *.exe
```

#### Server Mode
```bash
# Start compression server
resize --server --port=8080 --max-clients=10

# With SSL
resize --server --port=8443 --ssl-cert=cert.pem --ssl-key=key.pem
```

### 4. Integration APIs

#### Python Integration
```python
import resize

# Compress file
result = resize.compress('myapp.exe', level='best')
print(f"Compression ratio: {result.ratio}%")

# Batch compression
files = ['app1.exe', 'app2.exe', 'app3.exe']
results = resize.compress_batch(files, level='best', parallel=True)

for file, result in results.items():
    print(f"{file}: {result.ratio}% compression")
```

#### REST API
```bash
# Start API server
resize --api-server --port=8080

# Compress via API
curl -X POST http://localhost:8080/compress \
     -F "file=@myapp.exe" \
     -F "level=best" \
     -o compressed_app.exe

# Get compression stats
curl http://localhost:8080/stats/myapp.exe
```

---

*Dokumentasi ini akan terus diperbarui seiring dengan pengembangan fitur-fitur baru Resize.*