#include <QApplication>
#include <QStyle>
#include <QSystemTrayIcon>

#ifdef Q_OS_MACOS
extern void macos_installSystemTrayIconRightClickHandler();
#endif

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QSystemTrayIcon sti(app.style()->standardIcon(QStyle::SP_DesktopIcon));
    sti.setVisible(true);
    QObject::connect(&sti, &QSystemTrayIcon::activated, [](QSystemTrayIcon::ActivationReason reason){
       qDebug("from slot: %d", reason);
    });
#ifdef Q_OS_MACOS
    macos_installSystemTrayIconRightClickHandler();
#endif

    return app.exec();
}
