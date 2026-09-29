function(cpprest_find_websocketpp)
  if(TARGET cpprestsdk_websocketpp_internal)
    return()
  endif()

  set(WEBSOCKETPP_INCLUDE_DIR "" CACHE PATH "External WebSocket++ include root")
  if(WEBSOCKETPP_INCLUDE_DIR)
    message("-- Using externally supplied websocketpp headers: ${WEBSOCKETPP_INCLUDE_DIR}")
  else()
    find_package(WEBSOCKETPP CONFIG QUIET)
  endif()
  if(WEBSOCKETPP_INCLUDE_DIR)
    # Caller supplied an include root (for example KATE-NMOS-websocketpp).
  elseif(WEBSOCKETPP_FOUND)
    message("-- Found websocketpp version " ${WEBSOCKETPP_VERSION} " on system")
    set(WEBSOCKETPP_INCLUDE_DIR ${WEBSOCKETPP_INCLUDE_DIR} CACHE INTERNAL "")
  elseif(EXISTS ${PROJECT_SOURCE_DIR}/libs/websocketpp/CMakeLists.txt)
    message("-- websocketpp not found, using the embedded version")
    set(WEBSOCKETPP_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/libs/websocketpp CACHE INTERNAL "")
  else()
    message(FATAL_ERROR "-- websocketpp not found and embedded version not present; try `git submodule update --init` and run CMake again")
  endif()

  cpprest_find_boost()
  cpprest_find_openssl()

  add_library(cpprestsdk_websocketpp_internal INTERFACE)
  target_include_directories(cpprestsdk_websocketpp_internal INTERFACE "$<BUILD_INTERFACE:${WEBSOCKETPP_INCLUDE_DIR}>")
  target_link_libraries(cpprestsdk_websocketpp_internal
    INTERFACE
      cpprestsdk_boost_internal
      cpprestsdk_openssl_internal
  )
endfunction()
