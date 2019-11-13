(in-package :cl-event-processing-user)

(defun @new-schematic (&key (name ""))
  (e/schematic::new-schematic :name name))

(defun @new-code (&key (name ""))
  (e/part::new-code :name name))

(defun @new-wire (&key (name ""))
  (e/wire::new-wire :name name))

(defun @new-event (&key (pin nil) (data nil))
  (e/event::new-event :pin pin :data data))

(defun @initialize ()
  (e/dispatch::reset))

(defmethod @set-first-time-handler ((part e/part:part) fn)
  (setf (e/part::first-time-handler part) fn))

(defmethod @set-input-handler ((part e/part:part) fn)
  (setf (e/part::input-handler part) fn))

(defmethod @add-inbound-receiver-to-wire ((wire e/wire:wire) (part e/part:part) pin-sym)
  (let ((rcv ('e/receiver::new-inbound-receiver :part part :pin pin-sym)))
    (e/wire::ensure-receiver-not-alreader-on-wire wire rcv)
    (e/wire::add-receiver wire rcv)))

(defmethod @add-source-to-schematic ((schem e/schematic:schematic) (part e/part:part) pin-sym (wire e/wire:wire))
  (let ((s (e/source::new-source :part part :pin pin-sym :wire wire)))
    (e/schematic::ensure-source-not-already-present schem s)
    (e/schematic::add-source schem s)))

(defmethod @add-part-to-schematic ((self e/schematic:schematic) (part e/part:part))
  (e/schematic::ensure-part-not-already-present schem p)
  (e/schematic::add-part schem p)
  (e/dispatch::memo-part part))

(defun @start-dispatcher ()
  (@loop
   (@:exit-when (e/dispatch::all-parts-have-empty-input-queues-p))
   (e/dispatch::dispatch-output-queues)
   (e/dispatch::dispatch-sinlge-input)))

(defmethod @top-level-schematic ((schem e/schematic:schematic))
  (e/dispatch::memo-part shem))
