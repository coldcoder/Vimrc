if(has("win32")|| has("win64")) "�ж���ǰ����ϵͳ����
    let g:iswindows=1
else
    let g:iswindows=0
endif

"=> General
set history=700
"Enable filetype plugins
filetype plugin on
filetype indent on
"auto read when a file is changed from the outside
set autoread
"����mapleader
let mapleader=","
let g:mapleader=","

"��������_vimrc
map <silent> <leader>ss :source y:\Vim\_vimrc<cr>
map <silent> <leader>ee :e y:\Vim\_vimrc<cr>
autocmd! bufwritepost _vimrc source $vim\_vimrc

"fast saving
nmap <leader>w :w!<cr>
"=> VIM user Interface
set ruler
set ignorecase
set go=
set nu
set fileencodings=utf-8,gb2312,ucs-bom,euc-cn,euc-tw,gb18030,gbk,cp936
autocmd BufEnter * lcd %:p:h
"=> Colors and Fonts
syntax enable
colo freya 
set background=dark
set nocompatible "��Ҫvimģ��viģʽ���������ã�������кܶ಻���ݵ�����
set completeopt=menu
au BufRead,BufNewFile *.cst set filetype=cpp

if has("autocmd")
    augroup vimrcEx
        au!
        autocmd FileType text setlocal textwidth=78
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \ exe "normal! g`\"" |
                    \ endif
    augroup END
else
    "������������Ӧ����cindent���ٷ�˵autoindent����֧�ָ����ļ�������������Ч�����ֻ֧��C/C++��cindentЧ�����һ�㣬�����߲�û�п�����
    set autoindent " always set autoindenting on 
endif " has("autocmd")
set tabstop=4 "��һ��tab����4���ո�
set vb t_vb=
set nobackup "��Ҫ����
set nowrap "���Զ�����
set hlsearch "������ʾ���
set incsearch "������Ҫ����������ʱ��vim��ʵʱƥ��
set backspace=indent,eol,start whichwrap+=<,>,[,] "�����˸����ʹ��
if(g:iswindows==1) "��������ʹ��
    "��ֹlinux�ն����޷�����
    if has('mouse')
        set mouse=a
    endif
    au GUIEnter * simalt ~x
endif
"���������
set fenc=gbk
set guifont=Bitstream_Vera_Sans_Mono:h11:cANSI "��ס�ո����»��ߴ���Ŷ
set gfw=��Բ:h10.5:cGB2312

map <F12> :call Do_CsTag()<CR>
nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
function! Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
	if has("cscope")
		set cscopequickfix=s-,c-,d-,i-,t-,e-
		set csto=0
		set cst
		set csverb
	endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find . -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!cscope -b"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

"����Tlist������
"TlistUpdate���Ը���tags
map <F3> :silent! Tlist<CR> "����F3�Ϳ��Ժ�����
let Tlist_Ctags_Cmd='ctags' "��Ϊ���Ƿ��ڻ�����������Կ���ֱ��ִ��
let Tlist_Use_Right_Window=1 "�ô�����ʾ���ұߣ�0�Ļ�������ʾ�����
let Tlist_Show_One_File=0 "��taglist����ͬʱչʾ����ļ��ĺ����б������ֻ��1��������Ϊ1
let Tlist_File_Fold_Auto_Close=1 "�ǵ�ǰ�ļ��������б��۵�����
let Tlist_Exit_OnlyWindow=1 "��taglist�����һ���ָ��ʱ���Զ��Ƴ�vim
let Tlist_Process_File_Always=0 "�Ƿ�һֱ����tags.1:����;0:����������һֱʵʱ����tags����Ϊû�б�Ҫ
let Tlist_Inc_Winwidth=0

"Set tags

"MiniBufExplore
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMoreThanOne=0

"WinManager
let g:NERDTree_title="[NERDTree]"
let g:winManagerWindowLayout="NERDTree"
function! NERDTree_Start()
		exec 'NERDTree'
endfunction
function! NERDTree_IsValid()
		return 1
endfunction
nmap wm :WMToggle<CR>

"Indent_guides
let g:indent_guides_size=5
let g:indent_guides_auto_colors=1
"FencView
set fileencodings=utf-8,gb2312,ucs-bom,euc-cn,euc-tw,gb18030,gbk,cp936
"LastStatus
set laststatus=2
"set supertab
let g:SuperTabDefaultCompletionType="context"
"Tags
"set tags=
nmap ca :Calendar<CR>
