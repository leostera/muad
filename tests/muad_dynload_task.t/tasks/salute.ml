module Task: Muad.Task.Intf = struct
  let name = "salute"
  let help = "salutes the current user"
  let run _args = print_endline "lisan al-gaib!"
end;;

Muad.Task.register (module Task)
