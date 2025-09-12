# Resize (RES) - Advanced File Compression Tool

```
    ██████  ███████ ███████ ██ ███████ ███████ 
    ██   ██ ██      ██      ██    ███  ██      
    ██████  █████   ███████ ██   ███   █████   
    ██   ██ ██           ██ ██  ███    ██      
    ██   ██ ███████ ███████ ██ ███████ ███████ 
```

**Resize** adalah alat kompresi file yang canggih, berdasarkan teknologi UPX (Ultimate Packer for eXecutables) dengan peningkatan dan rebranding lengkap. Tool ini dirancang untuk mengompres file executable dengan tingkat kompresi tinggi sambil mempertahankan fungsionalitas penuh.

---

## 🚀 Fitur Utama

- **Kompresi Tingkat Tinggi**: Mengurangi ukuran file executable hingga 50-70%
- **Self-Contained**: File yang dikompres berjalan mandiri tanpa ketergantungan eksternal
- **Multi-Platform**: Mendukung berbagai format executable (Windows PE, Linux ELF, macOS Mach-O)
- **Zero Runtime Overhead**: Tidak ada penalty performa saat runtime
- **Reversible**: Dapat dikembalikan ke ukuran asli kapan saja
- **Batch Processing**: Mendukung pemrosesan multiple file sekaligus

## 📋 Persyaratan Sistem

### Minimum Requirements:
- **OS**: Linux (64-bit), Windows 10+, macOS 10.14+
- **RAM**: 512 MB tersedia
- **Storage**: 50 MB ruang kosong
- **CPU**: Intel/AMD x64 atau ARM64

### Build Requirements (untuk kompilasi):
- **Compiler**: GCC 8+ atau Clang 5+ dengan dukungan C++17 penuh
- **CMake**: Versi 3.8 atau lebih baru
- **Make**: GNU Make 4.0+
- **Git**: Untuk cloning dependencies

## 🛠️ Instalasi

### Build dari Source
```bash
# 1. Clone repository
git clone https://github.com/who-am-i-404/resize
cd resize

# 2. Persiapkan direktori build
mkdir -p build/release
cd build/release

# 3. Configure dengan CMake
cmake ../.. -DCMAKE_BUILD_TYPE=Release

# 4. Compile
make -j$(nproc)

# 5. Install (optional)
sudo make install
```

### Developer Build
```bash
# Untuk developer yang ingin berkontribusi
mkdir -p build/debug
cd build/debug
cmake ../.. -DCMAKE_BUILD_TYPE=Debug -DUSE_STRICT_DEFAULTS=ON
make -j$(nproc)
```

## 🎯 Penggunaan Dasar

### Syntax Umum
```bash
resize [OPTIONS] [FILE(S)]
```

### Contoh Penggunaan Sederhana

#### 1. Kompresi File Tunggal
```bash
# Kompresi basic (default level)
resize myprogram.exe

# Kompresi cepat (level 1)
resize -1 myprogram.exe

# Kompresi terbaik (level 9)
resize -9 myprogram.exe

# Kompresi dengan tingkat maksimal
resize --best myprogram.exe

# Kompresi dengan algoritma brute force (paling optimal)
resize --brute myprogram.exe
```

#### 2. Kompresi Multiple Files
```bash
# Kompresi semua file .exe di direktori
resize *.exe

# Kompresi dengan pattern specific
resize program1.exe program2.exe program3.exe
```

#### 3. Decompresi (Restore)
```bash
# Kembalikan ke ukuran asli
resize -d compressed_program.exe

# Test integritas file
resize -t compressed_program.exe
```

## ⚙️ Opsi dan Parameter Lengkap

### Opsi Kompresi
| Opsi | Deskripsi | Contoh |
|------|-----------|---------|
| `-1` | Kompresi cepat (hasil kurang optimal) | `resize -1 app.exe` |
| `-9` | Kompresi level tinggi | `resize -9 app.exe` |
| `--best` | Kompresi terbaik (lambat tapi optimal) | `resize --best app.exe` |
| `--brute` | Algoritma brute force (sangat lambat, hasil terbaik) | `resize --brute app.exe` |
| `--ultra-brute` | Mode ultra kompresi (sangat lambat) | `resize --ultra-brute app.exe` |
| `--lzma` | Gunakan algoritma LZMA | `resize --lzma app.exe` |

### Opsi Output
| Opsi | Deskripsi | Contoh |
|------|-----------|---------|
| `-oFILE` | Write output to FILE | `resize -oresult.exe input.exe` |
| `-k, --backup` | Buat backup file asli | `resize -k app.exe` |
| `--no-backup` | Jangan buat backup (default) | `resize --no-backup app.exe` |
| `-f` | Force compression of suspicious files | `resize -f app.exe` |

### Opsi Informasi
| Opsi | Deskripsi | Contoh |
|------|-----------|---------|
| `-l` | Tampilkan info file yang dikompres | `resize -l app.exe` |
| `-t` | Test integritas file | `resize -t app.exe` |
| `-v` | Output detail | `resize -v app.exe` |
| `-q` | Mode silent | `resize -q app.exe` |
| `-V` | Tampilkan versi program | `resize -V` |
| `-h` | Tampilkan bantuan | `resize -h` |
| `-L` | Tampilkan lisensi | `resize -L` |

### Opsi Lanjutan
| Opsi | Deskripsi | Contoh |
|------|-----------|---------|
| `--fileinfo` | Tampilkan parameter file yang dikompres | `resize --fileinfo app.exe` |
| `--overlay=copy` | Copy overlay data (default) | `resize --overlay=copy app.exe` |
| `--overlay=strip` | Strip overlay data | `resize --overlay=strip app.exe` |
| `--overlay=skip` | Skip file dengan overlay | `resize --overlay=skip app.exe` |
| `--force-overwrite` | Force overwrite output files | `resize --force-overwrite app.exe` |
| `--no-color` | Disable color output | `resize --no-color app.exe` |
| `--mono` | Monochrome output | `resize --mono app.exe` |
| `--color` | Enable color output | `resize --color app.exe` |
| `--no-progress` | Disable progress display | `resize --no-progress app.exe` |

### Opsi Windows PE
| Opsi | Deskripsi | Contoh |
|------|-----------|---------|
| `--compress-exports=0` | Jangan kompres export section | `resize --compress-exports=0 app.exe` |
| `--compress-exports=1` | Kompres export section (default) | `resize --compress-exports=1 app.exe` |
| `--compress-icons=0` | Jangan kompres icons | `resize --compress-icons=0 app.exe` |
| `--compress-icons=1` | Kompres kecuali first icon | `resize --compress-icons=1 app.exe` |
| `--compress-icons=2` | Kompres kecuali first icon directory (default) | `resize --compress-icons=2 app.exe` |
| `--compress-icons=3` | Kompres semua icons | `resize --compress-icons=3 app.exe` |
| `--compress-resources=0` | Jangan kompres resources | `resize --compress-resources=0 app.exe` |
| `--keep-resource=list` | Jangan kompres resource tertentu | `resize --keep-resource=list app.exe` |
| `--strip-relocs=0` | Jangan strip relocations | `resize --strip-relocs=0 app.exe` |
| `--strip-relocs=1` | Strip relocations (default) | `resize --strip-relocs=1 app.exe` |

### Opsi Linux ELF
| Opsi | Deskripsi | Contoh |
|------|-----------|---------|
| `--preserve-build-id` | Copy .gnu.note.build-id ke output | `resize --preserve-build-id app` |
| `--catch-sigsegv` | Debug errors di hardware/decompressor | `resize --catch-sigsegv app` |

## 📚 Panduan Penggunaan Detail

### 🔧 Skenario Penggunaan Umum

#### 1. Mengompres Aplikasi Desktop
```bash
# Untuk aplikasi Windows
resize --best -k MyApp.exe

# Untuk aplikasi Linux
resize --best -k ./myapp

# Untuk aplikasi macOS
resize --best -k MyApp.app/Contents/MacOS/MyApp
```

#### 2. Optimasi untuk Distribusi
```bash
# Kompresi untuk distribusi online (prioritas ukuran)
resize --brute --compress-icons=3 --compress-exports=1 installer.exe

# Kompresi untuk distribusi offline (balanced)
resize --best -k setup.exe
```

#### 3. Batch Processing untuk Developer
```bash
# Kompresi semua executable dalam project
find . -name "*.exe" -exec resize --best {} \;

# Kompresi dengan filter size minimum
find . -name "*.exe" -size +1M -exec resize --brute {} \;
```

#### 4. CI/CD Integration
```bash
# Script untuk pipeline
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

# Gunakan algoritma LZMA
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
# Test file setelah kompresi
resize --best app.exe && resize -t app.exe

# Preserve overlay data (default)
resize --overlay=copy app.exe
```

## 📊 Performance dan Statistik

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

### Error Messages dan Solusi

#### "Cannot pack: file is already packed"
```bash
# File sudah dikompres, decompress dulu
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
# Jika kompresi gagal dan file rusak
cp app.exe.backup app.exe       # Restore from backup

# Test file integrity
resize -t app.exe              # Verify compressed file
```

## 🧪 Testing dan Verification

### Pre-compression Checks
```bash
# Verify file sebelum kompresi
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

## 🔧 Build dari Source Code

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
# 1. Persiapan environment
export CC=clang
export CXX=clang++
export CFLAGS="-O3 -march=native"
export CXXFLAGS="-O3 -march=native"

# 2. Configure untuk production
mkdir -p build/production
cd build/production
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DRES_CONFIG_DISABLE_WERROR=ON \
    -DRES_CONFIG_DISABLE_GITREV=OFF

# 3. Build dengan optimasi maksimal
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

# Cross-compile untuk Windows (dari Linux)
cmake ../.. -DCMAKE_TOOLCHAIN_FILE=mingw-w64.cmake
```

## 🌐 Platform-Specific Notes

### Windows
```cmd
REM Kompresi untuk Windows PE
resize.exe --best --compress-resources=0 MyApp.exe

REM Kompresi dengan backup
resize.exe -k MyApp.exe

REM Handle overlay data (default adalah copy)
resize.exe --overlay=copy MyApp.exe
```

### Linux
```bash
# Preserve build ID (untuk debugging)
resize --preserve-build-id ./myapp

# Kompresi ELF executable
resize --best ./myapp

# Handle SIGSEGV untuk debugging
resize --catch-sigsegv ./myapp
```

### macOS
```bash
# Kompresi macOS Mach-O binary (gunakan opsi umum)
resize --best ./MyApp

# Kompresi dengan backup
resize -k ./MyApp

# Untuk aplikasi bundle
resize --best ./MyApp.app/Contents/MacOS/MyApp

# Note: Tidak ada opsi khusus macOS, gunakan opsi umum
```

## 🔄 Integration dengan Build Systems

### Makefile Integration
```makefile
# Tambahkan ke Makefile
compress: $(TARGET)
        @echo "Compressing executable..."
        resize --best -k $(TARGET)
        @echo "Compression complete."

.PHONY: compress
```

### CMake Integration
```cmake
# Tambahkan custom target
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

## 📈 Monitoring dan Logging

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
# Always verify setelah kompresi
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

## 📞 Support dan Kontribusi

### Mendapatkan Bantuan
- **Built-in Help**: `resize -h` untuk bantuan lengkap
- **Version Info**: `resize -V` untuk informasi versi
- **License**: `resize -L` untuk informasi lisensi

### Berkontribusi
```bash
# Clone repository
git clone https://github.com/who-am-i-404/resize
cd resize

# Create feature branch
git checkout -b feature/amazing-feature

# Build dan test
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

## 📄 License dan Copyright

**Resize** adalah software open source berdasarkan UPX dengan lisensi GPL v2+.

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

- **UPX Team**: Untuk teknologi dasar yang luar biasa
- **Contributors**: Semua yang telah berkontribusi pada proyek ini
- **Community**: Untuk feedback dan bug reports

---

**Made with ❤️ by WHO-AM-I-404**

*Resize - Making executables smaller, one byte at a time.*