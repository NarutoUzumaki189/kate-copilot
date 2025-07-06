#include "CopilotView.h"

#include <KLocalizedString>
#include <KTextEditor/View>
#include <QMessageBox>

CopilotView::CopilotView(QObject *plugin, KTextEditor::MainWindow *mainWindow)
    : QObject(mainWindow)
    , KXMLGUIClient()
    , m_mainWindow(mainWindow)
{
    setComponentName(QStringLiteral("kate-copilot"), i18n("Copilot"));
    setXMLFile(QStringLiteral("CopilotPlugin.xml"));
}

CopilotView::~CopilotView() = default;

void CopilotView::suggest()
{
    if (!m_mainWindow)
        return;

    KTextEditor::View *activeView = m_mainWindow->activeView();
    if (!activeView) {
        QMessageBox::information(nullptr, i18n("Copilot"), i18n("No active editor view."));
        return;
    }

    // Placeholder: In a real plugin, here you would call Copilot APIs and show results.
    QMessageBox::information(activeView->window(), i18n("Copilot Suggestion"), i18n("Copilot suggestion would appear here."));
}
