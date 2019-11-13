(in-package :e/wire)

;; a Wire is a list of Receivers

(defclass wire ()
  ((receivers :accessor receivers :initform nil)
   (name :accessor name :initarg name)))

(defun new-wire (&key (name ""))
  (make-instance 'wire :name name)

(defmethod deliver-event ((wire wire) (e a:event))
  (mapc #'(lambda (recv)
            (deliver-event recv e))
        (receivers wire)))

(defmethod ensure-receiver-not-already-on-wire ((wire wire) (rcv e/receiver:receiver))
  (e/util:ensure-not-in-list (receivers wire) rcv #'e/receiver::receiver-equal
                             "receiver ~S already on wire ~S" rcv wire))

