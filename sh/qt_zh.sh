#!/bin/bash

version=5.12.6
cp /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so  ~/Qt${version}/${version}/gcc_64/plugins/platforminputcontexts

cp /usr/lib/x86_64-linux-gnu/qt5/plugins/platforminputcontexts/libfcitxplatforminputcontextplugin.so ~/Qt${version}/Tools/QtCreator/lib/Qt/plugins/platforminputcontexts
