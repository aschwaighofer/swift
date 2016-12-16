add_swift_host_tool(sil-func-extractor
  SILFunctionExtractor.cpp
  LINK_LIBRARIES
    swiftFrontend
    swiftIRGen
    swiftSILGen
    swiftSILOptimizer
    swiftSerialization
    swiftClangImporter
    # Clang libraries included to appease the linker on linux.
    clangBasic
    clangCodeGen
  LLVM_COMPONENT_DEPENDS
    DebugInfoCodeView
  SWIFT_COMPONENT tools
)
