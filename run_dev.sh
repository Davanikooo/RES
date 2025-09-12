#!/bin/bash

# UPX Development Environment
# Script untuk setup development environment untuk UPX

echo "==================================="
echo "  UPX Development Environment"
echo "==================================="
echo

# Periksa apakah dependencies sudah lengkap
echo "Checking UPX dependencies..."

if [ -d "vendor/ucl/src" ]; then
    echo "✓ UCL library: OK"
else
    echo "✗ UCL library: MISSING"
fi

if [ -d "vendor/zlib" ]; then
    echo "✓ zlib library: OK"
else
    echo "✗ zlib library: MISSING"
fi

if [ -d "vendor/doctest" ]; then
    echo "✓ doctest: OK"
else
    echo "✗ doctest: MISSING"
fi

if [ -d "vendor/lzma-sdk" ]; then
    echo "✓ LZMA SDK: OK"
else
    echo "✗ LZMA SDK: MISSING"
fi

echo
echo "Build tools available:"
which cmake > /dev/null && echo "✓ CMake: $(cmake --version | head -n1)" || echo "✗ CMake: NOT FOUND"
which make > /dev/null && echo "✓ Make: $(make --version | head -n1)" || echo "✗ Make: NOT FOUND"
which clang++ > /dev/null && echo "✓ C++ Compiler: $(clang++ --version | head -n1)" || echo "✗ C++ Compiler: NOT FOUND"

echo
echo "Project struktur:"
echo "- src/          : Source code UPX utama"
echo "- vendor/       : Dependencies (UCL, zlib, dll)"
echo "- build/        : Build directory"
echo "- doc/          : Dokumentasi"
echo

echo "Untuk memulai development:"
echo "1. Modifikasi source code di direktori src/"
echo "2. Build menggunakan: cd build/release && cmake --build ."
echo "3. Test binary yang dihasilkan: ./build/release/upx --help"
echo

echo "Catatan:"
echo "- Proyek ini adalah UPX - Ultimate Packer for eXecutables"
echo "- Dependencies sudah didownload secara manual"
echo "- Beberapa build configuration mungkin perlu disesuaikan"
echo

echo "Happy coding! 🚀"