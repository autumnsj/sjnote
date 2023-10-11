```
let g:mapleader = ' '

" 中英文输入法自动切换
"set keep-english-in-normal

" surround插件
set surround
" easymotion
set easymotion

let g:EasyMotion_do_mapping = 0
nmap s <Plug>(easymotion-s)

" 仿真NERDTree插件
" https://github.com/JetBrains/ideavim/wiki/NERDTree-support
set NERDTree
nmap <leader>e :NERDTreeFind<CR>

" https://github.com/JetBrains/ideavim/blob/master/doc/IdeaVim%20Plugins.md
Plug 'vim-scripts/ReplaceWithRegister'
nmap rs  <Plug>ReplaceWithRegisterOperator
nmap rss <Plug>ReplaceWithRegisterLine
xmap rs  <Plug>ReplaceWithRegisterVisual
j
" 高亮搜索
set hlsearch
" 搜索时跳到搜索目标处
set incsearch
" 智能搜索
set ignorecase
set smartcase
" 行号显示
set nu
" 相对行号
set rnu

" 滚动时保持上下边距
set scrolloff=5
" 该设置可以将光标定位到窗口中间位置
" set scrolloff=999

" Esc
"imap jk <ESC>

" 取消高亮
nmap <ESC> :noh<CR>
nmap <C-[> :noh<CR>

" 快捷方式
nmap <A-q> :q<CR>

" 切换到下一个书签
nmap mm :action GotoNextBookmark<CR>
nmap m<tab> :action ToggleBookmark<CR>
" 拖拽行
nmap <c-s-j> :move +1<cr>==
nmap <c-s-k> :move -2<cr>==
xmap <c-s-j> :move '>+1<cr>gv=gv
xmap <c-s-k> :move '<-2<cr>gv=gv
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
" 系统剪板
set clipboard^=unnamed,unnamedplus
" x模式黏贴后重新复制被黏贴内容
" xnoremap p pgvy

" 复制黏贴
xmap <c-c> y
map <c-s-v> p
imap <c-s-v> <c-r>+

" 复制整个缓冲区
nmap <leader>y mmggvgy`m

" https://github.com/jetbrains/ideavim
" ideavim: track action ids
nmap <c-o> <action>(back)
nmap <c-i> <action>(forward)
" nmap u <action>($undo)
" nmap <c-r> <action>($redo)
" 文件查找
nmap <leader>ff <action>(gotofile)
" 全局模糊搜索
nmap <leader>fg <action>(findinpath)
" 等价于idea中的shift+shift
nmap <leader>fb <action>(searcheverywhere)
" 全局替换
nmap <leader>fr <action>(replaceinpath)
" 类查找
nmap gw <action>(gotoclass)
" 类方法或类成员字段查找
nmap gs <action>(filestructurepopup)
" 实现类或方法查找
nmap g<space> <action>(gotmplementation)
" 跳转到定义或引用处
nmap gd <action>(gotodeclaration)
" 查找所有引用，类似vimckfix列表
nmap gu <action>(findusages)
" 找到被实现的类或方法
nmap gp <action>(gotosupermethod)
" 注释
nmap gcc <action>(commentbylinecomment)
xmap gc <action>(commentbylinecomment)<esc>
" 代码编辑提示
nmap <leader>ca <action>(showintentionactions)
xmap <leader>ca <action>(showintentionactions)
" 新建类
nmap <leader>nc <action>(newclass)
" 打开终端
nmap `` <Action>(ActivateTerminalToolWindow)
" 翻译
xmap <leader>t <Action>($EditorTranslateAction)<Esc>
nmap <leader>T <Action>($ShowTranslationDialogAction)
nmap <leader>t viw<Action>($EditorTranslateAction)
" 格式化
nmap <leader>fm <Action>(ReformatCode)
" 重命名
nmap <leader>rn <Action>(RenameElement)
" 类wildfire
nmap <Enter> <Action>(EditorSelectWord)
nmap <BS> <Action>(EditorUnSelectWord)
xmap <Enter> <Action>(EditorSelectWord)
xmap <BS> <Action>(EditorUnSelectWord)
" 打开最近的项目
nmap <leader>fs <Action>($LRU)
" 选择主题
nmap <leader>fc <Action>(ChangeLaf)
" vim模式开关
nmap <leader>vim <Action>(VimPluginToggle)
" 选择idea keymap
nmap <leader>mp <Action>(ChangeKeymap)
" 跳转tab
nmap H <Action>(PreviousTab)
nmap L <Action>(NextTab)
" 跳转method
nmap [f <Action>(MethodUp)
nmap ]f <Action>(MethodDown)
" debug
nmap <leader>dd <Action>(DebugClass)
nmap <leader>db <Action>(ToggleLineBreakpoint)
nmap <leader>dr <Action>(EvaluateExpression)
" git


```

