package com.unhurdle.spectrum.utils
{
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.geom.Point;
    import org.apache.royale.utils.PointUtils;
    import org.apache.royale.utils.UIUtils;

    public function localToPopUpHost(point:Point, target:IUIBase):Point
    {
        COMPILE::SWF
        {
            return PointUtils.localToGlobal(point, target);
        }
        COMPILE::JS
        {
            var host:IPopUpHost = UIUtils.findPopUpHost(target);
            var hostOrigin:Point = PointUtils.localToViewport(new Point(), host.popUpParent);
            var viewportPoint:Point = PointUtils.localToViewport(point, target);
            viewportPoint.x -= hostOrigin.x;
            viewportPoint.y -= hostOrigin.y;
            return viewportPoint;
        }
    }
}