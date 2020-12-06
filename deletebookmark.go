{{/*
  Trigger type: Regex
  Trigger: ^-d(|del(|ete))b(|ook)m
  Deletes bookmarks :/
*/}}
{{$existingBMs := sdict (or (dbGet .User.ID "bookmarks").Value sdict)}}
{{if not $existingBMs}}
You have no bookmarks!
{{else}}
	{{if ne (len .CmdArgs) 0}}
		{{$existingBMs.Del (index .CmdArgs 0)}}
		Deleted {{index .CmdArgs 0}}!
		{{dbSet .User.ID "bookmarks" $existingBMs}}
	{{else}}
		Bad arguments. Can only accept one (the name).
	{{end}}
{{end}}
