# 🚀 Panduan Instalasi Resize

## Daftar Isi
1. [Quick Install](#quick-install)
2. [System Requirements](#system-requirements)
3. [Build dari Source](#build-dari-source)
4. [Platform-Specific Instructions](#platform-specific-instructions)
5. [Post-Installation](#post-installation)
6. [Troubleshooting](#troubleshooting)

## Instalasi

### Build dari Source (Satu-satunya Metode)
```bash
# Clone repository
git clone https://github.com/who-am-i-404/resize
cd resize

# Build menggunakan CMake
mkdir -p build/release
cd build/release
cmake ../.. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# Install (optional)
sudo make install
```

**Note**: Saat ini tidak ada package manager support, pre-built binaries, atau install script. Satu-satunya cara untuk menggunakan resize adalah dengan build dari source code.

## System Requirements

### Minimum Requirements
| Component | Requirement |
|-----------|-------------|
| OS | Linux (64-bit), Windows 10+, macOS 10.14+ |
| RAM | 512 MB available |
| Storage | 50 MB free space |
| CPU | Intel/AMD x64 atau ARM64 |

### Recommended Requirements
| Component | Recommendation |
|-----------|----------------|
| RAM | 2 GB atau lebih |
| Storage | 200 MB free space |
| CPU | Multi-core processor |

### Build Requirements
| Component | Version |
|-----------|---------|
| GCC | 8.0+ |
| Clang | 5.0+ |
| CMake | 3.8+ |
| Make | 4.0+ |
| Git | 2.0+ |

## Build dari Source

### Step 1: Install Dependencies

#### Ubuntu/Debian
```bash
# Update package list
sudo apt update

# Install build essentials
sudo apt install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    zlib1g-dev \
    libbz2-dev \
    libzstd-dev

# Optional: install additional tools
sudo apt install -y \
    clang \
    clang-format \
    clang-tidy \
    valgrind
```

#### CentOS/RHEL/Fedora
```bash
# For CentOS/RHEL 8+
sudo dnf groupinstall "Development Tools"
sudo dnf install cmake git pkgconfig zlib-devel bzip2-devel libzstd-devel

# For older CentOS/RHEL
sudo yum groupinstall "Development Tools"
sudo yum install cmake git pkgconfig zlib-devel bzip2-devel

# Enable EPEL untuk packages tambahan
sudo dnf install epel-release  # CentOS 8+
sudo yum install epel-release  # CentOS 7
```

#### Fedora
```bash
sudo dnf install \
    gcc-c++ \
    cmake \
    git \
    pkgconfig \
    zlib-devel \
    bzip2-devel \
    libzstd-devel \
    clang \
    clang-tools-extra
```

#### openSUSE
```bash
sudo zypper install \
    gcc-c++ \
    cmake \
    git \
    pkg-config \
    zlib-devel \
    libbz2-devel \
    libzstd-devel
```

#### Arch Linux
```bash
sudo pacman -S \
    base-devel \
    cmake \
    git \
    pkgconfig \
    zlib \
    bzip2 \
    zstd
```

#### Alpine Linux
```bash
sudo apk add \
    build-base \
    cmake \
    git \
    pkgconfig \
    zlib-dev \
    bzip2-dev \
    zstd-dev
```

#### macOS
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install cmake git pkg-config zlib bzip2 zstd

# Optional: install additional tools
brew install clang-format
```

### Step 2: Clone Repository
```bash
# Clone repository
git clone https://github.com/who-am-i-404/resize
cd resize

# Check repository structure
ls -la

# Verify vendor dependencies
ls -la vendor/
```

### Step 3: Configure Build Environment

#### Set Compiler (Optional)
```bash
# Use GCC
export CC=gcc
export CXX=g++

# Or use Clang (recommended)
export CC=clang
export CXX=clang++

# For cross-compilation (example: ARM64)
export CC=aarch64-linux-gnu-gcc
export CXX=aarch64-linux-gnu-g++
```

#### Set Build Flags (Optional)
```bash
# Optimization flags
export CFLAGS="-O3 -march=native -mtune=native"
export CXXFLAGS="-O3 -march=native -mtune=native"

# Debug flags (untuk development)
export CFLAGS="-O0 -g3 -fsanitize=address"
export CXXFLAGS="-O0 -g3 -fsanitize=address"
```

### Step 4: Configure dengan CMake

#### Release Build (Production)
```bash
mkdir -p build/release
cd build/release

cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DRES_CONFIG_DISABLE_WERROR=ON \
    -DRES_CONFIG_DISABLE_GITREV=OFF
```

#### Debug Build (Development)
```bash
mkdir -p build/debug
cd build/debug

cmake ../.. \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DUSE_STRICT_DEFAULTS=ON \
    -DRES_CONFIG_DISABLE_WERROR=OFF
```

#### Custom Configuration
```bash
# Static build (no shared libraries)
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_EXE_LINKER_FLAGS="-static"

# Cross-compile untuk Windows dari Linux
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=../cmake/mingw-w64.cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local/cross-tools/

# Dengan custom prefix
cmake ../.. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$HOME/.local
```

### Step 5: Build

#### Standard Build
```bash
# Build dengan semua CPU cores
make -j$(nproc)

# Untuk macOS
make -j$(sysctl -n hw.ncpu)

# Manual (single thread)
make

# Dengan verbose output
make VERBOSE=1
```

#### Advanced Build Options
```bash
# Build specific target
make resize

# Build dengan timing info
time make -j$(nproc)

# Build dengan progress
make -j$(nproc) --progress=short

# Clean build
make clean && make -j$(nproc)
```

### Step 6: Test Build

#### Basic Tests
```bash
# Test binary exists dan executable
ls -la resize
file resize

# Test basic functionality
./resize -V
./resize -h

# Test dengan file kecil
echo "test" > test.txt
./resize test.txt
./resize -d test.txt
```

#### Comprehensive Tests
```bash
# Run test suite
ctest --output-on-failure

# Run specific tests
ctest -R resize-version

# Run tests dengan verbose
ctest --output-on-failure --verbose

# Run tests paralel
ctest -j$(nproc)
```

#### Manual Testing
```bash
# Test compression/decompression cycle
cp /bin/ls test_binary
./resize --best test_binary
./test_binary --help
./resize -d test_binary
./test_binary --help

# Performance test
time ./resize --brute /bin/bash

# Memory test (jika valgrind installed)
valgrind --leak-check=full ./resize -t /bin/ls
```

### Step 7: Install

#### System-wide Installation
```bash
# Install to /usr/local (requires sudo)
sudo make install

# Verify installation
which resize
resize -V
```

#### User-specific Installation
```bash
# Install to home directory
cmake ../.. -DCMAKE_INSTALL_PREFIX=$HOME/.local
make install

# Add to PATH (tambahkan ke ~/.bashrc atau ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"
```

#### Custom Installation
```bash
# Install to custom directory
INSTALL_DIR="/opt/resize"
sudo mkdir -p "$INSTALL_DIR"
sudo cmake ../.. -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR"
sudo make install

# Create symlink
sudo ln -sf "$INSTALL_DIR/bin/resize" /usr/local/bin/resize
```

## Platform-Specific Instructions

### Linux Distributions

#### Ubuntu 20.04 LTS
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y build-essential cmake git pkg-config \
    zlib1g-dev libbz2-dev libzstd-dev

# Clone dan build
git clone https://github.com/who-am-i-404/resize
cd resize
mkdir -p build/release && cd build/release
cmake ../.. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
```

#### CentOS 8 Stream
```bash
# Enable PowerTools repository
sudo dnf config-manager --set-enabled powertools

# Install dependencies
sudo dnf groupinstall "Development Tools"
sudo dnf install cmake git pkgconfig zlib-devel bzip2-devel libzstd-devel

# Build
git clone https://github.com/who-am-i-404/resize
cd resize
mkdir -p build/release && cd build/release
cmake ../.. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
```

#### Debian 11 (Bullseye)
```bash
# Install dependencies
sudo apt update
sudo apt install -y build-essential cmake git pkg-config \
    zlib1g-dev libbz2-dev libzstd-dev

# Build
git clone https://github.com/who-am-i-404/resize
cd resize
mkdir -p build/release && cd build/release
cmake ../.. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
sudo make install
```

### Windows

#### Using MSYS2/MinGW-w64
```bash
# Install MSYS2 dari https://www.msys2.org/

# Update package database
pacman -Syu

# Install build tools
pacman -S mingw-w64-x86_64-gcc \
          mingw-w64-x86_64-cmake \
          mingw-w64-x86_64-make \
          mingw-w64-x86_64-pkg-config \
          git

# Build
git clone https://github.com/who-am-i-404/resize
cd resize
mkdir -p build/release && cd build/release
cmake ../.. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
mingw32-make -j$(nproc)
```

#### Using Visual Studio
```cmd
REM Install Visual Studio Community 2019+ dengan C++ workload
REM Install CMake dari https://cmake.org/
REM Install Git dari https://git-scm.com/

REM Clone repository
git clone https://github.com/who-am-i-404/resize
cd resize

REM Configure dan build
mkdir build\release
cd build\release
cmake ..\.. -G "Visual Studio 16 2019" -A x64
cmake --build . --config Release --parallel
```

### macOS

#### Using Homebrew
```bash
# Install Homebrew dependencies
brew install cmake git pkg-config zlib bzip2 zstd

# Build
git clone https://github.com/who-am-i-404/resize
cd resize
mkdir -p build/release && cd build/release
cmake ../.. -DCMAKE_BUILD_TYPE=Release
make -j$(sysctl -n hw.ncpu)
sudo make install
```

#### Universal Binary (Intel + Apple Silicon)
```bash
# Build for both architectures
mkdir -p build/intel build/arm64

# Intel build
cd build/intel
cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=x86_64
make -j$(sysctl -n hw.ncpu)

# ARM64 build
cd ../arm64
cmake ../.. -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES=arm64
make -j$(sysctl -n hw.ncpu)

# Create universal binary
lipo -create build/intel/resize build/arm64/resize -output resize-universal
```

### Android (Cross-compile)

#### Using Android NDK
```bash
# Download Android NDK
wget https://dl.google.com/android/repository/android-ndk-r25c-linux.zip
unzip android-ndk-r25c-linux.zip
export ANDROID_NDK_HOME=$PWD/android-ndk-r25c

# Configure toolchain
mkdir -p build/android && cd build/android
cmake ../.. \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-21 \
    -DCMAKE_BUILD_TYPE=Release

# Build
make -j$(nproc)
```

## Post-Installation

### Verification
```bash
# Check installation
which resize
resize -V
resize -h

# Test basic functionality
echo "test data" > test.txt
resize test.txt
resize -d test.txt
cat test.txt
rm test.txt
```

### Shell Integration

#### Bash Completion
```bash
# Create completion script
sudo tee /etc/bash_completion.d/resize << 'EOF'
_resize_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    opts="-h -V -t -d --best --brute --ultra-brute -v -q -f -k --lzma"
    
    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
    
    COMPREPLY=( $(compgen -f -- ${cur}) )
}

complete -F _resize_completion resize
EOF

# Reload bash completion
source /etc/bash_completion.d/resize
```

#### Zsh Completion
```bash
# Create completion script
sudo mkdir -p /usr/share/zsh/vendor-completions
sudo tee /usr/share/zsh/vendor-completions/_resize << 'EOF'
#compdef resize

_resize() {
    local context state line
    
    _arguments \
        '-h[Show help]' \
        '-V[Show version]' \
        '-t[Test compressed file]' \
        '-d[Decompress file]' \
        '--best[Best compression]' \
        '--brute[Brute force compression]' \
        '--ultra-brute[Ultra brute force]' \
        '-v[Verbose output]' \
        '-q[Quiet mode]' \
        '-f[Force overwrite]' \
        '-k[Create backup]' \
        '--lzma[Use LZMA compression]' \
        '-o[Output file]:file:_files' \
        '*:file:_files'
}

_resize "$@"
EOF
```

### System Integration

#### Desktop Entry (Linux)
```bash
# Create desktop entry
sudo tee /usr/share/applications/resize.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Resize
Comment=Advanced file compression tool
Exec=resize %F
Icon=resize
Terminal=true
MimeType=application/x-executable;application/x-sharedlib;
Categories=Utility;Archiving;Compression;
EOF

# Update desktop database
sudo update-desktop-database
```

#### File Manager Integration

##### Nautilus (GNOME)
```bash
# Create Nautilus script
mkdir -p ~/.local/share/nautilus/scripts
cat > ~/.local/share/nautilus/scripts/Compress\ with\ Resize << 'EOF'
#!/bin/bash
# Nautilus script for Resize compression

for file in "$@"; do
    if [ -x "$file" ]; then
        gnome-terminal -- bash -c "resize --best '$file'; echo 'Press Enter to close'; read"
    fi
done
EOF

chmod +x ~/.local/share/nautilus/scripts/Compress\ with\ Resize
```

##### Dolphin (KDE)
```bash
# Create service menu
mkdir -p ~/.local/share/kservices5/ServiceMenus
cat > ~/.local/share/kservices5/ServiceMenus/resize.desktop << 'EOF'
[Desktop Entry]
Type=Service
ServiceTypes=KonqPopupMenu/Plugin
MimeType=application/x-executable;
Actions=compress;decompress;test;

[Desktop Action compress]
Name=Compress with Resize
Icon=archive-insert
Exec=konsole -e bash -c "resize --best '%f'; echo 'Press Enter to close'; read"

[Desktop Action decompress]
Name=Decompress with Resize
Icon=archive-extract
Exec=konsole -e bash -c "resize -d '%f'; echo 'Press Enter to close'; read"

[Desktop Action test]
Name=Test with Resize
Icon=archive-test
Exec=konsole -e bash -c "resize -t '%f'; echo 'Press Enter to close'; read"
EOF
```

### Configuration

#### Global Configuration
```bash
# Create global config
sudo mkdir -p /etc/resize
sudo tee /etc/resize/resize.conf << 'EOF'
# Global Resize configuration
[compression]
default_level = best
backup = true
verify_after = true

[output]
log_level = info
progress = true

[memory]
limit = 512m
EOF
```

#### User Configuration
```bash
# Create user config
mkdir -p ~/.config/resize
cat > ~/.config/resize/resize.conf << 'EOF'
# User Resize configuration
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
limit = 1g
temp_dir = /tmp
EOF
```

## Troubleshooting

### Build Issues

#### CMake Issues
```bash
# CMake version too old
# Solution: Install newer CMake
wget https://github.com/Kitware/CMake/releases/latest/download/cmake-3.25.0-linux-x86_64.tar.gz
tar -xzf cmake-3.25.0-linux-x86_64.tar.gz
export PATH=$PWD/cmake-3.25.0-linux-x86_64/bin:$PATH

# Missing CMake modules
# Solution: Install development packages
sudo apt install cmake-extras  # Ubuntu/Debian
sudo dnf install cmake         # Fedora
```

#### Compiler Issues
```bash
# GCC/Clang too old
# Solution: Install newer compiler
sudo apt install gcc-9 g++-9  # Ubuntu/Debian
export CC=gcc-9 CXX=g++-9

# Missing C++17 support
# Solution: Check compiler version
gcc --version
clang++ --version

# Force C++17
export CXXFLAGS="-std=c++17"
```

#### Dependency Issues
```bash
# Missing zlib
sudo apt install zlib1g-dev     # Ubuntu/Debian
sudo dnf install zlib-devel     # Fedora/CentOS
brew install zlib               # macOS

# Missing pkg-config
sudo apt install pkg-config     # Ubuntu/Debian
sudo dnf install pkgconfig      # Fedora/CentOS
brew install pkg-config         # macOS
```

### Runtime Issues

#### Permission Issues
```bash
# Cannot execute resize
chmod +x resize
sudo chmod +x /usr/local/bin/resize

# Cannot access files
# Check file permissions dan ownership
ls -la target_file
sudo chown $USER:$USER target_file
```

#### Library Issues
```bash
# Missing shared libraries
ldd resize  # Check dependencies

# Add library path
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# Update library cache
sudo ldconfig
```

#### Memory Issues
```bash
# Out of memory during compression
# Solution: Reduce memory usage
resize --best large_file.exe

# Use swap space
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Platform-Specific Issues

#### Linux
```bash
# SELinux issues
sudo setsebool -P allow_execmod 1
sudo restorecon -R /usr/local/bin/resize

# AppArmor issues
sudo aa-complain /usr/local/bin/resize
```

#### macOS
```bash
# Code signing issues
codesign --force --deep --sign - resize

# Gatekeeper issues
sudo spctl --master-disable  # Temporary
xattr -dr com.apple.quarantine resize
```

#### Windows
```cmd
REM Antivirus false positives
REM Add resize.exe to antivirus exclusions

REM PATH issues
set PATH=%PATH%;C:\Program Files\Resize\bin
```

### Getting Help

#### Diagnostic Information
```bash
# Generate diagnostic report
resize --sysinfo > diagnostic.txt
resize -V >> diagnostic.txt
ldd resize >> diagnostic.txt  # Linux
otool -L resize >> diagnostic.txt  # macOS

# Include in bug report
```

#### Community Support
- **GitHub Issues**: [Create new issue](https://github.com/your-username/resize/issues)
- **Discussions**: [Community forum](https://github.com/your-username/resize/discussions)
- **Documentation**: [Wiki](https://github.com/your-username/resize/wiki)

---

*Jika mengalami masalah yang tidak tercakup dalam dokumentasi ini, silakan buat issue di GitHub repository dengan informasi diagnostic lengkap.*