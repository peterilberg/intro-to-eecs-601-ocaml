let enforce condition message =
  if not condition then Stdlib.invalid_arg message
;;
