(defun shortest-path (start end net)
  (nreverse (ids (list (list start))
                 (lambda (state) 
                   (eql state end))
                 (lambda (path)
                   (mapcan (lambda (node)
                             (unless (member node path)
                               (list node)))
                           (cdr (assoc (car path) net)))))))


(defun ids (paths pred gen)
  (catch 'true-failure 
         (do* ((i 0 (1+ i))
               (res (dls (car paths) pred gen i)
                    (dls (car paths) pred gen i)))
           ((or (consp (car res))
                (null (cdr res)))
            (car res)))))

(defun dls (path pred gen n)
  (if (<= n 0) 
      (cons nil t)
      (let ((states (funcall gen path))
            (depth-lim-reached nil))
        (cons (some (lambda (state)
                      (if (funcall pred state)
                          (cons state path)
                          (let ((res (dls (cons state path) pred gen (1- n))))
                            (cond ((consp (car res)) 
                                   (car res))
                                  ((cdr res)
                                   (setf depth-lim-reached t)
                                   nil)
                                  (t
                                   nil)))))
                    states)
              depth-lim-reached))))


(test-path '() 'a 'c '((a b) (b a) (c)))
(shortest-path 'a 'f '((a b) (b c d) (c e) (d a) (e f)))
(test-path '(a b c e f) 'a 'f '((a b) (b c d) (c e) (d a) (e f)))
(shortest-path 'a 'c '((a b) (b a) (c)))
(test-path '(a c e f) 'a 'f '((a b c) (b c) (c e) (e f)))
(run-tests shortest-path)
