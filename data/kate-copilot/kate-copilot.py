# kate-copilot.py - Craft Blueprint for your plugin
print("✅ Craft loaded kate-copilot blueprint!")

import info
from CraftCore import CraftCore
from Package.CMakePackageBase import *
import os


class subinfo(info.infoclass):

    def setTargets(self):
        self.description = "Copilot-style AI assistant for Kate editor"
        self.targets["master"] = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../"))
        self.targetInstSrc["master"] = "src"
        self.defaultTarget = "master"

    def setDependencies(self):
        self.buildDependencies["libs/qt/qtbase"] = None
        self.buildDependencies["kde/frameworks/ktexteditor"] = None
        self.buildDependencies["kde/frameworks/extra-cmake-modules"] = None


class Package(CMakePackageBase):
    def __init__(self):
        CMakePackageBase.__init__(self)

