module Task = struct
  module type Intf = sig
    val name : string
    val short_help : string
    val help : string
    val run : string list -> unit
  end

  let tasks : (module Intf) list ref = ref []
  let register : (module Intf) -> unit = fun m -> tasks := m :: !tasks

  let load_all () =
    let root = "./_build/default/tasks/" in
    let cmos = [ root ^ "salute.cmo" ] in
    List.iter
      (fun cmo ->
        let cmxs = Dynlink.adapt_filename cmo in
        try Dynlink.loadfile cmxs with
        | Dynlink.Error err as e ->
            print_endline ("ERROR loading plugin: " ^ Dynlink.error_message err);
            raise e
        | _ -> failwith "Unknow error while loading plugin")
      cmos

  let tasks () = !tasks
end

let all_tasks_help () =
  Task.tasks ()
  |> List.map (fun (module T : Task.Intf) ->
         "muad " ^ T.name ^ "    " ^ T.short_help)
  |> String.concat "\n"

let with_task name fn =
  let task =
    Task.tasks ()
    |> List.find_opt (fun (module T : Task.Intf) -> String.equal T.name name)
  in
  match task with
  | Some task -> fn task
  | None -> failwith (Format.sprintf "Task %S not found" name)

let run_task name args = with_task name @@ fun (module T) -> T.run args
let help name _args = with_task name @@ fun (module T) -> "\n" ^ T.help ^ "\n"
