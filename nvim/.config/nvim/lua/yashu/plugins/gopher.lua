return {
	"olexsmir/gopher.nvim",
	ft = "go",
	config = function(_, opts)
		require("gopher").setup(opts)

		local keymap = vim.keymap

		keymap.set("n", "<leader>gsj", "<cmd> GoTagAdd json <CR>", { desc = "Add json struct tags" })
		keymap.set("n", "<leader>gsy", "<cmd> GoTagAdd yaml <CR>", { desc = "Add yaml struct tags" })
	end,
	build = function()
		vim.cmd([[silent! GoInstallDeps]])
	end,
}
