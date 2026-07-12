package com.unhurdle.spectrum.utils
{
    COMPILE::JS
    public class PointerDrag
    {
        public function PointerDrag(target:HTMLElement, startHandler:Function, moveHandler:Function, endHandler:Function, touchAction:String)
        {
            _target = target;
            _startHandler = startHandler;
            _moveHandler = moveHandler;
            _endHandler = endHandler;
            _target.style.touchAction = touchAction;
            _target.addEventListener("pointerdown", handlePointerDown);
        }

        private var _target:HTMLElement;
        private var _startHandler:Function;
        private var _moveHandler:Function;
        private var _endHandler:Function;
        private var _pointerId:Number = -1;
        private var _enabled:Boolean = true;

        public function get enabled():Boolean
        {
            return _enabled;
        }

        public function set enabled(value:Boolean):void
        {
            if (_enabled == value) {
                return;
            }
            _enabled = value;
            if (!value) {
                cancel();
            }
        }

        public function dispose():void
        {
            cancel();
            _target.removeEventListener("pointerdown", handlePointerDown);
        }

        private function handlePointerDown(event:*):void
        {
            if (!_enabled || _pointerId >= 0 || event.isPrimary === false || event.button != 0) {
                return;
            }
            if (_startHandler(event) === false) {
                return;
            }
            _pointerId = event.pointerId;
            _target.addEventListener("pointermove", handlePointerMove);
            _target.addEventListener("pointerup", handlePointerUp);
            _target.addEventListener("pointercancel", handlePointerCancel);
            _target.addEventListener("lostpointercapture", handleLostPointerCapture);
            _target["setPointerCapture"](_pointerId);
            _moveHandler(event);
        }

        private function handlePointerMove(event:*):void
        {
            if (event.pointerId == _pointerId) {
                _moveHandler(event);
            }
        }

        private function handlePointerUp(event:*):void
        {
            if (event.pointerId == _pointerId) {
                finish(event, false);
            }
        }

        private function handlePointerCancel(event:*):void
        {
            if (event.pointerId == _pointerId) {
                finish(event, true);
            }
        }

        private function handleLostPointerCapture(event:*):void
        {
            if (event.pointerId == _pointerId) {
                finish(event, true);
            }
        }

        private function cancel():void
        {
            if (_pointerId >= 0) {
                finish(null, true);
            }
        }

        private function finish(event:*, cancelled:Boolean):void
        {
            var pointerId:Number = _pointerId;
            _pointerId = -1;
            _target.removeEventListener("pointermove", handlePointerMove);
            _target.removeEventListener("pointerup", handlePointerUp);
            _target.removeEventListener("pointercancel", handlePointerCancel);
            _target.removeEventListener("lostpointercapture", handleLostPointerCapture);
            if (_target["hasPointerCapture"](pointerId)) {
                _target["releasePointerCapture"](pointerId);
            }
            _endHandler(event, cancelled);
        }
    }
}