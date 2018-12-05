#!/bin/bash
#默认为debug方式
if [ 0 -eq $# ]
then
   cmds=release
else
   cmds=$@
fi

make_func()
{
   if [ ! -d "depend" ]
   then
      mkdir "depend"
   fi

   if [ ! -d "obj" ]
   then
      mkdir "obj"
   fi

   for target in ${targets}
   do
        for cmd in $@
        do
            #支持默认目标文件
            export STARGET=${target} 
            export SOBJS="`eval echo '$'{${target}_objs'}'`"
            if [ -z "${SOBJS}" ]
            then
                export   SOBJS="${target}.o"
            fi

            export SLIBS="`eval echo '$'{${target}_libs'}'`" 
            export SINCLUDEPATH="`eval echo '$'{${target}_include_path'}'`"
            if [ ${targetType} = "dynamic" ]; then
                export DLFLAG_OBJ:=-fPIC
            fi

            if [ "clean" = ${cmd} ]
            then
               make -f ${MKHOME}/mkcore.mak ${cmd} 
            elif [ "release" = ${cmd} ]
            then
                export CXXFLAGS="-O3 -g"
                cmd=${cmd}${targetType}
                make -f ${MKHOME}/mkcore.mak ${cmd}
            else
                export CXXFLAGS="-ggdb3 -fno-inline-small-functions"
                cmd=debug${targetType}
                make -f ${MKHOME}/mkcore.mak ${cmd}
            fi
        done
        if [[ $cmd =~ "release" ]]; then
            preFix=${PRONAME}/bin/
            if [ ${targetType} = "dynamic" ]; then
                suffix=".so"
                preFix=${PRONAME}/lib/lib
            elif [ ${targetType} = "static" ]; then
                suffix=".a"
                preFix=${PRONAME}/lib/lib
                echo strip ${preFix}${target}${suffix}
            else
                echo strip ${preFix}${target}
            fi
        fi
   done
}

for cmd in ${cmds}
do
   make_func ${cmd}
done
