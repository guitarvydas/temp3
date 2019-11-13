(defpackage cl-event-passing
  (:nicknames :a)
  (:use :cl)
  (:export
   #:implementable
   #:event
   #:pin
   #:data
   #:wire
   #:receivers
   #:part
   #:terminal
   #:schematic
   #:internal-parts
   #:internal-wires
   #:input-queue
   #:output-queue
   #:busy-flag
   #:namespace-input-pins
   #:namespace-output-pins
   #:input-handler
   #:first-time-handler))

(defpackage cl-event-passing-user
  ;; top level API
  (:use :cl)
  (:nicknames :aa)
  (:export
   #:@new-schematic
   #:@new-code
   #:@new-wire
   #:@new-event
   #:@initialize
   #:@top-level-schematic
   #:@set-first-time-handler
   #:@set-input-handler
   #:@add-inbound-receiver-to-wire
   #:@add-source-to-schematic
   #:@start-dispatcher))

(defpackage cl-event-passing-part
  (:nicknames :e/part)
  (:use :cl))

(defpackage cl-event-passing-event
  (:nicknames :e/event)
  (:use :cl))

(defpackage cl-event-passing-source
  (:nicknames :e/source)
  (:use :cl))

(defpackage cl-event-passing-receiver
  (:nicknames :e/receiver)
  (:use :cl))

(defpackage cl-event-passing-schematic
  (:nicknames :e/schematic)
  (:use :cl))

(defpackage cl-event-passing-dispatch
  (:nicknames :e/dispatch)
  (:use :cl))

(defpackage cl-event-passing-user-util
  (:nicknames :e/util)
  (:use :cl)
  (:export
   #:ensure-not-in-list))

