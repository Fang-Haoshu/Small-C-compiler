; ModuleID = 'struct.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.doubleO = type { i32, i32, i32, i32, i32 }
%struct.acrossthegreatxxxxwallwecanreacheverycornerintheworld = type { i32 }
%struct.haoehaoehaoewozhendehaoe = type { i32, i32, i32, i32 }

@T = common global %struct.doubleO zeroinitializer, align 4
@A = common global %struct.acrossthegreatxxxxwallwecanreacheverycornerintheworld zeroinitializer, align 4
@C = common global %struct.haoehaoehaoewozhendehaoe zeroinitializer, align 4
@G = common global %struct.doubleO zeroinitializer, align 4
@R = common global %struct.doubleO zeroinitializer, align 4
@B = common global %struct.acrossthegreatxxxxwallwecanreacheverycornerintheworld zeroinitializer, align 4

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %0 = load i32, i32* getelementptr inbounds (%struct.doubleO, %struct.doubleO* @T, i32 0, i32 0), align 4
  %call = call i32 (i32, ...) bitcast (i32 (...)* @read to i32 (i32, ...)*)(i32 %0)
  %1 = load i32, i32* getelementptr inbounds (%struct.acrossthegreatxxxxwallwecanreacheverycornerintheworld, %struct.acrossthegreatxxxxwallwecanreacheverycornerintheworld* @A, i32 0, i32 0), align 4
  %call1 = call i32 (i32, ...) bitcast (i32 (...)* @read to i32 (i32, ...)*)(i32 %1)
  %2 = load i32, i32* getelementptr inbounds (%struct.haoehaoehaoewozhendehaoe, %struct.haoehaoehaoewozhendehaoe* @C, i32 0, i32 1), align 4
  %call2 = call i32 (i32, ...) bitcast (i32 (...)* @read to i32 (i32, ...)*)(i32 %2)
  %3 = load i32, i32* getelementptr inbounds (%struct.doubleO, %struct.doubleO* @T, i32 0, i32 0), align 4
  %4 = load i32, i32* getelementptr inbounds (%struct.haoehaoehaoewozhendehaoe, %struct.haoehaoehaoewozhendehaoe* @C, i32 0, i32 1), align 4
  %xor = xor i32 %3, %4
  store i32 %xor, i32* getelementptr inbounds (%struct.doubleO, %struct.doubleO* @G, i32 0, i32 1), align 4
  %5 = load i32, i32* getelementptr inbounds (%struct.doubleO, %struct.doubleO* @G, i32 0, i32 1), align 4
  %6 = load i32, i32* getelementptr inbounds (%struct.acrossthegreatxxxxwallwecanreacheverycornerintheworld, %struct.acrossthegreatxxxxwallwecanreacheverycornerintheworld* @A, i32 0, i32 0), align 4
  %cmp = icmp eq i32 %5, %6
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  store i32 215, i32* getelementptr inbounds (%struct.haoehaoehaoewozhendehaoe, %struct.haoehaoehaoewozhendehaoe* @C, i32 0, i32 0), align 4
  br label %if.end

if.else:                                          ; preds = %entry
  store i32 0, i32* getelementptr inbounds (%struct.haoehaoehaoewozhendehaoe, %struct.haoehaoehaoewozhendehaoe* @C, i32 0, i32 0), align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %7 = load i32, i32* getelementptr inbounds (%struct.haoehaoehaoewozhendehaoe, %struct.haoehaoehaoewozhendehaoe* @C, i32 0, i32 0), align 4
  %call3 = call i32 (i32, ...) bitcast (i32 (...)* @write to i32 (i32, ...)*)(i32 %7)
  %8 = load i32, i32* getelementptr inbounds (%struct.doubleO, %struct.doubleO* @R, i32 0, i32 2), align 4
  %call4 = call i32 (i32, ...) bitcast (i32 (...)* @read to i32 (i32, ...)*)(i32 %8)
  %9 = load i32, i32* getelementptr inbounds (%struct.doubleO, %struct.doubleO* @R, i32 0, i32 2), align 4
  %tobool = icmp ne i32 %9, 0
  br i1 %tobool, label %if.then5, label %if.else7

if.then5:                                         ; preds = %if.end
  %call6 = call i32 (i32, ...) bitcast (i32 (...)* @write to i32 (i32, ...)*)(i32 215)
  br label %if.end9

if.else7:                                         ; preds = %if.end
  %call8 = call i32 (i32, ...) bitcast (i32 (...)* @write to i32 (i32, ...)*)(i32 -215)
  br label %if.end9

if.end9:                                          ; preds = %if.else7, %if.then5
  ret i32 0
}

declare i32 @read(...) #1

declare i32 @write(...) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (trunk 255459)"}
