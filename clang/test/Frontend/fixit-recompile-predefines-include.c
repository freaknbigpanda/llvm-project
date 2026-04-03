// REQUIRES: case-insensitive-filesystem

// RUN: rm -rf %t && split-file %s %t
// RUN: sed "s|DIR|%{/t:real}|g" %t/main.c.in > %t/main.c
// RUN: %clang_cc1 -fsyntax-only %t/main.c -include %t/hEadEr.h -fixit-recompile 2>&1 | FileCheck %s --check-prefix=CHECK --implicit-check-not="PLEASE submit a bug report"
// RUN: %clang_cc1 -fsyntax-only %t/main.c -include %t/hEadEr.h -fixit-recompile -fixit-to-temporary 2>&1 | FileCheck %s --check-prefix=CHECK --implicit-check-not="PLEASE submit a bug report"

//--- header.h
int included_header;

//--- main.c.in
#include "DIR/header.h"
int main(void) { return included_header; }

// CHECK: <built-in>:1:10: warning: non-portable path to file '"[[DIR:[^"]+]]/header.h"'; specified path differs in case from file name on disk [-Wnonportable-include-path]
// CHECK-NEXT:     1 | #include "[[DIR]]/hEadEr.h"
// CHECK-NEXT:       |          ^
