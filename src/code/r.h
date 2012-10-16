#ifndef X64_SRC_CODE_R_H
#define X64_SRC_CODE_R_H

#include <vector>

#include "src/code/operand.h"

namespace x64 {

class R {
	public:
		inline R() 
				: g_(16) { 
		}
		
		inline R(Operand g) 
				: g_(g) { 
		}

		inline operator Operand() const {
			return g_;
		}

		inline bool is_null() const {
			return g_ >= 16;
		}

	private:
		Operand g_;
};

class R8 : public R {
	public:
		inline R8() : R() { }
		inline R8(Operand o) : R(o) { }
		
		typedef const std::vector<R8>::const_iterator iterator;

		static iterator begin() { return domain_.begin(); }
		static iterator end()   { return domain_.end(); }

	private:
		static const std::vector<R8> domain_;
};

class RH : public R {
	public:
		inline RH() : R() { }
		inline RH(Operand o) : R(o) { }
		
		inline bool is_null() const { return (Operand)*this < 4; }

		typedef const std::vector<RH>::const_iterator iterator;

		static iterator begin() { return domain_.begin(); }
		static iterator end()   { return domain_.end(); }

	private:
		static const std::vector<RH> domain_;
};

class R16 : public R {
	public:
		inline R16() : R() { }
		inline R16(Operand o) : R(o) { }
		
		typedef const std::vector<R16>::const_iterator iterator;

		static iterator begin() { return domain_.begin(); }
		static iterator end()   { return domain_.end(); }

	private:
		static const std::vector<R16> domain_;
};

class R32 : public R {
	public:
		inline R32() : R() { }
		inline R32(Operand o) : R(o) { }
		
		typedef const std::vector<R32>::const_iterator iterator;

		static iterator begin() { return domain_.begin(); }
		static iterator end()   { return domain_.end(); }

	private:
		static const std::vector<R32> domain_;
};

class R64 : public R {
	public:
		inline R64() : R() { }
		inline R64(Operand o) : R(o) { }
		
		typedef const std::vector<R64>::const_iterator iterator;

		static iterator begin() { return domain_.begin(); }
		static iterator end()   { return domain_.end(); }

	private:
		static const std::vector<R64> domain_;
};

class Al : public R8 {
	public:
		inline Al() : R8() { }
		inline Al(Operand o) : R8(o) { }

		inline bool is_null() const { return (Operand)*this != 0; }
};

class Cl : public R8 {
	public:
		inline Cl() : R8() { }
		inline Cl(Operand o) : R8(o) { }

		inline bool is_null() const { return (Operand)*this != 0; }
};

class Ax : public R16 {
	public:
		inline Ax() : R16() { }
		inline Ax(Operand o) : R16(o) { }

		inline bool is_null() const { return (Operand)*this != 0; }
};

class Eax : public R32 {
	public:
		inline Eax() : R32() { }
		inline Eax(Operand o) : R32(o) { }

		inline bool is_null() const { return (Operand)*this != 0; }
};

class Rax : public R64 {
	public:
		inline Rax() : R64() { }
		inline Rax(Operand o) : R64(o) { }

		inline bool is_null() const { return (Operand)*this != 0; }
};

extern const Rax rax;
extern const R64 rcx;
extern const R64 rdx;
extern const R64 rbx;
extern const R64 rsp;
extern const R64 rbp;
extern const R64 rsi;
extern const R64 rdi;
extern const R64 r8;
extern const R64 r9;
extern const R64 r10;
extern const R64 r11;
extern const R64 r12;
extern const R64 r13;
extern const R64 r14;
extern const R64 r15;

extern const Eax eax;
extern const R32 ecx;
extern const R32 edx;
extern const R32 ebx;
extern const R32 esp;
extern const R32 ebp;
extern const R32 esi;
extern const R32 edi;
extern const R32 r8d;
extern const R32 r9d;
extern const R32 r10d;
extern const R32 r11d;
extern const R32 r12d;
extern const R32 r13d;
extern const R32 r14d;
extern const R32 r15d;

extern const Ax ax;
extern const R16 cx;
extern const R16 dx;
extern const R16 bx;
extern const R16 sp;
extern const R16 bp;
extern const R16 si;
extern const R16 di;
extern const R16 r8w;
extern const R16 r9w;
extern const R16 r10w;
extern const R16 r11w;
extern const R16 r12w;
extern const R16 r13w;
extern const R16 r14w;
extern const R16 r15w;

extern const Al al;
extern const Cl cl;
extern const R8 dl;
extern const R8 bl;
extern const R8 spl;
extern const R8 bpl;
extern const R8 sil;
extern const R8 dil;
extern const R8 r8b;
extern const R8 r9b;
extern const R8 r10b;
extern const R8 r11b;
extern const R8 r12b;
extern const R8 r13b;
extern const R8 r14b;
extern const R8 r15b;

extern const R8 ah;
extern const R8 ch;
extern const R8 dh;
extern const R8 bh;

extern const R r_null;

} // namespace x64

#endif