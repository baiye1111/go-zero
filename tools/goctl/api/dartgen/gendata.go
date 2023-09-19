package dartgen

import (
	"github.com/zeromicro/go-zero/tools/goctl/api/spec"
	"github.com/zeromicro/go-zero/tools/goctl/config"
	"github.com/zeromicro/go-zero/tools/goctl/util/format"
	"strings"
)

var DataTemplate string

func genData(dir string, cfg *config.Config, api *spec.ApiSpec) error {
	filename, err := format.FileNamingFormat(cfg.NamingFormat, strings.ToLower(api.Service.Name))
	if err != nil {
		return err
	}

	err = convertDataType(api)

	return genFile(fileGenConfig{
		dir:             dir,
		subdir:          "",
		filename:        filename + ".dart",
		templateName:    "dataTemplate",
		category:        category,
		templateFile:    dataTemplateFile,
		builtinTemplate: DataTemplate,
		data:            api,
	}, funcMap)
}

func convertDataType(api *spec.ApiSpec) error {
	types := api.Types
	if len(types) == 0 {
		return nil
	}

	for _, ty := range types {
		defineStruct, ok := ty.(spec.DefineStruct)
		if ok {
			for index, member := range defineStruct.Members {
				tp, err := specTypeToDart(member.Type)
				if err != nil {
					return err
				}
				defineStruct.Members[index].Type = buildSpecType(member.Type, tp)
			}
		}
	}

	return nil
}
