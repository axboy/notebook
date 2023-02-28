# neovim

## 安装配置

```sh
brew install neovim
```
- 安装[packer](https://github.com/wbthomason/packer.nvim)

从github翻到bootstrap这里，复制代码

```lua:lua/plugins/packer-setup.lua
-- 
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
```

- 配置packer

在init.lua增加一行
```lua:init.lua
require("plugins.packer-setup")
```

为了修改packer-setup自动更新插件，在packer-setup.lua文件return前插入如下代码。
```lua
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost packer-setup.lua source <afile> | PackerSync
    augroup end
]])
```

## 相关链接
- [neovim.io](https://neovim.io/)
- [github - neovim](https://github.com/neovim/neovim)
- [github - vim-plug](https://github.com/junegunn/vim-plug)
- [github - packer.nvim](https://github.com/wbthomason/packer.nvim)
- [github - tokyonight](https://github.com/folke/tokyonight.nvim)
- [github - lualine](https://github.com/nvim-lualine/lualine.nvim)
- [github - nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
- [bilibili - 技术蛋老师 - Neovim从零配置成属于你的个人编辑器](https://www.bilibili.com/video/BV1Td4y1578E/)