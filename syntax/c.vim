" -----------------------------------------------------------------------------
"  Highlight function names.
" -----------------------------------------------------------------------------
if !exists('g:cpp_no_function_highlight')
    syn match    cCustomParen    transparent "(" contains=cParen contains=cCppParen
    syn match    cCustomFunc     "\w\+\s*(\@=" contains=cCustomParen
    hi def link cCustomFunc  Function
endif

if exists('g:cpp_member_variable_highlight') && g:cpp_member_variable_highlight
    syn match   cCustomDot    "\." contained
    syn match   cCustomPtr    "->" contained
    syn match   cCustomMemVar "\(\.\|->\)\h\w*" contains=cCustomDot,cCustomPtr
    hi def link cCustomMemVar Function
endif

syn keyword   cTodo   contained    TODO FIXME MARK NOTE


syn keyword cType const

syn keyword cType u64
syn keyword cType u32
syn keyword cType u16
syn keyword cType u8

syn keyword cType s64
syn keyword cType s32
syn keyword cType s16
syn keyword cType s8

syn keyword cType __m64
syn keyword cType __m128
syn keyword cType __m256
syn keyword cType __m512

syn keyword cType b32
syn keyword cType b16
syn keyword cType b8

syn keyword cType f64
syn keyword cType f32

syn keyword cType ptrsize 

syn keyword cType m32 
syn keyword cType m64

syn keyword cStorageClass _restrict
syn keyword cStorageClass _align
syn keyword cStorageClass _packed


syn keyword cStorageClass _intern
syn keyword cStorageClass _global
syn keyword cStorageClass _persist
syn keyword cStorageClass _ainline
syn keyword cStorageClass _dllexport
syn keyword cStorageClass _winapi

syn keyword cOperator _dprint
syn keyword cOperator _compile_kill
syn keyword cOperator _break
syn keyword cOperator _kill
