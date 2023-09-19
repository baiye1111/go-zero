class {{with .Service}}{{ .Name -}}{{end}}API{
{{with .Service}}
    /// {{.Name}}
    {{range $i,$Route := .Routes}}
    /// --{{.Path}}
    ///
    /// req: {{with .RequestType}}{{.Name}}{{end}}
    /// resp:{{with .ResponseType}}{{.Name}}{{end}}
    {{if hasUrlPathParams $Route}}{{extractPositionalParamsFromPath $Route}},{{end}}
    static Future<{{with .ResponseType}}{{.Name}}{{end}}> {{normalizeHandlerName .Handler}}{{if ne .Method "get"}}{
        required {{with .RequestType}}{{.Name}} params,{{end}}
    } {{end}}
    async {{{if eq .Method "get"}}
        var response = await HttpUtil().get({{makeDartRequestUrlPath $Route}}{{end}});
        return {{with .ResponseType}}{{.Name}}{{end}}.fromJson(response);
        {{end}}{{if eq .Method "put"}}
        await HttpUtil().put(
            {{makeDartRequestUrlPath $Route}}{{end}},
            data: params.toJson()
        );
        {{end}}{{if eq .Method "post"}}
        var response = await HttpUtil().post({{makeDartRequestUrlPath $Route}}{{end}});
        return {{with .ResponseType}}{{.Name}}{{end}}.fromJson(response);
        {{end}}
    }
    {{end}}
{{end}}
}
