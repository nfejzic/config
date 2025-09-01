return {
	settings = {
		vetur = {
			completion = {
				autoImport = true,
				tagCasing = "kebab",
				useScaffoldSnippets = true,
			},
			useWorkspaceDependencies = true,
			experimental = {
				templateInterpolationService = true,
			},
		},
		format = {
			enable = false,
			options = {
				useTabs = false,
				tabSize = 2,
			},
			scriptInitialIndent = false,
			styleInitialIndent = false,
			defaultFormatter = {},
		},
		validation = {
			template = false,
			script = false,
			style = false,
			templateProps = false,
			interpolation = false,
		},
	},
}
