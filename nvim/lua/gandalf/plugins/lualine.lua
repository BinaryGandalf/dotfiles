local M = { "nvim-lualine/lualine.nvim" }

M.cond = true

M.lazy = false

local function bufsize()
	local s = vim.fn.getfsize(vim.fn.expand("%"))
	if s > 0 then
		return tostring(s) .. "B"
	end
	return "null"
end

function M.config()
	require("lualine").setup({
		options = {
			globalstatus = true,
			component_separators = {
				left = "",
				right = "",
			},
			section_separators = {
				left = "",
				right = "",
			},
		},
		sections = {
			lualine_a = {
				"mode",
			},
			lualine_b = {
				{
					"branch",
					icon = "",
				},
				"diff",
			},
			lualine_c = {
				{
					"filename",
					file_status = true,
					path = 1,
				},
				{
					"diagnostics",
					update_in_insert = true,
					symbols = {
						error = "E",
						warn = "W",
						info = "I",
						hint = "H",
					},
				},
			},
			lualine_x = {
				bufsize,
			},
			lualine_y = {
				"location",
				"progress",
			},
			lualine_z = {
				{
					"filetype",
					colored = false,
					icon_only = false,
					icon = {
						align = "left",
					},
				},
			},
		},
		extensions = {
			"nvim-dap-ui",
		},
	})
end

return M
