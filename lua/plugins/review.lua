local function add_comment()
    local mode = vim.fn.mode()
    local visual = mode == 'v' or mode == 'V' or mode == '\22'
    local first, last
    if visual then
        first = math.min(vim.fn.line('v'), vim.fn.line('.'))
        last = math.max(vim.fn.line('v'), vim.fn.line('.'))
        vim.cmd.normal({ args = { '\27' }, bang = true })
    end

    local config = require('fude.config')
    if not config.state.active then
        require('fude.local.session').start()
    end
    if not config.state.active then
        return
    end

    if visual then
        vim.api.nvim_buf_set_mark(0, '<', first, 0, {})
        vim.api.nvim_buf_set_mark(0, '>', last, 0, {})
    end
    require('fude.comments').create_comment(visual)
end

local function select_comment(action)
    local state = require('fude.config').state
    if not state.active then
        vim.notify('Start a local review with <leader>rr first', vim.log.levels.INFO)
        return
    end

    local path = require('fude.diff').to_repo_relative(vim.api.nvim_buf_get_name(0))
    if not path then
        return
    end

    local comments = require('fude.comments').get_comments_at(path, vim.fn.line('.'))
    if #comments == 0 then
        vim.notify('No review comments on this line', vim.log.levels.INFO)
        return
    end

    local session = state.local_session
    local function apply(comment)
        if
            comment
            and require('fude.config').state == state
            and state.active
            and state.local_session == session
        then
            action(comment.id)
        end
    end

    if #comments == 1 then
        apply(comments[1])
        return
    end

    vim.ui.select(comments, {
        prompt = 'Review comment:',
        format_item = function(comment)
            local status = comment.resolved and '[resolved] ' or '[open] '
            return status .. (comment.body or ''):match('[^\n]*')
        end,
    }, apply)
end

return {
    'flexphere/fude.nvim',
    dependencies = { 'folke/snacks.nvim' },
    cmd = {
        'FudeCommandPalette',
        'FudeReviewLocal',
        'FudeReviewLocalToggle',
        'FudeReviewLocalScope',
        'FudeReviewStop',
        'FudeReviewComment',
        'FudeReviewViewComment',
        'FudeReviewListComments',
        'FudeReviewResolve',
        'FudeReviewFiles',
        'FudeReviewPanel',
        'FudeReviewReload',
    },
    keys = {
        { '<leader>rr', '<cmd>FudeReviewLocal<cr>', desc = 'Start local review' },
        { '<leader>rq', '<cmd>FudeReviewStop<cr>',  desc = 'Stop review' },
        { '<A-r>',      add_comment,               mode = { 'n', 'x' },        desc = 'Add review comment' },
        {
            '<M-S-r>',
            function()
                select_comment(require('fude.comments').toggle_resolve)
            end,
            desc = 'Resolve/reopen review thread',
        },
        {
            '<M-S-d>',
            function()
                select_comment(require('fude.comments').delete_comment)
            end,
            desc = 'Delete review comment',
        },
        { '<leader>rv', '<cmd>FudeReviewViewComment<cr>',  desc = 'View line comments' },
        { '<leader>rl', '<cmd>FudeReviewListComments<cr>', desc = 'List review comments' },
        { '<leader>rf', '<cmd>FudeReviewFiles<cr>',        desc = 'Review changed files' },
        { '<leader>rp', '<cmd>FudeReviewPanel<cr>',        desc = 'Review side panel' },
        {
            ']r',
            function()
                require('fude.comments').next_comment()
            end,
            desc = 'Next review comment',
        },
        {
            '[r',
            function()
                require('fude.comments').prev_comment()
            end,
            desc = 'Previous review comment',
        },
    },
    opts = {
        file_list_mode = 'snacks',
        float = { border = 'rounded' },
        comment_style = 'virtualText',
        keymaps = {
            create_comment = '<A-r>',
            view_comments = '<leader>rv',
            next_comment = ']r',
            prev_comment = '[r',
        },
        auto_reload = { enabled = true, interval = 10, notify = false },
    },
}
