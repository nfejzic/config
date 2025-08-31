return {
	on_attach = function(client, _)
		client.server_capabilities.document_formatting = false
		client.server_capabilities.document_range_formatting = false
	end,
}
