%{

#include <map>
#include <sstream>
#include <string>

#include "src/code/fp_reg.h"
#include "src/code/gp_reg.h"
#include "src/code/imm.h"
#include "src/code/label.h"
#include "src/code/mmx_reg.h"
#include "src/code/scale.h"
#include "src/code/xmm_reg.h"
#include "src/gen/att.tab.h"

using namespace std;
using namespace x64;

static int colnum = 0;
#define YY_USER_ACTION {        \
	yylloc.first_line = yylineno; \
	yylloc.first_column = colnum; \
	colnum += yyleng;             \
	yylloc.last_column = colnum;  \
	yylloc.last_line = yylineno;  \
}

#define OPERAND(v,t,w) yylval.operand = new OperandInfo(v,t,w);
#define STRING() yylval.str = new string(yytext, yyleng);

Operand to_imm(const char* c, bool from_decimal) {
	istringstream iss(c);
	Operand o;

  if( from_decimal )
    iss >> dec >> o;
  else
	  iss >> hex >> o;

	// This removes sign extension (I think).
	// It should give us the invariant that we use exactly BitWidth bits.
	if ( ((o >> 8) == 0) || (((o >> 8) ^ 0xffffffffffffff) == 0) )
		o &= 0x00000000000000ff;
	else if ( ((o >> 16) == 0) || (((o >> 16) ^ 0xffffffffffff) == 0) )
		o &= 0x000000000000ffff;
	else if ( ((o >> 32) == 0) || (((o >> 32) ^ 0xffffffff) == 0) )
		o &= 0x00000000ffffffff;
	
	return o;
}

BitWidth to_imm_width(const char* c, bool from_decimal) {
	auto imm = to_imm(c, from_decimal);

	if ( imm <= 0x00000000000000ff )
		return LOW;
	if ( imm <= 0x000000000000ffff )
		return WORD;
	if ( imm <= 0x00000000ffffffff ) 
		return DOUBLE;

	return QUAD;
}

Operand to_label(const char* c) {
	static map<string, Operand> labels;
	if ( labels.find(c) == labels.end() )
		labels[c] = labels.size()-1;
	return labels[c];
}

%}

%option noyywrap nounput
%option yylineno

%%

","     { return COMMA; }
":"     { return COLON; }
"("     { return OPEN; }
")"     { return CLOSE; }
"\n"    { return ENDL; }
[ \t]   { ; }

"%rax" { OPERAND(rax, GP_REG, QUAD);   return ATT_GP_REG; }
"%eax" { OPERAND(rax, GP_REG, DOUBLE); return ATT_GP_REG; }
"%ax"  { OPERAND(rax, GP_REG, WORD);   return ATT_GP_REG; }
"%ah"  { OPERAND(rax, GP_REG, HIGH);   return ATT_GP_REG; }
"%al"  { OPERAND(rax, GP_REG, LOW);    return ATT_GP_REG; }

"%rbx" { OPERAND(rbx, GP_REG, QUAD);   return ATT_GP_REG; }
"%ebx" { OPERAND(rbx, GP_REG, DOUBLE); return ATT_GP_REG; }
"%bx"  { OPERAND(rbx, GP_REG, WORD);   return ATT_GP_REG; }
"%bh"  { OPERAND(rbx, GP_REG, HIGH);   return ATT_GP_REG; }
"%bl"  { OPERAND(rbx, GP_REG, LOW);    return ATT_GP_REG; }

"%rcx" { OPERAND(rcx, GP_REG, QUAD);   return ATT_GP_REG; }
"%ecx" { OPERAND(rcx, GP_REG, DOUBLE); return ATT_GP_REG; }
"%cx"  { OPERAND(rcx, GP_REG, WORD);   return ATT_GP_REG; }
"%ch"  { OPERAND(rcx, GP_REG, HIGH);   return ATT_GP_REG; }
"%cl"  { OPERAND(rcx, GP_REG, LOW);    return ATT_GP_REG; }

"%rdx" { OPERAND(rdx, GP_REG, QUAD);   return ATT_GP_REG; }
"%edx" { OPERAND(rdx, GP_REG, DOUBLE); return ATT_GP_REG; }
"%dx"  { OPERAND(rdx, GP_REG, WORD);   return ATT_GP_REG; }
"%dh"  { OPERAND(rdx, GP_REG, HIGH);   return ATT_GP_REG; }
"%dl"  { OPERAND(rdx, GP_REG, LOW);    return ATT_GP_REG; }

"%r8"   { OPERAND(r8, GP_REG, QUAD);   return ATT_GP_REG; }
"%r8d"  { OPERAND(r8, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r8w"  { OPERAND(r8, GP_REG, WORD);   return ATT_GP_REG; }
"%r8b"  { OPERAND(r8, GP_REG, LOW);    return ATT_GP_REG; }

"%r9"   { OPERAND(r9, GP_REG, QUAD);   return ATT_GP_REG; }
"%r9d"  { OPERAND(r9, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r9w"  { OPERAND(r9, GP_REG, WORD);   return ATT_GP_REG; }
"%r9b"  { OPERAND(r9, GP_REG, LOW);    return ATT_GP_REG; }

"%r10"   { OPERAND(r10, GP_REG, QUAD);   return ATT_GP_REG; }
"%r10d"  { OPERAND(r10, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r10w"  { OPERAND(r10, GP_REG, WORD);   return ATT_GP_REG; }
"%r10b"  { OPERAND(r10, GP_REG, LOW);    return ATT_GP_REG; }

"%r11"   { OPERAND(r11, GP_REG, QUAD);   return ATT_GP_REG; }
"%r11d"  { OPERAND(r11, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r11w"  { OPERAND(r11, GP_REG, WORD);   return ATT_GP_REG; }
"%r11b"  { OPERAND(r11, GP_REG, LOW);    return ATT_GP_REG; }

"%r12"   { OPERAND(r12, GP_REG, QUAD);   return ATT_GP_REG; }
"%r12d"  { OPERAND(r12, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r12w"  { OPERAND(r12, GP_REG, WORD);   return ATT_GP_REG; }
"%r12b"  { OPERAND(r12, GP_REG, LOW);    return ATT_GP_REG; }

"%r13"   { OPERAND(r13, GP_REG, QUAD);   return ATT_GP_REG; }
"%r13d"  { OPERAND(r13, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r13w"  { OPERAND(r13, GP_REG, WORD);   return ATT_GP_REG; }
"%r13b"  { OPERAND(r13, GP_REG, LOW);    return ATT_GP_REG; }

"%r14"   { OPERAND(r14, GP_REG, QUAD);   return ATT_GP_REG; }
"%r14d"  { OPERAND(r14, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r14w"  { OPERAND(r14, GP_REG, WORD);   return ATT_GP_REG; }
"%r14b"  { OPERAND(r14, GP_REG, LOW);    return ATT_GP_REG; }

"%r15"   { OPERAND(r15, GP_REG, QUAD);   return ATT_GP_REG; }
"%r15d"  { OPERAND(r15, GP_REG, DOUBLE); return ATT_GP_REG; }
"%r15w"  { OPERAND(r15, GP_REG, WORD);   return ATT_GP_REG; }
"%r15b"  { OPERAND(r15, GP_REG, LOW);    return ATT_GP_REG; }

"%rsp"  { OPERAND(rsp, GP_REG, QUAD);   return ATT_GP_REG; }
"%esp"  { OPERAND(rsp, GP_REG, DOUBLE); return ATT_GP_REG; }
"%sp"   { OPERAND(rsp, GP_REG, WORD);   return ATT_GP_REG; }
"%spl"  { OPERAND(rsp, GP_REG, LOW);    return ATT_GP_REG; }

"%rbp"  { OPERAND(rbp, GP_REG, QUAD);   return ATT_GP_REG; }
"%ebp"  { OPERAND(rbp, GP_REG, DOUBLE); return ATT_GP_REG; }
"%bp"   { OPERAND(rbp, GP_REG, WORD);   return ATT_GP_REG; }
"%bpl"  { OPERAND(rbp, GP_REG, LOW);    return ATT_GP_REG; }

"%rsi"  { OPERAND(rsi, GP_REG, QUAD);   return ATT_GP_REG; }
"%esi"  { OPERAND(rsi, GP_REG, DOUBLE); return ATT_GP_REG; }
"%si"   { OPERAND(rsi, GP_REG, WORD);   return ATT_GP_REG; }
"%sil"  { OPERAND(rsi, GP_REG, LOW);    return ATT_GP_REG; }

"%rdi"  { OPERAND(rdi, GP_REG, QUAD);   return ATT_GP_REG; }
"%edi"  { OPERAND(rdi, GP_REG, DOUBLE); return ATT_GP_REG; }
"%di"   { OPERAND(rdi, GP_REG, WORD);   return ATT_GP_REG; }
"%dil"  { OPERAND(rdi, GP_REG, LOW);    return ATT_GP_REG; }


"1"/")" { OPERAND(TIMES_1, SCALE, FIXED); return ATT_SCALE; }
"2"/")" { OPERAND(TIMES_2, SCALE, FIXED); return ATT_SCALE; }
"4"/")" { OPERAND(TIMES_4, SCALE, FIXED); return ATT_SCALE; }
"8"/")" { OPERAND(TIMES_8, SCALE, FIXED); return ATT_SCALE; }


"-"?"0x"[0-9a-f]+ { OPERAND(to_imm(yytext, false), IMM, DOUBLE); return ATT_IMM; }
"-"?[0-9]+ { OPERAND(to_imm(yytext, true), IMM, DOUBLE); return ATT_IMM; }
"$""-"?"0x"[0-9a-f]+ { OPERAND(to_imm(yytext+1, false), IMM, to_imm_width(yytext+1, false)); return ATT_IMM; }
"$""-"?[0-9]+ { OPERAND(to_imm(yytext+1, true), IMM, to_imm_width(yytext+1, true)); return ATT_IMM; }

"."[a-zA-Z][0-9a-zA-Z_]* { OPERAND(to_label(yytext+1), LABEL, FIXED); return ATT_LABEL; }

"%xmm0"  { OPERAND(xmm0,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm1"  { OPERAND(xmm1,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm2"  { OPERAND(xmm2,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm3"  { OPERAND(xmm3,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm4"  { OPERAND(xmm4,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm5"  { OPERAND(xmm5,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm6"  { OPERAND(xmm6,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm7"  { OPERAND(xmm7,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm8"  { OPERAND(xmm8,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm9"  { OPERAND(xmm9,  XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm10" { OPERAND(xmm10, XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm11" { OPERAND(xmm11, XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm12" { OPERAND(xmm12, XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm13" { OPERAND(xmm13, XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm14" { OPERAND(xmm14, XMM_REG, OCT); return ATT_XMM_REG; }
"%xmm15" { OPERAND(xmm15, XMM_REG, OCT); return ATT_XMM_REG; }

"%mm0" { OPERAND(mm0, MMX_REG, QUAD); return ATT_MMX_REG; }
"%mm1" { OPERAND(mm1, MMX_REG, QUAD); return ATT_MMX_REG; }
"%mm2" { OPERAND(mm2, MMX_REG, QUAD); return ATT_MMX_REG; }
"%mm3" { OPERAND(mm3, MMX_REG, QUAD); return ATT_MMX_REG; }
"%mm4" { OPERAND(mm4, MMX_REG, QUAD); return ATT_MMX_REG; }
"%mm5" { OPERAND(mm5, MMX_REG, QUAD); return ATT_MMX_REG; }
"%mm6" { OPERAND(mm6, MMX_REG, QUAD); return ATT_MMX_REG; }
"%mm7" { OPERAND(mm7, MMX_REG, QUAD); return ATT_MMX_REG; }

"%st"    { OPERAND(st0, FP_REG, QUAD); return ATT_FP_REG; }
"%st(0)" { OPERAND(st0, FP_REG, QUAD); return ATT_FP_REG; }
"%st(1)" { OPERAND(st1, FP_REG, QUAD); return ATT_FP_REG; }
"%st(2)" { OPERAND(st2, FP_REG, QUAD); return ATT_FP_REG; }
"%st(3)" { OPERAND(st3, FP_REG, QUAD); return ATT_FP_REG; }
"%st(4)" { OPERAND(st4, FP_REG, QUAD); return ATT_FP_REG; }
"%st(5)" { OPERAND(st5, FP_REG, QUAD); return ATT_FP_REG; }
"%st(6)" { OPERAND(st6, FP_REG, QUAD); return ATT_FP_REG; }
"%st(7)" { OPERAND(st7, FP_REG, QUAD); return ATT_FP_REG; }

"repz retq" { yylval.str = new string("retq"); return ATT_OPCODE; }
[a-zA-Z_]+  { STRING(); return ATT_OPCODE; }

. { yyterminate(); }

%%