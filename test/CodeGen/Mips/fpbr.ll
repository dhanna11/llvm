; RUN: llc < %s -march=mipsel -mcpu=mips32   | FileCheck %s -check-prefix=ALL -check-prefix=FCC -check-prefix=32-FCC
; RUN: llc < %s -march=mipsel -mcpu=mips32r2 | FileCheck %s -check-prefix=ALL -check-prefix=FCC -check-prefix=32-FCC
; RUN: llc < %s -march=mipsel -mcpu=mips32r6 | FileCheck %s -check-prefix=ALL -check-prefix=GPR -check-prefix=32-GPR
; RUN: llc < %s -march=mips64el -mcpu=mips64   | FileCheck %s -check-prefix=ALL -check-prefix=FCC -check-prefix=64-FCC
; RUN: llc < %s -march=mips64el -mcpu=mips64r2 | FileCheck %s -check-prefix=ALL -check-prefix=FCC -check-prefix=64-FCC
; RUN: llc < %s -march=mips64el -mcpu=mips64r6 | FileCheck %s -check-prefix=ALL -check-prefix=GPR -check-prefix=64-GPR

define void @func0(float %f2, float %f3) nounwind {
entry:
; ALL-LABEL: func0:

; 32-FCC:        c.eq.s $f12, $f14
; 64-FCC:        c.eq.s $f12, $f13
; FCC:           bc1f   {{(\$|.L)BB0_2}}

; 32-GPR:        cmp.eq.s $[[FGRCC:f[0-9]+]], $f12, $f14
; 64-GPR:        cmp.eq.s $[[FGRCC:f[0-9]+]], $f12, $f13
; GPR:           mfc1     $[[GPRCC:[0-9]+]], $[[FGRCC:f[0-9]+]]
; FIXME: We ought to be able to transform not+bnez -> beqz
; GPR:           not      $[[GPRCC]], $[[GPRCC]]
; GPR:           bnez     $[[GPRCC]], {{(\$|.L)BB0_2}}

  %cmp = fcmp oeq float %f2, %f3
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void (...) @g0() nounwind
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void (...) @g1() nounwind
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

declare void @g0(...)

declare void @g1(...)

define void @func1(float %f2, float %f3) nounwind {
entry:
; ALL-LABEL: func1:

; 32-FCC:        c.olt.s $f12, $f14
; 64-FCC:        c.olt.s $f12, $f13
; FCC:           bc1f    {{(\$|.L)BB1_2}}

; 32-GPR:        cmp.ule.s $[[FGRCC:f[0-9]+]], $f14, $f12
; 64-GPR:        cmp.ule.s $[[FGRCC:f[0-9]+]], $f13, $f12
; GPR:           mfc1     $[[GPRCC:[0-9]+]], $[[FGRCC:f[0-9]+]]
; GPR-NOT:       not      $[[GPRCC]], $[[GPRCC]]
; GPR:           bnez     $[[GPRCC]], {{(\$|.L)BB1_2}}

  %cmp = fcmp olt float %f2, %f3
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void (...) @g0() nounwind
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void (...) @g1() nounwind
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define void @func2(float %f2, float %f3) nounwind {
entry:
; ALL-LABEL: func2:

; 32-FCC:        c.ole.s $f12, $f14
; 64-FCC:        c.ole.s $f12, $f13
; FCC:           bc1t    {{(\$|.L)BB2_2}}

; 32-GPR:        cmp.ult.s $[[FGRCC:f[0-9]+]], $f14, $f12
; 64-GPR:        cmp.ult.s $[[FGRCC:f[0-9]+]], $f13, $f12
; GPR:           mfc1     $[[GPRCC:[0-9]+]], $[[FGRCC:f[0-9]+]]
; GPR-NOT:       not      $[[GPRCC]], $[[GPRCC]]
; GPR:           beqz     $[[GPRCC]], {{(\$|.L)BB2_2}}

  %cmp = fcmp ugt float %f2, %f3
  br i1 %cmp, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  tail call void (...) @g0() nounwind
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void (...) @g1() nounwind
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define void @func3(double %f2, double %f3) nounwind {
entry:
; ALL-LABEL: func3:

; 32-FCC:        c.eq.d $f12, $f14
; 64-FCC:        c.eq.d $f12, $f13
; FCC:           bc1f {{(\$|.L)BB3_2}}

; 32-GPR:        cmp.eq.d $[[FGRCC:f[0-9]+]], $f12, $f14
; 64-GPR:        cmp.eq.d $[[FGRCC:f[0-9]+]], $f12, $f13
; GPR:           mfc1     $[[GPRCC:[0-9]+]], $[[FGRCC:f[0-9]+]]
; FIXME: We ought to be able to transform not+bnez -> beqz
; GPR:           not      $[[GPRCC]], $[[GPRCC]]
; GPR:           bnez     $[[GPRCC]], {{(\$|.L)BB3_2}}

  %cmp = fcmp oeq double %f2, %f3
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void (...) @g0() nounwind
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void (...) @g1() nounwind
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define void @func4(double %f2, double %f3) nounwind {
entry:
; ALL-LABEL: func4:

; 32-FCC:        c.olt.d $f12, $f14
; 64-FCC:        c.olt.d $f12, $f13
; FCC:           bc1f {{(\$|.L)BB4_2}}

; 32-GPR:        cmp.ule.d $[[FGRCC:f[0-9]+]], $f14, $f12
; 64-GPR:        cmp.ule.d $[[FGRCC:f[0-9]+]], $f13, $f12
; GPR:           mfc1     $[[GPRCC:[0-9]+]], $[[FGRCC:f[0-9]+]]
; GPR-NOT:       not      $[[GPRCC]], $[[GPRCC]]
; GPR:           bnez     $[[GPRCC]], {{(\$|.L)BB4_2}}

  %cmp = fcmp olt double %f2, %f3
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  tail call void (...) @g0() nounwind
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void (...) @g1() nounwind
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}

define void @func5(double %f2, double %f3) nounwind {
entry:
; ALL-LABEL: func5:

; 32-FCC:        c.ole.d $f12, $f14
; 64-FCC:        c.ole.d $f12, $f13
; FCC:           bc1t {{(\$|.L)BB5_2}}

; 32-GPR:        cmp.ult.d $[[FGRCC:f[0-9]+]], $f14, $f12
; 64-GPR:        cmp.ult.d $[[FGRCC:f[0-9]+]], $f13, $f12
; GPR:           mfc1     $[[GPRCC:[0-9]+]], $[[FGRCC:f[0-9]+]]
; GPR-NOT:       not      $[[GPRCC]], $[[GPRCC]]
; GPR:           beqz     $[[GPRCC]], {{(\$|.L)BB5_2}}

  %cmp = fcmp ugt double %f2, %f3
  br i1 %cmp, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  tail call void (...) @g0() nounwind
  br label %if.end

if.else:                                          ; preds = %entry
  tail call void (...) @g1() nounwind
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret void
}
