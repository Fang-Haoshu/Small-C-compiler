; ModuleID = 'fib.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@mat = global [4 x i32] [i32 0, i32 1, i32 1, i32 1], align 16
@MOD = global i32 10007, align 4
@solve.ans = private unnamed_addr constant [2 x i32] [i32 0, i32 1], align 4
@n = common global i32 0, align 4

; Function Attrs: nounwind uwtable
define i32 @solve(i32 %x) #0 {
entry:
  %x.addr = alloca i32, align 4
  %p = alloca i32, align 4
  %q = alloca i32, align 4
  %r = alloca i32, align 4
  %s = alloca i32, align 4
  %ans = alloca [2 x i32], align 4
  store i32 %x, i32* %x.addr, align 4
  %0 = bitcast [2 x i32]* %ans to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* bitcast ([2 x i32]* @solve.ans to i8*), i64 8, i32 4, i1 false)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32, i32* %x.addr, align 4
  %tobool = icmp ne i32 %1, 0
  br i1 %tobool, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32, i32* %x.addr, align 4
  %and = and i32 %2, 1
  %tobool1 = icmp ne i32 %and, 0
  br i1 %tobool1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %arrayidx = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  %3 = load i32, i32* %arrayidx, align 4
  %4 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %mul = mul nsw i32 %3, %4
  %arrayidx2 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 1
  %5 = load i32, i32* %arrayidx2, align 4
  %6 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul3 = mul nsw i32 %5, %6
  %add = add nsw i32 %mul, %mul3
  store i32 %add, i32* %p, align 4
  %arrayidx4 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  %7 = load i32, i32* %arrayidx4, align 4
  %8 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %mul5 = mul nsw i32 %7, %8
  %arrayidx6 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 1
  %9 = load i32, i32* %arrayidx6, align 4
  %10 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %mul7 = mul nsw i32 %9, %10
  %add8 = add nsw i32 %mul5, %mul7
  store i32 %add8, i32* %q, align 4
  %11 = load i32, i32* %p, align 4
  %12 = load i32, i32* @MOD, align 4
  %rem = srem i32 %11, %12
  %arrayidx9 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  store i32 %rem, i32* %arrayidx9, align 4
  %13 = load i32, i32* %q, align 4
  %14 = load i32, i32* @MOD, align 4
  %rem10 = srem i32 %13, %14
  %arrayidx11 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 1
  store i32 %rem10, i32* %arrayidx11, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %15 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %16 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %mul12 = mul nsw i32 %15, %16
  %17 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %18 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul13 = mul nsw i32 %17, %18
  %add14 = add nsw i32 %mul12, %mul13
  store i32 %add14, i32* %p, align 4
  %19 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %20 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %mul15 = mul nsw i32 %19, %20
  %21 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %22 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %mul16 = mul nsw i32 %21, %22
  %add17 = add nsw i32 %mul15, %mul16
  store i32 %add17, i32* %q, align 4
  %23 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %24 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %mul18 = mul nsw i32 %23, %24
  %25 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %26 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul19 = mul nsw i32 %25, %26
  %add20 = add nsw i32 %mul18, %mul19
  store i32 %add20, i32* %r, align 4
  %27 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %28 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul21 = mul nsw i32 %27, %28
  %29 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %30 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %mul22 = mul nsw i32 %29, %30
  %add23 = add nsw i32 %mul21, %mul22
  store i32 %add23, i32* %s, align 4
  %31 = load i32, i32* %p, align 4
  %32 = load i32, i32* @MOD, align 4
  %rem24 = srem i32 %31, %32
  store i32 %rem24, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %33 = load i32, i32* %q, align 4
  %34 = load i32, i32* @MOD, align 4
  %rem25 = srem i32 %33, %34
  store i32 %rem25, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %35 = load i32, i32* %r, align 4
  %36 = load i32, i32* @MOD, align 4
  %rem26 = srem i32 %35, %36
  store i32 %rem26, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %37 = load i32, i32* %s, align 4
  %38 = load i32, i32* @MOD, align 4
  %rem27 = srem i32 %37, %38
  store i32 %rem27, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %39 = load i32, i32* %x.addr, align 4
  %shr = ashr i32 %39, 1
  store i32 %shr, i32* %x.addr, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %arrayidx28 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  %40 = load i32, i32* %arrayidx28, align 4
  ret i32 %40
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %0 = load i32, i32* @n, align 4
  %call = call i32 (i32, ...) bitcast (i32 (...)* @read to i32 (i32, ...)*)(i32 %0)
  %1 = load i32, i32* @n, align 4
  %call1 = call i32 @solve(i32 %1)
  %call2 = call i32 (i32, ...) bitcast (i32 (...)* @write to i32 (i32, ...)*)(i32 %call1)
  ret i32 0
}

declare i32 @read(...) #2

declare i32 @write(...) #2

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (trunk 255459)"}
