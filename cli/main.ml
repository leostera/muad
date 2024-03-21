let () =
  Muad.Task.load_all ();
  let args = Sys.argv |> Array.to_list in
  match args with
  | [ "muad"; "--help" ] -> Muad.help () |> print_endline
  | "muad" :: task :: args -> Muad.run_task task args
  | _ -> Muad.help () |> print_endline
