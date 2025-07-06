/*
    SPDX-FileCopyrightText: 2025 Sivakishore Padavala <siva2thrones@gmgail.com>

    SPDX-License-Identifier: GPL-3.0-or-later
*/
#include "CopilotPlugin.h"
#include "CopilotView.h"

#include <KLocalizedString>
#include <KPluginFactory>
#include <KTextEditor/MainWindow>
#include <KActionCollection>
#include <QAction>

K_PLUGIN_FACTORY_WITH_JSON(CopilotPluginFactory, "CopilotPlugin.json", registerPlugin<CopilotPlugin>();)

CopilotPlugin::CopilotPlugin(QObject *parent, const QList<QVariant> &)
    : KTextEditor::Plugin(parent)
{
}

CopilotPlugin::~CopilotPlugin() = default;

QObject *CopilotPlugin::createView(KTextEditor::MainWindow *mainWindow)
{
    auto *view = new CopilotView(this, mainWindow);

    QAction *action = new QAction(i18n("Suggest with Copilot"), view);

    // Register the action on the CopilotView's own actionCollection
    view->actionCollection()->addAction(QStringLiteral("copilot_suggest"), action);

    connect(action, &QAction::triggered, view, &CopilotView::suggest);

    return view;
}

#include "CopilotPlugin.moc"
