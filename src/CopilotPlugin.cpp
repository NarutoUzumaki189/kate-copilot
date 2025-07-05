#include "CopilotPlugin.h"

#include <KTextEditor/View>
#include <KTextEditor/Document>
#include <KTextEditor/MainWindow>
#include <KLocalizedString>
#include <KPluginFactory>
#include <QAction>
#include <QMessageBox>

K_PLUGIN_FACTORY_WITH_JSON(CopilotPluginFactory, "metadata.json", registerPlugin<CopilotPlugin>();)

CopilotPlugin::CopilotPlugin(QObject* parent, const QVariantList& args)
: KTextEditor::Plugin(parent)
{
    Q_UNUSED(args)
}

QObject* CopilotPlugin::createView(KTextEditor::MainWindow* mainWindow)
{
    auto* action = new QAction(i18n("Copilot Suggest"), mainWindow);
    action->setToolTip(i18n("Send current document to AI for suggestions"));
    action->setShortcut(QKeySequence(Qt::CTRL + Qt::Key_L));

    mainWindow->actionCollection()->addAction(QStringLiteral("copilot_suggest"), action);

    connect(action, &QAction::triggered, mainWindow, [mainWindow]() {
        auto* view = mainWindow->activeView();
        if (!view) return;

        QString content = view->document()->text();
        QMessageBox::information(nullptr, "Copilot", "Pretending to send:\n" + content.left(100));

        // TODO: Call AI API and insert result
    });

    return nullptr;
}

#include "CopilotPlugin.moc"
