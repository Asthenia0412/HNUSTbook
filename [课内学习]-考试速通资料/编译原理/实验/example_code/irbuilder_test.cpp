// irbuilder_test.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

#include <iostream>

#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Type.h>
#include <llvm/Support/FileSystem.h>

using namespace std;
using namespace llvm;


void hello_world() {
    llvm::LLVMContext context;
    llvm::Module module("IRbuilderTest", context);
    llvm::IRBuilder<> builder(context);

    Type* ret_type = Type::getInt32Ty(context);
    FunctionType* FT = FunctionType::get(ret_type, {}, false);
    Function* F = Function::Create(FT, Function::ExternalLinkage, "main", module);

    BasicBlock* bb = BasicBlock::Create(context, "entry", F);
    builder.SetInsertPoint(bb);

    llvm::FunctionType* func_type = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(context),
        { llvm::Type::getInt8PtrTy(context) },
        true);
    Function* printf = llvm::Function::Create(func_type, llvm::GlobalValue::ExternalLinkage, "printf", module);
    std::vector<Value*> printf_args = { builder.CreateGlobalStringPtr("Hello world!\n") };

    builder.CreateCall(printf, printf_args);

    Value* ret_value = ConstantInt::get(context, APInt(32, 0));
    builder.CreateRet(ret_value);

    module.dump();
}


/*******************************************
* 由于生成IR时有许多重复的代码和定义，因此
* 将重复的部分抽取出了公共的函数，具体实现
* 采用一个类，类似于unit test的做法
*******************************************/
class IR_gen {
private:
    llvm::LLVMContext context;
    llvm::IRBuilder<> builder;
    llvm::Module module;

    Function* printf;
    BasicBlock* bb;

    void init_module();
    void finish_module_with_int(Value* out_int);
public:
    IR_gen():context(), builder(context), module("IR_example", context),
        printf(nullptr), bb(nullptr) {}

    void gen_hello();
    void gen_var();
    void gen_func();
    void gen_if_without_else();
    void gen_array();
};


// 完成初始化工作
void IR_gen::init_module() {
    // 初始化 main 函数
    Type* ret_type = Type::getInt32Ty(context);
    FunctionType* FT = FunctionType::get(ret_type, {}, false);
    Function* F = Function::Create(FT, Function::ExternalLinkage, "main", module);
    bb = BasicBlock::Create(context, "entry", F);

    // 声明 printf 函数
    llvm::FunctionType* func_type = llvm::FunctionType::get(
        llvm::Type::getInt32Ty(context),
        { llvm::Type::getInt8PtrTy(context) },
        true);
    printf = llvm::Function::Create(func_type, llvm::GlobalValue::ExternalLinkage, "printf", module);
}


// 完成收尾工作
// 大部分情况下我们以输出一个整数变量的值结束，因此将需要输出的变量传入
void IR_gen::finish_module_with_int(Value* out_int) {
    Type* int_type = Type::getInt32Ty(context);
    Value* out_v = builder.CreateLoad(int_type, out_int);
    llvm::Constant* format_string = builder.CreateGlobalStringPtr("%d\n");
    std::vector<Value*> printf_args = { format_string, out_v };
    builder.CreateCall(printf, printf_args);

    Value* ret_value = ConstantInt::get(context, APInt(32, 0));
    builder.CreateRet(ret_value);

    // 输出 IR 代码
    module.dump();
}


/*********************************************
* gen_var生成对应于以下代码的IR：
int main() {
  print(1);
  return 0;
}
*********************************************/
void IR_gen::gen_hello() {
    init_module();

    builder.SetInsertPoint(bb);

    Value* value = ConstantInt::get(context, APInt(32, 1));
    std::vector<Value*> printf_args = { builder.CreateGlobalStringPtr("%d\n"), value };

    builder.CreateCall(printf, printf_args);

    Value* ret_value = ConstantInt::get(context, APInt(32, 0));
    builder.CreateRet(ret_value);

    module.dump();
}


/*********************************************
* gen_var生成对应于以下代码的IR：
int main() {
  int a;
  float b;
  a = 2;
  b = a * 1.5;
  print(b);
  return 0;
}
*********************************************/
void IR_gen::gen_var() {
    init_module();

    builder.SetInsertPoint(bb);
    // 创建变量
    Type* int_type = Type::getInt32Ty(context);
    AllocaInst* a = builder.CreateAlloca(int_type, 0, "a");
    Type* float_type = Type::getFloatTy(context);
    AllocaInst* b = builder.CreateAlloca(float_type, 0, "b");

    // 变量存取和运算
    builder.CreateStore(ConstantInt::get(context, APInt(32, 2)), a);
    Value* a_value = builder.CreateLoad(int_type, a);
    Value* lhs = builder.CreateSIToFP(a_value, float_type);
    Value* rhs = ConstantFP::get(context, APFloat(1.5f));
    Value* temp = builder.CreateFMul(lhs, rhs);
    builder.CreateStore(temp, b);

    // 输出
    Value* b_value = builder.CreateLoad(float_type, b);
    Type* double_type = Type::getDoubleTy(context);
    // printf只接收double类型，需要进行位数扩展
    Value* out = builder.CreateFPExt(b_value, double_type);
    std::vector<Value*> printf_args = { builder.CreateGlobalStringPtr("%f\n"), out };
    builder.CreateCall(printf, printf_args);

    Value* ret_value = ConstantInt::get(context, APInt(32, 0));
    builder.CreateRet(ret_value);

    module.dump();
}


/*********************************************
* gen_func生成对应于以下代码的IR：
int add(int n1, int n2) {
  return (n1 + n2);
}

int main() {
  int s;
  s = add(1, 2);
  print(s);
  return 0;
}
*********************************************/
void IR_gen::gen_func() {
    init_module();

    // 定义add函数
    Type* int_type = Type::getInt32Ty(context);
    FunctionType* add_ft = FunctionType::get(int_type, { int_type, int_type }, false);
    Function* add_f = Function::Create(add_ft, Function::ExternalLinkage, "add", module);
    BasicBlock* add_bb = BasicBlock::Create(context, "entry", add_f);
    builder.SetInsertPoint(add_bb);

    AllocaInst* n1 = builder.CreateAlloca(int_type, 0, "n1");
    builder.CreateStore(add_f->getArg(0), n1);
    AllocaInst* n2 = builder.CreateAlloca(int_type, 0, "n2");
    builder.CreateStore(add_f->getArg(1), n2);
    Value* sum = builder.CreateAdd(builder.CreateLoad(int_type, n1), builder.CreateLoad(int_type, n2));
    builder.CreateRet(sum);

    // 创建变量
    builder.SetInsertPoint(bb);
    AllocaInst* s = builder.CreateAlloca(int_type, 0, "s");
    Value* lv = ConstantInt::get(context, APInt(32, 1));
    Value* rv = ConstantInt::get(context, APInt(32, 2));
    Value* ret_v = builder.CreateCall(add_f, { lv, rv });
    builder.CreateStore(ret_v, s);

    finish_module_with_int(s);
}


/*********************************************
* gen_if_without_else生成对应于以下代码的IR：
int abs(int n) {
  if (n < 0)
  n = 0 - n;
  return x;
}

int main() {
  int s;
  s = abs(-1);
  print(s);
  return 0;
}
*********************************************/
void IR_gen::gen_if_without_else() {
    init_module();

    // 定义abs函数
    Type* int_type = Type::getInt32Ty(context);
    FunctionType* abs_ft = FunctionType::get(int_type, { int_type }, false);
    Function* abs_f = Function::Create(abs_ft, Function::ExternalLinkage, "abs", module);
    BasicBlock* abs_bb = BasicBlock::Create(context, "entry", abs_f);
    builder.SetInsertPoint(abs_bb);

    AllocaInst* p_n = builder.CreateAlloca(int_type, 0, "n");
    builder.CreateStore(abs_f->getArg(0), p_n);
    Value* n = builder.CreateLoad(int_type, p_n);
    Value* zero = ConstantInt::get(context, APInt(32, 0));
    Value* cond = builder.CreateICmpSLT(n, zero);

    // 跳转时需要跳转到基本块，先进行定义
    BasicBlock* then_bb = BasicBlock::Create(context, "then", abs_f);
    BasicBlock* succ_bb = BasicBlock::Create(context, "succ", abs_f);
    builder.CreateCondBr(cond, then_bb, succ_bb);

    // then分支，最后无条件跳转到succ块
    builder.SetInsertPoint(then_bb);
    Value* v = builder.CreateSub(zero, n);
    builder.CreateStore(v, p_n);
    builder.CreateBr(succ_bb);

    // succ块，返回结果
    builder.SetInsertPoint(succ_bb);
    Value* ret_v = builder.CreateLoad(int_type, p_n);
    builder.CreateRet(ret_v);

    // main 函数
    builder.SetInsertPoint(bb);
    AllocaInst* s = builder.CreateAlloca(int_type, 0, "s");
    Value* lv = ConstantInt::get(context, APInt(32, -1));
    Value* out_v = builder.CreateCall(abs_f, { lv });
    builder.CreateStore(out_v, s);

    finish_module_with_int(s);
}


/*********************************************
* gen_array生成对应于以下代码的IR：
int main() {
  int a[3];
  a[0] = 1;
  a[1] = 2;
  a[2] = 3;
  print(a[1]);
  return 0;
}
*********************************************/
void IR_gen::gen_array() {
    init_module();

    builder.SetInsertPoint(bb);

    // 定义数组
    Type* int_type = Type::getInt32Ty(context);
    Type* array_type = ArrayType::get(int_type, 3);
    AllocaInst* array = builder.CreateAlloca(array_type);

    // 使用GEP取得元素地址，再使用地址取值
    Value* a0 = builder.CreateGEP(array_type, array,
        { ConstantInt::get(context, APInt(32, 0)), ConstantInt::get(context, APInt(32, 0)) });
    builder.CreateStore(ConstantInt::get(context, APInt(32, 1)), a0);

    // 对于GEP后面有两个常数参数的情况，可以简写为下列函数
    Value* a1 = builder.CreateConstGEP2_32(array_type, array, 0, 1);
    builder.CreateStore(ConstantInt::get(context, APInt(32, 2)), a1);

    Value* a2 = builder.CreateConstGEP2_32(array_type, array, 0, 2);
    builder.CreateStore(ConstantInt::get(context, APInt(32, 4)), a2);

    Value* out = builder.CreateConstGEP2_32(array_type, array, 0, 1);
    finish_module_with_int(out);
}


int main()
{
    IR_gen test;
    test.gen_array();

    return 0;
}

// 运行程序: Ctrl + F5 或调试 >“开始执行(不调试)”菜单
// 调试程序: F5 或调试 >“开始调试”菜单

// 入门使用技巧: 
//   1. 使用解决方案资源管理器窗口添加/管理文件
//   2. 使用团队资源管理器窗口连接到源代码管理
//   3. 使用输出窗口查看生成输出和其他消息
//   4. 使用错误列表窗口查看错误
//   5. 转到“项目”>“添加新项”以创建新的代码文件，或转到“项目”>“添加现有项”以将现有代码文件添加到项目
//   6. 将来，若要再次打开此项目，请转到“文件”>“打开”>“项目”并选择 .sln 文件
