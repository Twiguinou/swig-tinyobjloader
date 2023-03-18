%module(directors="1") TinyOBJLoader

%include <arrays_java.i>
%include <std_string.i>
%include <std_vector.i>
%include <std_map.i>

%apply unsigned long { void * };

%define ENABLE_SIZED_BUFFER_MAPPER(NATIVE_T, JAVA_T, SIZE)
%typemap(jtype) NATIVE_T * "JAVA_T"
%typemap(jstype) NATIVE_T * "JAVA_T"
%typemap(jni) NATIVE_T * "jobject"
%typemap(javain,
    pre="
    assert $javainput.isDirect() : \"Buffer must be allocated direct.\";
    assert $javainput.capacity() >= SIZE : \"Buffer size mismatch.\";"
    ) NATIVE_T * "$javainput"
%typemap(javaout) NATIVE_T * { return $jnicall; }
%typemap(in) NATIVE_T * {

    $1 = (NATIVE_T *) jenv->GetDirectBufferAddress($input);
    if (!$1)
        SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, "Unable to get address of a direct buffer. Buffer must be direct.");

    else if (jenv->GetDirectBufferCapacity($input) < SIZE)
        SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, "Buffer entry size is incorrect.");

}
%typemap(memberin) NATIVE_T * {

    $1 = $input ? $input : 0;
}
%typemap(freearg) NATIVE_T * ""
%enddef

%define DISABLE_BUFFER_MAPPER(NATIVE_T)
%clear NATIVE_T *;
%enddef

%include "common_remap.i"
%{
#include <tiny_obj_loader.h>
%}
%include "tiny_obj_loader.h"

%template(tolUnsignedIntVector) std::vector<unsigned int>;
%template(tolIntVector) std::vector<int>;
%template(tolFloatVector) std::vector<float>;
%template(tolUnsignedCharVector) std::vector<unsigned char>;
%template(tolStringVector) std::vector<std::string>;
%template(tolTagVector) std::vector<tinyobj::tag_t>;
%template(tolSkinWeightVector) std::vector<tinyobj::skin_weight_t>;
%template(tolShapeVector) std::vector<tinyobj::shape_t>;
%template(tolMaterialVector) std::vector<tinyobj::material_t>;
%template(tolJointAndWeightVector) std::vector<tinyobj::joint_and_weight_t>;
%template(tolIndexVector) std::vector<tinyobj::index_t>;

%template(tolString2IntMap) std::map<std::string, int>;