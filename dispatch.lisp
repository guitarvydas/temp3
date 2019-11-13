(in-package :e/dispatch)

(defparameter *all-parts* nil)

(defun reset ()
  (setf *all-parts* nil))

(defun all-parts-have-empty-input-queues-p ()
  (dolist (part *all-parts*)
    (unless (e/part::input-queue part)
      (return-from all-parts-have-empty-input-queues-p nil)))
  t)


(defmethod memo-part ((part e/part:part))
  (e/util:ensure-not-in-list *all-parts* part
                             "part ~S already on dispatcher list" (e/part::name part))
  (push part *all-parts*))

(defun dispatch-single-input ()
  (dolist (part *all-parts*)
    (when (e/part::input-queue part)
      (let ((event (pop (e/part::input-queue part))))
        (funcall (e/part::input-handler part) part event)
        (return-from-dispatch-single-input part))))
  (assert nil)) ;; can't happen

(defun dispatch-output-queues ()
  (dolist (part *all-parts*)
    (when (e/part::output-queue part)
      (let ((out-list (e/part::output-queue part)))
        (setf (e/part::output-queue part) nil)
        (dolist (out-event out-list)
          (let ((out-pin (e/event::pin out-event))
                (data (e/event::data out-event)))
            lookup out-pin in sources
            send out-event through source