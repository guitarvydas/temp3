(in-package :e/dispatch)

(defparameter *all-parts* nil)

(defun reset ()
  (setf *all-parts* nil))

(defun all-parts-have-empty-input-queues-p ()
  (dolist (part *all-parts*)
    (when (e/part::input-queue part)
      (return-from all-parts-have-empty-input-queues-p nil)))
  t)


(defmethod memo-part ((part e/part:part))
  (e/util:ensure-not-in-list *all-parts* part #'equal
                             "part ~S already on dispatcher list" (e/part::name part))
  (push part *all-parts*))

(defun dispatch-single-input ()
  (dolist (part *all-parts*)
    (when (e/part::input-queue part)
      (let ((event (pop (e/part::input-queue part))))
        (funcall (e/part::input-handler part) part event)
        (return-from dispatch-single-input part))))
  (assert nil)) ;; can't happen

(defun dispatch-output-queues ()
  (dolist (part *all-parts*)
    (when (e/part:output-queue part)
      (let ((out-list (e/part:output-queue part)))
        (setf (e/part::output-queue part) nil)
        (dolist (out-event out-list)
          (let ((out-pin (e/event:pin out-event))
                (data (e/event:data out-event)))
            (let ((s (e/schematic::lookup-source (e/part:parent-schem part) part out-pin)))
              (if (null s)
                  ;; source can be null if this is the top-most part (a schematic)
                  (format *standard-output* "~&part ~S outputs /~S/ on pin /~S/~%"
                          (e/part:name part) data out-pin)
                (let ((wire (e/source:wire s)))
                  (dolist (receiver (e/wire::receivers wire))
                    (e/receiver::deliver-event receiver out-event)))))))))))

(defun run-first-times ()
  (dolist (part *all-parts*)
    (let ((fn (e/part:first-time-handler part)))
      (when fn
        (funcall fn part)))))
