unit TessAPI;

interface
uses
  Windows;

{$Z4}

type
  PPixColormap = ^PixColormap;
  PixColormap = record
    _array: Pointer;
    depth: Integer;
    nalloc: Integer;
    n: Integer;
  end;
  PIXCMAP = PixColormap;

  PPix = ^Pix;
  Pix = record
    w,
    h,
    d,
    spp,
    wpl,
    refcount: Cardinal;
    xres,
    yres,
    informat,
    special: Integer;
    text: PAnsiChar;
    colormap: PPixColormap;
    data: PCardinal;
  end;


function pixRead(filename: PAnsiChar): PPix; cdecl;
function pixReadMem(MemPtr: Pointer;len:integer): PPix; cdecl;
procedure pixDestroy(var APix: PPix); cdecl;

type
  TessBaseAPI = Pointer;

  TessOcrEngineMode = (OEM_TESSERACT_ONLY, OEM_LSTM_ONLY, OEM_TESSERACT_LSTM_COMBINED, OEM_DEFAULT);



function TessVersion: PAnsiChar;

//----------------------------------------------------- Base API -----------------------------------------------------//
function TessBaseAPICreate: TessBaseAPI;
procedure TessBaseAPIDelete(handle: TessBaseAPI); cdecl;
//TESS_API void  TESS_CALL TessDeleteText(char* text);
procedure TessDeleteText(text: PAnsiChar); cdecl;


//TESS_API int   TESS_CALL TessBaseAPIInit(TessBaseAPI* handle, const char* datapath, const char* language,
//                                         TessOcrEngineMode mode, char** configs, int configs_size,
//                                         const STRING* vars_vec, size_t vars_vec_size,
//                                         const STRING* vars_values, size_t vars_values_size, BOOL set_only_init_params);
function TessBaseAPIInit(handle: TessBaseAPI; datapath: PAnsiChar; language: PAnsiChar; mode: TessOcrEngineMode; configs: PAnsiChar;
  configs_size: Integer; vars_vec: PAnsiChar; vars_vec_size: NativeUInt; vars_values: PAnsiChar; vars_values_size: NativeUInt;
  set_only_init_params: BOOL): Integer; cdecl;

//TESS_API int   TESS_CALL TessBaseAPIInit1(TessBaseAPI* handle, const char* datapath, const char* language, TessOcrEngineMode oem,
//                                          char** configs, int configs_size);
function TessBaseAPIInit1(handle: TessBaseAPI; datapath: PAnsiChar; language: PAnsiChar; mode: TessOcrEngineMode; configs: PAnsiChar;
  configs_size: Integer): Integer; cdecl;

//TESS_API int   TESS_CALL TessBaseAPIInit2(TessBaseAPI* handle, const char* datapath, const char* language, TessOcrEngineMode oem);
function TessBaseAPIInit2(handle: TessBaseAPI; datapath: PAnsiChar; language: PAnsiChar; mode: TessOcrEngineMode): Integer; cdecl;

//TESS_API int   TESS_CALL TessBaseAPIInit3(TessBaseAPI* handle, const char* datapath, const char* language);
function TessBaseAPIInit3(handle: TessBaseAPI; datapath: PAnsiChar; language: PAnsiChar): Integer; cdecl;

//TESS_API int TESS_CALL TessBaseAPIInit4(TessBaseAPI* handle, const char* datapath, const char* language, TessOcrEngineMode mode,
//    char** configs, int configs_size,
//    char** vars_vec, char** vars_values, size_t vars_vec_size,
//    BOOL set_only_non_debug_params);
function TessBaseAPIInit4(handle: TessBaseAPI; datapath: PAnsiChar; language: PAnsiChar; mode: TessOcrEngineMode;
  configs: PPAnsiChar; configs_size: Integer; vars_vec: PPAnsiChar; vars_values: PPAnsiChar; vars_vec_size: NativeUInt;
  set_only_non_debug_params: BOOL): Integer; cdecl;

//TESS_API void  TESS_CALL TessBaseAPISetImage(TessBaseAPI* handle, const unsigned char* imagedata, int width, int height,
//                                             int bytes_per_pixel, int bytes_per_line);
procedure TessBaseAPISetImage(handle: TessBaseAPI; imagedata: PAnsiChar; width, height, bytes_per_pixel, bytes_per_line: Integer); cdecl;

//TESS_API void  TESS_CALL TessBaseAPISetImage2(TessBaseAPI* handle, struct Pix* pix);
procedure TessBaseAPISetImage2(handle: TessBaseAPI; APix: PPix); cdecl;

//TESS_API char* TESS_CALL TessBaseAPIGetUTF8Text(TessBaseAPI* handle);
function TessBaseAPIGetUTF8Text(handle: TessBaseAPI): PAnsiChar; cdecl;

//TESS_API void  TESS_CALL TessBaseAPIClear(TessBaseAPI* handle);
//TESS_API void  TESS_CALL TessBaseAPIEnd(TessBaseAPI* handle);
procedure TessBaseAPIEnd(handle: TessBaseAPI);


implementation
const
  TESS_DLL = 'libtesseract-5.dll';
  LEPT_DLL = 'liblept-5.dll';


function pixRead; external LEPT_DLL name 'pixRead';
function pixReadMem; external LEPT_DLL name 'pixReadMem';
procedure pixDestroy; external LEPT_DLL name 'pixDestroy';
function TessVersion; external TESS_DLL name 'TessVersion';
function TessBaseAPICreate; external TESS_DLL name 'TessBaseAPICreate';
procedure TessBaseAPIDelete; external TESS_DLL name 'TessBaseAPIDelete';
procedure TessDeleteText; external TESS_DLL name 'TessDeleteText';
function TessBaseAPIInit; external TESS_DLL name 'TessBaseAPIInit';
function TessBaseAPIInit1; external TESS_DLL name 'TessBaseAPIInit1';
function TessBaseAPIInit2; external TESS_DLL name 'TessBaseAPIInit2';
function TessBaseAPIInit3; external TESS_DLL name 'TessBaseAPIInit3';
function TessBaseAPIInit4; external TESS_DLL name 'TessBaseAPIInit4';
procedure TessBaseAPISetImage; external TESS_DLL name 'TessBaseAPISetImage';
procedure TessBaseAPISetImage2; external TESS_DLL name 'TessBaseAPISetImage2';
function TessBaseAPIGetUTF8Text; external TESS_DLL name 'TessBaseAPIGetUTF8Text';
procedure TessBaseAPIEnd; external TESS_DLL name 'TessBaseAPIEnd';

end.
