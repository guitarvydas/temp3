(in-package :e/source)

(defclass source ()
  ((part :accessor part :initarg :part)
   (pin  :accessor pin  :initarg :pin)
   (wire :accessor wire :initarg :wire)))

(defun new-source (&key (part nil) (pin nil) (wire nil))
  (make-instance 'source :part part :pin pin :wire wire))
