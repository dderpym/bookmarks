{{/*
  Trigger type: Rregex
  Trigger: ^-n((|ew)b(|ook)m)
  Too many and sometimes generic names will error. Specifying the name here also overwrites previous onces. Many uses, requires message id or message link, otherwise will create a new message and save that as the bookmark.
*/}}


{{- define "createGenericName"}}
    {{- $name := (print adjective "-" adjective "-" noun)}}
    {{- if (.input.Get $name)}}
        {{- template "createGenericName" ($data := sdict "input" .input)}}{{.Set "Result" $data.Result}}
    {{- else}}
        {{- .Set "Result" $name}}
    {{- end -}}
{{end}}

{{$regex := `https://(?:\w+\.)?discord(?:app)?\.com/channels\/(\d+)\/(\d+)\/(\d+)`}}
{{/*Regex stolen from Crafters message link cc*/}}
{{$args := .CmdArgs}}

{{/* Had an issue with this, DZ and Devonte helped. */}}
{{$existingBMs := sdict (or (dbGet .User.ID "bookmarks").Value sdict)}}

{{if eq (len $args) 0}}
	{{template "createGenericName" ($data := sdict "input" $existingBMs) }}
	{{$genericName := $data.Result}}
	{{$embed := cembed 
    "title" (print "Created new bookmark")
     "description"  (print "Location: This message\nName: " $genericName)
    "color" (randInt 0 16777215)}}
	{{$id := sendMessageRetID nil $embed}}
	{{$messageLink := (print "https://discord.com/channels/" .Guild.ID "/" .Channel.ID "/" $id)}}

	{{$existingBMs.Set $genericName $messageLink}}
	{{dbSet .User.ID "bookmarks" $existingBMs}}
{{else if eq (len $args) 1}}
	{{if (reFind $regex (index $args 0))}}
		{{template "createGenericName" ($data := sdict "input" $existingBMs) }}
		{{$genericName := $data.Result}}
		{{$messageLink := index $args 0}}
		{{$embed := cembed 
    "title" (print "Created new bookmark")
     "description"  (print "Location: [Message Link](" $messageLink ")\nName: " $genericName)
    "color" (randInt 0 16777215)}}
		{{sendMessage nil $embed}}

		{{$existingBMs.Set $genericName $messageLink}}
		{{dbSet .User.ID "bookmarks" $existingBMs}}
	{{else if ne (toInt (index $args 0)) 0}}
		{{template "createGenericName" ($data := sdict "input" $existingBMs) }}
		{{$genericName := $data.Result}}
		{{$id := index $args 0}}

		{{$messageLink := (print "https://discord.com/channels/" .Guild.ID "/" .Channel.ID "/" $id)}}

		{{$embed := cembed 
    "title" (print "Created new bookmark")
     "description"  (print "Location: [Message Link](" $messageLink ")\nName: " $genericName)
    "color" (randInt 0 16777215)}}
		{{sendMessage nil $embed}}

		{{$existingBMs.Set $genericName $messageLink}}
		{{dbSet .User.ID "bookmarks" $existingBMs}}
	{{else}}
		{{$genericName := index $args 0}}
		{{$embed := cembed 
    "title" (print "Created new bookmark")
     "description"  (print "Location: This message\nName: " $genericName)
    "color" (randInt 0 16777215)}}
		{{$id := sendMessageRetID nil $embed}}
		{{$messageLink := (print "https://discord.com/channels/" .Guild.ID "/" .Channel.ID "/" $id)}}

		{{$existingBMs.Set $genericName $messageLink}}
		{{dbSet .User.ID "bookmarks" $existingBMs}}
	{{end}}
{{else if eq (len $args) 2}}
	{{if (reFind $regex (index $args 1))}}
		{{$genericName := index $args 0}}
		{{$messageLink := index $args 1}}
		{{$embed := cembed 
    "title" (print "Created new bookmark")
     "description"  (print "Location: [Message Link](" $messageLink ")\nName: " $genericName)
    "color" (randInt 0 16777215)}}
		{{sendMessage nil $embed}}

		{{$existingBMs.Set $genericName $messageLink}}
		{{dbSet .User.ID "bookmarks" $existingBMs}}
	{{else if ne (toInt (index $args 1)) 0}}
		{{$genericName := index $args 0}}
		{{$id := index $args 1}}

		{{$messageLink := (print "https://discord.com/channels/" .Guild.ID "/" .Channel.ID "/" $id)}}

		{{$embed := cembed 
    "title" (print "Created new bookmark")
     "description"  (print "Location: [Message Link](" $messageLink ")\nName: " $genericName)
    "color" (randInt 0 16777215)}}
		{{sendMessage nil $embed}}

		{{$existingBMs.Set $genericName $messageLink}}
		{{dbSet .User.ID "bookmarks" $existingBMs}}
	{{end}}
	{{dbSet .User.ID "bookmarks" $existingBMs}}
{{else}}
	Too many arguments!
{{end}}
