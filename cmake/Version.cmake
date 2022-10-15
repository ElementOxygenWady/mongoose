#* Author: Wady <iswady@163.com>
#* Date:   Mon Feb 28 12:00:00 2022

find_package(Git)
if(NOT GIT_FOUND)
    message(FATAL_ERROR "Missing git executable, please add it to environment variable.")
endif()

macro(git_command OUTPUT_VAR)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} ${ARGN}
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        OUTPUT_VARIABLE ${OUTPUT_VAR}
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endmacro()

git_command(GIT_DESCRIBE describe --tags --always)
git_command(GIT_TAG describe --tags --abbrev=0)

if(GIT_DESCRIBE)
    if(GIT_TAG)
        if(NOT ("${GIT_TAG}" STREQUAL "${PROJECT_VERSION}"))
            message(FATAL_ERROR "Project version (${PROJECT_VERSION}) and GIT tag (${GIT_TAG}) differ.")
        endif()
    endif()
    set(PROJECT_VERSION_DETAIL "${GIT_DESCRIBE}")
    add_definitions(-DPROJECT_VERSION="${PROJECT_VERSION}")
    add_definitions(-DPROJECT_VERSION_DETAILS="${PROJECT_VERSION_DETAIL}")
    message(STATUS "Project version: ${PROJECT_VERSION}, GIT describe: ${GIT_DESCRIBE}")
else()
    message(FATAL_ERROR "Please put your code in a git repository.")
endif()
