-- Code Runner - run files in a floating terminal
-- Available placeholders:
--   ${file}     - full file path
--   ${dir}      - directory of the file
--   ${name}     - filename without extension
--   ${ext}      - file extension

local M = {}

M.commands = {
    cpp = "g++ ${file} -o ${dir}/bin/${name} && ${dir}/bin/${name}",
    c = "gcc ${file} -o ${dir}/bin/${name} && ${dir}/bin/${name}",
    py = "python3 ${file}",
    js = "node ${file}",
    ts = "npx tsx ${file}",
    go = "go run ${file}",
    rs = "cargo run",
    lua = "lua ${file}",
    sh = "bash ${file}",
    rb = "ruby ${file}",
    java = "java ${file}",
    zig = "zig run ${file}",
}

function M.run()
    local file = vim.fn.expand("%:p")
    local dir = vim.fn.expand("%:p:h")
    local name = vim.fn.expand("%:t:r")
    local ext = vim.fn.expand("%:e")

    local cmd_template = M.commands[ext]
    if not cmd_template then
        vim.notify("No run command configured for ." .. ext .. " files", vim.log.levels.WARN)
        return
    end

    -- Save the file before running
    vim.cmd("silent! write")

    local cmd = cmd_template
        :gsub("${file}", file)
        :gsub("${dir}", dir)
        :gsub("${name}", name)
        :gsub("${ext}", ext)

    Snacks.terminal.open(cmd, {
        win = {
            position = "float",
            height = 0.8,
            width = 0.8,
        },
    })
end

vim.keymap.set("n", "<leader>r", M.run, { desc = "Run File" })

return M
