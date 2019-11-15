(in-package :e/schematic)

(defclass schematic (e/part:part)
  ((sources :accessor sources :initform nil) ;; a list of Sources (which contain a list of Wires which contain a list of Receivers)
   (internal-parts :accessor internal-parts :initform nil))) ; a list of Parts

(defun new-schematic (&key (name ""))
  (make-instance 'schematic :name name))

(defmethod ensure-source-not-already-present ((self schematic) (s e/source:source))
  (e/util:ensure-not-in-list (sources self) s #'equal
                             "source ~S already present in schematic ~S" s (e/part::name self)))

(defmethod add-source ((self schematic) (s e/source:source))
  (push s (sources self)))

(defmethod ensure-part-not-already-present ((self schematic) (p e/part:part))
  (e/util:ensure-not-in-list (internal-parts self) p #'equal
                             "part ~S already present in schematic ~S" p (e/part::name self)))

(defmethod add-part ((self schematic) (p e/part:part))
  (setf (e/part:parent-schem p) self)
  (push p (internal-parts self)))

(defmethod lookup-source ((parent (eql nil)) part e)
  nil)

(defmethod lookup-source ((parent schematic) (self e/part:part) (e e/event:event))
  ;; find part-pin in parent's source list
  (let ((pin-sym (e/event:pin e)))
    (dolist (s (sources parent))
      (when (e/source::equal-part-pin-p s self pin-sym)
        (return-from lookup-source s)))
    (assert nil))) ;; shouldn't happen

(defmethod schematic-input-handler ((self schematic) (e e/event:event))
  (e/dispatch::lookup-output-source-and-deliver self self e))

