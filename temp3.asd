(defsystem "temp3"
  :depends-on (loops)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3)
                                         (safety 3)
                                         (speed 0)))
                    (funcall next))
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "util" :depends-on ("package"))
                                     (:file "part" :depends-on ("package"))
                                     (:file "schematic" :depends-on ("package" "part"))
                                     (:file "event" :depends-on ("package"))
                                     (:file "source" :depends-on ("package"))
                                     (:file "receiver" :depends-on ("package"))
                                     (:file "wire" :depends-on ("package" "util"))
				     (:file "api"  :depends-on ("package" "part" "event" "source" "receiver" "wire"))
				     (:file "test0"  :depends-on ("api"))))))
