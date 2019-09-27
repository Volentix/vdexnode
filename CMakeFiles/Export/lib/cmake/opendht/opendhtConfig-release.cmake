#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "opendht-static" for configuration "Release"
set_property(TARGET opendht-static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(opendht-static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopendht.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS opendht-static )
list(APPEND _IMPORT_CHECK_FILES_FOR_opendht-static "${_IMPORT_PREFIX}/lib/libopendht.a" )

# Import target "opendht" for configuration "Release"
set_property(TARGET opendht APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(opendht PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libopendht.so.1.10.0"
  IMPORTED_SONAME_RELEASE "libopendht.so.1"
  )

list(APPEND _IMPORT_CHECK_TARGETS opendht )
list(APPEND _IMPORT_CHECK_FILES_FOR_opendht "${_IMPORT_PREFIX}/lib/libopendht.so.1.10.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
