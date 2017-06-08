caffe_pickup_caffe_sources(${PROJECT_SOURCE_DIR})

add_library(FRCNNapi STATIC FRCNN/frcnn_api.cpp FRCNN/rpn_api.cpp)
caffe_default_properties(FRCNNapi)
target_link_libraries(FRCNNapi ${Caffe_LINKER_LIBS})
target_include_directories(FRCNNapi ${Caffe_INCLUDE_DIRS}
                                 PUBLIC
                                 $<BUILD_INTERFACE:${Caffe_INCLUDE_DIR}>
                                 $<INSTALL_INTERFACE:include>)
target_compile_definitions(FRCNNapi ${Caffe_DEFINITIONS})
if(Caffe_COMPILE_OPTIONS)
  target_compile_options(FRCNNapi ${Caffe_COMPILE_OPTIONS})
endif()
set_target_properties(FRCNNapi PROPERTIES
    VERSION   ${CAFFE_TARGET_VERSION}
    SOVERSION ${CAFFE_TARGET_SOVERSION}
    )
if(NOT MSVC)
  target_compile_definitions(gtest PUBLIC -DGTEST_USE_OWN_TR1_TUPLE)
endif()
install(DIRECTORY ${Caffe_INCLUDE_DIR}/api DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(TARGETS FRCNNapi EXPORT CaffeTargets DESTINATION ${CMAKE_INSTALL_LIBDIR})
#add_library(gtest_main gtest_main.cc)
#target_link_libraries(gtest_main gtest)
