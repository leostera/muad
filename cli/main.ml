let () =
  Muad.Task.load_all ();
  let args = Sys.argv |> Array.to_list in
  let help () = Muad.all_tasks_help () |> print_endline in
  match args with
  | [ "muad"; "--help" ] -> help ()
  | "muad" :: task :: "--help" :: args -> Muad.help task args |> print_endline
  | "muad" :: task :: args -> Muad.run_task task args
  | _ -> help ()
