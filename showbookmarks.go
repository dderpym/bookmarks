{{/*
  Trigger type: Regex
  Trigger: ^-m(|y)b(|ook)m
  Shows your bookmarks
*/}}
{{$existingBMs := (dbGet .User.ID "bookmarks").Value}}
{{$desc := ""}}
{{range $key, $val:= $existingBMs}}
{{$desc = (print $desc "**Name:** " $key "   **Location:** [Click Me!](" $val ")\n")}}
{{end}}
{{$embed := cembed 
    "title" (print "Your Bookmarks")
     "description" $desc
    "color" (randInt 0 16777215)}}
{{sendMessage nil $embed}}
