; ModuleID = 'IR_example'
source_filename = "IR_example"

@0 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

define i32 @main() {
entry:
  %0 = alloca [3 x i32], align 4
  %1 = getelementptr [3 x i32], [3 x i32]* %0, i32 0, i32 0
  store i32 1, i32* %1, align 4
  %2 = getelementptr [3 x i32], [3 x i32]* %0, i32 0, i32 1
  store i32 2, i32* %2, align 4
  %3 = getelementptr [3 x i32], [3 x i32]* %0, i32 0, i32 2
  store i32 4, i32* %3, align 4
  %4 = getelementptr [3 x i32], [3 x i32]* %0, i32 0, i32 1
  %5 = load i32, i32* %4, align 4
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @0, i32 0, i32 0), i32 %5)
  ret i32 0
}

declare i32 @printf(i8* %0, ...)