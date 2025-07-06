cmake_minimum_required(VERSION 3.16)
project(kate-copilot)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(ECMQtDeclareLoggingCategory)

find_package(Qt5 REQUIRED COMPONENTS Core Widgets)
find_package(KF5 REQUIRED COMPONENTS TextEditor I18n)

add_library(katecopilot MODULE
    src/CopilotPlugin.cpp
    src/CopilotView.cpp
)

target_link_libraries(katecopilot
    KF5::TextEditor
    KF5::I18n
)

install(TARGETS katecopilot DESTINATION ${KDE_INSTALL_PLUGINDIR}/ktexteditor)
install(FILES metadata.json DESTINATION ${KDE_INSTALL_KSERVICES5DIR})
