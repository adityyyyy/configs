return {
	"olexsmir/gopher.nvim",
	ft = "go",
	config = function()
		require("gopher").setup({
			commands = {
				go = "go",
				gotests = "gotests",
				impl = "impl",
				iferr = "iferr",
				dlv = "dlv",
			},
			gotests = {
				template = "default",
				template_dir = "nil",
				named = false,
			},
			gotag = {
				transform = "snakecase",
			},
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
		keymap.set("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })
	end,
	build = function()
		vim.cmd([[silent! GoInstallDeps]])
	end,
}
