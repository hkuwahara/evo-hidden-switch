#if !defined(HAVE_DLL_SCOPE)
#define HAVE_DLL_SCOPE

/*
#if defined(WIN32)
#define STDCALL __stdcall
#if defined(DLL_EXPORT)
#define DLLSCOPE __declspec(dllexport)
#else
#define DLLSCOPE __declspec(dllimport)
#endif
#else
#define STDCALL  
#define DLLSCOPE extern
#endif
*/
#define STDCALL  
#define DLLSCOPE extern

#endif
