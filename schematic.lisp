(in-package :e/schematic)

(defclass schematic (e/part:part)
  ((sources :accessor sources) ;; a list of Sources (which contain a list of Wires which contain a list of Receivers)
   (internal-parts :accessor internal-parts :initform nil))) ; a list of Parts

(defun new-schematic (&key (name ""))
  (make-instance 'schematic :name name))

(defmethod ensure-source-not-already-present ((self schematic) (s e/source:source))
  (e/util:ensure-not-in-list (sources self) s
                             "source ~S already present in schematic ~S" s (e/part::name self)))

(defmethod add-source ((self schematic) (s e/source:source))
  (push s (sources self)))

(defmethod ensure-part-not-already-present ((self schematic) (p e/part:part))
  (e/util:ensure-not-in-list (internal-parts self) p
                             "part ~S already present in schematic ~S" p (e/part::name self)))

(defmethod add-part ((self schematic) (p e/part:part))
  (push p (internal-parts self)))