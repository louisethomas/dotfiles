
local function delete_old_files(directory, days_old)
    local current_time = os.time()
    local age_limit = days_old * 24 * 60 * 60  -- Convert days to seconds

    -- Get list of files in the directory
    local files = vim.fn.globpath(directory, '*', false, true)
    for _, file_path in ipairs(files) do
        local file_stat = vim.loop.fs_stat(file_path)
        if file_stat and file_stat.type == 'file' then
            local age = current_time - file_stat.mtime.sec
            if age > age_limit then
                os.remove(file_path)
            end
        end
    end
end

local function clean_old_backups_and_undos()
    local backup_dir = vim.fn.stdpath("data") .. "/backup"
    local undo_dir = vim.fn.stdpath("data") .. "/undo"
    
    -- Delete files older than 7 days (1 week)
    delete_old_files(backup_dir, 7)
    delete_old_files(undo_dir, 7)
end

return {
    clean_old_backups_and_undos = clean_old_backups_and_undos
}

