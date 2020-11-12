; ModuleID = '<swift-imported-modules>'
source_filename = "<swift-imported-modules>"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.15.0"

%swift.async_func_pointer = type <{ i32, i32 }>
%swift.task = type {}
%swift.executor = type {}
%swift.context = type {}
%swift.error = type opaque
%TSi = type <{ i64 }>

@"$s5async15returnSomethingyS2iYFAD" = global %swift.async_func_pointer <{ i32 trunc (i64 sub (i64 ptrtoint (void (%swift.task*, %swift.executor*, %swift.context*)* @"$s5async15returnSomethingyS2iYF" to i64), i64 ptrtoint (%swift.async_func_pointer* @"$s5async15returnSomethingyS2iYFAD" to i64)) to i32), i32 56 }>, section "__TEXT,__const", align 8
@"$s5async19callReturnSomethingyyYFAD" = global %swift.async_func_pointer <{ i32 trunc (i64 sub (i64 ptrtoint (void (%swift.task*, %swift.executor*, %swift.context*)* @"$s5async19callReturnSomethingyyYF" to i64), i64 ptrtoint (%swift.async_func_pointer* @"$s5async19callReturnSomethingyyYFAD" to i64)) to i32), i32 40 }>, section "__TEXT,__const", align 8
@"\01l_entry_point" = private constant { i32 } { i32 trunc (i64 sub (i64 ptrtoint (i32 (i32, i8**)* @main to i64), i64 ptrtoint ({ i32 }* @"\01l_entry_point" to i64)) to i32) }, section "__TEXT, __swift5_entry, regular, no_dead_strip", align 4
@"_swift_FORCE_LOAD_$_swiftCompatibility51_$_async" = weak_odr hidden constant void ()* @"_swift_FORCE_LOAD_$_swiftCompatibility51"
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@llvm.used = appending global [8 x i8*] [i8* bitcast (i32 (i32, i8**)* @main to i8*), i8* bitcast (void (%swift.task*, %swift.executor*, %swift.context*)* @"$s5async15returnSomethingyS2iYF" to i8*), i8* bitcast (%swift.async_func_pointer* @"$s5async15returnSomethingyS2iYFAD" to i8*), i8* bitcast (void (%swift.task*, %swift.executor*, %swift.context*)* @"$s5async19callReturnSomethingyyYF" to i8*), i8* bitcast (%swift.async_func_pointer* @"$s5async19callReturnSomethingyyYFAD" to i8*), i8* bitcast ({ i32 }* @"\01l_entry_point" to i8*), i8* bitcast (void ()** @"_swift_FORCE_LOAD_$_swiftCompatibility51_$_async" to i8*), i8* bitcast (i16* @__swift_reflection_version to i8*)], section "llvm.metadata", align 8

define i32 @main(i32 %0, i8** %1) #0 {
entry:
  %2 = bitcast i8** %1 to i8*
  ret i32 0
}

define swiftcc void @"$s5async15returnSomethingyS2iYF"(%swift.task* %0, %swift.executor* %1, %swift.context* %2) #0 {
entry:
  %p.debug = alloca i64, align 8
  %3 = bitcast i64* %p.debug to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %3, i8 0, i64 8, i1 false)
  %4 = bitcast %swift.context* %2 to <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>*
  %5 = call token @llvm.coro.id.async(i32 56, i32 16, i32 2, i8* bitcast (%swift.async_func_pointer* @"$s5async15returnSomethingyS2iYFAD" to i8*))
  %6 = call i8* @llvm.coro.begin(token %5, i8* null)
  %7 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %4, i32 0, i32 7
  %._value = getelementptr inbounds %TSi, %TSi* %7, i32 0, i32 0
  %8 = load i64, i64* %._value, align 8
  store i64 %8, i64* %p.debug, align 8
  %9 = bitcast %swift.context* %2 to <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>*
  %10 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %9, i32 0, i32 6
  %._value1 = getelementptr inbounds %TSi, %TSi* %10, i32 0, i32 0
  store i64 %8, i64* %._value1, align 8
  %11 = bitcast %swift.context* %2 to <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>*
  %12 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %11, i32 0, i32 1
  %13 = load void (%swift.task*, %swift.executor*, %swift.context*)*, void (%swift.task*, %swift.executor*, %swift.context*)** %12, align 8
  tail call swiftcc void %13(%swift.task* %0, %swift.executor* %1, %swift.context* %2)
  br label %coro.end

coro.end:                                         ; preds = %entry
  %14 = call i1 @llvm.coro.end(i8* %6, i1 false)
  unreachable
}

; Function Attrs: nounwind
declare token @llvm.coro.id.async(i32, i32, i32, i8*) #1

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #2

; Function Attrs: nounwind
declare i8* @llvm.coro.begin(token, i8* writeonly) #1

; Function Attrs: argmemonly nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: nounwind
declare i1 @llvm.coro.end(i8*, i1) #1

define swiftcc void @"$s5async19callReturnSomethingyyYF"(%swift.task* %0, %swift.executor* %1, %swift.context* %2) #0 {
entry:
  %3 = bitcast %swift.context* %2 to <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error* }>*

  %4 = call token @llvm.coro.id.async(i32 40, i32 16, i32 2, i8* bitcast (%swift.async_func_pointer* @"$s5async19callReturnSomethingyyYFAD" to i8*))
  %5 = call i8* @llvm.coro.begin(token %4, i8* null)

  %6 = load i32, i32* getelementptr inbounds (%swift.async_func_pointer, %swift.async_func_pointer* @"$s5async15returnSomethingyS2iYFAD", i32 0, i32 0), align 8
  %7 = sext i32 %6 to i64
  %8 = add i64 ptrtoint (%swift.async_func_pointer* @"$s5async15returnSomethingyS2iYFAD" to i64), %7
  %9 = inttoptr i64 %8 to i8*
  %10 = bitcast i8* %9 to void (%swift.task*, %swift.executor*, %swift.context*)*
  %11 = load i32, i32* getelementptr inbounds (%swift.async_func_pointer, %swift.async_func_pointer* @"$s5async15returnSomethingyS2iYFAD", i32 0, i32 1), align 8
  %12 = zext i32 %11 to i64

  %13 = call swiftcc i8* @swift_task_alloc(%swift.task* %0, i64 %12) #7
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %13)

; Store caller context.

  %14 = bitcast i8* %13 to <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>*
  %15 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %14, i32 0, i32 0
  store %swift.context* %2, %swift.context** %15, align 8

; Store return to caller resumption function.
  %16 = call i8* @llvm.coro.async.resume()
  %17 = bitcast i8* %16 to void (%swift.task*, %swift.executor*, %swift.context*)*
  %18 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %14, i32 0, i32 1
  store void (%swift.task*, %swift.executor*, %swift.context*)* %17, void (%swift.task*, %swift.executor*, %swift.context*)** %18, align 8

; Store executor.
  %19 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %14, i32 0, i32 2
  store %swift.executor* %1, %swift.executor** %19, align 8

; Store argument
  %20 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %14, i32 0, i32 7
  %._value = getelementptr inbounds %TSi, %TSi* %20, i32 0, i32 0
  store i64 5, i64* %._value, align 8

; Compute callee function to be tail called.
  %21 = bitcast i8* %13 to %swift.context*
  %22 = bitcast void (%swift.task*, %swift.executor*, %swift.context*)* %10 to i8*

  %23 = call { i8*, i8*, i8* } (i8*, i8*, ...) @llvm.coro.suspend.async(
      i8* %16, // resumption function pointer, will be updated by lowering.
      i8* bitcast (i8* (i8*)* @__swift_async_resume_project_context to i8*), // function that describes how to restore the caller context from the callee context
      i8* bitcast (void (i8*, %swift.task*, %swift.executor*, %swift.context*)* @__swift_suspend_dispatch_3 to i8*), // function that is tail called as part of this suspend point.
      i8* %22, %swift.task* %0, %swift.executor* %1, %swift.context* %21) // its arguments

; Start of resumption function.
; Get return value.
  %24 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error*, %TSi, %TSi }>* %14, i32 0, i32 6
  %._value1 = getelementptr inbounds %TSi, %TSi* %24, i32 0, i32 0
  %25 = load i64, i64* %._value1, align 8
  call swiftcc void @swift_task_dealloc(%swift.task* %0, i8* %13) #1
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %13)

; Return to caller.
  %26 = bitcast %swift.context* %2 to <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error* }>*
  %27 = bitcast %swift.context* %2 to <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error* }>*
  %28 = getelementptr inbounds <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error* }>, <{ %swift.context*, void (%swift.task*, %swift.executor*, %swift.context*)*, %swift.executor*, i32, [4 x i8], %swift.error* }>* %27, i32 0, i32 1
  %29 = load void (%swift.task*, %swift.executor*, %swift.context*)*, void (%swift.task*, %swift.executor*, %swift.context*)** %28, align 8
  tail call swiftcc void %29(%swift.task* %0, %swift.executor* %1, %swift.context* %2)
  br label %coro.end

coro.end:                                         ; preds = %entry
  %30 = call i1 @llvm.coro.end(i8* %5, i1 false)
  unreachable
}

; Function Attrs: argmemonly nounwind
declare extern_weak swiftcc i8* @swift_task_alloc(%swift.task*, i64) #4

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #5

; Function Attrs: nounwind
declare i8* @llvm.coro.async.resume() #1

; Function Attrs: nounwind
define linkonce_odr hidden i8* @__swift_async_resume_project_context(i8* %0) #6 {
entry:
  %1 = bitcast i8* %0 to i8**
  %2 = load i8*, i8** %1, align 8
  ret i8* %2
}

; Function Attrs: nounwind
define internal void @__swift_suspend_dispatch_3(i8* %0, %swift.task* %1, %swift.executor* %2, %swift.context* %3) #1 {
entry:
  %4 = bitcast i8* %0 to void (%swift.task*, %swift.executor*, %swift.context*)*
  tail call swiftcc void %4(%swift.task* %1, %swift.executor* %2, %swift.context* %3)
  ret void
}

; Function Attrs: nounwind
declare { i8*, i8*, i8* } @llvm.coro.suspend.async(i8*, i8*, ...) #1

; Function Attrs: argmemonly nounwind
declare extern_weak swiftcc void @swift_task_dealloc(%swift.task*, i8*) #4

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #5

declare extern_weak void @"_swift_FORCE_LOAD_$_swiftCompatibility51"()

attributes #0 = { "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { cold noreturn nounwind }
attributes #3 = { argmemonly nounwind willreturn writeonly }
attributes #4 = { argmemonly nounwind }
attributes #5 = { argmemonly nounwind willreturn }
attributes #6 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind readnone }

!swift.module.flags = !{!0}
!llvm.asan.globals = !{!1, !2, !3}
!llvm.module.flags = !{!4, !5, !6, !7, !8, !9, !10, !11}
!llvm.linker.options = !{!12, !13, !14, !15, !16}

!0 = !{!"standard-library", i1 false}
!1 = !{%swift.async_func_pointer* @"$s5async15returnSomethingyS2iYFAD", null, null, i1 false, i1 true}
!2 = !{%swift.async_func_pointer* @"$s5async19callReturnSomethingyyYFAD", null, null, i1 false, i1 true}
!3 = !{[8 x i8*]* @llvm.used, null, null, i1 false, i1 true}
!4 = !{i32 1, !"Objective-C Version", i32 2}
!5 = !{i32 1, !"Objective-C Image Info Version", i32 0}
!6 = !{i32 1, !"Objective-C Image Info Section", !"__DATA,__objc_imageinfo,regular,no_dead_strip"}
!7 = !{i32 4, !"Objective-C Garbage Collection", i32 84084480}
!8 = !{i32 1, !"Objective-C Class Properties", i32 64}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{i32 1, !"Swift Version", i32 7}
!12 = !{!"-lswiftSwiftOnoneSupport"}
!13 = !{!"-lswiftCore"}
!14 = !{!"-lswift_Concurrency"}
!15 = !{!"-lobjc"}
!16 = !{!"-lswiftCompatibility51"}
