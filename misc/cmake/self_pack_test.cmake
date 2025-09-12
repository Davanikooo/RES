#
# RESIZE "CMake" build file; see https://cmake.org/
# Copyright (C) Markus Franz Xaver Johannes Oberhumer
#

#***********************************************************************
# test section: self-pack tests
#
# IMPORTANT NOTE: these tests can only work if the host executable format
#   is supported by RESIZE!
#***********************************************************************

function(resize_self_pack_test)

set(emu "")
if(DEFINED CMAKE_CROSSCOMPILING_EMULATOR)
    set(emu "${CMAKE_CROSSCOMPILING_EMULATOR}")
endif()
set(exe "${CMAKE_EXECUTABLE_SUFFIX}")
set(resize_self_exe "$<TARGET_FILE:resize>")
set(fo "--force-overwrite")

#
# basic tests
#

resize_add_test(resize-self-pack          resize -3               "${resize_self_exe}" ${fo} -o resize-packed${exe})
resize_add_test(resize-self-pack-fa       resize -3 --all-filters "${resize_self_exe}" ${fo} -o resize-packed-fa${exe})
resize_add_test(resize-self-pack-fn       resize -3 --no-filter   "${resize_self_exe}" ${fo} -o resize-packed-fn${exe})
resize_add_test(resize-self-pack-fr       resize -3 --all-filters --debug-use-random-filter "${resize_self_exe}" ${fo} -o resize-packed-fr${exe})
resize_add_test(resize-self-pack-nrv2b    resize -3 --nrv2b       "${resize_self_exe}" ${fo} -o resize-packed-nrv2b${exe})
resize_add_test(resize-self-pack-nrv2d    resize -3 --nrv2d       "${resize_self_exe}" ${fo} -o resize-packed-nrv2d${exe})
resize_add_test(resize-self-pack-nrv2e    resize -3 --nrv2e       "${resize_self_exe}" ${fo} -o resize-packed-nrv2e${exe})
resize_add_test(resize-self-pack-lzma     resize -1 --lzma        "${resize_self_exe}" ${fo} -o resize-packed-lzma${exe})

resize_add_test(resize-list               resize -l         resize-packed${exe} resize-packed-fa${exe} resize-packed-fn${exe} resize-packed-fr${exe} resize-packed-nrv2b${exe} resize-packed-nrv2d${exe} resize-packed-nrv2e${exe} resize-packed-lzma${exe})
resize_add_test(resize-fileinfo           resize --fileinfo resize-packed${exe} resize-packed-fa${exe} resize-packed-fn${exe} resize-packed-fr${exe} resize-packed-nrv2b${exe} resize-packed-nrv2d${exe} resize-packed-nrv2e${exe} resize-packed-lzma${exe})
resize_add_test(resize-test               resize -t         resize-packed${exe} resize-packed-fa${exe} resize-packed-fn${exe} resize-packed-fr${exe} resize-packed-nrv2b${exe} resize-packed-nrv2d${exe} resize-packed-nrv2e${exe} resize-packed-lzma${exe})

resize_add_test(resize-unpack             resize -d resize-packed${exe}       ${fo} -o resize-unpacked${exe})
resize_add_test(resize-unpack-fa          resize -d resize-packed-fa${exe}    ${fo} -o resize-unpacked-fa${exe})
resize_add_test(resize-unpack-fn          resize -d resize-packed-fn${exe}    ${fo} -o resize-unpacked-fn${exe})
resize_add_test(resize-unpack-fr          resize -d resize-packed-fr${exe}    ${fo} -o resize-unpacked-fr${exe})
resize_add_test(resize-unpack-nrv2b       resize -d resize-packed-nrv2b${exe} ${fo} -o resize-unpacked-nrv2b${exe})
resize_add_test(resize-unpack-nrv2d       resize -d resize-packed-nrv2d${exe} ${fo} -o resize-unpacked-nrv2d${exe})
resize_add_test(resize-unpack-nrv2e       resize -d resize-packed-nrv2e${exe} ${fo} -o resize-unpacked-nrv2e${exe})
resize_add_test(resize-unpack-lzma        resize -d resize-packed-lzma${exe}  ${fo} -o resize-unpacked-lzma${exe})

# all unpacked files must be identical
resize_add_test(resize-compare-fa         "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-fa${exe})
resize_add_test(resize-compare-fn         "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-fn${exe})
resize_add_test(resize-compare-fr         "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-fr${exe})
resize_add_test(resize-compare-nrv2b      "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-nrv2b${exe})
resize_add_test(resize-compare-nrv2d      "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-nrv2d${exe})
resize_add_test(resize-compare-nrv2e      "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-nrv2e${exe})
resize_add_test(resize-compare-lzma       "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-lzma${exe})

# test dependencies
resize_test_depends(resize-list           "resize-self-pack;resize-self-pack-fa;resize-self-pack-fn;resize-self-pack-fr;resize-self-pack-nrv2b;resize-self-pack-nrv2d;resize-self-pack-nrv2e;resize-self-pack-lzma")
resize_test_depends(resize-fileinfo       "resize-self-pack;resize-self-pack-fa;resize-self-pack-fn;resize-self-pack-fr;resize-self-pack-nrv2b;resize-self-pack-nrv2d;resize-self-pack-nrv2e;resize-self-pack-lzma")
resize_test_depends(resize-test           "resize-self-pack;resize-self-pack-fa;resize-self-pack-fn;resize-self-pack-fr;resize-self-pack-nrv2b;resize-self-pack-nrv2d;resize-self-pack-nrv2e;resize-self-pack-lzma")
resize_test_depends(resize-unpack         resize-self-pack)
resize_test_depends(resize-unpack-fa      resize-self-pack-fa)
resize_test_depends(resize-unpack-fn      resize-self-pack-fn)
resize_test_depends(resize-unpack-fr      resize-self-pack-fr)
resize_test_depends(resize-unpack-nrv2b   resize-self-pack-nrv2b)
resize_test_depends(resize-unpack-nrv2d   resize-self-pack-nrv2d)
resize_test_depends(resize-unpack-nrv2e   resize-self-pack-nrv2e)
resize_test_depends(resize-unpack-lzma    resize-self-pack-lzma)
resize_test_depends(resize-compare-fa     "resize-unpack;resize-unpack-fa")
resize_test_depends(resize-compare-fn     "resize-unpack;resize-unpack-fn")
resize_test_depends(resize-compare-fr     "resize-unpack;resize-unpack-fr")
resize_test_depends(resize-compare-nrv2b  "resize-unpack;resize-unpack-nrv2b")
resize_test_depends(resize-compare-nrv2d  "resize-unpack;resize-unpack-nrv2d")
resize_test_depends(resize-compare-nrv2e  "resize-unpack;resize-unpack-nrv2e")
resize_test_depends(resize-compare-lzma   "resize-unpack;resize-unpack-lzma")
# tests with higher COST values will run first
set_tests_properties(resize-self-pack       PROPERTIES COST 90)
set_tests_properties(resize-self-pack-fa    PROPERTIES COST 20)
set_tests_properties(resize-self-pack-fn    PROPERTIES COST 20)
set_tests_properties(resize-self-pack-fr    PROPERTIES COST 20)
set_tests_properties(resize-self-pack-nrv2b PROPERTIES COST 20)
set_tests_properties(resize-self-pack-nrv2d PROPERTIES COST 20)
set_tests_properties(resize-self-pack-nrv2e PROPERTIES COST 20)
set_tests_properties(resize-self-pack-lzma  PROPERTIES COST 30)
set_tests_properties(resize-unpack          PROPERTIES COST 10)

if(NOT RESIZE_CONFIG_DISABLE_RUN_UNPACKED_TEST)
    resize_add_test(resize-run-unpacked           ${emu} ./resize-unpacked${exe} --version-short)
    resize_test_depends(resize-run-unpacked       resize-unpack)
endif()

if(NOT RESIZE_CONFIG_DISABLE_RUN_PACKED_TEST)
    resize_add_test(resize-run-packed             ${emu} ./resize-packed${exe}       --version-short)
    resize_add_test(resize-run-packed-fa          ${emu} ./resize-packed-fa${exe}    --version-short)
    resize_add_test(resize-run-packed-fn          ${emu} ./resize-packed-fn${exe}    --version-short)
    resize_add_test(resize-run-packed-fr          ${emu} ./resize-packed-fr${exe}    --version-short)
    resize_add_test(resize-run-packed-nrv2b       ${emu} ./resize-packed-nrv2b${exe} --version-short)
    resize_add_test(resize-run-packed-nrv2d       ${emu} ./resize-packed-nrv2d${exe} --version-short)
    resize_add_test(resize-run-packed-nrv2e       ${emu} ./resize-packed-nrv2e${exe} --version-short)
    resize_add_test(resize-run-packed-lzma        ${emu} ./resize-packed-lzma${exe}  --version-short)
    resize_test_depends(resize-run-packed         resize-self-pack)
    resize_test_depends(resize-run-packed-fa      resize-self-pack-fa)
    resize_test_depends(resize-run-packed-fn      resize-self-pack-fn)
    resize_test_depends(resize-run-packed-fr      resize-self-pack-fr)
    resize_test_depends(resize-run-packed-nrv2b   resize-self-pack-nrv2b)
    resize_test_depends(resize-run-packed-nrv2d   resize-self-pack-nrv2d)
    resize_test_depends(resize-run-packed-nrv2e   resize-self-pack-nrv2e)
    resize_test_depends(resize-run-packed-lzma    resize-self-pack-lzma)
endif()

#
# exhaustive tests
#

if(NOT RESIZE_CONFIG_DISABLE_EXHAUSTIVE_TESTS)
    foreach(method IN ITEMS nrv2b nrv2d nrv2e lzma)
        foreach(level IN ITEMS 1 2 3 4 5 6 7)
            foreach(small IN ITEMS normal small)
                set(s "${method}-${level}")
                set(ss "")
                if(small MATCHES "small")
                    set(s "${method}-${level}-${small}")
                    set(ss "--small")
                endif()
                resize_add_test(resize-self-pack-${s}         resize --${method} -${level} ${ss} --all-filters --debug-use-random-filter "${resize_self_exe}" ${fo} -o resize-packed-${s}${exe})
                resize_add_test(resize-list-${s}              resize -l resize-packed-${s}${exe})
                resize_add_test(resize-fileinfo-${s}          resize --fileinfo resize-packed-${s}${exe})
                resize_add_test(resize-test-${s}              resize -t resize-packed-${s}${exe})
                resize_add_test(resize-unpack-${s}            resize -d resize-packed-${s}${exe} ${fo} -o resize-unpacked-${s}${exe})
                resize_add_test(resize-compare-${s}           "${CMAKE_COMMAND}" -E compare_files resize-unpacked${exe} resize-unpacked-${s}${exe})
                resize_test_depends(resize-list-${s}          resize-self-pack-${s})
                resize_test_depends(resize-fileinfo-${s}      resize-self-pack-${s})
                resize_test_depends(resize-test-${s}          resize-self-pack-${s})
                resize_test_depends(resize-unpack-${s}        resize-self-pack-${s})
                resize_test_depends(resize-compare-${s}       "resize-unpack;resize-unpack-${s}")
                if(method MATCHES "lzma")
                    set_tests_properties(resize-self-pack-${s} PROPERTIES COST "3${level}")
                else()
                    set_tests_properties(resize-self-pack-${s} PROPERTIES COST "2${level}")
                endif()
                if(NOT RESIZE_CONFIG_DISABLE_RUN_PACKED_TEST)
                    set(i 0)
                    while(${i} LESS 20)
                        math(EXPR i "${i} + 1")
                        resize_add_test(resize-run-packed-${s}-${i}     ${emu} ./resize-packed-${s}${exe} --version-short)
                        resize_test_depends(resize-run-packed-${s}-${i} resize-self-pack-${s})
                    endwhile()
                endif()
            endforeach()
        endforeach()
    endforeach()
endif() # RESIZE_CONFIG_DISABLE_EXHAUSTIVE_TESTS

endfunction()

# vim:set ft=cmake ts=4 sw=4 tw=0 et:
