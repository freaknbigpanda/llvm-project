; RUN: opt -passes=gvn -S %s | FileCheck %s

@storage = global [2 x ptr] zeroinitializer

; The GEP constant expression is shared by both functions. Do not use a load
; from one function as the invariant-group dependency of a load in the other.
define ptr @first() {
; CHECK-LABEL: define ptr @first(
; CHECK:         [[LOAD:%.*]] = load ptr, ptr getelementptr inbounds ([2 x ptr], ptr @storage, i64 0, i64 1), align 8, !invariant.group [[GROUP:![0-9]+]]
; CHECK-NEXT:    ret ptr [[LOAD]]
  tail call void @llvm.memset.p0.i64(ptr null, i8 0, i64 0, i1 false)
  %load = load ptr, ptr getelementptr inbounds ([2 x ptr], ptr @storage, i64 0, i64 1), !invariant.group !0
  ret ptr %load
}

define ptr @second() {
; CHECK-LABEL: define ptr @second(
; CHECK:         [[LOAD:%.*]] = load ptr, ptr getelementptr inbounds ([2 x ptr], ptr @storage, i64 0, i64 1), align 8, !invariant.group [[GROUP]]
; CHECK-NEXT:    ret ptr [[LOAD]]
  %load = load ptr, ptr getelementptr inbounds ([2 x ptr], ptr @storage, i64 0, i64 1), !invariant.group !0
  ret ptr %load
}

declare void @llvm.memset.p0.i64(ptr, i8, i64, i1 immarg)

!0 = !{}
