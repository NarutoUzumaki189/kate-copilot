#pragma once

#include <KTextEditor/Plugin>
#include <KTextEditor/MainWindow>
#include <KActionCollection>
#include <QObject>

class CopilotPlugin : public KTextEditor::Plugin
{
    Q_OBJECT
public:
    explicit CopilotPlugin(QObject* parent = nullptr, const QVariantList& args = {});
    ~CopilotPlugin() override;
    QObject* createView(KTextEditor::MainWindow* mainWindow) override;
};
