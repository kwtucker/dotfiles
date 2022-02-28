return {
	settings = {
		assist = {
			importMergeBehavior = "last",
			importPrefix = "by_self",
		},
		diagnostics = {
			disabled = { "unresolved-import" },
		},
		cargo = {
			loadOutDirsFromCheck = true,
		},
		procMacro = {
			enable = true,
		},
		checkOnSave = {
			command = "clippy",
		},
	},
}
