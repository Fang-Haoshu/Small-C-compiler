; ModuleID = 'fib.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@mat = global [4 x i32] [i32 0, i32 1, i32 1, i32 1], align 16
@MOD = global i32 10007, align 4
@solve.ans = private unnamed_addr constant [2 x i32] [i32 0, i32 1], align 4
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1
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
  %1 = load i32, i32* %r, align 4
  %2 = load i32, i32* %s, align 4
  %mul = mul nsw i32 %1, %2
  store i32 %mul, i32* %p, align 4
  %arrayidx = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  %3 = load i32, i32* %arrayidx, align 4
  store i32 %3, i32* %r, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %4 = load i32, i32* %x.addr, align 4
  %tobool = icmp ne i32 %4, 0
  br i1 %tobool, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %5 = load i32, i32* %x.addr, align 4
  %and = and i32 %5, 1
  %tobool1 = icmp ne i32 %and, 0
  br i1 %tobool1, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %arrayidx2 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  %6 = load i32, i32* %arrayidx2, align 4
  %7 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %mul3 = mul nsw i32 %6, %7
  %arrayidx4 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 1
  %8 = load i32, i32* %arrayidx4, align 4
  %9 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul5 = mul nsw i32 %8, %9
  %add = add nsw i32 %mul3, %mul5
  store i32 %add, i32* %p, align 4
  %arrayidx6 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  %10 = load i32, i32* %arrayidx6, align 4
  %11 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %mul7 = mul nsw i32 %10, %11
  %arrayidx8 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 1
  %12 = load i32, i32* %arrayidx8, align 4
  %13 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %mul9 = mul nsw i32 %12, %13
  %add10 = add nsw i32 %mul7, %mul9
  store i32 %add10, i32* %q, align 4
  %14 = load i32, i32* %p, align 4
  %15 = load i32, i32* @MOD, align 4
  %rem = srem i32 %14, %15
  %arrayidx11 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  store i32 %rem, i32* %arrayidx11, align 4
  %16 = load i32, i32* %q, align 4
  %17 = load i32, i32* @MOD, align 4
  %rem12 = srem i32 %16, %17
  %arrayidx13 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 1
  store i32 %rem12, i32* %arrayidx13, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %18 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %19 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %mul14 = mul nsw i32 %18, %19
  %20 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %21 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul15 = mul nsw i32 %20, %21
  %add16 = add nsw i32 %mul14, %mul15
  store i32 %add16, i32* %p, align 4
  %22 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %23 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %mul17 = mul nsw i32 %22, %23
  %24 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %25 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %mul18 = mul nsw i32 %24, %25
  %add19 = add nsw i32 %mul17, %mul18
  store i32 %add19, i32* %q, align 4
  %26 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %27 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %mul20 = mul nsw i32 %26, %27
  %28 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %29 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul21 = mul nsw i32 %28, %29
  %add22 = add nsw i32 %mul20, %mul21
  store i32 %add22, i32* %r, align 4
  %30 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %31 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %mul23 = mul nsw i32 %30, %31
  %32 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %33 = load i32, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  %mul24 = mul nsw i32 %32, %33
  %add25 = add nsw i32 %mul23, %mul24
  store i32 %add25, i32* %s, align 4
  %34 = load i32, i32* %p, align 4
  %35 = load i32, i32* @MOD, align 4
  %rem26 = srem i32 %34, %35
  store i32 %rem26, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 0), align 16
  %36 = load i32, i32* %q, align 4
  %37 = load i32, i32* @MOD, align 4
  %rem27 = srem i32 %36, %37
  store i32 %rem27, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 1), align 4
  %38 = load i32, i32* %r, align 4
  %39 = load i32, i32* @MOD, align 4
  %rem28 = srem i32 %38, %39
  store i32 %rem28, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 2), align 8
  %40 = load i32, i32* %s, align 4
  %41 = load i32, i32* @MOD, align 4
  %rem29 = srem i32 %40, %41
  store i32 %rem29, i32* getelementptr inbounds ([4 x i32], [4 x i32]* @mat, i64 0, i64 3), align 4
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %42 = load i32, i32* %x.addr, align 4
  %shr = ashr i32 %42, 1
  store i32 %shr, i32* %x.addr, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %arrayidx30 = getelementptr inbounds [2 x i32], [2 x i32]* %ans, i64 0, i64 0
  %43 = load i32, i32* %arrayidx30, align 4
  ret i32 %43
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %call = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0), i32* @n)
  %0 = load i32, i32* @n, align 4
  %call1 = call i32 @solve(i32 %0)
  %call2 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0), i32 %call1)
  ret i32 0
}

declare i32 @__isoc99_scanf(i8*, ...) #2

declare i32 @printf(i8*, ...) #2

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (trunk 255459)"}
