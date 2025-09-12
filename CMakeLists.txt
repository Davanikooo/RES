#
# Resize (RES) "CMake" build file; see https://cmake.org/
# Copyright (C) WHO-AM-I-404
#

# Build requirements:
#   A C++ compiler that fully implements C++17: clang-5, gcc-8 or msvc-2019-16.11
#   (older or other compilers may work but are unsupported, use at your own risk)

# Sections of this CMakeLists.txt:
#   - options
#   - init
#   - common compilation flags
#   - targets
#   - target compilation flags
#   - test
#   - install
#   - print summary

# CMake version check; using a somewhat current CMake version is highly recommended
file(REMOVE "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/.resize_cmake_config_done.txt")
if(DEFINED RES_CONFIG_CMAKE_MINIMUM_REQUIRED_VERSION)
    cmake_minimum_required(VERSION "${RES_CONFIG_CMAKE_MINIMUM_REQUIRED_VERSION}" FATAL_ERROR)
elseif(NOT ${CMAKE_VERSION} VERSION_LESS "3.10")
    cmake_minimum_required(VERSION "3.10" FATAL_ERROR)
else()
    cmake_minimum_required(VERSION "3.8" FATAL_ERROR) # CMake >= 3.8 is needed for CXX_STANDARD 17
endif()

# support functions and some utility
include("${CMAKE_CURRENT_SOURCE_DIR}/misc/cmake/functions.cmake")
resize_print_var(CMAKE_VERSION RES_CONFIG_CMAKE_MINIMUM_REQUIRED_VERSION CMAKE_GENERATOR)
resize_print_var(CMAKE_GENERATOR_TOOLSET CMAKE_GENERATOR_PLATFORM)
resize_print_env_var(CC CXX CPPFLAGS CFLAGS CXXFLAGS)

#***********************************************************************
# options
#***********************************************************************

resize_cmake_include_hook(1_options)

# compilation config options
if(NOT USE_STRICT_DEFAULTS)
    # permissive config defaults when building from source code tarball
    option(RES_CONFIG_DISABLE_GITREV   "Do not compile with Git version info."         ON)
    option(RES_CONFIG_DISABLE_SANITIZE "Do not compile with sanitize options."         ON)
    option(RES_CONFIG_DISABLE_WERROR   "Do not compile with -Werror option."           ON)
    option(RES_CONFIG_DISABLE_WSTRICT  "Do not compile with strict compiler warnings." ON)
else()
    # strict config defaults for Git developer builds
    message(STATUS "===== RESIZE NOTE: strict developer config defaults enabled =====")
    option(RES_CONFIG_DISABLE_GITREV   "Do not compile with Git version info."         OFF)
    option(RES_CONFIG_DISABLE_SANITIZE "Do not compile with sanitize options."         OFF)
    option(RES_CONFIG_DISABLE_WERROR   "Do not compile with -Werror option."           OFF)
    option(RES_CONFIG_DISABLE_WSTRICT  "Do not compile with strict compiler warnings." OFF)
endif()

# test config options (see below)
# IMPORTANT NOTE: self-pack test can only work if the host executable format is supported by Resize!
option(RES_CONFIG_DISABLE_SELF_PACK_TEST   "Do not test packing Resize with itself" OFF)
option(RES_CONFIG_DISABLE_EXHAUSTIVE_TESTS "Do not run exhaustive tests"         OFF)

#***********************************************************************
# init
#***********************************************************************

set(RES_VERSION_STRING "1.0.1") # this should match src/version.h

resize_cmake_include_hook(2_init)

# Disallow in-source build. Note that you will still have to manually
# clean up a few files if you accidentally try an in-source build.
if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    resize_disallow_in_source_build()
endif()

# global settings
if(${CMAKE_VERSION} VERSION_GREATER "3.14.99" AND NOT DEFINED CMAKE_MSVC_RUNTIME_LIBRARY)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded")
    cmake_policy(SET CMP0091 NEW)
endif()
# global CMake settings that default to ON
resize_cache_bool_vars(ON
    CMAKE_C_STANDARD_REQUIRED CMAKE_CXX_STANDARD_REQUIRED
    CMAKE_EXPORT_COMPILE_COMMANDS CMAKE_REQUIRED_QUIET
)
# internal RESIZE settings that default to OFF; useful for CI jobs
resize_cache_bool_vars(OFF
    RES_CONFIG_CMAKE_DISABLE_TEST RES_CONFIG_CMAKE_DISABLE_INSTALL
    RES_CONFIG_CMAKE_DISABLE_PRINT_INFO RES_CONFIG_CMAKE_DISABLE_PLATFORM_CHECK
    RES_CONFIG_DISABLE_C_STANDARD RES_CONFIG_DISABLE_CXX_STANDARD
    RES_CONFIG_DISABLE_RUN_UNPACKED_TEST RES_CONFIG_DISABLE_RUN_PACKED_TEST
    RES_CONFIG_DISABLE_SAVE_TEMPS RES_CONFIG_DISABLE_SHARED_LIBS RES_CONFIG_REQUIRE_THREADS
)
resize_cache_bool_vars(ON RES_CONFIG_EXPECT_THREADS)

# determine Git revision
set(GITREV_SHORT "")
set(GITREV_PLUS "")
set(GIT_DESCRIBE "")
if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/.git" AND NOT RES_CONFIG_DISABLE_GITREV)
    find_package(Git)
    if(Git_FOUND)
        execute_process(
            COMMAND "${GIT_EXECUTABLE}" rev-parse --short=12 HEAD
            RESULT_VARIABLE result ERROR_QUIET
            OUTPUT_VARIABLE GITREV_SHORT OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        string(LENGTH "${GITREV_SHORT}" l)
        if(${result} EQUAL 0 AND ${l} EQUAL 12)
            execute_process(RESULT_VARIABLE result COMMAND "${GIT_EXECUTABLE}" diff --quiet)
            if(NOT ${result} EQUAL 0)
                set(GITREV_PLUS "+")
            endif()
        else()
            set(GITREV_SHORT "")
        endif()
        execute_process(
            COMMAND "${GIT_EXECUTABLE}" describe --match "v*.*.*" --tags --dirty
            RESULT_VARIABLE result ERROR_QUIET
            OUTPUT_VARIABLE GIT_DESCRIBE OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(GIT_DESCRIBE MATCHES "^v?([0-9]+\\.[0-9]+\\.[0-9]+)-([0-9]+)-g(.+)$")
            set(GIT_DESCRIBE "${CMAKE_MATCH_1}-devel.${CMAKE_MATCH_2}+git-${CMAKE_MATCH_3}")
        endif()
    endif()
endif()
if(GITREV_SHORT)
    message(STATUS "RES_VERSION_GITREV = \"${GITREV_SHORT}${GITREV_PLUS}\"")
    if(GIT_DESCRIBE)
        message(STATUS "RES_VERSION_GIT_DESCRIBE = \"${GIT_DESCRIBE}\"")
    endif()
elseif(RES_CONFIG_DISABLE_GITREV)
    message(STATUS "RES_VERSION_GITREV: disabled")
else()
    message(STATUS "RES_VERSION_GITREV: not set")
endif()

# CMake init
resize_set_default_build_type(Release) # default is CMAKE_BUILD_TYPE=Release
project(resize VERSION "${RES_VERSION_STRING}" LANGUAGES C CXX)
resize_apply_build_type()
resize_set_global_vars()
resize_check_working_build_rpath(RES_CONFIG_HAVE_WORKING_BUILD_RPATH)

if(DEFINED RES_CONFIG_CMAKE_EXECUTABLE_SUFFIX)
    set(CMAKE_EXECUTABLE_SUFFIX "${RES_CONFIG_CMAKE_EXECUTABLE_SUFFIX}")
endif()
if(NOT RES_CONFIG_CMAKE_DISABLE_INSTALL AND CMAKE_INSTALL_PREFIX)
    include(GNUInstallDirs)
endif()

#***********************************************************************
# common compilation flags
#***********************************************************************

include(CheckCCompilerFlag)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckStructHasMember)
include(CheckSymbolExists)
include(CheckTypeSize)

resize_cmake_include_hook(3_common_compilation_flags)

# assert sane type sizes
check_type_size("size_t" C_SIZEOF_SIZE_T LANGUAGE C)
check_type_size("size_t" CXX_SIZEOF_SIZE_T LANGUAGE CXX)
if(NOT "${C_SIZEOF_SIZE_T}" MATCHES "^(4|8|16)$")
    message(FATAL_ERROR "ERROR: unexpected C_SIZEOF_SIZE_T '${C_SIZEOF_SIZE_T}'")
endif()
if(NOT ",${C_SIZEOF_SIZE_T}," STREQUAL ",${CXX_SIZEOF_SIZE_T},")
    message(FATAL_ERROR "FATAL ERROR: '${C_SIZEOF_SIZE_T}' '${CXX_SIZEOF_SIZE_T}' mismatch")
endif()

if(NOT DEFINED HAVE_UNISTD_H)
    check_include_file("unistd.h" HAVE_UNISTD_H)
endif()
if(NOT DEFINED HAVE_UTIMENSAT)
    # proper checking for utimensat() is somewhat messy
    check_function_exists(utimensat HAVE_UTIMENSAT_FUNCTION__)
    if(HAVE_UTIMENSAT_FUNCTION__)
        check_symbol_exists(utimensat "sys/types.h;fcntl.h;sys/stat.h" HAVE_UTIMENSAT_SYMBOL__)
        if(HAVE_UTIMENSAT_SYMBOL__)
            CHECK_STRUCT_HAS_MEMBER("struct stat" "st_mtim.tv_nsec" "sys/types.h;fcntl.h;sys/stat.h" HAVE_STRUCT_STAT_ST_MTIM_TV_NSEC) # POSIX.1-2008
            if(NOT HAVE_STRUCT_STAT_ST_MTIM_TV_NSEC)
                CHECK_STRUCT_HAS_MEMBER("struct stat" "st_mtimespec.tv_nsec" "sys/types.h;fcntl.h;sys/stat.h" HAVE_STRUCT_STAT_ST_MTIMESPEC_TV_NSEC) # macOS
            endif()
            if(HAVE_STRUCT_STAT_ST_MTIM_TV_NSEC OR HAVE_STRUCT_STAT_ST_MTIMESPEC_TV_NSEC)
                set(HAVE_UTIMENSAT 1)
            endif()
        endif()
    endif()
endif()

if(RES_CONFIG_DISABLE_WSTRICT)
    # enable all basic warnings
    set(warn_Wall -Wall)
    set(warn_WN -W3)
else()
    # enable all basic warnings, and enable lots of strict warnings
    set(warn_Wall -Wall -Wextra -Wcast-align -Wcast-qual -Wmissing-declarations -Wpointer-arith -Wshadow -Wvla -Wwrite-strings)
    set(warn_WN -W4)
endif()
if(RES_CONFIG_DISABLE_WERROR)
    # warnings are just warnings
    set(warn_Werror "")
    set(warn_WX "")
else()
    # warnings are fatal errors; annoy developers to keep the source code warning-free
    set(warn_Werror -Werror)
    set(warn_WX -WX)
endif()
if(MSVC_FRONTEND)
    # disable warning C5105 which may get triggered by some older versions of <windows.h>
    set(warn_WX -wd5105 ${warn_WX})
endif()

if(NOT CMAKE_C_COMPILER_ID MATCHES "^MSVC")
    # use -O2 instead of -O3 to reduce code size
    string(REGEX REPLACE "(^| )-O3( |$$)" "\\1-O2\\2" a "${CMAKE_C_FLAGS_RELEASE}")
    string(REGEX REPLACE "(^| )-O3( |$$)" "\\1-O2\\2" b "${CMAKE_CXX_FLAGS_RELEASE}")
    set(CMAKE_C_FLAGS_RELEASE "${a}" CACHE STRING "Flags used by the C compiler during RELEASE builds." FORCE)
    set(CMAKE_CXX_FLAGS_RELEASE "${b}" CACHE STRING "Flags used by the CXX compiler during RELEASE builds." FORCE)
endif()
if(MSVC_FRONTEND OR WIN32 OR MINGW OR CYGWIN)
    # disable silly warnings about using "deprecated" POSIX functions like fopen()
    add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)
    add_definitions(-D_CRT_NONSTDC_NO_WARNINGS)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    add_definitions(-D_SCL_SECURE_NO_DEPRECATE)
    add_definitions(-D_SCL_SECURE_NO_WARNINGS)
    add_definitions(-DWIN32_LEAN_AND_MEAN)
    add_definitions(-D__USE_MINGW_ANSI_STDIO)
endif()
if(MSVC_FRONTEND)
    # use -funsigned-char; set __cplusplus according to selected C++ standard
    add_definitions(-J -Zc:__cplusplus)
    if(CMAKE_C_COMPILER_ID MATCHES "^MSVC")
        resize_add_definitions(-Zc:preprocessor) # use new preprocessor
    endif()
endif()
if(NOT CMAKE_C_COMPILER_ID MATCHES "^MSVC")
    # protect against security threats caused by misguided compiler "optimizations"
    resize_add_definitions(-fno-delete-null-pointer-checks -fno-lifetime-dse)
    resize_add_definitions(-fno-strict-aliasing -fno-strict-overflow -funsigned-char)
    # disable overambitious auto-vectorization until this actually gains something
    resize_add_definitions(-fno-tree-vectorize)
    # disable annoying clang warnings which get added by the macOS Xcode cmake generator
    if(CMAKE_GENERATOR MATCHES "Xcode")
        resize_add_definitions(-Wno-shorten-64-to-32)
    endif()
endif()

# examine compiler configuration
if(NOT RES_CONFIG_CMAKE_DISABLE_PRINT_INFO)
    resize_print_common_symbols()
    resize_print_mingw_symbols()
endif()

#***********************************************************************
# targets
#***********************************************************************

# internal settings; these may change in a future versions
set(RES_CONFIG_DISABLE_THREADS ON) # multithreading is currently not used; maybe in RESIZE version 6
set(RES_CONFIG_DISABLE_BZIP2 ON)   # bzip2 is currently not used; we might need it to decompress linux kernels
set(RES_CONFIG_DISABLE_ZSTD ON)    # zstd is currently not used; maybe in RESIZE version 6

resize_cmake_include_hook(4_targets)

if(NOT RES_CONFIG_DISABLE_THREADS)
    find_package(Threads)
endif()
# make sure that threads are indeed fully supported in C++
if(Threads_FOUND)
    foreach(f std_lock_guard.cpp types_abi.cpp)
        set(CMAKE_TRY_COMPILE_TARGET_TYPE "EXECUTABLE")
        if(NOT RES_CONFIG_DISABLE_CXX_STANDARD)
            try_compile(result "${CMAKE_CURRENT_BINARY_DIR}"
                        "${CMAKE_CURRENT_SOURCE_DIR}/misc/cmake/try_compile/${f}"
                        OUTPUT_VARIABLE output CXX_STANDARD 17)
        else()
            try_compile(result "${CMAKE_CURRENT_BINARY_DIR}"
                        "${CMAKE_CURRENT_SOURCE_DIR}/misc/cmake/try_compile/${f}"
                        OUTPUT_VARIABLE output)
        endif()
        if(NOT result)
            # failed; under MinGW be sure to use the posix-threads and NOT the win32-threads version
            if(RES_CONFIG_REQUIRE_THREADS OR (RES_CONFIG_EXPECT_THREADS AND NOT RES_CONFIG_DISABLE_THREADS))
                message(WARNING "Threads FAILED ${f}: ${output}") # output from try_compile
            endif()
            set(Threads_FOUND OFF)
            break()
        endif()
    endforeach()
endif()

if(NOT RES_CONFIG_DISABLE_BZIP2)
resize_add_glob_files(bzip2_SOURCES "vendor/bzip2/*.c")
add_library(resize_vendor_bzip2 STATIC ${bzip2_SOURCES})
if(NOT RES_CONFIG_DISABLE_C_STANDARD)
    set_property(TARGET resize_vendor_bzip2 PROPERTY C_STANDARD 11)
endif()
endif() # RES_CONFIG_DISABLE_BZIP2

resize_add_glob_files(ucl_SOURCES "vendor/ucl/src/*.c")
add_library(resize_vendor_ucl STATIC ${ucl_SOURCES})
if(NOT RES_CONFIG_DISABLE_C_STANDARD)
    set_property(TARGET resize_vendor_ucl PROPERTY C_STANDARD 11)
endif()

resize_add_glob_files(zlib_SOURCES "vendor/zlib/*.c")
add_library(resize_vendor_zlib STATIC ${zlib_SOURCES})
if(NOT RES_CONFIG_DISABLE_C_STANDARD)
    set_property(TARGET resize_vendor_zlib PROPERTY C_STANDARD 11)
endif()

if(NOT RES_CONFIG_DISABLE_ZSTD)
resize_add_glob_files(zstd_SOURCES "vendor/zstd/lib/*/*.c")
add_library(resize_vendor_zstd STATIC ${zstd_SOURCES})
if(NOT RES_CONFIG_DISABLE_C_STANDARD)
    set_property(TARGET resize_vendor_zstd PROPERTY C_STANDARD 11)
endif()
endif() # RES_CONFIG_DISABLE_ZSTD

resize_add_glob_files(resize_SOURCES "src/*.cpp" "src/[cfu]*/*.cpp")
add_executable(resize ${resize_SOURCES})
if(NOT RES_CONFIG_DISABLE_CXX_STANDARD)
    set_property(TARGET resize PROPERTY CXX_STANDARD 17)
endif()
target_link_libraries(resize resize_vendor_ucl resize_vendor_zlib)
if(NOT RES_CONFIG_DISABLE_BZIP2)
    target_link_libraries(resize resize_vendor_bzip2)
endif()
if(NOT RES_CONFIG_DISABLE_ZSTD)
    target_link_libraries(resize resize_vendor_zstd)
endif()
if(Threads_FOUND)
    target_link_libraries(resize Threads::Threads)
endif()

#***********************************************************************
# target compilation flags
#***********************************************************************

resize_cmake_include_hook(5_target_compilation_flags)

if(NOT RES_CONFIG_DISABLE_BZIP2)
set(t resize_vendor_bzip2)
resize_compile_target_debug_with_O2(${t})
resize_sanitize_target(${t})
target_compile_definitions(${t} PRIVATE BZ_NO_STDIO=1)
if(MSVC_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_WN} -wd4127 -wd4244 -wd4267 ${warn_WX})
elseif(GNU_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_Wall} ${warn_Werror})
endif()
resize_add_target_extra_compile_options(${t} RES_CONFIG_EXTRA_COMPILE_OPTIONS_BZIP2)
endif() # RES_CONFIG_DISABLE_BZIP2

set(t resize_vendor_ucl)
target_include_directories(${t} PRIVATE vendor/ucl/include vendor/ucl)
resize_compile_target_debug_with_O2(${t})
resize_sanitize_target(${t})
if(MSVC_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_WN} ${warn_WX})
elseif(GNU_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_Wall} ${warn_Werror})
endif()
resize_add_target_extra_compile_options(${t} RES_CONFIG_EXTRA_COMPILE_OPTIONS_UCL)

set(t resize_vendor_zlib)
target_include_directories(${t} PRIVATE vendor/zlib)
resize_compile_target_debug_with_O2(${t})
resize_sanitize_target(${t})
target_compile_definitions(${t} PRIVATE HAVE_VSNPRINTF=1)
if(HAVE_UNISTD_H)
    target_compile_definitions(${t} PRIVATE HAVE_UNISTD_H=1)
endif()
if(MSVC_FRONTEND)
    target_compile_options(${t} PRIVATE -W3 ${warn_WX})
elseif(GNU_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_Wall} -Wno-cast-align -Wno-cast-qual ${warn_Werror})
endif()
resize_add_target_extra_compile_options(${t} RES_CONFIG_EXTRA_COMPILE_OPTIONS_ZLIB)

if(NOT RES_CONFIG_DISABLE_ZSTD)
set(t resize_vendor_zstd)
resize_compile_target_debug_with_O2(${t})
resize_sanitize_target(${t})
target_compile_definitions(${t} PRIVATE DYNAMIC_BMI2=0 ZSTD_DISABLE_ASM=1)
if(MSVC_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_WN} ${warn_WX})
elseif(GNU_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_Wall} ${warn_Werror})
endif()
resize_add_target_extra_compile_options(${t} RES_CONFIG_EXTRA_COMPILE_OPTIONS_ZSTD)
endif() # RES_CONFIG_DISABLE_ZSTD

set(t resize)
target_include_directories(${t} PRIVATE vendor)
target_compile_definitions(${t} PRIVATE $<$<CONFIG:Debug>:DEBUG=1>)
if(GITREV_SHORT)
    target_compile_definitions(${t} PRIVATE RES_VERSION_GITREV="${GITREV_SHORT}${GITREV_PLUS}")
    if(GIT_DESCRIBE)
        target_compile_definitions(${t} PRIVATE RES_VERSION_GIT_DESCRIBE="${GIT_DESCRIBE}")
    endif()
endif()
if(Threads_FOUND)
    target_compile_definitions(${t} PRIVATE WITH_THREADS=1)
endif()
if(NOT RES_CONFIG_DISABLE_WSTRICT)
    target_compile_definitions(${t} PRIVATE RES_CONFIG_DISABLE_WSTRICT=0)
endif()
if(NOT RES_CONFIG_DISABLE_WERROR)
    target_compile_definitions(${t} PRIVATE RES_CONFIG_DISABLE_WERROR=0)
endif()
if(NOT RES_CONFIG_DISABLE_BZIP2)
    target_compile_definitions(${t} PRIVATE WITH_BZIP2=1)
endif()
if(NOT RES_CONFIG_DISABLE_ZSTD)
    target_compile_definitions(${t} PRIVATE WITH_ZSTD=1)
endif()
if(HAVE_UTIMENSAT)
    target_compile_definitions(${t} PRIVATE USE_UTIMENSAT=1)
    if(HAVE_STRUCT_STAT_ST_MTIMESPEC_TV_NSEC)
        target_compile_definitions(${t} PRIVATE HAVE_STRUCT_STAT_ST_MTIMESPEC_TV_NSEC=1)
    endif()
endif()
# improve speed of the Debug versions
resize_compile_source_debug_with_O2(src/compress/compress_lzma.cpp)
resize_compile_source_debug_with_O2(src/filter/filter_impl.cpp)
#resize_compile_target_debug_with_O2(${t})
resize_sanitize_target(${t})
if(MSVC_FRONTEND)
    target_compile_options(${t} PRIVATE -EHsc ${warn_WN} ${warn_WX})
elseif(GNU_FRONTEND)
    target_compile_options(${t} PRIVATE ${warn_Wall} ${warn_Werror})
endif()
resize_add_target_extra_compile_options(${t} RES_CONFIG_EXTRA_COMPILE_OPTIONS_RESIZE)

#***********************************************************************
# test
#   ctest
#   make test
#   ninja test
#***********************************************************************

resize_cmake_include_hook(6_test)

if(NOT RES_CONFIG_CMAKE_DISABLE_TEST)

add_custom_command(TARGET resize POST_BUILD COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_CURRENT_BINARY_DIR}/XTesting/$<CONFIG>")

include(CTest)
if(NOT CMAKE_CROSSCOMPILING OR CMAKE_CROSSCOMPILING_EMULATOR)
    resize_add_test(resize-version       resize --version)
    resize_add_test(resize-version-short resize --version-short)
    resize_add_test(resize-license       resize --license)
    resize_add_test(resize-help-1        resize --help)
    resize_add_test(resize-help-2        resize --help-short)
    resize_add_test(resize-help-3        resize --help-verbose)
    resize_add_test(resize-sysinfo-1     resize --sysinfo)
    resize_add_test(resize-sysinfo-2     resize --sysinfo -v)
    resize_add_test(resize-sysinfo-3     resize --sysinfo -vv)
    if(NOT RES_CONFIG_DISABLE_SELF_PACK_TEST)
        # IMPORTANT NOTE: these tests can only work if the host executable format
        #   is supported by RESIZE!
        include("${CMAKE_CURRENT_SOURCE_DIR}/misc/cmake/self_pack_test.cmake")
        resize_self_pack_test()
    endif()
endif()

endif() # RES_CONFIG_CMAKE_DISABLE_TEST

#***********************************************************************
# install
#   cmake --install .
#   make install
#   ninja install
#***********************************************************************

resize_cmake_include_hook(7_install)

if(NOT RES_CONFIG_CMAKE_DISABLE_INSTALL)

# installation prefix and directories
if(NOT CMAKE_INSTALL_PREFIX)
    #message(FATAL_ERROR "ERROR: CMAKE_INSTALL_PREFIX is not defined")
    message(WARNING "WARNING: CMAKE_INSTALL_PREFIX is not defined")
endif()
# install files
if(CMAKE_INSTALL_PREFIX AND DEFINED CMAKE_INSTALL_BINDIR)
    install(TARGETS resize DESTINATION "${CMAKE_INSTALL_BINDIR}")
    install(FILES
        COPYING LICENSE NEWS README doc/THANKS.txt doc/upx-doc.html doc/upx-doc.txt
        DESTINATION "${CMAKE_INSTALL_DOCDIR}"
    )
    install(FILES doc/resize.1 DESTINATION "${CMAKE_INSTALL_MANDIR}/man1")
endif()

endif() # RES_CONFIG_CMAKE_DISABLE_INSTALL

#***********************************************************************
# summary
# print some info about the build configuration
#***********************************************************************

resize_cmake_include_hook(8_summary)

resize_print_var(CMAKE_VERSION RES_CONFIG_CMAKE_MINIMUM_REQUIRED_VERSION CMAKE_GENERATOR)
if(NOT RES_CONFIG_CMAKE_DISABLE_PRINT_INFO)
    # print detailed info
    include("${CMAKE_CURRENT_SOURCE_DIR}/misc/cmake/print_info.cmake")
    resize_print_info()
endif()
resize_print_var(CMAKE_INSTALL_PREFIX CMAKE_CONFIGURATION_TYPES CMAKE_TRY_COMPILE_CONFIGURATION CMAKE_BUILD_TYPE)
if(Threads_FOUND)
    message(STATUS "WITH_THREADS = 1")
elseif(RES_CONFIG_REQUIRE_THREADS)
    message(FATAL_ERROR "ERROR: WITH_THREADS required")
elseif(RES_CONFIG_EXPECT_THREADS AND NOT RES_CONFIG_DISABLE_THREADS)
    message(FATAL_ERROR "ERROR: WITH_THREADS expected; set RES_CONFIG_EXPECT_THREADS=OFF")
endif()
if(CMAKE_BUILD_TYPE AND NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|None|Release)$")
    message(WARNING "WARNING: unsupported CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}; please use \"Debug\" or \"Release\"")
endif()

# extra sanity checks to detect incompatible C vs CXX settings
if(NOT RES_CONFIG_CMAKE_DISABLE_PLATFORM_CHECK)
    resize_platform_check_c_cxx_mismatch()
endif()

resize_cmake_include_hook(9_finish)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/.resize_cmake_config_done.txt" "")

# vim:set ft=cmake ts=4 sw=4 tw=0 et:
