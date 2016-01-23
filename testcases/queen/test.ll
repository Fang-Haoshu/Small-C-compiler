; ModuleID = 'queen.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@ans = global i32 0, align 4
@n = common global i32 0, align 4
@b = common global [20 x i32] zeroinitializer, align 16
@l = common global [40 x i32] zeroinitializer, align 16
@r = common global [40 x i32] zeroinitializer, align 16
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Function Attrs: nounwind uwtable
define i32 @dfs(i32 %x) #0 {
entry:
  %retval = alloca i32, align 4
  %x.addr = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %x, i32* %x.addr, align 4
  %0 = load i32, i32* %x.addr, align 4
  %1 = load i32, i32* @n, align 4
  %cmp = icmp eq i32 %0, %1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %2 = load i32, i32* @ans, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* @ans, align 4
  store i32 0, i32* %retval, align 4
  br label %return

if.end:                                           ; preds = %entry
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %3 = load i32, i32* %i, align 4
  %4 = load i32, i32* @n, align 4
  %cmp1 = icmp slt i32 %3, %4
  br i1 %cmp1, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load i32, i32* %i, align 4
  %idxprom = sext i32 %5 to i64
  %arrayidx = getelementptr inbounds [20 x i32], [20 x i32]* @b, i64 0, i64 %idxprom
  %6 = load i32, i32* %arrayidx, align 4
  %tobool = icmp ne i32 %6, 0
  br i1 %tobool, label %if.end33, label %land.lhs.true

land.lhs.true:                                    ; preds = %for.body
  %7 = load i32, i32* %i, align 4
  %8 = load i32, i32* %x.addr, align 4
  %add = add nsw i32 %7, %8
  %idxprom2 = sext i32 %add to i64
  %arrayidx3 = getelementptr inbounds [40 x i32], [40 x i32]* @l, i64 0, i64 %idxprom2
  %9 = load i32, i32* %arrayidx3, align 4
  %tobool4 = icmp ne i32 %9, 0
  br i1 %tobool4, label %if.end33, label %land.lhs.true5

land.lhs.true5:                                   ; preds = %land.lhs.true
  %10 = load i32, i32* %i, align 4
  %11 = load i32, i32* %x.addr, align 4
  %sub = sub nsw i32 %10, %11
  %12 = load i32, i32* @n, align 4
  %add6 = add nsw i32 %sub, %12
  %sub7 = sub nsw i32 %add6, 1
  %idxprom8 = sext i32 %sub7 to i64
  %arrayidx9 = getelementptr inbounds [40 x i32], [40 x i32]* @r, i64 0, i64 %idxprom8
  %13 = load i32, i32* %arrayidx9, align 4
  %tobool10 = icmp ne i32 %13, 0
  br i1 %tobool10, label %if.end33, label %if.then11

if.then11:                                        ; preds = %land.lhs.true5
  %14 = load i32, i32* %i, align 4
  %idxprom12 = sext i32 %14 to i64
  %arrayidx13 = getelementptr inbounds [20 x i32], [20 x i32]* @b, i64 0, i64 %idxprom12
  store i32 -1, i32* %arrayidx13, align 4
  %15 = load i32, i32* %i, align 4
  %16 = load i32, i32* %x.addr, align 4
  %add14 = add nsw i32 %15, %16
  %idxprom15 = sext i32 %add14 to i64
  %arrayidx16 = getelementptr inbounds [40 x i32], [40 x i32]* @l, i64 0, i64 %idxprom15
  store i32 1, i32* %arrayidx16, align 4
  %17 = load i32, i32* %i, align 4
  %18 = load i32, i32* %x.addr, align 4
  %sub17 = sub nsw i32 %17, %18
  %19 = load i32, i32* @n, align 4
  %add18 = add nsw i32 %sub17, %19
  %sub19 = sub nsw i32 %add18, 1
  %idxprom20 = sext i32 %sub19 to i64
  %arrayidx21 = getelementptr inbounds [40 x i32], [40 x i32]* @r, i64 0, i64 %idxprom20
  store i32 1, i32* %arrayidx21, align 4
  %20 = load i32, i32* %x.addr, align 4
  %add22 = add nsw i32 %20, 1
  %call = call i32 @dfs(i32 %add22)
  %21 = load i32, i32* %i, align 4
  %idxprom23 = sext i32 %21 to i64
  %arrayidx24 = getelementptr inbounds [20 x i32], [20 x i32]* @b, i64 0, i64 %idxprom23
  store i32 0, i32* %arrayidx24, align 4
  %22 = load i32, i32* %i, align 4
  %23 = load i32, i32* %x.addr, align 4
  %add25 = add nsw i32 %22, %23
  %idxprom26 = sext i32 %add25 to i64
  %arrayidx27 = getelementptr inbounds [40 x i32], [40 x i32]* @l, i64 0, i64 %idxprom26
  store i32 0, i32* %arrayidx27, align 4
  %24 = load i32, i32* %i, align 4
  %25 = load i32, i32* %x.addr, align 4
  %sub28 = sub nsw i32 %24, %25
  %26 = load i32, i32* @n, align 4
  %add29 = add nsw i32 %sub28, %26
  %sub30 = sub nsw i32 %add29, 1
  %idxprom31 = sext i32 %sub30 to i64
  %arrayidx32 = getelementptr inbounds [40 x i32], [40 x i32]* @r, i64 0, i64 %idxprom31
  store i32 0, i32* %arrayidx32, align 4
  br label %if.end33

if.end33:                                         ; preds = %if.then11, %land.lhs.true5, %land.lhs.true, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end33
  %27 = load i32, i32* %i, align 4
  %inc34 = add nsw i32 %27, 1
  store i32 %inc34, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  store i32 0, i32* %retval, align 4
  br label %return

return:                                           ; preds = %for.end, %if.then
  %28 = load i32, i32* %retval, align 4
  ret i32 %28
}

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %call = call i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0), i32* @n)
  %0 = load i32, i32* @n, align 4
  %cmp = icmp sgt i32 %0, 16
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %call1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0), i32 -1)
  br label %if.end

if.else:                                          ; preds = %entry
  %call2 = call i32 @dfs(i32 0)
  %1 = load i32, i32* @ans, align 4
  %call3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0), i32 %1)
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  ret i32 0
}

declare i32 @scanf(i8*, ...) #1

declare i32 @printf(i8*, ...) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (trunk 255459)"}
