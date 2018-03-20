#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#include <Qt>

static IMP _originalImp = NULL;

void swizzle_triggerSelectorButton(id self, SEL _cmd, id sender, Qt::MouseButton mouseButton) {
    qDebug("from native: %d", mouseButton);
    if (mouseButton == Qt::RightButton)
    {
        // handle RMB click
    }
    _originalImp(self, _cmd, sender, mouseButton); // call original method, you might want to prevent this for RMB click
}

void macos_installSystemTrayIconRightClickHandler()
{
    if (_originalImp)
        return;

    // relies on private implementation, see qcocoasystemtrayicon.mm
    Class QNSStatusItemClass = objc_lookUpClass("QNSStatusItem");
    if (!QNSStatusItemClass)
        return;

    // https://blog.newrelic.com/2014/04/16/right-way-to-swizzle/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _originalImp = method_setImplementation(class_getInstanceMethod(QNSStatusItemClass, @selector(triggerSelector:button:)), (IMP)swizzle_triggerSelectorButton);
    });
}
