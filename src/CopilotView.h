#pragma once

#include <KTextEditor/MainWindow>
#include <KXMLGUIClient>
#include <QObject>
#include <QPointer>

/**
 * @brief The CopilotView class
 * This class represents the per-window view part of the Copilot plugin.
 * It inherits from QObject for signal/slot, and KXMLGUIClient for action/menu integration.
 */
class CopilotView : public QObject, public KXMLGUIClient
{
    Q_OBJECT

public:
    explicit CopilotView(QObject *plugin, KTextEditor::MainWindow *mainWindow);
    ~CopilotView() override;

public slots:
    void suggest();

private:
    QPointer<KTextEditor::MainWindow> m_mainWindow;
};
