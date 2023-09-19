// --{{with .Info}}{{.Title}}{{end}}--
// env: test
{{ range .Types}}
class {{.Name}} {
	{{range .Members}}
	{{if .Comment}}{{.Comment}}{{end}}
	final {{if isNumberType .Type.Name}}num{{else}}{{.Type.Name}}{{end}} {{lowCamelCase .Name}};
  {{end}}{{.Name}}({{if .Members}}{
	{{range .Members}}  required this.{{lowCamelCase .Name}},
	{{end}}}{{end}});
	factory {{.Name}}.fromJson(Map<String,dynamic> m) {
		return {{.Name}}(
			{{range .Members}}
				{{lowCamelCase .Name}}: {{appendNullCoalescing .}}
					{{if isAtomicType .Type.Name}}
						m['{{getPropertyFromMember .}}'] {{appendDefaultEmptyValue .Type.Name}}
					{{else if isAtomicListType .Type.Name}}
						m['{{getPropertyFromMember .}}']?.cast<{{getCoreType .Type.Name}}>() {{appendDefaultEmptyValue .Type.Name}}
					{{else if isClassListType .Type.Name}}
						((m['{{getPropertyFromMember .}}'] {{appendDefaultEmptyValue .Type.Name}}) as List<dynamic>).map((i) => {{getCoreType .Type.Name}}.fromJson(i)).toList()
					{{else}}
						{{.Type.Name}}.fromJson(m['{{getPropertyFromMember .}}']){{end}}
			,{{end}}
		);
	}
	Map<String,dynamic> toJson() {
		return { {{range .Members}}
			'{{getPropertyFromMember .}}': 
				{{if isDirectType .Type.Name}}
					{{lowCamelCase .Name}}
				{{else if isClassListType .Type.Name}}
					{{lowCamelCase .Name}}{{if isNullableType .Type.Name}}?{{end}}.map((i) => i{{if isListItemsNullable .Type.Name}}?{{end}}.toJson())
				{{else}}
					{{lowCamelCase .Name}}{{if isNullableType .Type.Name}}?{{end}}.toJson()
				{{end}}
			,{{end}}
		};
	}
}
{{end}}
