#
# RESIZE "CMake" build file; see https://cmake.org/
# Copyright (C) Markus Franz Xaver Johannes Oberhumer
#

#***********************************************************************
# summary section
# print some info about the build configuration
#***********************************************************************

function(resize_print_info)
    get_property(PROPERTY_GENERATOR_IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
    get_property(PROPERTY_TARGET_SUPPORTS_SHARED_LIBS GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS)

    # generator
    resize_print_var(CMAKE_GENERATOR_TOOLSET CMAKE_GENERATOR_PLATFORM)
    resize_print_var(PROPERTY_GENERATOR_IS_MULTI_CONFIG)

    # directories
    if(NOT ",${CMAKE_BINARY_DIR}," STREQUAL ",${CMAKE_CURRENT_BINARY_DIR}," OR NOT ",${CMAKE_SOURCE_DIR}," STREQUAL ",${CMAKE_CURRENT_SOURCE_DIR},")
        resize_print_var(CMAKE_BINARY_DIR CMAKE_SOURCE_DIR CMAKE_CURRENT_BINARY_DIR CMAKE_CURRENT_SOURCE_DIR)
    endif()

    # system
    resize_print_var(CMAKE_HOST_SYSTEM_NAME CMAKE_HOST_SYSTEM_VERSION CMAKE_HOST_SYSTEM_PROCESSOR)
    resize_print_var(CMAKE_SYSTEM_NAME CMAKE_SYSTEM_VERSION CMAKE_SYSTEM_PROCESSOR)
    resize_print_var(CMAKE_ANDROID_NDK CMAKE_ANDROID_NDK_VERSION CMAKE_ANDROID_STANDALONE_TOOLCHAIN)
    resize_print_var(CMAKE_APPLE_SILICON_PROCESSOR CMAKE_OSX_DEPLOYMENT_TARGET CMAKE_OSX_SYSROOT)
    resize_print_var(CMAKE_VS_PLATFORM_TOOLSET CMAKE_VS_PLATFORM_TOOLSET_HOST_ARCHITECTURE CMAKE_VS_PLATFORM_TOOLSET_VERSION)
    resize_print_var(CMAKE_CROSSCOMPILING CMAKE_CROSSCOMPILING_EMULATOR)
    resize_print_var(CMAKE_SIZEOF_VOID_P)

    # binutils
    resize_print_var(CMAKE_EXECUTABLE_FORMAT CMAKE_EXECUTABLE_SUFFIX RESIZE_CONFIG_CMAKE_EXECUTABLE_SUFFIX)
    resize_print_var(CMAKE_AR CMAKE_RANLIB)

    # compilers
    foreach(lang IN ITEMS ASM C CXX)
        resize_print_var(CMAKE_${lang}_COMPILER_LAUNCHER)
        resize_print_var(CMAKE_${lang}_COMPILER)
        resize_print_var(CMAKE_${lang}_COMPILER_ARG1)
        resize_print_var(CMAKE_${lang}_COMPILER_ID)
        resize_print_var(CMAKE_${lang}_SIMULATE_ID)
        resize_print_var(CMAKE_${lang}_COMPILER_VERSION)
        resize_print_var(CMAKE_${lang}_COMPILER_FRONTEND_VARIANT)
        resize_print_var(CMAKE_${lang}_COMPILER_ARCHITECTURE_ID)
        resize_print_var(CMAKE_${lang}_PLATFORM_ID)
        resize_print_var(CMAKE_${lang}_COMPILER_ABI)
        resize_print_var(CMAKE_${lang}_COMPILER_TARGET)
    endforeach()

    # misc
    resize_print_var(CMAKE_BUILD_WITH_INSTALL_RPATH CMAKE_SKIP_RPATH CMAKE_SKIP_BUILD_RPATH CMAKE_SKIP_INSTALL_RPATH)
    resize_print_var(CMAKE_INTERPROCEDURAL_OPTIMIZATION CMAKE_POSITION_INDEPENDENT_CODE)
    resize_print_var(PROPERTY_TARGET_SUPPORTS_SHARED_LIBS)
    resize_print_var(RESIZE_CONFIG_SANITIZE_FLAGS_DEBUG RESIZE_CONFIG_SANITIZE_FLAGS_RELEASE)

    # shortcuts
    resize_print_var(AIX APPLE CLANG CYGWIN GNU_FRONTEND GNUC MINGW MSVC MSVC_FRONTEND MSVC_IDE MSVC_SIMULATE MSVC_TOOLSET_VERSION MSVC_VERSION MSYS UNIX WIN32 WIN64)
endfunction()

# vim:set ft=cmake ts=4 sw=4 tw=0 et:
