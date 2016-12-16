add_swift_host_tool(sil-passpipeline-dumper
  SILPassPipelineDumper.cpp
  LINK_LIBRARIES
    swiftFrontend
    swiftSILGen
    swiftSILOptimizer
    swiftIRGen
    swiftSerialization
    swiftClangImporter
  LLVM_COMPONENT_DEPENDS
    DebugInfoCodeView
  SWIFT_COMPONENT tools
)
