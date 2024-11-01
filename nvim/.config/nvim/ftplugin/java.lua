local home = vim.env.HOME
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local jdtls = require("jdtls")

local extendedClientCapabilities = jdtls.extendedClientCapabilities

local bundles = {
	vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/share/nvim/mason/share/java-test/*.jar", true), "\n"))

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx4g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-jar",
		vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
		"-configuration",
		home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
		"-data",
		workspace_dir,
	},

	root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

	settings = {
		java = {
			home = "/home/bunny/.sdkman/candidates/java/current/bin/java",
			configuration = {
				updateBuildConfiguration = "interactive",
				-- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
				-- The runtime name parameters need to match specific Java execution environments.  See https://github.com/tamago324/nlsp-settings.nvim/blob/2a52e793d4f293c0e1d61ee5794e3ff62bfbbb5d/schemas/_generated/jdtls.json#L317-L334
				-- runtimes = {
				-- 	{
				-- 		name = "JavaSE-11",
				-- 		path = "/usr/lib/jvm/java-11-openjdk-amd64",
				-- 	},
				-- },
			},
			eclipse = { downloadSources = true },
			maven = { downloadSources = true },
			gradle = { enabled = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			signatureHelp = { enabled = true },
			format = { enabled = true },
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			saveActions = {
				organizeImports = true,
			},
		},
		completion = {
			favoriteStaticMembers = {
				"org.assertj.core.api.Assertions.*",
				"org.junit.Assert.*",
				"org.junit.Assume.*",
				"org.junit.jupiter.api.Assertions.*",
				"org.junit.jupiter.api.Assumptions.*",
				"org.junit.jupiter.api.DynamicContainer.*",
				"org.junit.jupiter.api.DynamicTest.*",
				"org.mockito.Mockito.*",
				"org.mockito.ArgumentMatchers.*",
				"org.mockito.Answers.*",
			},
			importOrder = {
				"java",
				"javax",
				"com",
				"org",
			},
		},
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		extendedClientCapabilities = extendedClientCapabilities,
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
	},
	capabilities = capabilities,
	flags = {
		allow_incremental_sync = true,
		server_side_fuzzy_completion = true,
	},
	init_options = {
		bundles = bundles,
	},
}

config["on_attach"] = function(client, bufnr)
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
end

require("jdtls").start_or_attach(config)

vim.keymap.set("n", "<leader>co", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "Organize Imports" })
vim.keymap.set("n", "<leader>crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "Extract Variable" })
vim.keymap.set(
	"v",
	"<leader>crv",
	"<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
	{ desc = "Extract Variable" }
)
vim.keymap.set("n", "<leader>crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "Extract Constant" })
vim.keymap.set(
	"v",
	"<leader>crc",
	"<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
	{ desc = "Extract Constant" }
)
vim.keymap.set(
	"v",
	"<leader>crm",
	"<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
	{ desc = "Extract Method" }
)

vim.keymap.set("n", "<leader>tc", function()
	require("jdtls").test_class()
end, { desc = "Run tests" })

vim.keymap.set("n", "<leader>tm", function()
	require("jdtls").test_nearest_method()
end, { desc = "Run test method" })
