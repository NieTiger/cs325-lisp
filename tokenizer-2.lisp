(defun split-string (str &optional (delim #\space))
  (let ((tr (make-tokenizer str delim)))
    (do ((l nil (cons (next-token tr) l)))
      ((not (next-token-p tr)) (nreverse l)))))

(defclass tokenizer ()
  ((str :accessor tok-str
        :initarg :str)
   (delim :accessor tok-delim
          :initarg :delim
          :initform #\space)
   (len :accessor tok-len
        :initarg :len
        :initform 0)
   (idx :accessor tok-idx
        :initarg :idx
        :initform 0)))

(defmethod next-token-p ((tr tokenizer))
  (not (null (tok-idx tr))))

(defmethod get-next-token-start ((tr tokenizer))
  (if (eql (tok-delim tr) #\space)
      (position (tok-delim tr) 
                (tok-str tr) 
                :start (tok-idx tr) 
                :test #'(lambda (a b) (not (eql a b)))) 
      (tok-idx tr)))

(defmethod get-token-end ((tr tokenizer))
  (position (tok-delim tr) (tok-str tr) :start (tok-idx tr)))

(defmethod next-token ((tr tokenizer))
  (let* ((end (get-token-end tr))
         (new-token (subseq (tok-str tr) (tok-idx tr) (or end (tok-len tr)))))
    (setf (tok-idx tr) (and end (1+ end)))
    (setf (tok-idx tr) (get-next-token-start tr))
    new-token))

(defun make-tokenizer (str &optional (delim #\space))
  (let ((tr (make-instance 'tokenizer
                           :str str
                           :delim delim
                           :len (length str))))
    (setf (tok-idx tr) (get-next-token-start tr))
    tr))

(run-tests tokenizer)

; (split-string "" #\space)
; (split-string " now  is the+time  " #\space)
; (defparameter tt (make-tokenizer ",," #\,))
; (defparameter tt (make-tokenizer "," #\,))
; (defparameter tt (make-tokenizer "now is the tim" #\space))
; (defparameter tt (make-tokenizer " now  is the+time  " #\space))

; (defparameter tt (make-tokenizer ",12,132,,abc" #\,))
; (defparameter tt (make-tokenizer "12,132,abc" #\,))

; (next-token tt)
; (next-token-p tt)
; (tok-idx tt)
; (tok-len tt)
; (get-token-end tt)
; (get-next-token-start tt)

; (tok-idx tt)
; (tok-len tt)
; (next-token (make-tokenizer "now "))
; (next-token (make-tokenizer "   hello world"))
; (split-string "Now is the time ")

; (run-tests tokenizer)
; (define-test tokenizer 
  ; (assert-equal '("now" "is" "the" "time")
                 ; (split-string " now  is the time  "))
  ; (assert-equal '("12" "132" "abc")
                ; (split-string "12,132,abc" #\,))
  ; (assert-equal '("" "12" "132" "" "abc")
                ; (split-string ",12,132,,abc" #\,))
  ; (assert-equal '("" "")
                ; (split-string "," #\,))
  
  ; (assert-equal () (split-string "  "))
  ; (assert-equal '("") (split-string "" #\,))
  ; (assert-equal '("  ") (split-string "  " #\,))
  ; )

; (next-token-p (make-tokenizer "" #\,))
