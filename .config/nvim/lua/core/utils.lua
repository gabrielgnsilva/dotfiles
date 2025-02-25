local U = {}

U.load_keymaps = function(map, opts)
	local set = vim.keymap.set

	local M
	if type(map) == "table" then
		M = map
	elseif type(map) == "function" then
		M = map()
	else
		M = require("custom.mappings")[map]
		if type(M) == "function" then
			M = M()
		end
	end

	for _, row in ipairs(M) do
		for _, mode in ipairs(row.mode) do
			for key, action in pairs(row.bindings) do
				local command = action[1]
				local options = action[2]
				if type(options) == "table" then
					set(mode, key, command, vim.tbl_extend("force", options, opts or {}))
				elseif type(options) == "string" then
					set(mode, key, command, vim.tbl_extend("force", opts or {}, { desc = options }))
				end
			end
		end
	end
end

U.lsp = {
	on_attach = function(client, bufnr)
		local builtin = require("telescope.builtin")
		local map = vim.keymap.set

		-- Disable LSP for large files
		local max_filesize = 100 * 1024 -- 100 KB
		local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
		if stats and stats.size > max_filesize then
			client.stop()
			vim.notify("LSP has been deactivated on this file!")
			return
		end

		local desc = function(desc)
			return { buffer = client.buf, desc = "LSP " .. desc }
		end

		-- Keymaps
		map("n", "gd", vim.lsp.buf.definition, desc("LSP Go to definition"))
		map("n", "gD", vim.lsp.buf.declaration, desc("LSP Go to declaration"))
		map("n", "gi", vim.lsp.buf.implementation, desc("LSP Go to implementation"))
		map("n", "go", vim.lsp.buf.type_definition, desc("LSP Go to type definition"))
		map("n", "gr", vim.lsp.buf.references, desc("LSP Show references"))
		map("n", "H", vim.lsp.buf.hover, desc("LSP Show hover information"))
		map("n", "gs", builtin.lsp_document_symbols, desc("LSP find symbols on current buffer"))
		map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, desc("LSP Find symbols on workspace"))
		map("n", "<leader>rn", vim.lsp.buf.rename, desc("LSP Rename symbol"))
		map("n", "<leader>ca", vim.lsp.buf.code_action, desc("LPS Show code actions"))

		if client.server_capabilities.signatureHelpProvider then
			map("n", "gh", vim.lsp.buf.signature_help, desc("LSP Show signature help"))
		end

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					require("conform").format()
				end,
			})
		end
	end,

	capabilities = vim.tbl_deep_extend(
		"force",
		vim.lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities()
	),
}

U.ts_ls = {
	organize_imports = function()
		local params = {
			command = "_typescript.OrganizeImports",
			arguments = { vim.api.nvim_buf_get_name(0) },
		}
		vim.lsp.buf.execute_command(params)
	end,

	minify = function(opts)
		local filePath = vim.api.nvim_buf_get_name(0)
		local dir = filePath:match("(.*[/\\])") or "" -- Capture the directory (handles both / and \)
		local fileName = filePath:match("([^/\\]+)%.([^/.]+)$") -- Capture the filename without extension
		local ext = filePath:match("%.([^/.]+)$") -- Capture the extension
		local outputFile = dir .. fileName .. ".min." .. ext

		if not fileName or not ext then
			vim.notify("Not a valid file!", vim.log.levels.ERROR)
			return nil
		end

		vim.ui.input({ prompt = "[C] Year: ", default = os.date("%Y") }, function(year)
			if year == nil or year == "" then
				vim.notify("Cancelled", vim.log.levels.INFO)
				return
			end

			-- Prompt user for version
			vim.ui.input({ prompt = "[C] Version: ", default = "1.0.0" }, function(version)
				if version == nil or version == "" then
					vim.notify("Cancelled", vim.log.levels.INFO)
					return
				end

				vim.ui.input({ prompt = "[C] Name: ", default = opts.name or "NAME" }, function(name)
					if name == nil or name == "" then
						vim.notify("Cancelled", vim.log.levels.INFO)
						return
					end

					-- Construct the copyright notice
					local copyrightNotice = string.format(
						[[/*!
 * %s v%s
 * Copyright %s %s
 * Licensed under %s
 */
]],
						fileName,
						version,
						year,
						name,
						opts.licence or "MIT (https://opensource.org/licenses/MIT)"
					)

					local cmd = string.format(
						'esbuild %s --outfile=%s --minify --banner:%s="' .. copyrightNotice .. '"',
						filePath,
						outputFile,
						ext
					)
					vim.fn.jobstart(cmd, {
						on_exit = function(_, exit_code)
							if exit_code == 0 then
								vim.notify("Successfully minified: " .. outputFile, vim.log.levels.INFO)
							else
								vim.notify("Error minifying file", vim.log.levels.ERROR)
							end
						end,
					})
				end)
			end)
		end)
	end,
}

U.is_angular_project = function()
	local current_dir = vim.fn.getcwd()
	while current_dir ~= "/" do
		if vim.fn.filereadable(current_dir .. "/angular.json") == 1 then
			return true
		end
		current_dir = vim.fn.fnamemodify(current_dir, ":h") -- Go to the parent directory
	end
	return false
end

U.luasnip = {
	FLUIG = {
		libraries = [[
    <!-- #region: Libraries -->
    <script type="text/javascript" src="/TOTVSIP_LIB/resources/js/gd-lib.js"></script>
    <script type="text/javascript" src="/TOTVSIP_LIB/resources/js/jMask.js"></script>
    <script type="text/javascript" src="/webdesk/vcXMLRPC.js"></script>
    <!-- #endregion -->
]],
		style_guide = [[
    <!-- #region: Style guide -->
    <link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide.min.css" />
    <link rel="stylesheet" type="text/css" href="/style-guide/css/fluig-style-guide-flat.min.css" />
    <link rel="stylesheet" type="text/css" href="/TOTVSIP_LIB/resources/css/TOTVSIP_LIB.css" />
    <script src="/portal/resources/js/jquery/jquery.js"></script>
    <script src="/portal/resources/js/jquery/jquery-ui.min.js"></script>
    <script src="/portal/resources/js/mustache/mustache-min.js"></script>
    <script src="/style-guide/js/fluig-style-guide.min.js"></script>
    <!-- #endregion -->
]],
		overrides = [[
    <!-- #region: Scripts -->
    <script language="javascript">
        function disablePullToRefresh() {{
            return true;
        }}
    </script>
    <!-- #endregion -->
]],
	},
}

return U
