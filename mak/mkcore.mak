RM:=rm -f
RMDIR:=rmdir
CXX:=ccache g++ -std=c++1y -Wall -static
#CXX:=g++ -std=c++1y -Wall -static -save-temps
#CC:=gcc -Wall 
AR:=ar
LD:=ld
SLFLAG:=-ruc
DLFLAG_OBJ:=-fPIC
DLFLAG_TARGET:=-shared
PROC:=proc
CP:=cp
JAVAC:=javac

#各类型文件存放路径
INCLUDEPATH:= $(SINCLUDEPATH) -I$(HOME)/usr/include
LIBOUTPATH:=$(PRONAME)/lib
BINPATH:=$(PRONAME)/bin
#BINPATH:=.
DEPENDPATH:=depend
OBJPATH:=obj
OBJS:=$(addprefix $(OBJPATH)/, $(SOBJS))
LIBS:=$(SLIBS)

#预编译选项
CPP_PROFLAGS = def_sqlcode=yes \
					sqlcheck=full \
					define=USE_PRO_C \
					prefetch=200 \
					close_on_commit=yes \
					hold_cursor=yes \
					oreclen=132 \
					code=cpp \
					mode=ansi \
					ireclen=132 \
					cpp_suffix=cpp \
					threads=yes \
					char_map=string \
					maxopencursors=60 \
					parse=partial \
					select_error=yes \
					#include=$(ORACLE_HOME)/precomp/public\
					#include=$(ORACLE_HOME)/oci/include\
					#include=$(FBASE_HOME)


#各类型文件后缀
DLFIX:=.so
SLFIX:=.a
OBJFIX:=.o
JAVAFIX:=.class

#可执行程序
EXTTARGET:=$(BINPATH)/$(STARGET)

#JAVA字节码
JAVATARGET:=$(BINPATH)/$(STARGET)$(JAVAFIX)

#动态库
DLTARGET:=$(LIBOUTPATH)/lib$(STARGET)$(DLFIX)

#静态库
SLTARGET:=$(LIBOUTPATH)/lib$(STARGET)$(SLFIX)

debugexec: $(EXTTARGET) 
debugstatic: $(SLTARGET)
debugdynamic: $(DLTARGET)
releaseexec: $(EXTTARGET) 
releasedynamic: $(DLTARGET)
releasestatic: $(SLTARGET)
debugjava:$(JAVATARGET)

$(EXTTARGET):$(OBJS)
	@echo "[$^ -> $@]"
	$(CXX) $^ $(CXXFLAGS) -o $@ $(LIBS) 

$(DLTARGET):$(OBJS)
	@echo "[$^ -> $@]"
	$(CXX) $^ $(CXXFLAGS) $(DLFLAG_TARGET) -o $@ 

#$(INCLUDEPATH)

$(SLTARGET):$(OBJS)
	@echo "[$^ -> $@]"
	$(AR) $(SLFLAG) $@ $^

.SUFFIXES:
.SUFFIXES: .c .cpp .pc .sqc .java .class .o

# 隐式推断
#$(CXX) -c $< $(DFLAG_OBJ) -o $@ $(INCLUDEPATH)

$(OBJPATH)/%.o: %.cpp $(DEPENDPATH)/%.d
	@echo "[$^ -> $@]"
	$(CXX) -c $< $(CXXFLAGS) $(DFLAG_OBJ) -o $@ $(INCLUDEPATH)


$(OBJPATH)/%.o: %.pc $(DEPENDPATH)/%.d
	@echo "[$^ -> $@]"
	$(PROC) iname=$<  oname=$(patsubst %.pc,%.cpp,$<) code=CPP mode=ANSI parse=NONE sqlcheck=FULL lines=YES
	$(CXX) -c $(patsubst %.pc,%.cpp,$<) $(CXXFLAGS) $(DFLAG_OBJ) -o $@ $(INCLUDEPATH)
	$(RM) $(patsubst %.pc,%.lis,$<) $(patsubst %.pc,%.cpp,$<)

$(DEPENDPATH)/%.d:%.pc
	@echo "[$^ -> $@]"
	$(CXX) -xc++ -MM $< -o $@ $(INCLUDEPATH)
	sed -i 's,\($*\)\.o[ :]*,\1.o $@ :,g' $@

$(DEPENDPATH)/%.d:%.cpp
	@echo "[$^ -> $@]"
	$(CXX) -MM $< -o $@ 
	sed -i 's,\($*\)\.o[ :]*,\1.o $@ :,g' $@

#$(INCLUDEPATH)

$(BINPATH)/%.class:%.java
	@echo "[$^ -> $@]"
	$(JAVAC) $< -d $(BINPATH)

sinclude $(addprefix $(DEPENDPATH)/, $(patsubst %.o, %.d, $(SOBJS)))

clean:
	$(RM) $(EXTTARGET)
	$(RM) $(SLTARGET) 
	$(RM) $(DLTARGET) 
	$(RM) $(OBJS)
	$(RM) $(addprefix $(DEPENDPATH)/, $(patsubst %.o,%.d,$(SOBJS)))
	$(RMDIR) $(OBJPATH) $(DEPENDPATH)

setdebug:
#@echo "OBJS:$(OBJS)"
#@echo "TARGET:$(EXTTARGET)"
#@echo "SLTARGET:$(SLTARGET)"
#@echo "DLTARGET:$(DLTARGET)"
#@echo "LIBS:$(LIBS)"
#@echo "INCLUDEPATH:$(INCLUDEPATH)"
#echo "$*"

setrelease:

setdynamic:
