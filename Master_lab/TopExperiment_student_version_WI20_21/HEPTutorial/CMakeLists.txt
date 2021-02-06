cmake_minimum_required(VERSION 3.11)
project(TopQuark)

#set(CMAKE_VERBOSE_MAKEFILE ON)

set(CMAKE_CXX_STANDARD 14)

#---Locate the ROOT package and defines a number of variables (e.g. ROOT_INCLUDE_DIRS)
find_package(ROOT CONFIG REQUIRED )

#---Define useful ROOT functions and macros (e.g. ROOT_GENERATE_DICTIONARY)
include(${ROOT_USE_FILE})

root_generate_dictionary(G__TopQuark MyAnalysis.h MyElectron.h MyJet.h MyMuon.h MyPhoton.h Plotter.h LINKDEF LinkDef.h)
add_library(TopQuark SHARED MyAnalysis.C MyElectron.C MyJet.C MyMuon.C MyPhoton.C Plotter.C G__TopQuark)
target_include_directories(TopQuark PUBLIC ${CMAKE_SOURCE_DIR})

add_executable(top-quark example.C)
target_link_libraries(top-quark  ROOT::Core ROOT::Physics ROOT::Graf ROOT::RIO ROOT::Net ${ROOT_LIBRARIES} ROOT::Hist TopQuark)