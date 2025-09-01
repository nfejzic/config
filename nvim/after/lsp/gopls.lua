return {
	settings = {
		gopls = {
			gofumpt = true,
			buildFlags = {
				"-tags=integration,unit",
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}
